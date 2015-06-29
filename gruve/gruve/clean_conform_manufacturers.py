import re
import os
import sys
import csv
from collections import defaultdict
from gruve import io, ProductNdc

class CleanAndConformManufacturers():
    '''
    The raw extract of the manufacturers contain many slight variations of the
    manufacturer's name.  This class determines the "best" representation of
    the name
    '''
    def __init__(self):
        self.sourceFileName = io.relativeToAbsolute('../../data/openfda-manufacturer_name.txt')
        self.targetFileName = io.relativeToAbsolute('../../data/cleaned-manufacturer_name.txt')
        self.groups = defaultdict(list)
    
    # -------------------------------------------------------------------------
    # Monad-like functions for partitioning
    # 

    def _defaultPartition(self, x):
        return x[0:4].lower()

    def _fixEDotFO(self, x):
        if x[:4] == 'E.FO':
            return x[0:2] + ' ' + x[2:]
        return x

    def _stripThe(self, x):
        if x[:4].lower() == 'the ':
            return x[4:]
        return x

    # -------------------------------------------------------------------------
    # Monad-like functions for processing strings
    # 

    def _replaceCommaEnd(self, x):
        if x[-1] == ',':
            return x[:-1] + '.'
        return x

    def _stripAddress(self, x):
        if ', Lincolnton, NC 28092' in x:
            return x[:-22] + '.'
        if ', Woodcliff Lake, NJ 07677' in x:
            return x[:-26] + '.'
        return x

    def _stripDoublePeriodEnd(self, x):
        if x[-2:] == '..':
            return x[:-1]
        return x

    def _stripGo(self, x):
        if x[-5:] == ' [GO]':
            return x[:-5]
        return x

    # -------------------------------------------------------------------------

    def _map(self, x):
        '''
        Extend the manufacturer record to include the labeler value from the 
        product NDC and the partition key to use
        '''
        ndc = ProductNdc.parse(x['product_ndc'])
        partition = x['name']
        for fn in [self._stripThe, self._fixEDotFO, self._defaultPartition]:
            partition = fn(partition)

        return {'name': x['name'],
                'labeler': ndc.labeler,
                'product_ndc': x['product_ndc'],
                'partition' : partition
                }

    def _acquire(self):
        with open(self.sourceFileName, 'r', encoding='utf-8') as f:
            for row in csv.DictReader(f, dialect=csv.excel_tab):
                yield self._map(row)

    def _reduce(self, dicts):
        '''
        Reduce the manufacturer's name to the longest.
        Multiple values are returned if the starting character is different
        '''
        bestNames = defaultdict(str)
        for i in range(0, len(dicts)):
            name = dicts[i]['name']
            for fn in [self._stripThe, self._fixEDotFO]:
                name = fn(name)

            key = dicts[i]['partition']
            best = bestNames[key]
            if len(best) < len(name):
                bestNames[key] = name
        return self._clean(bestNames)

    def _clean(self, dict):
        '''
        Use monad-like functions to clean the strings
        '''
        for k in dict:
            value = dict[k]
            for fn in [self._replaceCommaEnd, 
                       self._stripAddress,
                       self._stripGo,
                       self._stripDoublePeriodEnd]:
                value = fn(value)
            dict[k] = value
        return dict

    def _save(self):
        with open(self.targetFileName, 'w', encoding='utf-8') as f:
            print('product_ndc', 'name', sep='\t', file=f)
            for k in sorted(self.groups):
                for manu in self.groups[k]:
                    print(manu['product_ndc'], manu['name'],sep='\t',file=f)

    # -------------------------------------------------------------------------

    def process(self):
        ''' 
        Make a key-value map of certain attributes in the Open FDA dataset
        '''
        print('Building Map')
        for manu in self._acquire():
            self.groups[manu['labeler']].append(manu)

        print('Finding "best" representation of manufacturer')
        for k in sorted(self.groups):
            names = self._reduce(self.groups[k])
            for manu in self.groups[k]:
                key = manu['partition']
                manu['name'] = names[key]

        print('Saving')
        self._save()

        # no errors, rename
        os.remove(self.sourceFileName)
        os.rename(self.targetFileName, self.sourceFileName)

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

if __name__ == '__main__':
    y = CleanAndConformManufacturers()
    y.process()
