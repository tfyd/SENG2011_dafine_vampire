from BeautifulPrint import BeautifulPrint
from MenuLevel import MenuLevel
from TestedBloodList import TestedBloodList
from datetime import datetime
from Dispose import Dispose
from ReservedBloodList import ReservedBloodList

class Doctor():

    def select(self):
        callReserve = lambda id: lambda: self.reserveBlood(id)
        testedList = TestedBloodList()

        newLevel = MenuLevel(
            welcomeMessage='We have these tested blood in the storehouse:',
            inputPrompt='Select one of the blood you want to reserve: '
        )

        i = 1
        for tested in testedList.list:
            newLevel.addItem(MenuLevel(
                id=str(i),
                title='Blood ID: {}'.format(str(tested.id)),
                onSelect=callReserve(tested.id)
            ))
            i += 1

        newLevel.run()

    def showMenu(self):
        thisLevel = MenuLevel(
            welcomeMessage=
            'You have signed in as a: Doctor \n'
            'The following actions are available to you',
            inputPrompt='Please enter an action: '
        )
        thisLevel.addItem(MenuLevel('1', 'View Blood', onSelect=self.viewBlood))
        thisLevel.addItem(MenuLevel('2', 'Reserve Blood', onSelect=self.select))
        thisLevel.addItem(MenuLevel('3', 'Search By Blood Type', onSelect=self.viewBloodType))
        thisLevel.addItem(MenuLevel('4', 'View Reserve Blood List', onSelect=self.viewReservedList))
        thisLevel.select()

    def reserveBlood(self, id):
        BeautifulPrint.infoPurple("Reserve Functionality Pending...")

        reservedBlood = TestedBloodList().extractBlood(id)
        ReservedBloodList().addBlood(reservedBlood)
        input('Press enter to go back...')

    def viewBlood(self):
        Dispose().dispose()
        testedList = TestedBloodList()
        testedList.checkStorage()
        print('We currently have ', end='')
        BeautifulPrint.bold(str(testedList.count), end='')
        print(' available blood supplies.')

        # TODO sort list by expiration date
        for blood in testedList.list:
            expirationString = datetime.fromtimestamp(blood.expiration).strftime('%d-%m-%Y %H:%M')
            retrievalString = datetime.fromtimestamp(blood.retrievalDate).strftime('%d-%m-%Y %H:%M')
            BeautifulPrint.infoPurple(
                'ID:' + str(blood.id) + ' | Blood Type:' + str(
                    blood.type) + ' | Retrieval Date: ' + retrievalString + ' | Expiration Date: ' + expirationString,

                end='\n')

        input('Press enter to go back...')

    def viewBloodType(self):
        bloodtype = input('Please enter a type of blood : ')

        testedList = TestedBloodList()

        for blood in testedList.list:
            if blood.type == bloodtype:
                expirationString = datetime.fromtimestamp(blood.expiration).strftime('%d-%m-%Y %H:%M')
                # print('blood retrieval = ', blood.retrievalDate)
                retrievalString = datetime.fromtimestamp(blood.retrievalDate).strftime('%d-%m-%Y %H:%M')
                BeautifulPrint.infoPurple(
                    'ID:' + str(blood.id) + ' | Blood Type:' + str(
                        blood.type) + ' | Retrieval Date: ' + retrievalString + ' | Expiration Date: ' + expirationString,

                    end='\n')

        input('Press enter to go back...')

    def viewReservedList(self):
        Dispose().dispose()
        reservedList = ReservedBloodList()
        # reservedList.checkStorage()
        print('We currently have ', end='')
        BeautifulPrint.bold(str(reservedList.count), end='')
        print(' blood reserved.')

        # TODO sort list by expiration date
        for blood in reservedList.list:
            expirationString = datetime.fromtimestamp(blood.expiration).strftime('%d-%m-%Y %H:%M')
            retrievalString = datetime.fromtimestamp(blood.retrievalDate).strftime('%d-%m-%Y %H:%M')
            BeautifulPrint.infoPurple(
                'ID:' + str(blood.id) + ' | Blood Type:' + str(
                    blood.type) + ' | Retrieval Date: ' + retrievalString + ' | Expiration Date: ' + expirationString,

                end='\n')

        input('Press enter to go back...')
