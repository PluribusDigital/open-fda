import os
import sys
import json
import csv
from gruve import io, AcquireOpenFda, ProductNdc, BuildNdcWhiteList

class BuildDrugCanon():
    def __init__(self):
        self.sourceNames = BuildNdcWhiteList()
        self.sourceLabels = AcquireOpenFda()

    # -------------------------------------------------------------------------

    def _map(self, label):
        if ('openfda' in label and 'product_ndc' in label['openfda'] and
            'brand_name' in label['openfda']):
            asString = json.dumps(label)
            for x in label['openfda']['brand_name']:
                brand = self.sourceNames.title(x)
                for y in label['openfda']['product_ndc']:
                    ndc = ProductNdc.parse(y).format()
                    yield {'proprietary_name': brand, 
                           'ndc':ndc, 
                           'size':len(asString)}

    def _reduce(self, dicts):
        if len(dicts) < 1:
            return None

        best = dicts[0]
        for i in range(1, len(dicts)):
            if best['size'] < dicts[i]['size']:
                best = dicts[i]
        return best

    # -------------------------------------------------------------------------

    def _mapLabels(self):
        '''
        A generator function that internally calls the map function for each label
        '''
        for record in self.sourceLabels.acquire_labels():
            for node in self._map(record):
                yield node

    def _reduceToCanon(self, partitions):
        '''
        A generator that internally calls the reduce function on each entry
        '''
        for name in sorted(partitions):
            result = self._reduce(partitions[name])
            if result:
                yield (name, result['ndc'])

    # -------------------------------------------------------------------------

    def build(self):
        ''' 
        Use the size of a record in the FDA data set to determine which package
        NDC is considered _the_ representitive for the same proprietary name
        '''
        print('Loading White List')
        whiteListFileName = io.relativeToAbsolute('../../data/product_ndc.txt')
        records = []
        with open(whiteListFileName) as f:
            for row in csv.DictReader(f, dialect=csv.excel_tab):
                # for some reason a weird 'None' column appears
                records.append({k:v for k,v in row.items() if k})

        partitions = {x['proprietary_name']: [] for x in records}
        products = {x['product_ndc'] for x in records if x['proprietary_name']}

        print('Mapping Labels')
        for node in self._mapLabels():
            nameKey = node['proprietary_name']
            prodKey = node['ndc']
            if nameKey in partitions and prodKey in products:
                partitions[nameKey].append(node)

        print('Reducing to Canon')
        outFileName = io.relativeToAbsolute('../../data/canon_drugs.txt')
        canon = {x for x in self._reduceToCanon(partitions)}

        print('Updating NDC Whitelist')
        for row in records:
            tuple = (row['proprietary_name'], row['product_ndc'])
            if tuple in canon:
                # consume because multiple package codes map to this key
                canon.remove(tuple) 
                row['is_canon'] = True
            else:
                row['is_canon'] = False

        tempName = io.relativeToAbsolute('../../data/product_ndc_canon.txt')
        io.saveAsTabbedText(records, '../../data/product_ndc_canon.txt')

        # no errors, rename
        os.remove(whiteListFileName)
        os.rename(tempName, whiteListFileName)
        

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

if __name__ == '__main__':
    y = BuildDrugCanon()
    y.build()
