app.directive('panel',function() {
  return {
    restrict: 'E',
    transclude: true,
    scope: {
      panelTitle: '@',
      panelClass: '@',
      expand: '@',
      style: '@'
    },
    templateUrl: 'panel.html'
  };
});