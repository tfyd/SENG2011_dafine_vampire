from abc import ABC, abstractmethod
from JsonWriter import JsonWriter
from BeautifulPrint import BeautifulPrint
from collections import Counter

class BloodList(ABC):
    list = []

    # An abstract attribute indicating where the list links to the json file
    @property
    def jsonfile(self):
        pass

    @property
    def count(self):
        return len(self.list)

    @abstractmethod
    def __init__(self):
        # Load list from json file, initialise correct object
        # Then store the object into the list
        pass

    # convert the list to a list of dictionary then save to file
    def save(self):
        dictList = []
        for elem in self.list:
            dictList.append(elem.toDictionary()) # TODO: Default Method
        JsonWriter.writeJsonToFile(self.jsonfile, dictList)

    # Used for printing on screen
    def __str__(self):
        string = ''
        for blood in self.list:
            string += str(blood) + "\n"
        return string

    # auto save to file after finished
    def addBlood(self, blood):
        self.list.append(blood) # TODO: Default Method
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
            self.list.remove(target) # TODO: Default Method
        self.save()
        
    # Get and remove, then save to file
    def extractBlood(self, id):
        target = self.getBlood(id)
        self.removeBlood(id)
        return target

    def checkStorage(self):

        # All valid blood types
        keys = ['O', 'O+', '0-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-']

        # Using 3 as a dummy value, replace with real value later
        for key in keys:
            if self.list.count(key) < 3:
                BeautifulPrint.error('Blood Type: ' + key + ' currently has ' + str(self.list.count(key)) +
                                     ' Blood in stock. Please find more stock!')




