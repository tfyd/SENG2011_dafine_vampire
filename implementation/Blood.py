from abc import ABC, abstractmethod

class Blood(ABC):

    def __init__(self, id, retrivalDate):
        self.id = id
        self.retrivalDate = retrivalDate

    @abstractmethod
    def toDictionary(self):
        pass
