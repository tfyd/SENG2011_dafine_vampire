import sys

# A class to print colourful sentences in command line.
# Examples & usages are at the end of this file.
class BeautifulPrint:
    PURPLE = '\033[95m'
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    END_PRINT = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

    @staticmethod
    def warning(msg, sep=' ', end='\n', file=sys.stdout, flush=False):
        print(BeautifulPrint.YELLOW, end='')
        print(msg, sep=sep, end=end, file=file, flush=flush)
        print(BeautifulPrint.END_PRINT, end='')

    @staticmethod
    def infoBlue(msg, sep=' ', end='\n', file=sys.stdout, flush=False):
        print(BeautifulPrint.BLUE, end='')
        print(msg, sep=sep, end=end, file=file, flush=flush)
        print(BeautifulPrint.END_PRINT, end='')

    @staticmethod
    def infoPurple(msg, sep=' ', end='\n', file=sys.stdout, flush=False):
        print(BeautifulPrint.PURPLE, end='')
        print(msg, sep=sep, end=end, file=file, flush=flush)
        print(BeautifulPrint.END_PRINT, end='')

    @staticmethod
    def error(msg, sep=' ', end='\n', file=sys.stdout, flush=False):
        print(BeautifulPrint.RED, end='')
        print(msg, sep=sep, end=end, file=file, flush=flush)
        print(BeautifulPrint.END_PRINT, end='')

    @staticmethod
    def success(msg, sep=' ', end='\n', file=sys.stdout, flush=False):
        print(BeautifulPrint.GREEN, end='')
        print(msg, sep=sep, end=end, file=file, flush=flush)
        print(BeautifulPrint.END_PRINT, end='')
    
    @staticmethod
    def bold(msg, sep=' ', end='\n', file=sys.stdout, flush=False):
        print(BeautifulPrint.BOLD, end='')
        print(msg, sep=sep, end=end, file=file, flush=flush)
        print(BeautifulPrint.END_PRINT, end='')
        
    @staticmethod
    def underline(msg, sep=' ', end='\n', file=sys.stdout, flush=False):
        print(BeautifulPrint.UNDERLINE, end='')
        print(msg, sep=sep, end=end, file=file, flush=flush)
        print(BeautifulPrint.END_PRINT, end='')

if __name__ == '__main__':
    # Some preset functions
    BeautifulPrint.warning("Warning")
    BeautifulPrint.infoBlue("Information Blue")
    BeautifulPrint.infoPurple("Information Purple")
    BeautifulPrint.error("Error")
    BeautifulPrint.success("Success")
    BeautifulPrint.underline("Underline")
    BeautifulPrint.bold("Bold")

    # For more complicated combination, do it manually
    print(BeautifulPrint.UNDERLINE, BeautifulPrint.BOLD, BeautifulPrint.GREEN, sep='', end='')
    print("Underline + Bold + Green")
    print(BeautifulPrint.END_PRINT, end='')
    
    print(BeautifulPrint.BOLD, BeautifulPrint.RED, sep='', end='')
    print("Bold + Red")
    print(BeautifulPrint.END_PRINT, end='')