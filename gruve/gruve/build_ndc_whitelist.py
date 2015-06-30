import sys
import csv
import re
from gruve import io, ProductNdc, PackageNdc

class BuildNdcWhiteList():
    '''
    Limits the list of Product and Package NDC's to match records in the 
    Medicare cost speradsheet
    '''
    def __init__(self):
        self.titleExceptions = ['and']

    def __str__(self):
        return 'Build NDC White List'
    # -------------------------------------------------------------------------

    def map_nadac(self, x):
        ''' Projects an element from a record in the Medicare cost spreadsheet.
        '''
        ndc = PackageNdc.parse_nadac(x['NDC'])
        return {'description': x['NDC Description'],
                'package_code' : ndc.packageCode,
                'product_code' : ndc.productCode,
                'labeler' : ndc.labeler,
                'package_ndc': ndc.format(),
                'product_ndc': ndc.format_product(),
                'price_per_unit': x['NADAC Per Unit'],
                'unit': x['Pricing Unit']
                }

    def acquire_nadac(self):
        ''' Loads the records from the Medicare cost spreadsheet.
        Source: [http://www.medicaid.gov/Medicaid-CHIP-Program-Information/By-Topics/Benefits/Prescription-Drugs/Pharmacy-Pricing.html]
        '''
        fileName = io.relativeToAbsolute('../../data/NADAC 20150617.txt')
        with open(fileName) as f:
            for row in csv.DictReader(f, dialect=csv.excel_tab):
                yield self.map_nadac(row)

    # -------------------------------------------------------------------------

    def title(self, s):
        ''' Normalize the proprietary and non-proprietary names.
        Inspiration: [http://stackoverflow.com/questions/3728655/python-titlecase-a-string-with-exceptions]
        '''
        word_list = re.split(' ', s)
        final = [word_list[0].capitalize()]
        for word in word_list[1:]:
            final.append(word.lower()
                         if word.lower() in self.titleExceptions
                         else word.capitalize())
        return " ".join(final)

    def map_fda(self, x):
        ''' Project an element from the FDA product list
        '''
        ndc = ProductNdc.parse(x['PRODUCTNDC'])
        return {'product_ndc': ndc.format(),
                'proprietary_name': self.title(x['PROPRIETARYNAME']),
                'nonproprietary_name': self.title(x['NONPROPRIETARYNAME']),
                'dea_schedule': x['DEASCHEDULE']
                }

    def acquire_fda_ndc(self):
        ''' Loads records from the FDA product list.
        Source: [http://www.fda.gov/Drugs/InformationOnDrugs/ucm142438.htm]
        ''' 
        fileName = io.relativeToAbsolute('../../data/FDA Product NDC 20150618.txt')
        with open(fileName) as f:
            for row in csv.DictReader(f, dialect=csv.excel_tab):
                yield self.map_fda(row)

    # -------------------------------------------------------------------------

    def join(self, fda_info):
        ''' Load the NADAC data set and join the FDA info
        '''
        for row in self.acquire_nadac():
            if row['product_ndc'] in fda_info:
                info = fda_info[row['product_ndc']]
                row.update(info)
                row.update({'is_canon' : False})
            else:
                print(row['product_ndc'], 'not matched in FDA data set', 
                      file=sys.stderr)
            yield row

    # -------------------------------------------------------------------------

    def run(self):
        ''' Perform an inner join between the Medicare and FDA spreadsheets
        '''
        print('Load the FDA info as a dictionary')
        fda_info = {x['product_ndc']: x for x in self.acquire_fda_ndc() }

        print('Join to the Medicare spreadsheet and save')
        io.saveAsTabbedText(self.join(fda_info), '../../data/product_ndc.txt')

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

if __name__ == '__main__':
    y = BuildNdcWhiteList()
    y.run()


