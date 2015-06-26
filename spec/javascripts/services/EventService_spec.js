describe("EventService", function () {
    var target, httpBackend;

    beforeEach(module("openFDA"));
    beforeEach(inject(function (_EventService_, $httpBackend) {
        target = _EventService_;
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

    it('expects two variables for index search', function () {
        url = '/api/v1/events?brand_name=V&term=Q';
        httpBackend.expectGET(url).respond({ 'name': 'x' });

        var success = function (data) {
            expect(data).not.toBeNull();
            expect(data.name).toBeDefined();
        };

        target.index('V', 'Q', success);

        httpBackend.flush();
    });

    it('responds gracefully when the server is not available during index search', function () {
        url = '/api/v1/events?brand_name=V&term=Q';
        httpBackend.expectGET(url).respond(404, '');

        var success = function (data) {
            expect(false).toBe(true);
        };

        target.index('V', 'Q', success);

        httpBackend.flush();
    });

});