app.controller("VizController", ['$scope', '$http', '$routeParams', '$location', '$sanitize', 
  function ($scope, $http, $routeParams, $location, $sanitize) {

  $scope.treeData=[];
  $scope.focusNode={};

  $scope.getNode = function (node) {
    // label data
    var ident = node.identifier;
    // manually escape any trailing periods
    if ( ident.substring(ident.length-1,ident.length) === "." ) {
      ident = ident.substring(0,ident.length-1)+"-*-";
    }
    $http.get('/api/v1/node/'+node.type.toLowerCase()+'/'+ident , {}
    ).then(function(response){
      $scope.treeData = response.data;
      $scope.focusNode.name = $scope.treeData.name;
      return true;
    });
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