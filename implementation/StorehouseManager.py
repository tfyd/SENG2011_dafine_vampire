from BeautifulPrint import BeautifulPrint
from MenuLevel import MenuLevel
from DisposedBloodList import DisposedBloodList
from TestedBloodList import TestedBloodList
from Role import Role
from Dispose import Dispose
from datetime import datetime
from ScreanCleaner import ScreanCleaner
import time

class StorehouseManager(Role):
    
    def select(self):
        def refresh(level):
            callDispose = lambda id: lambda: self.dispose(id)
            Dispose().dispose()
            disposedList = DisposedBloodList()
            i = 1
            for disposed in disposedList.list:
                newLevel.addItem(MenuLevel(
                    id=str(i),
                    title='Disposed sample {} '.format(str(disposed.id)),
                    onSelect=callDispose(disposed.id)
                ))
                i += 1
            return level
        newLevel = MenuLevel(
            welcomeMessage='We have these expired blood in the storehouse:',
            inputPrompt='Select one of the blood you want to dispose: ',
            onRefresh = lambda: refresh(newLevel)
        )



        newLevel.run()

  
    def dispose(self, id):
        toBeDisposed = DisposedBloodList().extractBlood(id)
        BeautifulPrint.success('Blood sample ' + str(toBeDisposed.id) + ' successed. \nPlease remove the blood from the storehouse')
        
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
        ScreanCleaner.clear()  

    def viewBloodStockCurrent(self):
        Dispose().dispose()
        testedList = TestedBloodList()
        testedList.sortByExpiryDate()
        testedList.numOfStorageCurrent()
        input('Press enter to go back...')
        ScreanCleaner.clear()

    def viewBloodStockFuture(self):
        Dispose().dispose()
        testedList = TestedBloodList()
        testedList.sortByExpiryDate()
        while(True):
            try:
                timeString  = input('Enter date in future (DD/MM/YYYY HH:mm): ')
                ScreanCleaner.clear() # clear the screen  
                if timeString != 'q':
                    futureDate = datetime.strptime(timeString, '%d/%m/%Y %H:%M')
                    if futureDate.timestamp() <= time.time() :
                        BeautifulPrint.infoBlue('You have entered a date at past, return current stack level instead')
                        testedList.numOfStorageCurrent()
                    else :
                        BeautifulPrint.infoBlue('The estimated stock level at ' + timeString + ' is:')
                        testedList.numOfStorageFuture(futureDate.timestamp())
                else:
                    BeautifulPrint.error("Insertion cancelled")
                input('Press enter to go back...')
                ScreanCleaner.clear()# clear the screen  
                break
            except ValueError:
                BeautifulPrint.error("Please insert the date in [DD/MM/YYYY HH:mm] format")
                BeautifulPrint.error("Insert 'q' to go back")
            except OSError:
                BeautifulPrint.error("Please not to insert a date in the past")
                BeautifulPrint.error("Insert 'q' to go back")  

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
                    BeautifulPrint.infoPurple(
                        '  ID:' + str(disposed.id),
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
        thisLevel.addItem(MenuLevel('2', 'View All Blood', onSelect = self.viewBlood))
        thisLevel.addItem(MenuLevel('3', 'Dispose All Blood', onSelect = self.disposeAll))
        thisLevel.addItem(MenuLevel('4', 'View Current Blood Stock', onSelect = self.viewBloodStockCurrent))
        thisLevel.addItem(MenuLevel('5', 'View Future Blood Stock', onSelect = self.viewBloodStockFuture))

        thisLevel.select()