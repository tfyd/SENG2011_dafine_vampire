from BeautifulPrint import BeautifulPrint
from JsonWriter import JsonWriter
from MenuLevel import MenuLevel
from Role import Role
from UntestedBlood import UntestedBlood
from UntestedBloodList import UntestedBloodList
import time

class DonationManager(Role):

    def showMenu(self):
        thisLevel = MenuLevel(
            welcomeMessage=
                'You have signed in as a: Donation Manager.\n'
                'The following actions are available to you',
            inputPrompt='Please enter an action: '
        )
        thisLevel.addItem(MenuLevel('1', 'Insert blood', onSelect=self.insertBlood))
        thisLevel.addItem(MenuLevel('2', 'View blood', onSelect=self.viewBlood))
        thisLevel.addItem(MenuLevel('3', '...'))

        thisLevel.select()
        
    def insertBlood(self):
        newBlood = UntestedBlood(int(time.time()))

        UntestedBloodList().addBlood(newBlood)

        BeautifulPrint.success('Insert ' + str(newBlood) + ' successed. Please insert the blood to the storehouse')
        input('Press enter to go back...')

    def viewBlood(self):
        l = UntestedBloodList()
        
        print('We currently have ', end='')
        BeautifulPrint.bold(str(l.count), end='')
        print(' untested blood.')

        BeautifulPrint.infoPurple(str(l), end='')

        input('Press enter to go back...')
