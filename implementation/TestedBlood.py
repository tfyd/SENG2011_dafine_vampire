from Blood import Blood

class TestedBlood(Blood):
    def __init__(self, id, type, expiration):
        super().__init__(id)
        self.type = type
        self.expiration = expiration

    def __str__(self):
        return "Tested Sample: {} ({} {})".format(
            str(self.id), str(self.type), str(self.expiration)
        )

    def toDictionary(self):
        return {
            'id': int(self.id),
            'type': str(self.type),
            'expiration': int(self.expiration)
        }