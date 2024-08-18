@RestResource(urlMapping = '/ProductZoning/*')
global with sharing class ProductZoningService {
    
    @HttpGet
    global static String getMapping(){
        
        String returnStr;
        String retStrCase1 = 'ProductCode is missing or doesn\'t exist';
    	String retStrCase2 = 'Confirm with the local authorities';
        RestRequest req = RestContext.request;
        
        String countryCode = req.headers.get('CountryCode');
        if(String.isEmpty(countryCode)){
            countryCode = 'US';
        }
        
        String productCodeStr = req.params.get('ProductCode');
        if(String.isEmpty(productCodeStr)){
            return retStrCase1;
        }
        
        List<Product2> productQueried = [select Id, Family from Product2 where ProductCode =: productCodeStr LIMIT 1];
        if(productQueried.isEmpty()){
            return retStrCase1;
        }
        
        List<Product_Geo_Mapping__mdt> pMapping = [select Permissible_Fly_Zone__c from Product_Geo_Mapping__mdt where Product_Family__c =: productQueried[0].Family AND Country_Code__c =: countryCode LIMIT 1];
        if(!pMapping.isEmpty()){
            returnStr = pMapping[0].Permissible_Fly_Zone__c;
        }
        else{
            returnStr = retStrCase2;
        }
        
        return returnStr;
    }
}