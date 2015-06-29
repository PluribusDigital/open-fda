app.factory('DrugService',
    function ($http) {
        'use strict';

        var service = {
           error: function (response) {
                console.log('error when calling Drugs API');
                console.log(response);
                return [];
            },

            searchSuccess: function (response) {
                return response.data.results.map(function (item) {
                    return item;
                });
            },

            // These methods encapsulate API calls
            typeAheadSearch: function (val) {
                return $http.get('/api/v1/drugs.json', {
                    params: {
                        q: val
                    }
                })
                .then(this.searchSuccess, this.error);
            },

            getDetails: function (product_ndc, success) {
                $http.get('/api/v1/drugs/' + product_ndc, {})
                     .then(function (response) { success(response.data.results[0]); }, this.error);
            }

        };

        return service;
    });