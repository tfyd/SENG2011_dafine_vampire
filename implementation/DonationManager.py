from BeautifulPrint import BeautifulPrint
from MenuLevel import MenuLevel
from Role import Role
from UntestedBlood import UntestedBlood
from UntestedBloodList import UntestedBloodList
import time
from datetime import datetime 
from screanCleaner import screanCleaner

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
                retrievalString = input('Enter retrieval date (DD/MM/YYYY HH:mm): ')
                screanCleaner.clear() # clear the screen  
                if retrievalString != 'q':
                    retrievalDate = datetime.strptime(retrievalString, '%d/%m/%Y %H:%M')
                    retrievalDate = retrievalDate.timestamp()
                    newBlood = UntestedBlood(int(time.time()), retrievalDate)
                    UntestedBloodList().addBlood(newBlood)
                    BeautifulPrint.success('Insert ' + str(newBlood) + ' succeeded. \nPlease insert the blood to the storehouse')
                    input('Press enter to go back...')
                    screanCleaner.clear() # clear the screen 
                else:
                    BeautifulPrint.error("Insertion cancelled")
                    input('Press enter to go back...')
                    screanCleaner.clear()# clear the screen  
                break
            except ValueError:
                BeautifulPrint.error("Please insert the date in [DD/MM/YYYY HH:mm] format")
                BeautifulPrint.error("Insert 'q' to go back")
            except OSError:
                BeautifulPrint.error("Please not to insert a date in the past")
                BeautifulPrint.error("Insert 'q' to go back")

    def viewBlood(self):
        list = UntestedBloodList()
        
        print('We currently have ', end='')
        BeautifulPrint.bold(str(list.count), end='')
        print(' untested blood.')

        BeautifulPrint.infoPurple(str(list), end='')

        input('Press enter to go back...')
        screanCleaner.clear() # clear the screen  
