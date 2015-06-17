app.controller("DrugController", ['$scope', '$http', '$routeParams', function ($scope, $http, $routeParams) {

  window.DrugControllerScope = $scope;
  $scope.selectedProductNDC, $scope.drug = null;

  // typeahead search
  $scope.searchDrugs = function(val) {
    return $http.get('/drugs.json', {
      params: {
        name: val
      }
    }).then(function(response){
      return response.data.results.map(function(item){
        $scope.selectedProductNDC = item.product_ndc;
        return item.name;
      });
    });
  };

  // fetch all relevant details for a given drug
  $scope.getDetail = function() {
    return $http.get('/drugs/' + $scope.selectedProductNDC + '.json', {}
    ).then(function(response){
      $scope.drug = response.data;
      return response.data;
    });
  }

  // if we have a drug ID via the route, use that
  if ($routeParams.product_ndc) {
    $scope.selectedProductNDC = $routeParams.product_ndc;
    $scope.getDetail();
  }

}]);
