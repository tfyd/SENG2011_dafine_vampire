from Blood import Blood
class DisposedBlood(Blood):
    def __init__(self, id, e):
        super().__init__(id)
        self.expiration = e

    def toDictionary(self):
        return {'id': self.id, 'expiration': self.expiration}