from MenuLevel import MenuLevel
from Role import Role

class Tester(Role):
    def test(self):
        # list = getUntestedList()
        # foreach in list:
        # create interface level and show them
        print('Pretend I am doing testing now...')
        input('Press enter to continue')


    
    def showMenu(self):
        thisLevel = MenuLevel(
            welcomeMessage='You are a tester now.',
            inputPrompt='What do you want to do? '
        )
        thisLevel.addItem(MenuLevel('1', 'Test blood', onSelect=self.test))
        thisLevel.addItem(MenuLevel('2', 'Placeholder'))
        thisLevel.addItem(MenuLevel('3', 'Placeholder'))

        thisLevel.select()
        