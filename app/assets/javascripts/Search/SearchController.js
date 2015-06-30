app.controller("SearchController", 
function ($rootScope, $scope, $location, DrugService) {
    $scope.currentPath = '/';
    $scope.hide = false;
    $scope.noRecords = false;

    $scope.reset = function () {
        $scope.selectedLabel = null;
        $scope.noRecords = false;
        $scope.searchPlaceholder = "enter drug name (e.g. Lipitor)";
    };

    $scope.searchDrugs = function (val) {
        var promise = DrugService.typeAheadSearch(val);
        promise.then(function (data) {
            $scope.noRecords = (data == null || data.length == 0);
        });
        return promise;
    };

    $scope.onSelect = function (item, model, label) {
        $scope.reset();
        $location.hash(null);

        var shortPath = $location.path().split('/').slice(0, 2).join("/");
        if (shortPath == "/viz") {
            return $location.path("/viz/Drug/" + item.product_ndc);    
        } else {
            return $location.path("/drug/" + item.product_ndc);    
        }
    };

    $scope.onNewLocation = function (newValue, oldValue) {
        $scope.currentPath = newValue;
        if( $scope.hideOnHome || null )
            $scope.hide = ($scope.currentPath == '/')
        $scope.reset();
    };

    $scope.reset();
});

app.directive('searchBox', function ($location) {
    var chart = {
        restrict: 'EA',
        scope: {
            hideOnHome: '='
        },
        templateUrl: 'Search/searchTemplate.html',
        controller: 'SearchController',
        link: function (scope, element, attrs) {
            scope.$watch(function () {
                return $location.$$path;
            }, scope.onNewLocation);
        }
    }

    return chart;
});