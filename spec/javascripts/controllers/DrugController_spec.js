describe("DrugController", function() {
  var ctrl, scope, http, routeParams, location, setupController;
  scope = null;
  ctrl = null;
  location = null;
  routeParams = null;
  setupController = function(keywords) {
    return inject(function($location, $routeParams, $rootScope, $controller) {
      scope = $rootScope.$new();
      location = $location;
      routeParams = $routeParams;
      return ctrl = $controller('DrugController', {
        $scope: scope,
        $location: location
      });
    });
  };
  beforeEach(module("openFDA"));
  beforeEach(setupController());

  return it('defaults to no drug', function() {
    return expect(scope.selectedDrug).toEqualData({});
  });
  
});