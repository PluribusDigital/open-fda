app.controller("DrugController", ['$scope', '$http', function ($scope, $http) {


  $scope.getLocation = function(val) {
    return $http.get('/drugs.json', {
      params: {
        name: val
      }
    }).then(function(response){
      return response.data.results.map(function(item){
        return item.name;
      });
    });
  };

}]);
