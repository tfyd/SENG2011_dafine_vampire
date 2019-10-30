from BloodList import BloodList
from UntestedBlood import UntestedBlood
from JsonWriter import JsonWriter

class UntestedBloodList(BloodList):
    jsonfile = './dataset/UntestedBlood.json'

    def __init__(self):
        super().__init__()
        self.list = []
        data = JsonWriter.parseJsonFromFile(
            filename = self.jsonfile, 
            defaultValue = []
        )
        for blood in data:
            self.list.append(UntestedBlood(blood['id'], blood['retrievalDate']))


