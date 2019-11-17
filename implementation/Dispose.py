from TestedBloodList import TestedBloodList
from DisposedBlood import DisposedBlood
from DisposedBloodList import DisposedBloodList
from EmailSender import EmailSender
from BeautifulPrint import BeautifulPrint
import threading
import time

class Dispose():

    _haveSentEmail = []

    def checkExp(self, blood):
        return blood.expiration < time.time()

    def dispose(self):
        tested = TestedBloodList()
        disposed = []
        toBeRemoved = []

        for blood in tested.list:
            print(str(blood))
            if self.checkExp(blood):
                BeautifulPrint.warning("Blood " + str(blood.id) + " is expired")
                toBeRemoved.append(blood)
                disposed.append(str(blood.id))
                DisposedBloodList().addBlood(DisposedBlood(blood.id))

        for blood in toBeRemoved:
            tested.extractBlood(blood.id)

        insufficientBloodList = tested.insufficentBloodList()

        if not all(elem in type(self)._haveSentEmail  for elem in insufficientBloodList) :
            sender = EmailSender()
            thread = threading.Thread(target=sender.detailedEmail, args=[insufficientBloodList])
            thread.daemon = True 
            # comment out next line if you don't want Email                           
            thread.start() 
            
        type(self)._haveSentEmail = insufficientBloodList

        disposedString = ", ".join(disposed)
        if len(disposed) != 0:
            BeautifulPrint.warning('Blood sample {} has been added to disposed blood list, pending to be disposed'.format(disposedString))
    

