import re
import os
import sys
import csv
from operator import itemgetter
from gruve import io, AcquireOpenFda, Feature, ProductNdc, BuildNdcWhiteList

class ExtractOpenFdaFeatures():
    def __init__(self):
        self.source = AcquireOpenFda()
        self.whiteList = BuildNdcWhiteList()
        self.features = [{'feature':Feature('openfda.manufacturer_name'),
                          'column': 'name',
                          'transform': []},
                         {'feature':Feature('openfda.pharm_class_cs'),
                          'column': 'class_name',
                          'transform': [self.whiteList.title,
                                        self.trimPharmClassCs]},
                         {'feature':Feature('openfda.pharm_class_epc'),
                          'column': 'class_name',
                          'transform': [self.whiteList.title, 
                                        self.trimPharmClass3]},
                         {'feature':Feature('openfda.pharm_class_moa'),
                          'column': 'class_name',
                          'transform': [self.whiteList.title,
                                        self.trimPharmClass3]},
                         {'feature':Feature('openfda.pharm_class_pe'),
                          'column': 'class_name',
                          'transform': [self.whiteList.title,
                                        self.trimPharmClass2]},
                         {'feature':Feature('openfda.product_type'),
                          'column': 'type_name',
                          'transform': [self.titleCaseIgnoreSmall]},
                         {'feature':Feature('openfda.route'),
                          'column': 'route',
                          'transform': [self.whiteList.title]},
                         {'feature':Feature('openfda.substance_name'),
                          'column': 'name',
                          'transform': [self.titleCaseIgnoreSmall]},
                         {'feature':Feature('openfda.brand_name'),
                          'column': 'name',
                          'transform': [self.titleCaseIgnoreSmall]},
                         {'feature':Feature('openfda.generic_name'),
                          'column': 'name',
                          'transform': [self.titleCaseIgnoreSmall]},
                         {'feature':Feature('active_ingredient'),
                          'column': 'text',
                          'transform': []},
                         {'feature':Feature('inactive_ingredient'),
                          'column': 'text',
                          'transform': []}
                        ]

    # -------------------------------------------------------------------------

    def trimPharmClassCs(self, s):
        execute = '[chemical/ingredient]' in s
        return s[:-22] if execute else s

    def trimPharmClass2(self, s):
        return s[:-5] if s[-1] == ']' else s

    def trimPharmClass3(self, s):
        return s[:-6] if s[-1] == ']' else s

    def titleCaseIgnoreSmall(self, s):
        word_list = re.split(' ', s)
        final = [word_list[0].capitalize()]
        for word in word_list[1:]:
            final.append(word if len(word) < 4 else word.capitalize())
        return " ".join(final)

    # -------------------------------------------------------------------------

    def extract(self):
        ''' 
        Make a key-value map of certain attributes in the Open FDA dataset
        '''
        print('Acquiring Records')
        for record in self.source.acquire_labels():
            if 'openfda' in record and 'product_ndc' in record['openfda']:
                for entry in record['openfda']['product_ndc']:
                    ndc = ProductNdc.parse(entry)
                    id = ndc.format()
                    for op in self.features:
                        op['feature'].accumulate(id, record)
        
        print('Writing Features')
        for op in self.features:
            feature = op['feature']
            baseName = '-'.join(feature.fields)
            fileName = io.relativeToAbsolute('../../data/'+baseName+'.txt')

            with open(fileName, 'w', encoding='utf-8') as f:
                print('product_ndc', op['column'], sep='\t', file=f)
                for pair in sorted(feature.data, key=itemgetter(0)):
                    value = pair[1]
                    for fn in op['transform']:
                        value = fn(value)
                    print(pair[0],value,sep='\t',file=f)

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

if __name__ == '__main__':
    y = ExtractOpenFdaFeatures()
    y.extract()
