from BeautifulPrint import BeautifulPrint
from MenuLevel import MenuLevel
from UntestedBloodList import UntestedBloodList
from TestedBloodList import TestedBloodList
from TestingBlood import TestingBlood
from TestingBloodList import TestingBloodList
from TestedBlood import TestedBlood
from DisposedBlood import DisposedBlood
from DisposedBloodList import DisposedBloodList
from Role import Role
from datetime import datetime
from ScreanCleaner import ScreanCleaner
import time

class Tester(Role):
    def select(self):
        callTest = lambda id: lambda: self.startTest(id)
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
    
    def fill(self):
        callFill = lambda id: lambda: self.test(id)
        testingList = TestingBloodList()
    
        newLevel = MenuLevel(
            welcomeMessage='We have these testing blood in the pending:',
            inputPrompt='Select one of the blood you want to fill in test result: '
        )

        i = 1
        for testing in testingList.list:
            startDateString = datetime.fromtimestamp(testing.startTestDate).strftime('%d-%m-%Y %H:%M')
            newLevel.addItem(MenuLevel(
                id=str(i),
                title='Pending sample {} | Testing Start Date {}'.format(str(testing.id), str(startDateString)),
                onSelect=callFill(testing.id) 
            ))
            i += 1

        newLevel.run()

    def startTest(self, id):
        toBeTested = UntestedBloodList().extractBlood(id)
        TestingBloodList().addBlood(TestingBlood(toBeTested.id, toBeTested.retrievalDate, int(time.time())))
        BeautifulPrint.success('Blood sample {} has been moved to testing list.'.format(str(toBeTested.id)))
        input('Press enter to continue')
        ScreanCleaner.clear() # clear the screen  

    def test(self, id):
        toBeTested = TestingBloodList().extractBlood(id)
        validBlood =  ['O', 'O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-']
        checkedBloodType = None
        while True:
            testPassed = input('Is the test passed (Y/N): ')
            ScreanCleaner.clear()
            if (testPassed == 'Y' or testPassed == 'y'):
                break
            elif (testPassed == 'N' or testPassed == 'n'):
                DisposedBloodList().addBlood(DisposedBlood(toBeTested.id))
                BeautifulPrint.warning('Blood is pending to be disposed.')
                input('Press enter to continue')
                ScreanCleaner.clear() # clear the screen  
                return
            else :
                BeautifulPrint.warning('Please enter Y or N')

        while checkedBloodType is None:
            BeautifulPrint.warning('Valid Blood Types are: O, O+, O-, A+, A-, B+, B-, AB+, AB-')
            bloodType = input('Enter blood type: ')
            ScreanCleaner.clear()
            if bloodType in validBlood:
                checkedBloodType = bloodType  
            else:
                BeautifulPrint.error('Please enter a valid blood type.')

        expiration = None
        while expiration is None:        
            try:
                expirationString = input('Enter expiration date (DD/MM/YYYY HH:mm): ')
                ScreanCleaner.clear()
                expiration = datetime.strptime(expirationString, '%d/%m/%Y %H:%M')
                expiration = expiration.timestamp()
            except:
                expiration = None
                ScreanCleaner.clear()
                BeautifulPrint.error("Please insert the date in [DD/MM/YYYY HH:mm] format")

        TestedBloodList().addBlood(TestedBlood(toBeTested.id, toBeTested.retrievalDate, checkedBloodType, expiration))

        BeautifulPrint.success('Blood sample {} has been tested.'.format(str(toBeTested.id)))
        input('Press enter to continue')
        ScreanCleaner.clear() # clear the screen  


    def showMenu(self):
        thisLevel = MenuLevel(
            welcomeMessage='You are a tester now.',
            inputPrompt='What do you want to do? '
        )
        thisLevel.addItem(MenuLevel('1', 'Test blood', onSelect=self.select))
        thisLevel.addItem(MenuLevel('2', 'Fill in result', onSelect=self.fill))
        thisLevel.addItem(MenuLevel('3', 'Placeholder'))

        thisLevel.select()
        