describe("DrugService", function () {
    var target, httpBackend;

    beforeEach(module("openFDA"));
    beforeEach(inject(function (_DrugService_, $httpBackend) {
        target = _DrugService_;
        httpBackend = $httpBackend;
        httpBackend.resetExpectations();
    }));

    afterEach(function () {
        httpBackend.verifyNoOutstandingExpectation();
        httpBackend.verifyNoOutstandingRequest();
    });

    it('is created on module initialization', function () {
        expect(target).not.toBeNull();
    });

    it('supports the type ahead search', function () {
        url = '/api/v1/drugs.json?q=v';
        httpBackend.whenGET(url).respond({ 'results': [{'name': 'x'}]});

        target.typeAheadSearch('v')
            .then(function (result) {
                expect(result).not.toBeNull();
                expect(result.length).toEqual(1);
                expect(result[0].name).toBeDefined();
            });

        httpBackend.flush();
    });

    it('responds gracefully when the server is not available during type ahead search', function () {
        url = '/api/v1/drugs.json?q=v';
        httpBackend.whenGET(url).respond(404, '');

        target.typeAheadSearch('v')
            .then(function (result) {
                expect(result).not.toBeNull();
                expect(result.length).toEqual(0);
            });

        httpBackend.flush();
    });

    it('supports getting drug details', function () {
        url = '/api/v1/drugs/0904-5818';
        httpBackend.whenGET(url).respond({meta:{},results:[{ 'name': 'x' }]});

        var success = function (data) {
            expect(data).not.toBeNull();
            expect(data.name).toBeDefined();
        };

        target.getDetails('0904-5818', success);

        httpBackend.flush();
    });

    it('responds gracefully when the server not available when retrieving drug details', function () {
        url = '/api/v1/drugs/0904-5818';
        httpBackend.whenGET(url).respond(404, '');

        var success = function (data) {
            expect(false).toBe(true);
        };

        target.getDetails('0904-5818', success);

        httpBackend.flush();
    });
});