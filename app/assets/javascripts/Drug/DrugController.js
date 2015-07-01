app.controller("DrugController", ['$scope', '$routeParams', '$location', '$anchorScroll', '$timeout', 'DrugService', 'EventService',
function ($scope, $routeParams, $location, $anchorScroll, $timeout, drugService, eventService) {
    $scope.selectedDrug = {}
    $scope.drug = null;
    $scope.eventTerm = null;
    $scope.eventsDetail = null;
    $scope.eventQualLabels = [ "unk", "MD", "rph", "other", "atty", "cons"];
    $scope.eventQualData = {labels:[],values:[],title:'', key_strings:[]};
    $scope.eventAgeData = {title: '', data:[]};

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
        // update the qualification data for drill-down donut chart
        if (data.results.qualification_breakdown) {
            $scope.eventQualData = {
                title: 'Source Qualification',
                labels: $scope.eventQualLabels,
                values: [
                    data.results.qualification_breakdown.unknown,
                    data.results.qualification_breakdown.physician,
                    data.results.qualification_breakdown.pharmacist,
                    data.results.qualification_breakdown.other_health_professional,
                    data.results.qualification_breakdown.lawyer,
                    data.results.qualification_breakdown.consumer_or_non_health_professional
                ],
                key_strings: Object.keys(data.results.qualification_breakdown)
            }
        }
        if (data.results.age_breakdown) {
            $scope.eventAgeData = {
                title: 'Onset Age and Gender',
                data: data.results.age_breakdown
            }
        }

        // scroll down the page (after it has time to render)
        // TODO:  implement when it works smoothly 
        // $scope.scrollTo('eventDetail');
    }

    // replacement for normal HTML anchor links (<a href="#foo">)
    $scope.scrollTo = function(id) {
        $location.hash(id);
        $timeout(function () {
            $anchorScroll();
        }, 400); // 400 milliseconds is responsive for people, but plenty of time after the page has rendered
   }

    // navigate among drugs
    $scope.navigateToDrug = function (product_ndc) {
        $location.hash(null);
        return $location.path("/drug/" + product_ndc);
    }

    // if we have a drug ID via the route, use that
    if ($routeParams.product_ndc) {
        $scope.drugLoading = true;
        $scope.selectedDrug.product_ndc = $routeParams.product_ndc;
        $scope.getDetail();
    }

}]);
