app.controller("NodeController", ['$scope', '$http', '$routeParams', '$location', '$sanitize', 
  function ($scope, $http, $routeParams, $location, $sanitize) {

  window.NodeControllerScope = $scope; // debugging hook TODO: remove

  $scope.treeData=[];
  $scope.focusNode={};

  $scope.getNode = function (node) {
    // label data
    $http.get('/api/v1/node/'+node.type.toLowerCase()+'/'+node.identifier , {}
    ).then(function(response){
      $scope.treeData = response.data;
      $scope.focusNode.name = $scope.treeData.name;
      return true;
    });
  }

  $scope.drillOnNode = function (node) {
    // fetch node data based on type
    $scope.focusNode = node;
    $scope.getNode(node);
  }

  // if we have a type & ID via the route, use that
  if ($routeParams.type && $routeParams.identifier) {
    $scope.drillOnNode({type:$routeParams.type,identifier:$routeParams.identifier});
  }

}]);