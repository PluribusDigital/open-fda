import argparse
import gruve

def buildArgParser():
    description = 'Create bulk load files to support the Open FDA prototype'
    p = argparse.ArgumentParser(description=description)
    p.add_argument('-w', '--white-list', action='store_true', dest='whiteList',
                   help='Create the limited list of product NDCs')
    p.add_argument('-f', '--features', action='store_true',
                   dest='features', 
                   help='Extract attributes from the Open FDA data set')
    return p

def executePipeline(operations):
    divider = "=" * 78
    for operation in operations:
        print(divider)
        print(str(operation))
        print(divider)
        operation.run()

def main():
    parser = buildArgParser()
    args = parser.parse_args()

    divider = "=" * 78

    if args.whiteList:
        executePipeline([gruve.BuildNdcWhiteList(), 
                         gruve.BuildDrugCanon()])

    if args.features:
        executePipeline([gruve.ExtractOpenFdaFeatures(), 
                         gruve.CleanAndConformManufacturers()])

    if not args.whiteList and not args.features:
        parser.print_help()

if __name__ == '__main__':
    main()
