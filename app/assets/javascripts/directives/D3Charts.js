app.controller('D3BarController', function ($scope) {
    $scope.event_data = [];

    $scope.onLoaded = function (data) {
        if (data == null)
            return;

        $scope.event_data = data;
    };

    $scope.onClick = function (term) {
        $scope.clickTarget()(term);
    }
});


app.directive('barchart', function () {
    var chart = {
        restrict: 'EA',
        scope: {
            series: "=",
            clickTarget: "&"
        },
        template: '<table class="table"><tbody><tr ng-repeat="datum in event_data"><th>{{datum.term}}</th><td><a href="" ng-click="onClick(datum.term)">{{datum.count}}</a></td></tr></tbody></table>',
        controller: 'D3BarController',
        link: function (scope, element, attrs) {
            // watch for the value to bind
            scope.$watch('series', function (newValue, oldValue) {
                if (newValue)
                    scope.onLoaded(newValue);
            });
        }
    }

    return chart;
});