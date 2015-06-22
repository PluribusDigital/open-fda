import sys
import time
import json
import requests

class OpenFdaProxy():
    """
    Encapsulates calling the OpenFDA Web Service
    """
    def __init__(self, api_key):
        self.api_key = api_key
        self.maxCallsPerSecond = 4
        self.step = 100
        self.status_code = 0

    # -------------------------------------------------------------------------

    def _chunk(self, url, maxRecords, start):
        ''' Retrieves a full set of data from an API
        '''
        if not self.api_key:
            raise StopIteration

        # The URL parameters
        params = {'api_key' : self.api_key,
                    'limit' : self.step,
                    'skip' : start}

        while True:
            print('Calling', url, params['skip'])
            r = requests.get(url, params=params)
            data = json.loads(r.text)
            self.status_code = r.status_code

            if not data or 'results' not in data:
                print('Unable to load records', r.status_code, file=sys.stderr)
                if 'error' in data:
                    print(data['error'], file=sys.stderr)
                raise StopIteration

            yield data['results']

            if maxRecords == -1:
                maxRecords = int(data['meta']['results']['total'])
            params['skip'] = params['skip'] + self.step

            if params['skip'] >= maxRecords:
                raise StopIteration

            time.sleep(1/self.maxCallsPerSecond)  

    # -------------------------------------------------------------------------

    def get(self, url, maxRecords=-1, start=0):
        data = []

        # assemble the chunks
        for i,chunk in enumerate(self._chunk(url, maxRecords, start)):
            data.extend(chunk)

        return data

