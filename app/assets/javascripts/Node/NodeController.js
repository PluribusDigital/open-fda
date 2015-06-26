app.controller("NodeController", ['$scope', '$http', '$routeParams', '$location', '$sanitize', 
  function ($scope, $http, $routeParams, $location, $sanitize) {

  window.NodeControllerScope = $scope; // debugging hook TODO: remove

  $scope.treeData=[];

  $scope.getDrugNode = function (ndc) {
    // label data
    $http.get('/api/v1/node/drug/'+ndc , {}
    ).then(function(response){
      $scope.treeData = response.data;
      return true;
    });
  }

  $scope.drillOnNode = function (d) {
    console.log(">> drill baby, drill!");
    console.log(d);
    // fetch node data based on type
    if (d.type=="Drug") {
       $scope.getDrugNode(d.identifier||d.product_ndc);
    }
  }

  // if we have a type & ID via the route, use that
  if ($routeParams.type && $routeParams.identifier) {
    $scope.drillOnNode({type:$routeParams.type,identifier:$routeParams.identifier});
  }

}]);