from Blood import Blood
class DisposedBlood(Blood):
    def __init__(self, id):
        super().__init__(id)

    def toDictionary(self):
        return {'id': self.id}