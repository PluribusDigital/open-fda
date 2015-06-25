app.factory('EventService',
    function ($http) {
        'use strict';

        var service = {
            error: function (response) {
                console.log('error when calling Events API');
                console.log(response);
                return [];
            },

            // These methods encapsulate API calls
            index: function (brand, symptom, success) {
                $http.get('/api/v1/events', {
                    params: {
                        brand_name: brand,
                        term: symptom
                    }
                })
                .then(function (response) { success(response.data); }, this.error);
            }

        };

        return service;
    });