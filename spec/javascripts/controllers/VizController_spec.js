describe("VizController", function () {
    var scope, NodeServiceMock, target;

    beforeEach(module("openFDA"));

    // Mock the services
    beforeEach(function () {
        NodeServiceMock = {
            getDetails: function (nodeType, identifier, success) {
                success({ 'name': 'xyz', 'children':[] });
            }
        };

        module(function ($provide) {
            $provide.value('NodeService', NodeServiceMock);
        });

        spyOn(NodeServiceMock, 'getDetails').and.callThrough();
    });

    describe('with a product NDC in the routeParams', function () {
        var location = null;

        beforeEach(inject(function ($rootScope, $controller, $location) {
            scope = $rootScope.$new();
            location = $location;
            target = $controller('VizController', {
                $scope: scope,
                $routeParams: {'type':'Drug','identifier' : '0001-0001'}
            });
        }));

        it('gets details', function () {
            expect(scope.treeData).not.toBeNull();
            expect(NodeServiceMock.getDetails).toHaveBeenCalledWith('Drug','0001-0001', jasmine.any(Function));
        });

        it('navigates to other nodes', function () {
            scope.drillOnNode({type:'Drug',identifier:'0002-0002'});
            expect(location.$$url).toEqual('/viz/Drug/0002-0002');
        });

    });
});