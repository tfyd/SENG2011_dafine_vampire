from BeautifulPrint import BeautifulPrint
from MenuLevel import MenuLevel
from Role import Role
from UntestedBlood import UntestedBlood
import json
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
        untestedList = []

        open('./dataset/UntestedBlood.json', 'a')

        with open('./dataset/UntestedBlood.json', 'r+') as f:
            try:
                untestedList = json.load(f)
            except:    
                untestedList = []
            finally:
                untestedList.append(newBlood.toDictionary())
        
        with open('./dataset/UntestedBlood.json', 'w') as f:
            json.dump(untestedList, f)

        BeautifulPrint.success('Insert ' + str(newBlood) + ' successed. Please insert the blood to the storehouse')
        input('Press enter to go back...')


    def viewBlood(self):
        open('./dataset/UntestedBlood.json', 'a')

        with open('./dataset/UntestedBlood.json', 'r') as f:
            try:
                untestedList = json.load(f)
            except:
                untestedList = []
            finally:
                print('We currently have ', end='')
                BeautifulPrint.bold(str(len(untestedList)), end='')
                print(' untested blood.')
                for blood in untestedList:
                    BeautifulPrint.infoPurple(str(UntestedBlood(blood['id'])))

        input('Press enter to go back...')
