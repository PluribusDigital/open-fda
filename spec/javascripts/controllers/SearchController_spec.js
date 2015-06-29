describe("SearchController", function () {
    var scope, DrugServiceMock, target, location;

    beforeEach(module("openFDA"));

    // Mock the services
    beforeEach(function () {
        DrugServiceMock = {
            typeAheadSearch: function (val) {
                return { 'results': [{ 'name': 'x' }] };
            }
        };

        module(function ($provide) {
            $provide.value('DrugService', DrugServiceMock);
        });

        spyOn(DrugServiceMock, 'typeAheadSearch').and.callThrough();
    });

    // Create the target
    beforeEach(inject(function ($rootScope, $controller, $location) {
        scope = $rootScope.$new();
        location = $location;
        target = $controller('SearchController', {
            $scope: scope
        });
    }));

    it('has defaults for every instance variable', function () {
        expect(scope.currentPath).toEqual('/');
        expect(scope.shortPath).toEqual('/');
        expect(scope.hide).toEqual(false);
        expect(scope.selectedLabel).toBeNull();
        expect(scope.searchPlaceholder).toEqual('enter drug name (e.g. Lipitor)');
    });

    it('tracks the current path', function () {
        scope.onNewLocation('/x/y/z', '/someOtherPath');
        expect(scope.currentPath).toEqual('/x/y/z');
        expect(scope.shortPath).toEqual('/x');
    });

    it('does not hide on the front page by default', function () {
        scope.onNewLocation('/', '/someOtherPath');
        expect(scope.currentPath).toEqual('/');
        expect(scope.hide).toEqual(false);
    });

    it('calls the drug service to get a list of drugs', function () {
        var actual = scope.searchDrugs('was');
        expect(actual).not.toBeNull();
        expect(DrugServiceMock.typeAheadSearch).toHaveBeenCalledWith('was');
    });

    it('navigates to a details page by default', function () {
        var item = { 'product_ndc': '0002-0002' };
        scope.onSelect(item, null, null);
        expect(location.$$url).toEqual('/drug/0002-0002');
    });

    describe('when on a visualization page', function () {
        beforeEach(function () {
            scope.selectedLabel = 'some value';
            scope.shortPath = '/viz';
        });

        it('navigates to another visualization page', function () {
            var item = { 'product_ndc': '0002-0002' };
            scope.onSelect(item, null, null);
            expect(location.$$url).toEqual('/viz/Drug/0002-0002');
        });

        afterEach(function () {
            expect(scope.selectedLabel).toBeNull();
        });
    });

    describe('when on a details page', function () {
        beforeEach(function () {
            scope.selectedLabel = 'some value';
            scope.shortPath = '/drug';
        });

        it('navigates to a details page', function () {
            var item = { 'product_ndc': '0002-0002' };
            scope.onSelect(item, null, null);
            expect(location.$$url).toEqual('/drug/0002-0002');
        });

        afterEach(function () {
            expect(scope.selectedLabel).toBeNull();
        });
    });

    it('can be programmed to hide on the front page', function () {
        scope.hideOnHome = true;
        scope.onNewLocation('/', '/someOtherPath');
        expect(scope.currentPath).toEqual('/');
        expect(scope.hide).toEqual(true);
    });
});