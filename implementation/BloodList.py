from abc import ABC, abstractmethod
from JsonWriter import JsonWriter
from DafnyList import DafnyList

class BloodList(ABC):
    _list = DafnyList(10)

    # An abstract attribute indicating where the list links to the json file
    @property
    def jsonfile(self):
        pass

    @property
    def count(self):
        return len(self.list)

    @property
    def list(self):
        return self._list

    @list.setter
    def list(self, newlist):
        self._list = newlist

    @abstractmethod
    def __init__(self):
        # Load list from json file, initialise correct object
        # Then store the object into the list
        pass

    # convert the list to a list of dictionary then save to file
    def save(self):
        dictList = []
        for elem in self.list:
            dictList.append(elem.toDictionary())  # TODO: Default Method
        JsonWriter.writeJsonToFile(self.jsonfile, dictList)

    # Used for printing on screen
    def __str__(self):
        string = ''
        for blood in self.list:
            string += str(blood) + "\n"
        return string

    # auto save to file after finished
    def addBlood(self, blood):
        self.list.append(blood)
        self.save()

    # search by id
    def getBlood(self, id):
        for blood in self.list:
            if blood.id == id:
                return blood
        return None

    # auto save to file after finished
    def removeBlood(self, id):
        target = None
        for blood in self.list:
            if blood.id == id:
                target = blood
                break
        if target is not None:
            self.list.remove(target)
        self.save()

    # Get and remove, then save to file
    def extractBlood(self, id):
        target = self.getBlood(id)
        self.removeBlood(id)
        return target


