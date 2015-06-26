app.controller("DrugController", ['$scope', '$routeParams', '$location', '$sanitize', 'DrugService', 'EventService',
function ($scope, $routeParams, $location, $sanitize, drugService, eventService) {

  window.DrugControllerScope = $scope; // debugging hook TODO: remove
  $scope.selectedDrug = {}
  $scope.drug = null,
  $scope.eventsDetail = null;
  $scope.selectedLabel = null;
  $scope.searchPlaceholder = "enter drug name (e.g. Lipitor)";

  // typeahead search
  $scope.searchDrugs = function (val) {
      return drugService.typeAheadSearch(val);
  };
  $scope.onSelect = function (item, model, label) {
    $scope.navigateToDrug(item.product_ndc)
  };

  // fetch details for a given drug
  $scope.getDetail = function () {
      drugService.getDetails($scope.selectedDrug.product_ndc, $scope.onDetailsLoaded);
  }

  $scope.onDetailsLoaded = function(data){
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
  $scope.navigateToDrug = function(product_ndc) {
    return $location.path("/drug/" + product_ndc);
  }

  // if we have a drug ID via the route, use that
  if ($routeParams.product_ndc) {
    $scope.drugLoading = true;
    $scope.selectedDrug.product_ndc = $routeParams.product_ndc;
    $scope.getDetail();
  }

}]);
