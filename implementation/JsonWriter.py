
import json

# A wrapper for common json operation
class JsonWriter:

    # This function ensure the file exists by opening it with append mode
    # If the file does not exist, it creates the file
    # If the directory does not exist, it raises FileNotFound error
    @staticmethod
    def ensureExists(filename):
        open(filename, 'a')

    # This function trys to open a file and parse it as json
    # If the file does not exist, it creates the file
    # If the directory does not exist, it raises FileNotFound error
    # If the file contains invalid json string, it returns defaultValue
    @staticmethod
    def parseJsonFromFile(filename, defaultValue=[]):
        JsonWriter.ensureExists(filename)
        with open(filename, 'r+') as f:
            try:
                result = json.load(f)
            except:    
                result = defaultValue
            finally:
                return result

    # This function trys to convert given data to json, then write to a file
    # If the file does not exist, it automatically creates the file and write
    # If the directory does not exist, it raises FileNotFound error
    # If the data is not convertable, it raises JSONParseError error 
    @staticmethod
    def writeJsonToFile(filename, data):
        JsonWriter.ensureExists(filename)
        with open(filename, 'w') as f:
            json.dump(data, f)

        