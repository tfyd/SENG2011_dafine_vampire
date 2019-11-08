from BloodList import BloodList
from JsonWriter import JsonWriter
from DisposedBlood import DisposedBlood

class DisposedBloodList(BloodList):
    jsonfile = './dataset/DisposedBlood.json'

    def __init__(self):
        super().__init__()
        self.list = []
        data = JsonWriter.parseJsonFromFile(
            filename = self.jsonfile, 
            defaultValue = []
        )
        for blood in data:
            self.list.append(DisposedBlood(blood['id'], blood['expiration']))


