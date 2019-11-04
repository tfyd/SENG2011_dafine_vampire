from BeautifulPrint import BeautifulPrint
from MenuLevel import MenuLevel
from UntestedBloodList import UntestedBloodList
from TestedBloodList import TestedBloodList
from TestedBlood import TestedBlood
from DisposedBlood import DisposedBlood
from DisposedBloodList import DisposedBloodList
from Role import Role
from datetime import datetime

class Tester(Role):
    def select(self):
        callTest = lambda id: lambda: self.test(id)
        untestedList = UntestedBloodList()
    
        newLevel = MenuLevel(
            welcomeMessage='We have these untested blood in the storehouse:',
            inputPrompt='Select one of the blood you want to test: '
        )

        i = 1
        for untested in untestedList.list:
            newLevel.addItem(MenuLevel(
                id=str(i),
                title='Untested sample {}'.format(str(untested.id)),
                onSelect=callTest(untested.id) 
            ))
            i += 1

        newLevel.run()


    def test(self, id):
        toBeTested = UntestedBloodList().extractBlood(id)
        validBlood =  ['O', 'O+', '0-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-']
        checkedBloodType = None
        while True:
            testPassed = input('Is the test passed (Y/N): ')
            if (testPassed == 'Y'):
                break
            if (testPassed == 'N'):
                DisposedBloodList().addBlood(DisposedBlood(toBeTested.id))
                BeautifulPrint.warning('Blood is pending to be disposed.')
                return

        while checkedBloodType is None:
            BeautifulPrint.warning('Valid Blood Types are: O, O+, O-, A+, A-, B+, B-, AB+, AB-')
            bloodType = input('Enter blood type: ')
            if bloodType in validBlood:
                checkedBloodType = bloodType
            else:
                BeautifulPrint.error('Please enter a valid blood type.')

        expiration = None
        while expiration is None:        
            try:
                expirationString = input('Enter expiration date (DD/MM/YYYY HH:mm): ')
                expiration = datetime.strptime(expirationString, '%d/%m/%Y %H:%M')
                expiration = expiration.timestamp()
            except:
                expiration = None

        TestedBloodList().addBlood(TestedBlood(toBeTested.id, toBeTested.retrievalDate, checkedBloodType, expiration))

        BeautifulPrint.success('Blood sample {} has been tested.'.format(str(toBeTested.id)))
        input('Press enter to continue')


    def showMenu(self):
        thisLevel = MenuLevel(
            welcomeMessage='You are a tester now.',
            inputPrompt='What do you want to do? '
        )
        thisLevel.addItem(MenuLevel('1', 'Test blood', onSelect=self.select))
        thisLevel.addItem(MenuLevel('2', 'Placeholder'))
        thisLevel.addItem(MenuLevel('3', 'Placeholder'))

        thisLevel.select()
        