app.controller("DrugController", ['$scope', '$routeParams', '$location', '$anchorScroll', 'DrugService', 'EventService',
function ($scope, $routeParams, $location, $anchorScroll, drugService, eventService) {
    $scope.selectedDrug = {}
    $scope.drug = null;
    $scope.eventTerm = null;
    $scope.eventsDetail = null;
    $scope.eventQualData = {
        labels:["physician", "pharmacist", "other health prof.", "lawyer", "consumer or non health professional"],
        values:[]
    };

    // fetch details for a given drug
    $scope.getDetail = function () {
        drugService.getDetails($scope.selectedDrug.product_ndc, $scope.onDetailsLoaded);
    }

    $scope.onDetailsLoaded = function (data) {
        $scope.drug = data;
        // $scope.drillOnEvent(''); // get a sampling of recent events
    }

    // fetch event details for table
    $scope.drillOnEvent = function (term) {
        $scope.eventTerm = term;
        eventService.index($scope.drug.proprietary_name, term, $scope.onEventsLoaded);
    }

    $scope.onEventsLoaded = function (data) {
        $scope.eventsDetail = data.results;
        $scope.eventQualData.values = [
            20*data.results.qualification_breakdown.unknown,
            20*data.results.qualification_breakdown.physician,
            20*data.results.qualification_breakdown.pharmacist,
            20*data.results.qualification_breakdown.other_health_professional,
            20*data.results.qualification_breakdown.lawyer,
            20*data.results.qualification_breakdown.consumer_or_non_health_professional
        ]
    }

    // replacement for normal HTML anchor links (<a href="#foo">)
    $scope.scrollTo = function(id) {
      $location.hash(id);
      $anchorScroll();
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
