from BeautifulPrint import BeautifulPrint
from MenuLevel import MenuLevel
from DisposedBloodList import DisposedBloodList
from TestedBloodList import TestedBloodList
from Role import Role
from Dispose import Dispose
from datetime import datetime
from ScreanCleaner import ScreanCleaner

class StorehouseManager(Role):
    
    def select(self):
        callDispose = lambda id: lambda: self.dispose(id)
        Dispose().dispose()
        disposedList = DisposedBloodList()

        newLevel = MenuLevel(
            welcomeMessage='We have these expired blood in the storehouse:',
            inputPrompt='Select one of the blood you want to dispose: '
        )

        i = 1
        for disposed in disposedList.list:
            retrievalString = datetime.fromtimestamp(disposed.expiration).strftime('%d-%m-%Y %H:%M')
            newLevel.addItem(MenuLevel(
                id=str(i),
                title='Disposed sample {} | Expiration Date: {}'.format(str(disposed.id), retrievalString),
                onSelect=callDispose(disposed.id) 
            ))
            i += 1

        newLevel.run()

  
    def dispose(self, id):
        toBeDisposed = DisposedBloodList().extractBlood(id)
        BeautifulPrint.success('Blood sample ' + str(toBeDisposed.id) + ' successed. \nPlease remove the blood from the storehouse')
        
        input('Press enter to go back...')
        ScreanCleaner.clear() # clear the screen  

    def viewBlood(self):
        Dispose().dispose()
        testedList = TestedBloodList()
        testedList.checkStorage()
        print('We currently have ', end='')
        BeautifulPrint.bold(str(testedList.count), end='')
        print(' available blood supplies.')
        # TODO sort list by expiration date
        for blood in testedList.list:
            expirationString = datetime.fromtimestamp(blood.expiration).strftime('%d-%m-%Y %H:%M')
            retrievalString = datetime.fromtimestamp(blood.retrievalDate).strftime('%d-%m-%Y %H:%M')
            BeautifulPrint.infoPurple(
                'ID:' + str(blood.id) + ' |  Blood Type:' + str(
                    blood.type) + ' |  Expiration Date: ' + expirationString + ' | Retrieval Date: ' +
                retrievalString,
                end='\n')

        input('Press enter to go back...')
        ScreanCleaner.clear()  

    def disposeAll(self):
        Dispose().dispose()
        disposedList = DisposedBloodList()
        if len(disposedList.list) != 0 :
            answer = None
            while True:
                expiredId = []
                print('We have ', end='')
                BeautifulPrint.bold(len(disposedList.list), end='')
                print(' expired blood.')
                for disposed in disposedList.list:
                    expiredId.append(disposed.id)
                    expirationString = datetime.fromtimestamp(disposed.expiration).strftime('%d-%m-%Y %H:%M')
                    BeautifulPrint.infoPurple(
                        '  ID:' + str(disposed.id) + ' | Expiration Date: ' + expirationString,
                        end='\n')
                BeautifulPrint.warning('Please collect all above blood from storehouse before delete them from system', end='\n')
                answer = input('Are you sure you want to delete them all (Y/N): ')
                ScreanCleaner.clear()
                if (answer == 'Y' or answer == 'y') :
                    for eId in expiredId:
                        DisposedBloodList().extractBlood(eId)
                    input('All expired blood is removed. Press enter to go back...')
                    ScreanCleaner.clear()
                    break
                elif (answer == 'N' or answer == 'n') :
                    break
                else :
                    BeautifulPrint.error('Please enter Y or N', end='\n')
        else:
            BeautifulPrint.warning('We currently don\'t have any expired blood required to be removed', end='\n')
            input('Press enter to go back...')
            ScreanCleaner.clear()


    def showMenu(self):
        thisLevel = MenuLevel(
            welcomeMessage='You are a storehouse manager now.',
            inputPrompt='What do you want to do? '
        )
        thisLevel.addItem(MenuLevel('1', 'Dispose Blood', onSelect=self.select))
        thisLevel.addItem(MenuLevel('2', 'View Blood', onSelect = self.viewBlood))
        thisLevel.addItem(MenuLevel('3', 'Dispose All Blood', onSelect = self.disposeAll))

        thisLevel.select()