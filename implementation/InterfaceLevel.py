from BeautifulPrint import BeautifulPrint

# An abstracted class to print levelised menu.
# Examples & usages are at the end of this file.
class InterfaceLevel():
    _subLevels = []
    _welcomeMessage = None
    _id = ''
    _title = ''
    _backable = True
    _onSelect = None

    def __init__(self, id='', title='', welcomeMessage=None, backable=True, onSelect=None, inputPrompt=None):
        self._id = id
        self._title = title
        self._subLevels = []
        self._welcomeMessage = welcomeMessage
        self._backable = backable
        self._onSelect = onSelect
        self._inputPrompt = 'Please choose one item: '
        if inputPrompt:
            self._inputPrompt = inputPrompt

    def select(self):
        if self._onSelect:
            self._onSelect()
        else:
            self.run()

    def run(self):
        while True:
            print('') # give some space here
            if self._welcomeMessage:
                BeautifulPrint.infoBlue(self._welcomeMessage)
            BeautifulPrint.infoPurple(self._showItems(), end='')
            BeautifulPrint.infoBlue(self._inputPrompt, end='')
            userInput = input()

            # A little bit hackey here...
            if (self._backable) and (userInput == 'b'): 
                return
            
            if (self._backable) and (userInput == 'q'): 
                InterfaceLevel.quitSystem()

            for em in self._subLevels:
                if userInput == em.id:
                    em.select()

    def _showItems(self):
        string = ''
        if self._subLevels:
            for em in self._subLevels:
                string += str(em) + '\n'
        else:
            BeautifulPrint.warning('  There\'s nothing in this level...')
        if self._backable:
            string += '  b. Go back\n'
            string += '  q. Quit system\n'
        return string
    
    def addItem(self, interfaceLevel):
        if (self._backable) and (interfaceLevel.id in ['b', 'q']):
            raise Exception('Bad ID')

        for em in self._subLevels:
            if (em.id == interfaceLevel.id):
                raise Exception('Bad ID')

        self._subLevels.append(interfaceLevel)

    def __str__(self):
        return '  ' + self.id + '. ' + self.title

    # Getter and setters
    @property
    def id(self):
        return self._id

    @id.setter
    def id(self, newId):
        self._id = newId
    
    @property
    def title(self):
        return self._title

    @staticmethod
    def quitSystem():
        print('You are leaving the system. Bye!')
        exit()

if __name__ == "__main__":
    def showLeaf():
        print('You are running a leaf function here')
        print('use input() function to block the program')
        input('Press enter to continue/go back...')

    def dynamicLoad():
        import random

        # A random subtree
        dynamicRoot = InterfaceLevel(
            welcomeMessage= '= Random Number =\n '
                            + str(random.randint(1000000000, 9999999999)) + '\n'
                            '================='
        )

        nMenu = random.randint(1, 3)
        for i in range(nMenu):
            dynamicNode = InterfaceLevel(
                id=str(i),
                title='Number of sub-item can be dynamic generated'
            )
            dynamicRoot.addItem(dynamicNode)
        
        # Dynamic load here
        dynamicRoot.run()

    # Tree-like structure
    # Initialise as a tree node
    root = InterfaceLevel(
        welcomeMessage='Root node',
        backable=False,
        inputPrompt='Select a option above:'
    )

    # A subtree level
    subtree = InterfaceLevel(
        id='1',
        title='Subtree'
    )

    # Leaf node should always have a onSelect method to specify what it is doing
    leaf = InterfaceLevel(
        id='1',
        title='Leaf',
        onSelect=showLeaf # pass a function as a param (NOT CALLING IT)
    )

    # Or you can manually call run() later to make the node dynamic
    dynamicNode = InterfaceLevel(
        id='2',
        title='Dynamic-Loaded Node',
        onSelect=dynamicLoad # pass a function as a param (NOT CALLING IT)
    )

    subtree.addItem(leaf)
    subtree.addItem(dynamicNode)
    root.addItem(subtree)

    root.run()


