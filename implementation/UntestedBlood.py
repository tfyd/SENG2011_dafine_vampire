import json
from Blood import Blood
class UntestedBlood(Blood):
    def __init__(self, id):
        super().__init__(id)

    def addToFile(self):
        with open('./dataset/UntestedBlood.json', 'a') as f:
            json.dump(self.__dict__, f)
            f.write("\n")

    def __str__(self):
        return "Untested Sample: " + str(self.id)
