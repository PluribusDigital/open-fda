import unittest
from gruve import PackageNdc

class TestPackageNdc(unittest.TestCase):
    def setUp(self):
        self.suite = [{'l': 9, 'prc' : 9, 'pkc': 9, 'formatted': '0009-0009-09'},
                      {'l': 99, 'prc' : 9, 'pkc': 9, 'formatted': '0099-0009-09'},
                      {'l': 999, 'prc' : 9, 'pkc': 9, 'formatted': '0999-0009-09'},
                      {'l': 9999, 'prc' : 9, 'pkc': 9,  'formatted': '9999-0009-09'},
                      {'l': 99999, 'prc' : 9, 'pkc': 9,  'formatted': '99999-0009-09'},
                      {'l': 9, 'prc' : 99, 'pkc': 9,  'formatted': '0009-0099-09'},
                      {'l': 99, 'prc' : 99, 'pkc': 9,  'formatted': '0099-0099-09'},
                      {'l': 999, 'prc' : 99, 'pkc': 9,  'formatted': '0999-0099-09'},
                      {'l': 9999, 'prc' : 99, 'pkc': 9,  'formatted': '9999-0099-09'},
                      {'l': 99999, 'prc' : 99, 'pkc': 9,  'formatted': '99999-0099-09'},
                      {'l': 9, 'prc' : 999, 'pkc': 9,  'formatted': '0009-0999-09'},
                      {'l': 99, 'prc' : 999, 'pkc': 9,  'formatted': '0099-0999-09'},
                      {'l': 999, 'prc' : 999, 'pkc': 9,  'formatted': '0999-0999-09'},
                      {'l': 9999, 'prc' : 999, 'pkc': 9,  'formatted': '9999-0999-09'},
                      {'l': 99999, 'prc' : 999, 'pkc': 9,  'formatted': '99999-0999-09'},
                      {'l': 9, 'prc' : 9999, 'pkc': 9,  'formatted': '0009-9999-09'},
                      {'l': 99, 'prc' : 9999, 'pkc': 9,  'formatted': '0099-9999-09'},
                      {'l': 999, 'prc' : 9999, 'pkc': 9,  'formatted': '0999-9999-09'},
                      {'l': 9999, 'prc' : 9999, 'pkc': 9,  'formatted': '9999-9999-09'},
                      {'l': 99999, 'prc' : 9999, 'pkc': 9,  'formatted': '99999-9999-09'},
                      {'l': 9, 'prc' : 9, 'pkc': 99, 'formatted': '0009-0009-99'},
                      {'l': 99, 'prc' : 9, 'pkc': 99, 'formatted': '0099-0009-99'},
                      {'l': 999, 'prc' : 9, 'pkc': 99, 'formatted': '0999-0009-99'},
                      {'l': 9999, 'prc' : 9, 'pkc': 99,  'formatted': '9999-0009-99'},
                      {'l': 99999, 'prc' : 9, 'pkc': 99,  'formatted': '99999-0009-99'},
                      {'l': 9, 'prc' : 99, 'pkc': 99,  'formatted': '0009-0099-99'},
                      {'l': 99, 'prc' : 99, 'pkc': 99,  'formatted': '0099-0099-99'},
                      {'l': 999, 'prc' : 99, 'pkc': 99,  'formatted': '0999-0099-99'},
                      {'l': 9999, 'prc' : 99, 'pkc': 99,  'formatted': '9999-0099-99'},
                      {'l': 99999, 'prc' : 99, 'pkc': 99,  'formatted': '99999-0099-99'},
                      {'l': 9, 'prc' : 999, 'pkc': 99,  'formatted': '0009-0999-99'},
                      {'l': 99, 'prc' : 999, 'pkc': 99,  'formatted': '0099-0999-99'},
                      {'l': 999, 'prc' : 999, 'pkc': 99,  'formatted': '0999-0999-99'},
                      {'l': 9999, 'prc' : 999, 'pkc': 99,  'formatted': '9999-0999-99'},
                      {'l': 99999, 'prc' : 999, 'pkc': 99,  'formatted': '99999-0999-99'},
                      {'l': 9, 'prc' : 9999, 'pkc': 99,  'formatted': '0009-9999-99'},
                      {'l': 99, 'prc' : 9999, 'pkc': 99,  'formatted': '0099-9999-99'},
                      {'l': 999, 'prc' : 9999, 'pkc': 99,  'formatted': '0999-9999-99'},
                      {'l': 9999, 'prc' : 9999, 'pkc': 99,  'formatted': '9999-9999-99'},
                      {'l': 99999, 'prc' : 9999, 'pkc': 99,  'formatted': '99999-9999-99'},
                      ]

    def test_canon(self):
        for s in self.suite:
            actual = PackageNdc.parse(s['formatted'])
            self.assertEqual(s['l'], actual.labeler)
            self.assertEqual(s['prc'], actual.productCode)
            self.assertEqual(s['pkc'], actual.packageCode)
            self.assertEqual(s['formatted'], actual.format())

    def test_nadac(self):
        for s in self.suite:
            newFormat = s['formatted'].replace('-', '')
            if s['l'] < 10000:
                newFormat = '0' + newFormat

            actual = PackageNdc.parse_nadac(newFormat)
            self.assertEqual(s['l'], actual.labeler)
            self.assertEqual(s['prc'], actual.productCode)
            self.assertEqual(s['pkc'], actual.packageCode)
            self.assertEqual(s['formatted'], actual.format())
            self.assertEqual(newFormat, actual.format_nadac())

    def test_fda(self):
        self.suite[4]['formatted'] = '99999-009-09'
        self.suite[9]['formatted'] = '99999-099-09'
        self.suite[14]['formatted'] = '99999-999-09'
        self.suite[24]['formatted'] = '99999-009-99'
        self.suite[29]['formatted'] = '99999-099-99'
        self.suite[34]['formatted'] = '99999-999-99'

        for s in self.suite:
            actual = PackageNdc.parse(s['formatted'])
            self.assertEqual(s['l'], actual.labeler)
            self.assertEqual(s['prc'], actual.productCode)
            self.assertEqual(s['pkc'], actual.packageCode)
            self.assertEqual(s['formatted'], actual.format_fda())


    def test_nutricel(self):
        actual = PackageNdc.parse('53157-AS3-10')
        self.assertEqual(53157, actual.labeler)
        self.assertEqual(120, actual.productCode)
        self.assertEqual(10, actual.packageCode)
        self.assertEqual('53157-0120-10', actual.format())

if __name__ == '__main__':
    unittest.main()
