from abc import ABC, abstractmethod

class Blood(ABC):

    def __init__(self, id, retrievalDate):
        self.id = id
        self.retrievalDate = retrievalDate

    @abstractmethod
    def toDictionary(self):
        pass
