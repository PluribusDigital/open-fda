app.controller("SearchController", 
function ($rootScope, $scope, $location, DrugService) {
    $scope.currentPath = '/';
    $scope.shortPath = '/';
    $scope.hide = false;

    $scope.reset = function () {
        $scope.selectedLabel = null;
        $scope.searchPlaceholder = "enter drug name (e.g. Lipitor)";
    };

    $scope.searchDrugs = function (val) {
        return DrugService.typeAheadSearch(val);
    };

    $scope.onSelect = function (item, model, label) {
        $scope.reset();
        if ($scope.shortPath=="/viz") {
            return $location.path("/viz/Drug/" + item.product_ndc);    
        } else {
            return $location.path("/drug/" + item.product_ndc);    
        }
    };

    $scope.onNewLocation = function (newValue, oldValue) {
        $scope.currentPath = newValue;
        $scope.shortPath   = newValue.split('/').slice(0,2).join("/");
        if( $scope.hideOnHome || null )
            $scope.hide = ($scope.currentPath == '/')
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