app.controller("DrugController", ['$scope', '$http', '$routeParams', '$location', 
  function ($scope, $http, $routeParams, $location) {

  window.DrugControllerScope = $scope;
  $scope.selectedDrug = {}
  $scope.drug, $scope.events = null;
  $scope.selectedLabel = null;
  $scope.searchPlaceholder = "enter drug name (e.g. Lipitor)";

  // typeahead search
  $scope.searchDrugs = function(val) {
    return $http.get('/api/v1/drugs.json', {
      params: {
        q: val
      }
    }).then(function(response){
      return response.data.results.map(function(item){
        return item;
      });
    });
  };

  $scope.onSelect = function (item, model, label) {
      // $scope.selectedDrug = item;
      $scope.navigateToDrug(item.product_ndc)
  };

  // fetch details for a given drug
  $scope.getDetail = function () {
    // label data
    $http.get('/api/v1/drugs/' + $scope.selectedDrug.product_ndc , {}
    ).then(function(response){
      $scope.drug = response.data;
      return true;
    });
    // events data
    $http.get('/api/v1/events?product_ndc=' + $scope.selectedDrug.product_ndc + '' , {}
    ).then(function(response){
      $scope.events = response.data.results;
      return true;
    });
    $scope.searchPlaceholder = "new search"
    return true;
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
