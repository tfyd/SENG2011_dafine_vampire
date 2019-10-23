from BeautifulPrint import BeautifulPrint
from InterfaceLevel import InterfaceLevel
from Role import Role

class DonationManager(Role):

    def showMenu(self):
        thisLevel = InterfaceLevel(
            welcomeMessage=
                'You have signed in as a: Donation Manager.\n'
                'The following actions are available to you',
            inputPrompt='Please enter an action: '
        )
        thisLevel.addItem(InterfaceLevel('1', 'Insert blood', onSelect=self.insertBlood))
        thisLevel.addItem(InterfaceLevel('2', 'View blood', onSelect=self.viewBlood))
        thisLevel.addItem(InterfaceLevel('3', '...'))

        thisLevel.select()
        

    def insertBlood(self):
        BeautifulPrint.infoPurple('Please enter blood details...')
        input('Assume doing something... press enter to go back...')


    def viewBlood(self):
        BeautifulPrint.infoPurple('Here is a list of all blood samples...')
        input('Assume doing something... press enter to go back...')