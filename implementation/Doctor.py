from BeautifulPrint import BeautifulPrint
from MenuLevel import MenuLevel
from TestedBloodList import TestedBloodList
from datetime import datetime


class Doctor():

    def showMenu(self):
        thisLevel = MenuLevel(
            welcomeMessage=
            'You have signed in as a: Doctor \n'
            'The following actions are available to you',
            inputPrompt='Please enter an action: '
        )
        thisLevel.addItem(MenuLevel('1', 'View Blood', onSelect=self.viewBlood))
        thisLevel.addItem(MenuLevel('2', 'Reserve Blood', onSelect=self.reserveBlood))
        thisLevel.addItem(MenuLevel('3', 'Search By Blood Type', onSelect=self.viewBloodType))

        thisLevel.select()

    def reserveBlood(self):
        BeautifulPrint.infoPurple("Reserve Functionality Pending...")
        input('Press enter to go back...')

    def viewBlood(self):
        testedList = TestedBloodList()

        print('We currently have ', end='')
        BeautifulPrint.bold(str(testedList.count), end='')
        print(' available blood supplies.')

        # TODO sort list by expiration date
        for blood in testedList.list:
            expirationString = datetime.utcfromtimestamp(blood.expiration).strftime('%d-%m-%Y %H:%M')
            retrievalString = datetime.utcfromtimestamp(blood.retrievalDate).strftime('%d-%m-%Y %H:%M')
            BeautifulPrint.infoPurple(
                'ID:' + str(blood.id) + ' |  Blood Type:' + str(
                    blood.type) + ' |  Expiration Date: ' + expirationString + ' | Retrieval Date: ' +
                retrievalString,
                end='\n')

        input('Press enter to go back...')

    def viewBloodType(self):
        bloodtype = input('Please enter a type of blood : ')

        testedList = TestedBloodList()

        for blood in testedList.list:
            if blood.type == bloodtype:
                expirationString = datetime.utcfromtimestamp(blood.expiration).strftime('%d-%m-%Y %H:%M')
                retrievalString = datetime.utcfromtimestamp(blood.retrievalDate).strftime('%d-%m-%Y %H:%M')
                BeautifulPrint.infoPurple(
                    'ID:' + str(blood.id) + ' | Blood Type:' + str(
                        blood.type) + ' | Expiration Date: ' + expirationString + ' | Retrieval Date: ' +
                    retrievalString,
                    retrievalString,
                    end='\n')

        input('Press enter to go back...')
