from TestedBloodList import TestedBloodList
from DisposedBlood import DisposedBlood
from DisposedBloodList import DisposedBloodList
from EmailSender import EmailSender
import time

class Dispose():

    haveSentEmail = []

    def checkExp(self, blood):
        if blood.expiration < time.time():
            return True

    def dispose(self):
        tested = TestedBloodList()
        disposed = []
        
        for blood in tested.list:
            if self.checkExp(blood):
                print("blood " + str(blood.expiration) + " is expired")
                DisposedBloodList().addBlood(DisposedBlood(blood.id))
                tested.extractBlood(blood.id)
                disposed.append(str(blood.id))

        insufficientBloodList = tested.insufficentBloodList()

        if not all(elem in self.haveSentEmail  for elem in insufficientBloodList) :
            sender = EmailSender()
            sender.detailedEmail(insufficientBloodList)
        self.haveSentEmail = insufficientBloodList

        disposedString = "\n".join(disposed)
        if len(disposed) != 0:
            print('Blood sample \n{}\nhas been added to disposed blood list.'.format(disposedString))
            print('this message just for debug')
    

