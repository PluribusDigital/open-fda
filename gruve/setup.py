from setuptools import setup

setup(name='gruve',
      version='0.1',
      description='ETL Pipeline for the Open FDA Project',
      author='STSI',
      packages=['gruve'],
      install_requires=[
          'requests',
      ],
      test_suite='tests',
      zip_safe=False)
