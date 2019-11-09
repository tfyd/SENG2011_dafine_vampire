from BloodList import BloodList
from TestedBlood import TestedBlood
from JsonWriter import JsonWriter
from BeautifulPrint import BeautifulPrint
import time

class TestedBloodList(BloodList):
    jsonfile = './dataset/TestedBlood.json'

    def __init__(self):
        super().__init__()
        self.list = []
        data = JsonWriter.parseJsonFromFile(
            filename=self.jsonfile,
            defaultValue=[]
        )
        for blood in data:
            self.list.append(TestedBlood(
                id=blood['id'],
                retrievalDate=blood['retrievalDate'],
                type=blood['type'],
                expiration=blood['expiration']
            ))

    def checkStorage(self):

        # All valid blood types
        keysDict = {'O': 0, 'O+': 0, 'O-': 0, 'A+': 0, 'A-': 0, 'B+': 0, 'B-': 0, 'AB+': 0, 'AB-': 0}

        # Using 3 as a dummy value, replace with real value later
        for key in keysDict.keys():
            for blood in self.list:
                if blood.type == key:
                    keysDict[key] += 1

        for key in keysDict.keys():
            if keysDict[key] < 3:
                BeautifulPrint.warning('  Blood Type: ' + key + ' has ' + str(keysDict[key]) +
                                       ' Blood stock remaining. Please get more stock.')

    def numOfStorageCurrent(self):

        self.numOfStorageFuture(time.time())

    def numOfStorageFuture(self, date):

        # All valid blood types
        keysDict = {'O': 0, 'O+': 0, 'O-': 0, 'A+': 0, 'A-': 0, 'B+': 0, 'B-': 0, 'AB+': 0, 'AB-': 0}

        futureTime = 0
        if date >= time.time() :
            futureTime = date
        else :
            futureTime = time.time()
        for key in keysDict.keys():
            for blood in self.list:
                if blood.type == key and blood.expiration >= futureTime:
                    keysDict[key] += 1

        for key in keysDict.keys():
                BeautifulPrint.warning('  Blood Type: ' + key + ' has ', end='')
                BeautifulPrint.bold(str(keysDict[key]), end='')                       
                BeautifulPrint.warning(' Blood stock remaining')

    def testedBloodNum(self):
        return len(self.list)

    def sortByExpiryDate(self):

        for i in range(1, len(self.list)):

            # Insertion Shuffle Sort
            key = self.list[i]
            j = i-1
            while j >= 0 and key.expiration < self.list[j].expiration:
                self.list[j+1] = self.list[j]
                j -= 1
            self.list[j+1] = key


        # Insertion Swap Sort
        # for i in range(1, len(self.list)):
        #
        #     key = self.list[i]
        #     j = i-1
        #     while j >= 0 and key.expiration < self.list[j].expiration:
        #         temp = self.list[j]
        #         self.list[j+1] = self.list[j]
        #         self.list[j] = temp
        #
        #         j -= 1
        #     self.list[j+1] = key

