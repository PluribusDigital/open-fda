var app = angular.module('openFDA', [
    'templates', 'ngRoute', 'ngResource', 'directives', 'angular-flash.service',
    'angular-flash.flash-alert-directive', 'ui.bootstrap'
]);

app.config([
'$routeProvider', 'flashProvider', function ($routeProvider, flashProvider) {
    flashProvider.errorClassnames.push("alert-danger");
    flashProvider.warnClassnames.push("alert-warning");
    flashProvider.infoClassnames.push("alert-info");
    flashProvider.successClassnames.push("alert-success");
    return $routeProvider.when('/', {
        templateUrl: "Drug/Drug.html",
        controller: 'DrugController'
    }).when('/drug/:product_ndc', {
        templateUrl: "Drug/Drug.html",
        controller: 'DrugController'
    }).when('/about', {
        templateUrl: "About/About.html",
        controller: 'AboutController'
    })
}
]);

var directives  = angular.module('directives', []);