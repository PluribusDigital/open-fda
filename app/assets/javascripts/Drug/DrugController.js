app.controller("DrugController", ['$scope', '$http', function ($scope, $http) {

  window.DrugControllerScope = $scope;
  $scope.selectedDrug, $scope.drug = null;


  // typeahead search
  $scope.searchDrugs = function(val) {
    return $http.get('/drugs.json', {
      params: {
        name: val
      }
    }).then(function(response){
      return response.data.results.map(function(item){
        $scope.selectedDrug = item;
        return item.name;
      });
    });
  };

  // fetch all relevant details for a given drug
  $scope.getDetail = function() {
    $scope.drug = $scope.selectedDrug;
  }

}]);
