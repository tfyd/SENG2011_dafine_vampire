from BloodList import BloodList
from TestedBlood import TestedBlood
from JsonWriter import JsonWriter
from BeautifulPrint import BeautifulPrint


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
        keysDict = {'O': 0, 'O+': 0, '0-': 0, 'A+': 0, 'A-': 0, 'B+': 0, 'B-': 0, 'AB+': 0, 'AB-': 0}

        # Using 3 as a dummy value, replace with real value later
        for key in keysDict.keys():
            for blood in self.list:
                if blood.type == key:
                    keysDict[key] += 1

        for key in keysDict.keys():
            if keysDict[key] < 3:
                BeautifulPrint.warning('Blood Type: ' + key + ' has ' + str(keysDict[key]) +
                                       ' Blood stock remaining. Please get more stock.')
