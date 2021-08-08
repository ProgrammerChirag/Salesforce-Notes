@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock{
    global HttpResponse respond(HttpRequest req){
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://api.covid19api.com/summary', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"chirag"}');
        res.setStatusCode(200);
        return res;
    }
}