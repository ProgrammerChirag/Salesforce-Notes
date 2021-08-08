public class Covid19Controller {
    
    @auraEnabled
    public static Covid19Parser getCovidData(){
        String baseURL='https://api.covid19api.com/summary';
        HttpRequest req = new HttpRequest();
        req.setEndPoint(baseURL);
        req.setMethod('GET');
        req.setHeader('Accept','application/json');
        HTTP H = new HTTP();
        HttpResponse response = H.send(req);
        
        Covid19Parser parser = Covid19Parser.parse(response.getBody().replace('"Global":','"AllStats":'));
        return parser;
    }
}