app.directive('panel',function() {
  return {
    restrict: 'E',
    transclude: true,
    scope: {
      panelTitle: '@',
      panelClass: '@',
      panelIcon: '@',
      expand: '@',
      style: '@'
    },
    templateUrl: 'panel.html'
  };
});