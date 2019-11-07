#!/usr/bin/python3
from BeautifulPrint import BeautifulPrint
from VampireSystem import VampireSystem
import os

def main():
    yellow = BeautifulPrint.warning
    red = BeautifulPrint.error
    os.system('clear') # clear the screen
    yellow('===================================')
    yellow('    Welcome to Project ', end='')
    red('Vampire', end='')
    yellow('!    ')
    yellow('===================================')
    
    # load the system
    VampireSystem()

main()