from BeautifulPrint import BeautifulPrint
from MenuLevel import MenuLevel
from DisposedBloodList import DisposedBloodList
from Role import Role
from Dispose import Dispose

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

    def showMenu(self):
        thisLevel = MenuLevel(
            welcomeMessage='You are a tester now.',
            inputPrompt='What do you want to do? '
        )
        thisLevel.addItem(MenuLevel('1', 'Dispose Blood', onSelect=self.select))
        thisLevel.addItem(MenuLevel('2', 'Placeholder'))
        thisLevel.addItem(MenuLevel('3', 'Placeholder'))

        thisLevel.select()