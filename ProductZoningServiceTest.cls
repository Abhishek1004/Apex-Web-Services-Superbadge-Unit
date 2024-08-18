@isTest
public class ProductZoningServiceTest {

    @testSetup
    static void setup(){
        
        Product2 testProduct = new Product2(Name='Test Product', ProductCode = 'SL9060', Family = 'Test Family');
        insert testProduct;
    }
    
    @isTest
    static void testResponses(){
        
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexRest/productZoning/';
        req.addParameter('ProductCode', 'SL9060');
        req.headers.put('CountryCode', 'US');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
        String response1 = ProductZoningService.getMapping();
        System.assertEquals('Confirm with the local authorities', response1);
        
        req.headers.put('CountryCode', 'AU');
        String response2 = ProductZoningService.getMapping();
        System.assertEquals('Confirm with the local authorities', response2);
        
        RestRequest req1 = new RestRequest();
        req1.requestURI = '/services/apexRest/productZoning/';
        req1.addParameter('ProductCode', 'SL9060Test');
        req1.headers.put('CountryCode', 'US');
        req1.httpMethod = 'GET';
        RestContext.request = req1;
        
        String response3 = ProductZoningService.getMapping();
        System.assertEquals('ProductCode is missing or doesn\'t exist', response3);
        
        RestRequest req2 = new RestRequest();
        req2.requestURI = '/services/apexRest/productZoning/';
        req2.headers.put('CountryCode', 'US');
        req2.httpMethod = 'GET';
        RestContext.request = req2;
        
        String response4 = ProductZoningService.getMapping();
        System.assertEquals('ProductCode is missing or doesn\'t exist', response4);
        
        RestRequest req3 = new RestRequest();
        req3.requestURI = '/services/apexRest/productZoning/';
        req3.addParameter('ProductCode', 'SL9060');
        req3.httpMethod = 'GET';
        RestContext.request = req3;
        
        String response5 = ProductZoningService.getMapping();
        System.assertEquals('Confirm with the local authorities', response5);
        
    }
}