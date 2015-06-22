import os
import sys
import csv
from gruve import io, OpenFdaProxy, WebServiceCache

class AcquireOpenFda():
    def __init__(self):
        self.api_key = self._findKey()

    # -------------------------------------------------------------------------

    def _findKey(self):
        ''' Looks for the API key in the .env file in the root of the project
        '''
        envFileName = io.relativeToAbsolute(r'../../.env')
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

    def acquire_labels(self):
        ''' Retrieve the full set of drug labeling data from the FDA
        '''
        # get the list of labelers (minus some missing ones)
        fileName = io.relativeToAbsolute('../../data/product_ndc.txt')
        with open(fileName) as f:
            labelers = {x['labeler'] 
                        for x in csv.DictReader(f, dialect=csv.excel_tab)
                        if x['labeler'] not in ['49158', '60687', '62107',
                                                '62542', '69235']}

        proxy = OpenFdaProxy(self.api_key)
        cache = WebServiceCache(proxy)
        base = 'https://api.fda.gov/drug/label.json?search=openfda.product_ndc:'
        for labeler in sorted(labelers):
            url = base + '%04d' % int(labeler)
            data = cache.get(url)
#            print(labeler, ' = ', len(data))
        
# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

if __name__ == '__main__':
    y = AcquireOpenFda()
    y.acquire_labels()
