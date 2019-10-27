from MenuLevel import MenuLevel
from Tester import Tester
from DonationManager import DonationManager
from Doctor import Doctor # noqa
from StorehouseManager import StorehouseManager # noqa

class VampireSystem():
    interfaceRootLevel = None

    def __init__(self):
        self._rootLevelInitialise()

        self.interfaceRootLevel.run()
        


    def _rootLevelInitialise(self):
        self.interfaceRootLevel = MenuLevel(
            welcomeMessage='Currently we have these roles', 
            backable=False,
            inputPrompt='Please specify your role: '
        )
        self._bindRoutes()
        self.interfaceRootLevel.addItem(MenuLevel(
            id='q',
            title='Quit system',
            onSelect=self.quitSystem
        ))

    def _bindRoutes(self):
        root = self.interfaceRootLevel

        root.addItem(MenuLevel(
            id='1',
            title='Donation Manager',
            onSelect=DonationManager().showMenu
        ))
        root.addItem(MenuLevel(
            id='2',
            title='Tester',
            onSelect=Tester().showMenu
        ))
        root.addItem(MenuLevel(
            id='3',
            title='Doctor',
            onSelect=Doctor().showMenu
        ))
        root.addItem(MenuLevel(
            id='4',
            title='Storehouse Manager',
            # onSelect=StorehouseManager().showMenu
        ))

    def quitSystem(self):
        MenuLevel.quitSystem()

if __name__ == "__main__":
    VampireSystem()