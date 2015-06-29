app.factory('NodeService',
    function ($http) {
        'use strict';

        var service = {
           error: function (response) {
                console.log('error when calling Node API');
                console.log(response);
                return [];
            },

            getDetails: function (nodeType, identifier, success) {
                // manually escape any periods
                identifier = U.replaceAll(identifier,".","-*-");
                $http.get('/api/v1/node/'+nodeType.toLowerCase()+'/'+identifier , {})
                     .then(function (response) { success(response.data); }, this.error);
            }

        };

        return service;
    });