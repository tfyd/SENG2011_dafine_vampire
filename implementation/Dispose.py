from TestedBloodList import TestedBloodList
from DisposedBlood import DisposedBlood
from DisposedBloodList import DisposedBloodList
import time

class Dispose():
    def checkExp(self, blood):
        if blood.expiration < time.time():
            return True

    def dispose(self):
        tested = TestedBloodList()
        disposed = []
        
        for blood in tested.list:
            if self.checkExp(blood):
                print("blood " + str(blood.id) + " is expired")
                DisposedBloodList().addBlood(DisposedBlood(blood.id, blood.expiration))
                tested.extractBlood(blood.id)
                disposed.append(str(blood.id))

        disposedString = "\n".join(disposed)
        if len(disposed) != 0:
            print('Blood sample \n{}\nhas been added to disposed blood list.'.format(disposedString))
            print('this message just for debug')
    

