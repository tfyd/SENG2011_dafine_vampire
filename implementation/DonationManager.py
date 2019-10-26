from BeautifulPrint import BeautifulPrint
from JsonWriter import JsonWriter
from MenuLevel import MenuLevel
from Role import Role
from UntestedBlood import UntestedBlood
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

        untestedList = JsonWriter.parseJsonFromFile(
            filename='./dataset/UntestedBlood.json', 
            defaultValue=[]
        )

        untestedList.append(newBlood.toDictionary())
        
        JsonWriter.writeJsonToFile(
            filename='./dataset/UntestedBlood.json',
            data=untestedList
        )

        BeautifulPrint.success('Insert ' + str(newBlood) + ' successed. Please insert the blood to the storehouse')
        input('Press enter to go back...')


    def viewBlood(self):
        untestedList = JsonWriter.parseJsonFromFile(
            filename='./dataset/UntestedBlood.json', 
            defaultValue=[]
        )

        print('We currently have ', end='')
        BeautifulPrint.bold(str(len(untestedList)), end='')
        print(' untested blood.')

        for blood in untestedList:
            BeautifulPrint.infoPurple(str(UntestedBlood(blood['id'])))

        input('Press enter to go back...')
