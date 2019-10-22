#!/usr/bin/python3
from BeautifulPrint import BeautifulPrint

def roleSelect():
    while True:
        BeautifulPrint.infoPurple(''
            'Currently we have these roles' '\n'
            '  1. Donation Manager' '\n'
            '  2. Tester' '\n'
            '  3. Doctor' '\n'
            '  4. Storehouse Manager'
        )
        BeautifulPrint.underline('If you want to quit, enter \'q\'')
        BeautifulPrint.infoBlue('Please specify your role: ', end='')
        role = input()
        if role == '1':
            print('Selected Donation Manager')
            return
        if role == '2':
            print('Selected Tester')
            return
        if role == '3':
            print('Selected Doctor')
            return
        if role == '4':
            print('Selected Storehouse Manager')
            return
        if role == 'q':
            return

def main():
    printInfo = BeautifulPrint.infoBlue

    printInfo('===================================')
    printInfo('    Welcome to Project Vampire!    ')
    printInfo('===================================')
    roleSelect()
    printInfo('Bye!')

main()