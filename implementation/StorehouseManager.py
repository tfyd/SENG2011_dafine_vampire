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
            welcomeMessage='We have these untested blood in the storehouse:',
            inputPrompt='Select one of the blood you want to test: '
        )

        i = 1
        for disposed in disposedList.list:
            newLevel.addItem(MenuLevel(
                id=str(i),
                title='Disposed sample {}'.format(str(disposed.id)),
                onSelect=callDispose(disposed.id) 
            ))
            i += 1

        newLevel.run()

  
    def dispose(self, id):
        toBeDisposed = DisposedBloodList().extractBlood(id)
        BeautifulPrint.success('Blood sample ' + str(toBeDisposed.id) + ' successed. \nPlease remove the blood to the storehouse')
        
        input('Press enter to go back...')
        ScreanCleaner.clear() # clear the screen  

    def viewBlood(self):
        Dispose().dispose()
        testedList = TestedBloodList()
        testedList.sortByExpiryDate()
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
                    blood.type) +  ' | Retrieval Date: ' +
                retrievalString + ' |  Expiration Date: ' + expirationString,
                end='\n')

        input('Press enter to go back...')
        ScreanCleaner.clear() # clear the screen  


    def showMenu(self):
        thisLevel = MenuLevel(
            welcomeMessage='You are a storehouse manager now.',
            inputPrompt='What do you want to do? '
        )
        thisLevel.addItem(MenuLevel('1', 'Dispose Blood', onSelect=self.select))
        thisLevel.addItem(MenuLevel('2', 'View Blood', onSelect = self.viewBlood))
        thisLevel.addItem(MenuLevel('3', 'Placeholder'))

        thisLevel.select()