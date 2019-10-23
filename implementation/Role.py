from abc import ABC, abstractmethod

class Role(ABC):
    _menu = None

    def __init__(self):
        pass

    @abstractmethod
    def showMenu(self):
        pass
