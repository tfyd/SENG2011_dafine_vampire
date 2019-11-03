
from BloodList import BloodList
from TestedBlood import TestedBlood
from JsonWriter import JsonWriter

class ReservedBloodList(BloodList):
    jsonfile = './dataset/ReservedBlood.json'

    def __init__(self):
        super().__init__()
        self.list = []
        data = JsonWriter.parseJsonFromFile(
            filename = self.jsonfile,
            defaultValue = []
        )
        for blood in data:
            self.list.append(TestedBlood(
                id=blood['id'],
                retrievalDate=blood['retrievalDate'],
                type=blood['type'],
                expiration=blood['expiration']
        ))

