from BeautifulPrint import BeautifulPrint
from MenuLevel import MenuLevel
from Role import Role
from UntestedBlood import UntestedBlood
import time
import re

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
        newBlood.addToFile()
        BeautifulPrint.success('Insert ' + str(newBlood) + ' successed. Please insert the blood to the storehouse')
        input('Press enter to go back...')


    def viewBlood(self):
        BeautifulPrint.bold('We currently have these untested blood.')
        bloodList = ''
        with open("./dataset/UntestedBlood.json") as f:
            for line in f:
                bloodList += "\n" + re.search(r"\d+", line).group(0)
        BeautifulPrint.infoPurple(bloodList)
        input('Press enter to go back...')