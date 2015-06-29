describe("NodeService", function () {
    var target, httpBackend;

    beforeEach(module("openFDA"));
    beforeEach(inject(function (_NodeService_, $httpBackend) {
        target = _NodeService_;
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

    it('supports getting drug node details', function () {
        url = '/api/v1/node/drug/0904-5818';
        httpBackend.whenGET(url).respond({name:'x',identifier:'0904-5818',type:'Drug',children:[]});

        var success = function (data) {
            expect(data).not.toBeNull();
            expect(data.name).toBeDefined();
        };

        target.getDetails('Drug', '0904-5818', success);

        httpBackend.flush();
    });

    it('responds gracefully when the server not available when retrieving drug node details', function () {
        url = '/api/v1/node/drug/0904-5818';
        httpBackend.whenGET(url).respond(404, '');

        var success = function (data) {
            expect(false).toBe(true);
        };

        target.getDetails('Drug', '0904-5818', success);

        httpBackend.flush();
    });
});