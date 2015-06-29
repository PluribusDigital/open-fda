app.controller("DrugController", ['$scope', '$routeParams', '$location', 'DrugService', 'EventService',
function ($scope, $routeParams, $location, drugService, eventService) {
    $scope.selectedDrug = {}
    $scope.drug = null;
    $scope.eventsDetail = null;

    // fetch details for a given drug
    $scope.getDetail = function () {
        drugService.getDetails($scope.selectedDrug.product_ndc, $scope.onDetailsLoaded);
    }

    $scope.onDetailsLoaded = function (data) {
        $scope.drug = data;
        $scope.drillOnEvent(''); // get a sampling of recent events
    }

    // fetch event details for table
    $scope.drillOnEvent = function (term) {
        eventService.index($scope.drug.proprietary_name, term, $scope.onEventsLoaded);
    }

    $scope.onEventsLoaded = function (data) {
        $scope.eventsDetail = data.results;
    }

    // navigate among drugs
    $scope.navigateToDrug = function (product_ndc) {
        return $location.path("/drug/" + product_ndc);
    }

    // if we have a drug ID via the route, use that
    if ($routeParams.product_ndc) {
        $scope.drugLoading = true;
        $scope.selectedDrug.product_ndc = $routeParams.product_ndc;
        $scope.getDetail();
    }

}]);
