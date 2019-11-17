from TestedBloodList import TestedBloodList
from DisposedBlood import DisposedBlood
from DisposedBloodList import DisposedBloodList
from EmailSender import EmailSender
import threading
import time

class Dispose():

    _haveSentEmail = []

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

        if not all(elem in type(self)._haveSentEmail  for elem in insufficientBloodList) : #TODO can be vertified
            sender = EmailSender()
            thread = threading.Thread(target=sender.detailedEmail, args=[insufficientBloodList])
            thread.daemon = True 
            # comment out next line if you don't want Email                           
            thread.start() 
            
        type(self)._haveSentEmail = insufficientBloodList

        disposedString = "\n".join(disposed)
        if len(disposed) != 0:
            print('Blood sample \n{}\nhas been added to disposed blood list.'.format(disposedString))
            print('this message just for debug')
    

