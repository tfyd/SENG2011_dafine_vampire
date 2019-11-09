import smtplib
import ssl


class EmailSender():

    def __init__(self):
        self.port = 465  # For SSL
        self.smtp_server = "smtp.gmail.com"
        self.sender_email = "vampirebloodproject@gmail.com"  # Enter your address
        self.storehouse_manager_email = "happysheepqaq@gmail.com"  # Enter receiver address
        self.donor_manager_email = "happysheepqaq@gmail.com"  # Enter receiver address
        self.password = "transfusion"
        self.message = """\
            Subject: Insufficient Blood Storage

            Insufficient Blood Storage, for more details please use view blood storage funtion in Vampire System"""

    def detailedEmail(self, typeList):
        self.message = "\nSubject: Insufficient Blood Storage\n\nBlood Type(s) : "
        for ele in typeList :
            self.message = self.message + str(ele) + " "
        self.message = self.message + " is not sufficient at stock, for more details please use view blood storage funtion in Vampire System"
        self.sendEmail()

    def sendEmail(self):
        context = ssl.create_default_context()
        with smtplib.SMTP_SSL(self.smtp_server, self.port, context=context) as server:
            server.login(self.sender_email, self.password)
            server.sendmail(self.sender_email, self.storehouse_manager_email, self.message)

        context2 = ssl.create_default_context()
        with smtplib.SMTP_SSL(self.smtp_server, self.port, context=context2) as server:
            server.login(self.sender_email, self.password)
            server.sendmail(self.sender_email, self.donor_manager_email, self.message)