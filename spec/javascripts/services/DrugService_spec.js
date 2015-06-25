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
        httpBackend.expectGET(url).respond({ 'results': [{'name': 'x'}]});

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
        httpBackend.expectGET(url).respond(404, '');

        target.typeAheadSearch('v')
            .then(function (result) {
                expect(result).not.toBeNull();
                expect(result.length).toEqual(0);
            });

        httpBackend.flush();
    });
});