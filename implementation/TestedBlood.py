from Blood import Blood
class DisposedBlood(Blood):
    def __init__(self, id, type, expiration):
        super().__init__(id)
        self.type = type
        self.expiration = expiration