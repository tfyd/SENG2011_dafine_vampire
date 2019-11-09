import os

class screanCleaner:

    @staticmethod
    def clear(): 
    # check and make call for specific operating system 
        os.system(['clear','cls'][os.name == 'nt'])