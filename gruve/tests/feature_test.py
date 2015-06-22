import os
import json
import unittest
import gruve

class TestFeature(unittest.TestCase):
    def setUp(self):
        pass

    def test_accumulate_missing_key(self):
        '''missing key column does not produce an error'''
        target = gruve.Feature('y')
        target.accumulate(1, {'x': 'hello'})
        self.assertEqual(0, len(target.data))

    def test_accumulate_single(self):
        target = gruve.Feature('x')
        target.accumulate(1, {'x': 'hello'})
        target.accumulate(2, {'x': 'hi'})
        self.assertEqual(2, len(target.data))

    def test_accumulate_list(self):
        target = gruve.Feature('x')
        target.accumulate(1, {'x': ['hello', 'hi', 'how are ya']})
        self.assertEqual(3, len(target.data))

    def test_accumulate_multiple_ok(self):
        target = gruve.Feature('x')
        target.accumulate(1, {'x': 'hello'})
        target.accumulate(1, {'x': 'hi'})
        self.assertEqual(2, len(target.data))

    def test_accumulate_no_duplicate(self):
        target = gruve.Feature('x')
        target.accumulate(1, {'x': 'hello'})
        target.accumulate(1, {'x': 'hello'})
        self.assertEqual(1, len(target.data))

    def test_accumulate_subfields(self):
        target = gruve.Feature('x.y.z')
        target.accumulate(1, {'x': {'y': {'z': 'hello'}}})
        self.assertEqual(1, len(target.data))

    def test_openFDA_subset(self):
        fileName = os.path.join(os.path.dirname(__file__), 'labels.json')
        with open(fileName, 'r') as f:
            records = json.load(f)

        target = gruve.Feature('openfda.route')
        for record in records:
            target.accumulate(record['id'], record)
        self.assertEqual(86, len(target.data))

if __name__ == '__main__':
    unittest.main()
