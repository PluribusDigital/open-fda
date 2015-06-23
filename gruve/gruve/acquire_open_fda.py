import os
import sys
import csv
from gruve import io, OpenFdaProxy, WebServiceCache

class AcquireOpenFda():
    # -------------------------------------------------------------------------

    def acquire_labels(self):
        ''' Retrieve the full set of drug labeling data from the FDA.
        Since the FDA data set is limited to 5000 records, partition on the 
        'labeler' code of the product NDC
        '''
        # get the list of labelers (minus some missing ones)
        fileName = io.relativeToAbsolute('../../data/product_ndc.txt')
        with open(fileName) as f:
            labelers = {x['labeler'] 
                        for x in csv.DictReader(f, dialect=csv.excel_tab)
                        if x['labeler'] not in ['49158', '60687', '62107',
                                                '62542', '69235']}

        proxy = OpenFdaProxy()
        cache = WebServiceCache(proxy)
        base = 'https://api.fda.gov/drug/label.json?search=openfda.product_ndc:'
        for labeler in sorted(labelers):
            url = base + '%04d' % int(labeler)
            for record in cache.get(url):
                yield record
