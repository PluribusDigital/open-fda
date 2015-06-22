import os
import sys
import csv
from gruve import io, AcquireOpenFda, Feature, ProductNdc

class ExtractOpenFdaFeatures():
    def __init__(self):
        self.source = AcquireOpenFda()
        self.features = [Feature('openfda.manufacturer_name'),
                         Feature('openfda.pharm_class_cs'),
                         Feature('openfda.pharm_class_epc'),
                         Feature('openfda.pharm_class_moa'),
                         Feature('openfda.pharm_class_pe'),
                         Feature('openfda.product_type'),
                         Feature('openfda.route'),
                         Feature('openfda.substance_name'),
                         Feature('openfda.brand_name'),
                         Feature('openfda.generic_name'),
                         Feature('active_ingredient'),
                         Feature('inactive_ingredient')
                        ]

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
                    for feature in self.features:
                        feature.accumulate(id, record)
        
        print('Writing Raw Features')
        for feature in self.features:
            baseName = '-'.join(feature.fields)
            fileName = io.relativeToAbsolute('../../data/'+baseName+'.txt')
            feature.save(fileName)

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

if __name__ == '__main__':
    y = ExtractOpenFdaFeatures()
    y.extract()
