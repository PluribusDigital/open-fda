import os
import sys
import json
import time
import requests

def relativeToAbsolute(path):
    # where is this script?
    thisScriptDir = os.path.dirname(__file__)

    # get the expected paths
    return os.path.join(thisScriptDir, path)


class AcquireOpenFda():
    def __init__(self):
        self.api_key = self._findKey()

    # -------------------------------------------------------------------------

    def _findKey(self):
        ''' Looks for the API key in the .env file in the root of the project
        '''
        envFileName = relativeToAbsolute(r'../../.env')
        if not os.path.exists(envFileName):
            print("ENV file '%s' not found." % envFileName, file=sys.stderr)
            return None

        # get the key
        with open(envFileName, 'r') as f:
            for line in f:
                k, v = line.strip().split('=', 1)
                if k == 'OPEN_FDA_API_KEY':
                    return v

    # -------------------------------------------------------------------------

    def slurp(self, url, maxCallsPerSecond=4, maxRecords=-1, step=100, start=0):
        ''' Retrieves a full set of data from an API
        '''
        if not self.api_key:
            raise StopIteration

        # The URL parameters
        params = {'api_key' : self.api_key,
                  'limit' : step,
                  'skip' : start}

        while True:
            print('Calling', url, params['skip'])
            r = requests.get(url, params=params)
            data = json.loads(r.text)

            if not data or 'results' not in data:
                print('Unable to load records', r.status_code, file=sys.stderr)
                if 'error' in data:
                    print(data['error'], file=sys.stderr)
                raise StopIteration

            yield data['results']

            if maxRecords == -1:
                maxRecords = int(data['meta']['results']['total'])
            params['skip'] = params['skip'] + step

            if params['skip'] >= maxRecords:
                raise StopIteration

            time.sleep(1/maxCallsPerSecond)  

    # -------------------------------------------------------------------------

    def acquire_labels(self):
        ''' Retrieve the full set of drug labeling data from the FDA
            and save it to a local file 
        '''
        data = []
        url = 'https://api.fda.gov/drug/label.json'

        # reassemble the chunks
        for i,chunk in enumerate(self.slurp(url)):
            data.extend(chunk)

            # dump the progress so far
            fileName = relativeToAbsolute(r'../data/labels'+str(i*100)+'.json')
            with open(fileName, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2)
        
        # QA Check
        ids = {x['set_id'] for x in data}
        print(len(data), len(ids))
        
# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

if __name__ == '__main__':
    y = AcquireOpenFda()
    y.acquire_labels()
