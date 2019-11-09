from BloodList import BloodList
from TestedBlood import TestedBlood
from JsonWriter import JsonWriter


class ReservedBloodList(BloodList):
    jsonfile = './dataset/ReservedBlood.json'

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

    def sortByExpiryDate(self):

        for i in range(1, len(self.list)):

            key = self.list[i]
            j = i - 1
            while j >= 0 and key.expiration < self.list[j].expiration:
                self.list[j + 1] = self.list[j]
                j -= 1
            self.list[j + 1] = key


