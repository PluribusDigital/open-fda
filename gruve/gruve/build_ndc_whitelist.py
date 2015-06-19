import sys
import csv
import re
from gruve import io

class BuildNdcWhiteList():
    '''
    Limits the list of Product and Package NDC's to be what is in the Medicare
    cost speradsheet
    '''
    def __init__(self):
        self.titleExceptions = ['and']

    # -------------------------------------------------------------------------

    def parsePackageNDC(self, ndc):
        labeler = ndc[:-6]
        if labeler[:2] == '00':
            labeler = labeler[1:]

        return {'package_code' : ndc[-2:],
                'product_code' : ndc[-6:-2],
                'labeler' : labeler}

    def formatProductNDC(self, parsed):
        return parsed['labeler'] + '-' + parsed['product_code']

    def formatPackageNDC(self, parsed):
        return self.formatProductNDC(parsed) + '-' + parsed['package_code']

    def map_nadac(self, x):
        parsedNDC = self.parsePackageNDC(x['NDC'])
        return {'description': x['NDC Description'],
                'package_code' : parsedNDC['package_code'],
                'product_code' : parsedNDC['product_code'],
                'labeler' : parsedNDC['labeler'],
                'package_ndc': self.formatPackageNDC(parsedNDC),
                'product_ndc': self.formatProductNDC(parsedNDC),
                'price_per_unit': x['NADAC Per Unit'],
                'unit': x['Pricing Unit']
                }

    def acquire_nadac(self):
        # Source is http://www.medicaid.gov/Medicaid-CHIP-Program-Information/By-Topics/Benefits/Prescription-Drugs/Pharmacy-Pricing.html
        fileName = io.relativeToAbsolute('../../data/NADAC 20150617.txt')
        with open(fileName) as f:
            for row in csv.DictReader(f, dialect=csv.excel_tab):
                yield self.map_nadac(row)

    # -------------------------------------------------------------------------

    def title(self, s):
        ''' Normalize the proprietary and non-proprietary names 
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
        # the FDA dataset mis-parses some 11 digit NDCs
        ndc = x['PRODUCTNDC']
        codes = ndc.split('-')
        if len(codes[0]) == 5 and len(codes[1]) < 4:
            ndc = codes[0] + '-0' + codes[1]

        return {'product_ndc': ndc,
                'proprietary_name': self.title(x['PROPRIETARYNAME']),
                'nonproprietary_name': self.title(x['NONPROPRIETARYNAME']),
                'dea_schedule': x['DEASCHEDULE']
                }

    def acquire_fda_ndc(self):
        # Source is http://www.fda.gov/Drugs/InformationOnDrugs/ucm142438.htm
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
            else:
                print(row['product_ndc'], 'not matched in FDA data set', 
                      file=sys.stderr)
            yield row

    # -------------------------------------------------------------------------

    def execute(self):
        # load the FDA info as a dictionary
        fda_info = {x['product_ndc']: x for x in self.acquire_fda_ndc() }

        outFileName = io.relativeToAbsolute('../../data/product_ndc.txt')
        columns = []

        # output the join as it processes
        with open(outFileName, 'w') as f:
            for row in self.join(fda_info):
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
    y = BuildNdcWhiteList()
    y.execute()


