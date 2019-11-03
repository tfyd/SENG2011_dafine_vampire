from Blood import Blood
from datetime import datetime 

class UntestedBlood(Blood):
    def __init__(self, id, retrievalDate):
        super().__init__(id)
        self.retrievalDate = retrievalDate


    def __str__(self):
        dt = datetime.fromtimestamp(self.retrievalDate)
        return "Untested Sample: " + str(self.id) + " retrived at " + str(dt)

    def toDictionary(self):
        return {'id': self.id, 'retrievalDate': self.retrievalDate}
