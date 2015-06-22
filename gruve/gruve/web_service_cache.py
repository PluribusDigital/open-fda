import os
import sys
import json
from urllib.parse import urlparse
from gruve import io

class WebServiceCache():
    """
    Implements a local file system cache to prevent overusing a web service
    """

    def __init__(self, webServiceProxy):
        self.webServiceProxy = webServiceProxy

    # -------------------------------------------------------------------------

    def _removeBadFileNameCharacters(self, x):
        value = x.replace('.', '-')
        for c in '\/:*?"<>|':
            value = value.replace(c, '')
        return value;

    def _createFileName(self, url):
        c = urlparse(url)
        dir = str(c.netloc).replace('.', '-')
        file = self._removeBadFileNameCharacters(c.query) + '.json'
        relative = os.path.join('../cache/', dir, file)
        return io.relativeToAbsolute(relative) 

    # -------------------------------------------------------------------------

    def get(self, url, maxRecords=-1, start=0):
        fileName = self._createFileName(url)
        
        if not os.path.exists(fileName):
            data = self.webServiceProxy.get(url, maxRecords, start)
            if not data or self.webServiceProxy.status_code != 200:
                return []

            if not os.path.exists(os.path.dirname(fileName)):
                os.makedirs(os.path.dirname(fileName))
            with open(fileName, 'w') as f:
                json.dump(data, f)

            return data

        else:
            with open(fileName, 'r') as f:
                data = json.load(f)

            return data

