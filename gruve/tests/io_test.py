import unittest
from gruve import io

class TestIO(unittest.TestCase):
    def test_dotEnv_exists(self):
        actual = list(io.apiKeys())
        self.assertGreater(len(actual), 0)

    def test_getApiKey_present(self):
        actual = io.getApiKey('OPENFDA_API_KEY')
        self.assertTrue(actual)

    def test_getApiKey_missing(self):
        self.assertRaises(AssertionError, io.getApiKey, 'SOME_OTHER_KEY')

if __name__ == '__main__':
    unittest.main()
