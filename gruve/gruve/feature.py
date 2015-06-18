import os
import sys
import json
import csv
from gruve import io

class Feature():
    """
    This class manages a set of key-value tuples.
    - The tuples are unique within the feature
    - A key may have one or more values
    """
    def __init__(self, field):
        '''
        `field` will be the field that is extracted from the input. 
        '''
        self.field = field
        self.data = set()

    # -------------------------------------------------------------------------

    def accumulate(self, key, object):
        ''' 
        `key` is the field that is considered the primary key for the system
        '''
        if self.field not in object:
            return

        value = object[self.field]
        if isinstance(value, list):
            for x in value:
                self.data.add((key, x))
        else:
            self.data.add((key, value))

    # -------------------------------------------------------------------------

    def load(self, fileName):
        pass

    def save(self, fileName):
        with open(fileName, 'w', encoding='utf-8') as f:
            print('Key\tValue', file=f)
            for pair in self.data:
                print(pair[0],pair[1],sep='\t',file=f)

        

