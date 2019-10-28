from Blood import Blood
from datetime import datetime 

class UntestedBlood(Blood):
    def __init__(self, id, retrivalDate):
        super().__init__(id, retrivalDate)

    def __str__(self):
        dt = datetime.fromtimestamp(self.retrivalDate)
        return "Untested Sample: " + str(self.id) + " retrived at " + str(dt)

    def toDictionary(self):
        return {'id': self.id, 'retrivalDate': self.retrivalDate}
