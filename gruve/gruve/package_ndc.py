import gruve

class PackageNdc(gruve.ProductNdc):
    """Encapsulates the logic for parsing and formatting package NDC
    Includes methods for handling systems that mis-represent the NDC
    """
    def __init__(self):
        self.packageCode = 0
        super(PackageNdc, self).__init__()

    def __str__(self):
        return "%04d-%04d-%02d" % (self.labeler, self.productCode, 
                                   self.packageCode)

    # -------------------------------------------------------------------------

    @classmethod
    def parse(cls, str):
        codes = str.split('-')
        result = PackageNdc()
        result.labeler = int(codes[0])
        result.productCode = int(codes[1]) if codes[1] != 'AS3' else 120
        result.packageCode = int(codes[2])
        return result

    @classmethod
    def parse_nadac(cls, ndc):
        result = PackageNdc()
        result.labeler = int(ndc[:-6])
        result.productCode = int(ndc[-6:-2])
        result.packageCode = int(ndc[-2:])
        return result

    # -------------------------------------------------------------------------

    def format(self):
        return str(self)   

    def format_product(self):
        return "%04d-%04d" % (self.labeler, self.productCode)

    def format_fda(self):
        if self.labeler > 9999 and self.productCode < 1000:
            return "%04d-%03d-%02d" % (self.labeler, self.productCode, 
                                       self.packageCode)
        else:
            return str(self)

    def format_nadac(self):
        return "%05d%04d%02d" % (self.labeler, self.productCode, 
                                 self.packageCode)
