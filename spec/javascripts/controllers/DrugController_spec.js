describe("DrugController", function () {
    var scope, DrugServiceMock, EventServiceMock, target;

    beforeEach(module("openFDA"));

    // Mock the services
    beforeEach(function () {
        DrugServiceMock = {
            typeAheadSearch: function (val) {
                return { 'results': [{ 'name': 'x' }] };
            },

            getDetails: function (product_ndc, success) {
                success({ 'proprietary_name': 'xyz' });
            }
        };

        EventServiceMock = {
            index: function (brand, symptom, success) {
                success({ 'results': [] });
            }
        };

        module(function ($provide) {
            $provide.value('DrugService', DrugServiceMock);
            $provide.value('EventService', EventServiceMock);
        });

        spyOn(DrugServiceMock, 'getDetails').and.callThrough();
        spyOn(EventServiceMock, 'index').and.callThrough();
    });

    describe('with no routeParams', function () {
        beforeEach(inject(function ($rootScope, $controller) {
            scope = $rootScope.$new();
            target = $controller('DrugController', {
                $scope: scope,
                $routeParams: {}
            });
        }));

        it('defaults to no drug', function () {
            expect(scope.selectedDrug).toEqualData({});
            expect(scope.drug).toBeNull();
            expect(scope.eventsDetail).toBeNull();
        });
    });

    describe('with a product NDC in the routeParams', function () {
        var location = null;

        beforeEach(inject(function ($rootScope, $controller, $location) {
            scope = $rootScope.$new();
            location = $location;
            target = $controller('DrugController', {
                $scope: scope,
                $routeParams: {'product_ndc' : '0001-0001'}
            });
        }));

        it('gets details, but not events on initial load', function () {
            expect(scope.drug).not.toBeNull();
            expect(scope.eventsDetail).toBeNull();
            expect(DrugServiceMock.getDetails).toHaveBeenCalledWith('0001-0001', jasmine.any(Function));
        });

        it('navigates to other drugs', function () {
            scope.navigateToDrug('0002-0002');
            expect(location.$$url).toEqual('/drug/0002-0002');
        });

        it('drills down on event details', function () {
            scope.drillOnEvent('VOMITING');
            expect(scope.eventsDetail).not.toBeNull();
            expect(EventServiceMock.index).toHaveBeenCalledWith('xyz', 'VOMITING', jasmine.any(Function));
        });

    });
});