app.controller("DrugController", ['$scope', '$http', '$routeParams', 'chartInitializer', 
  function ($scope, $http, $routeParams, chartInitializer) {

  window.DrugControllerScope = $scope;
  $scope.selectedDrug, $scope.drug, $scope.events = null;
  $scope.selectedLabel = null;

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
      $scope.selectedDrug = item;
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
    return true;
  }

  // if we have a drug ID via the route, use that
  if ($routeParams.product_ndc) {
    $scope.selectedDrug.product_ndc = $routeParams.product_ndc;
    $scope.getDetail();
  }

}]);
