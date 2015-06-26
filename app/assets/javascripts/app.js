var app = angular.module('openFDA', [
    'templates', 'ngRoute', 'ngResource', 'ngSanitize', 'directives', 'angular-flash.service',
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
    }).when('/viz', {
        templateUrl: "Node/Node.html",
        controller: 'NodeController'
    });
}
]);

app.run(function($rootScope) {

  //app util functions
  $rootScope.UTIL = {

    //Parse date in YYYYmmdd format and return date
    parseDate: function(dateString) {
      if(!/^(\d){8}$/.test(dateString)) return "invalid date";
      var y = dateString.substr(0,4),
          m = dateString.substr(4,2) - 1,
          d = dateString.substr(6,2);
      return new Date(y, m, d);
    },

    //template strings to change class to colorize.
    classifyRecall: function(recallClassification) {
      switch (recallClassification) {
        case "Class I":
          return "danger";
        case "Class II":
          return "warning";
        case "Class III":
          return "info";
        default:
          return "";
      }
    }

  };
});

var directives  = angular.module('directives', []);
