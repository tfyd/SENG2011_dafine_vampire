from BeautifulPrint import BeautifulPrint

class DonationManager():

    def run(self):
        while True:
            BeautifulPrint.infoBlue('You have signed in as a: Donation Manager')
            BeautifulPrint.infoPurple(''
                                    'The following actions are available to you' '\n'
                                    '  1. Insert new blood' '\n'
                                    '  2. View list of blood' '\n'
                                    '  3. ...' '\n'
                                    '  b. Go back' '\n'
                                    '  q. Quit'
                                    )

            BeautifulPrint.infoBlue('Please enter an action: ', end='')
            action = input()

            if action == '1':
                self.insertBlood()

            elif action == '2':
                self.viewBlood()
            
            elif action == 'b':
                return
            
            elif action == 'q':
                return 'q'


    def insertBlood(self):
        BeautifulPrint.infoPurple('Please enter blood details...')
        input('Assume doing something... press enter to go back...')


    def viewBlood(self):
        BeautifulPrint.infoPurple('Here is a list of all blood samples...')
        input('Assume doing something... press enter to go back...')