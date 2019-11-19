class DafnyList():
    def __init__(self, size):
        self._list = [None]*size
        self._upto = 0
    
    def append(self, item):
        if self._upto == len(self._list):
            newlist = [None]*(len(self._list)*2)
            for i in range (self._upto):
                newlist[i] = self._list[i]
            self._list = newlist
        self._list[self._upto] = item
        self._upto = self._upto + 1

    def remove(self, item):
        i = 0
        while i < self._upto:
            if self._list[i] == item:
                for k in range(i+1, self._upto):
                    self._list[k - 1] = self._list[k]
                self._upto = self._upto - 1
                break
            i = i + 1
    
    @property
    def list(self):
        return self._list[:self._upto]

    @list.setter
    def list(self, newlist):
        newlength = len(newlist)
        self._list = DafnyList(newlength+1) # make sure length not equals to 0
        for elem in newlist:
            self.append(elem)

    def __str__(self):
        return " ".join(self._list[:self._upto])
    

if __name__ == '__main__':
    # for testing only
    test = DafnyList(2)
    test.append("hi")
    test.append("test")
    test.append("world")
    print(test)
    test.remove("world")
    print(test)
