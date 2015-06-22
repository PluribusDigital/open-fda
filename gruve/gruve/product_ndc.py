
class ProductNdc():
    """Encapsulates the logic for parsing and formatting National Drug Codes
    Includes methods for handling systems that mis-represent the NDC
    """
    def __init__(self):
        self.labeler = 0
        self.productCode = 0

    def __str__(self):
        return "%04d-%04d" % (self.labeler, self.productCode)

    # -------------------------------------------------------------------------

    @classmethod
    def parse(cls, str):
        codes = str.split('-')
        result = ProductNdc()
        result.labeler = int(codes[0])
        result.productCode = int(codes[1]) if codes[1] != 'AS3' else 120
        return result

    # -------------------------------------------------------------------------

    def format(self):
        return str(self)   

    def format_fda(self):
        if self.labeler > 9999 and self.productCode < 1000:
            return "%04d-%03d" % (self.labeler, self.productCode)
        else:
            return str(self)

