from Blood import Blood

class UntestedBlood(Blood):
    def __init__(self, id):
        super().__init__(id)

    def __str__(self):
        return "Untested Sample: " + str(self.id)

    def toDictionary(self):
        return {'id': self.id}
