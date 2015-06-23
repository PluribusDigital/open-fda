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
                           'product_ndc' : ndc,
                           'size' : len(asString)}

    def _reduce(self, tuples):
        if len(tuples) < 1:
            return None

        best = tuples[0]
        for i in range(1, len(tuples)):
            if best[1] < tuples[i][1]:
                best = tuples[i]
        return best

    def _reduceToCanon(self, partitions):
        '''
        A generator that internally calls the reduce function on each entry
        '''
        for name in sorted(partitions):
            result = self._reduce(partitions[name])
            if result:
                yield {'proprietary_name': name,
                       'product_ndc' : result[0]}

    # -------------------------------------------------------------------------

    def build(self):
        ''' 
        Use the size of a record in the FDA data set to determine which product
        NDC is considered _the_ representitive for the same proprietary name
        '''
        print('Acquiring Names')
        fileName = io.relativeToAbsolute('../../data/product_ndc.txt')
        with open(fileName) as f:
            partitions = {x['proprietary_name']: [] 
                          for x in csv.DictReader(f, dialect=csv.excel_tab)}

        print('Mapping Labels')
        for record in self.sourceLabels.acquire_labels():
            for node in self._map(record):
                nameKey = node['proprietary_name']
                if nameKey not in partitions:
                    pass #print(nameKey, 'not in white list', file=sys.stderr)
                else:
                    partitions[nameKey].append((node['product_ndc'], 
                                                node['size']))

        print('Reducing to Canon')
        outFileName = io.relativeToAbsolute('../../data/canon_drugs.txt')
        columns = []

        # output the join as it processes
        with open(outFileName, 'w') as f:
            for row in self._reduceToCanon(partitions):
                if not columns:
                    columns = sorted(row.keys())
                    print('\t'.join(columns), file=f)

                for col in columns:
                    print(row[col] if col in row else '', end='\t', file=f)
                print('', file=f)

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

if __name__ == '__main__':
    y = BuildDrugCanon()
    y.build()
