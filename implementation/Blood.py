from abc import ABC, abstractmethod

class Blood(ABC):

    def __init__(self, id):
        self.id = id

    @abstractmethod
    def toDictionary(self):
        pass

