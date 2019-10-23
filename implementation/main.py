#!/usr/bin/python3
from BeautifulPrint import BeautifulPrint
from VampireSystem import VampireSystem

def main():
    yellow = BeautifulPrint.warning
    red = BeautifulPrint.error

    yellow('===================================')
    yellow('    Welcome to Project ', end='')
    red('Vampire', end='')
    yellow('!    ')
    yellow('===================================')
    
    # load the system
    VampireSystem()

main()