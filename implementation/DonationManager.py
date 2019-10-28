from BeautifulPrint import BeautifulPrint
from MenuLevel import MenuLevel
from Role import Role
from UntestedBlood import UntestedBlood
from UntestedBloodList import UntestedBloodList
import time
from datetime import datetime 

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
        while(1):
            try:
                retrivalString = input('Enter retrival date (DD/MM/YYYY HH:mm): ')
                if retrivalString != 'q':
                    retrivalDate = datetime.strptime(retrivalString, '%d/%m/%Y %H:%M')
                    retrivalDate = retrivalDate.timestamp()
                    newBlood = UntestedBlood(int(time.time()), retrivalDate)
                    UntestedBloodList().addBlood(newBlood)
                    BeautifulPrint.success('Insert ' + str(newBlood) + ' successed. \nPlease insert the blood to the storehouse')
                    input('Press enter to go back...')
                else:
                    BeautifulPrint.error("Insertion cancelled")
                break
            except ValueError:
                BeautifulPrint.error("Please insert the date in [DD/MM/YYYY HH:mm] format")
                BeautifulPrint.error("Insert 'q' to go back")

    def viewBlood(self):
        list = UntestedBloodList()
        
        print('We currently have ', end='')
        BeautifulPrint.bold(str(list.count), end='')
        print(' untested blood.')

        BeautifulPrint.infoPurple(str(list), end='')

        input('Press enter to go back...')
