import unittest
from gruve import ProductNdc

class TestProductNdc(unittest.TestCase):
    def setUp(self):
        self.suite = [{'l': 9, 'prc' : 9, 'formatted': '0009-0009'},
                      {'l': 99, 'prc' : 9, 'formatted': '0099-0009'},
                      {'l': 999, 'prc' : 9, 'formatted': '0999-0009'},
                      {'l': 9999, 'prc' : 9, 'formatted': '9999-0009'},
                      {'l': 99999, 'prc' : 9, 'formatted': '99999-0009'},
                      {'l': 9, 'prc' : 99, 'formatted': '0009-0099'},
                      {'l': 99, 'prc' : 99, 'formatted': '0099-0099'},
                      {'l': 999, 'prc' : 99, 'formatted': '0999-0099'},
                      {'l': 9999, 'prc' : 99, 'formatted': '9999-0099'},
                      {'l': 99999, 'prc' : 99, 'formatted': '99999-0099'},
                      {'l': 9, 'prc' : 999, 'formatted': '0009-0999'},
                      {'l': 99, 'prc' : 999, 'formatted': '0099-0999'},
                      {'l': 999, 'prc' : 999, 'formatted': '0999-0999'},
                      {'l': 9999, 'prc' : 999, 'formatted': '9999-0999'},
                      {'l': 99999, 'prc' : 999, 'formatted': '99999-0999'},
                      {'l': 9, 'prc' : 9999, 'formatted': '0009-9999'},
                      {'l': 99, 'prc' : 9999, 'formatted': '0099-9999'},
                      {'l': 999, 'prc' : 9999, 'formatted': '0999-9999'},
                      {'l': 9999, 'prc' : 9999, 'formatted': '9999-9999'},
                      {'l': 99999, 'prc' : 9999, 'formatted': '99999-9999'},
                      ]

    def test_canon(self):
        for s in self.suite:
            actual = ProductNdc.parse(s['formatted'])
            self.assertEqual(s['l'], actual.labeler)
            self.assertEqual(s['prc'], actual.productCode)
            self.assertEqual(s['formatted'], actual.format())

    def test_fda(self):
        self.suite[4]['formatted'] = '99999-009'
        self.suite[9]['formatted'] = '99999-099'
        self.suite[14]['formatted'] = '99999-999'

        for s in self.suite:
            actual = ProductNdc.parse(s['formatted'])
            self.assertEqual(s['l'], actual.labeler)
            self.assertEqual(s['prc'], actual.productCode)
            self.assertEqual(s['formatted'], actual.format_fda())

    def test_nutricel(self):
        actual = ProductNdc.parse('53157-AS3')
        self.assertEqual(53157, actual.labeler)
        self.assertEqual(120, actual.productCode)
        self.assertEqual('53157-0120', actual.format())


if __name__ == '__main__':
    unittest.main()
