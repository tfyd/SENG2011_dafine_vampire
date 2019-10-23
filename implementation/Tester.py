from InterfaceLevel import InterfaceLevel
from Role import Role

class Tester(Role):
    def test(self):
        # list = getUntestedList()
        # foreach in list:
        # create interface level and show them
        print('Pretend I am doing testing now...')
        input('Press enter to continue')


    
    def showMenu(self):
        thisLevel = InterfaceLevel(
            welcomeMessage='You are a tester now.',
            inputPrompt='What do you want to do? '
        )
        thisLevel.addItem(InterfaceLevel('1', 'Test blood', onSelect=self.test))
        thisLevel.addItem(InterfaceLevel('2', 'Placeholder'))
        thisLevel.addItem(InterfaceLevel('3', 'Placeholder'))

        thisLevel.select()
        