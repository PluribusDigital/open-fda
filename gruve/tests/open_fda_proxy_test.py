import unittest
import gruve

class TestOpenFdaProxy(unittest.TestCase):
    def test_get(self):
        target = gruve.OpenFdaProxy()
        actual = target.get('https://api.fda.gov/drug/label.json?search=openfda.product_ndc:0001-')
        self.assertTrue(target.status_code == 200)
        self.assertTrue(actual)
        self.assertTrue(len(actual) > 0)

if __name__ == '__main__':
    unittest.main()
