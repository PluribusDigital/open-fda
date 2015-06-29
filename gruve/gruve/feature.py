import os
import sys
import json
import csv

class Feature():
    """
    This class manages a set of key-value tuples.
    - The tuples are unique within the feature
    - A key may have one or more values
    """
    def __init__(self, path):
        '''
        `path` will be the path to the field that is extracted from the input. 
        `name` will look for `object['name']`
        `person.name` will look for `object['person']['name']`
        '''
        self.fields = path.split('.')
        self.data = set()

    # -------------------------------------------------------------------------

    def accumulate(self, key, object):
        ''' 
        `key` is the field that is considered the primary key for the system
        '''
        node = object
        for field in self.fields:
            if field not in node:
                return
            node = node[field]

        if isinstance(node, list):
            for x in node:
                self.data.add((key, x))
        else:
            self.data.add((key, node))

    # -------------------------------------------------------------------------

    def load(self, fileName):
        pass

    def save(self, fileName):
        with open(fileName, 'w', encoding='utf-8') as f:
            print('Key\tValue', file=f)
            for pair in self.data:
                print(pair[0],pair[1],sep='\t',file=f)

        

