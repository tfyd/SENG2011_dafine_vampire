from BeautifulPrint import BeautifulPrint

class donationManager():

    def run(self):
        BeautifulPrint.infoBlue('You have signed in as a : Donation Manager')
        BeautifulPrint.infoPurple(''
                                  'The following actions are available to you' '\n'
                                  '  1. Insert New Blood' '\n'
                                  '  2. View List Of Blood' '\n'
                                  '  3. ...' '\n'
                                  '  4. ...'
                                  )

        BeautifulPrint.infoBlue('Please enter an action: ', end='')
        action = input()

        if action == '1':
            self.insertBlood()

        elif action == '2':
            self.viewBlood()


    def insertBlood(self):
        BeautifulPrint.infoPurple("Please enter blood details...")


    def viewBlood(self):
        BeautifulPrint.infoPurple("Here is a list of all blood samples...")