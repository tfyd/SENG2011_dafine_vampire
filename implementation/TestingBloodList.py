from BloodList import BloodList
from TestingBlood import TestingBlood
from JsonWriter import JsonWriter

class TestingBloodList(BloodList):
    jsonfile = './dataset/TestingBlood.json'

    def __init__(self):
        super().__init__()
        self.list = []
        data = JsonWriter.parseJsonFromFile(
            filename = self.jsonfile, 
            defaultValue = []
        )
        for blood in data:
            self.list.append(TestingBlood(int(blood['id']), int(blood['retrievalDate']), int(blood['startTestDate'])))