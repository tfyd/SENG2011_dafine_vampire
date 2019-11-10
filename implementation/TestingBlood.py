from Blood import Blood
from datetime import datetime 

class TestingBlood(Blood):
    def __init__(self, id, retrievalDate, startTestDate):
        super().__init__(id)
        self.retrievalDate = retrievalDate
        self.startTestDate = startTestDate


    def __str__(self):
        dt = datetime.fromtimestamp(self.startTestDate)
        return "Testing Sample: " + str(self.id) + " test start at " + str(dt)

    def toDictionary(self):
        return {'id': self.id, 'retrievalDate': self.retrievalDate, 'startTestDate' : self.startTestDate}