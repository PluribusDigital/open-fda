import os

def relativeToAbsolute(path):
    # where is this script?
    thisScriptDir = os.path.dirname(__file__)

    # get the expected paths
    return os.path.join(thisScriptDir, path)

