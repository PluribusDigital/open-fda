app.controller("NodeController", ['$scope', '$http', '$routeParams', '$location', '$sanitize', 
  function ($scope, $http, $routeParams, $location, $sanitize) {

  window.NodeControllerScope = $scope; // debugging hook TODO: remove


  $scope.getNode = function () {
    // label data
    $http.get('/api/v1/node/drug/0069-4190' , {}
    ).then(function(response){
      $scope.treeData = response.data;
      return true;
    });
  }

  $scope.drillOnNode = function () {
    console.log("drill");
  }

  $scope.getNode();

}]);