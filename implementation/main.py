#!/usr/bin/python3
from BeautifulPrint import BeautifulPrint
from VampireSystem import VampireSystem
from ScreanCleaner import ScreanCleaner

def main():
    yellow = BeautifulPrint.warning
    red = BeautifulPrint.error
    ScreanCleaner.clear()
    yellow('===================================')
    yellow('    Welcome to Project ', end='')
    red('Vampire', end='')
    yellow('!    ')
    yellow('===================================')
    
    # load the system
    VampireSystem()

main()