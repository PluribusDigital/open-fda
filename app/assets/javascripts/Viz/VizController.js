app.controller("VizController", ['$scope', '$http', '$routeParams', '$location', '$sanitize', 'NodeService',
  function ($scope, $http, $routeParams, $location, $sanitize, nodeService) {

  $scope.treeData=[];
  $scope.focusNode={};

  $scope.getNode = function (node) {
      nodeService.getDetails(node.type, node.identifier, $scope.onNodeLoaded);
  }

  $scope.onNodeLoaded = function (data) {
      $scope.treeData = data;
      $scope.focusNode.name = $scope.treeData.name;
  }

  $scope.drillOnNode = function (node) {
    // fetch node data based on type
    $scope.focusNode = node;
    $location.path("/viz/"+node.type+"/"+node.identifier);
    $scope.getNode(node);
  }

  // if we have a type & ID via the route, use that
  if ($routeParams.type && $routeParams.identifier) {
    $scope.drillOnNode({type:$routeParams.type,identifier:$routeParams.identifier});
  }

}]);