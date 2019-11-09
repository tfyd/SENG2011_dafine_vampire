#!/usr/bin/python3
from BeautifulPrint import BeautifulPrint
from VampireSystem import VampireSystem
from screanCleaner import screanCleaner

def main():
    yellow = BeautifulPrint.warning
    red = BeautifulPrint.error
    screanCleaner.clear()
    yellow('===================================')
    yellow('    Welcome to Project ', end='')
    red('Vampire', end='')
    yellow('!    ')
    yellow('===================================')
    
    # load the system
    VampireSystem()

main()