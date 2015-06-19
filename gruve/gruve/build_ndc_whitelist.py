import csv
from gruve import io

class BuildNdcWhiteList():
    '''
    Limits the list of Product and Package NDC's to be what is in the Medicare
    cost speradsheet
    '''
    def __init__(self):
        pass

    # -------------------------------------------------------------------------

    def parsePackageNDC(self, ndc):
        return {'packageCode' : ndc[-2:],
                'productCode' : ndc[-6:-2],
                'labeler' : ndc[:-6]}

    def formatProductNDC(self, parsed):
        return parsed['labeler'] + '-' + parsed['productCode']

    def formatPackageNDC(self, parsed):
        return self.formatProductNDC(parsed) + '-' + parsed['packageCode']

    def map_nadac(self, x):
        parsedNDC = self.parsePackageNDC(x['NDC'])
        return {'description': x['NDC Description'],
                'packageCode' : parsedNDC['packageCode'],
                'productCode' : parsedNDC['productCode'],
                'labeler' : parsedNDC['labeler'],
                'package_ndc': self.formatPackageNDC(parsedNDC),
                'product_ndc': self.formatProductNDC(parsedNDC),
                'price_per_unit': x['NADAC Per Unit'],
                'unit': x['Pricing Unit']
                }

    def acquire_nadac(self):
        fileName = io.relativeToAbsolute('../../data/NADAC 20150617.txt')
        with open(fileName) as f:
            for row in csv.DictReader(f, dialect=csv.excel_tab):
                yield self.map_nadac(row)

    # -------------------------------------------------------------------------

    def execute(self):
        data = list(self.acquire_nadac())
        columns = sorted(data[0].keys())

        outFileName = io.relativeToAbsolute('../../data/product_ndc.txt')
        with open(outFileName, 'w') as f:
            writer = csv.DictWriter(f, columns, dialect=csv.excel_tab, extrasaction='ignore')
            writer.writeheader()
            writer.writerows(data)

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

if __name__ == '__main__':
    y = BuildNdcWhiteList()
    y.execute()


