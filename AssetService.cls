@RestResource(urlMapping = '/lost')
global with sharing class AssetService {

    @HttpPost
    global static String reportLostDevice(String assetIdentifier){
        String retStr;
        String str1 = 'No device found.';
        String str2 = ' already filed.';
        String str3 = 'No coverage. Asset status adjusted to Lost.';
        
        //search asset by assetIdentifier
        List<Asset> assetList = [select Id, Status, Asset_Identifier__c, ContactId from Asset where Asset_Identifier__c =: assetIdentifier LIMIT 1];
        if(assetList.isEmpty()){
            return str1;
        }
        assetList[0].Status = 'Lost';
        update assetList[0];
        
        //check for active=true, coverage=comprehensive insurance
        List<Insurance__c> qInsurance = [select Id, Active__c from Insurance__c where Active__c = True AND Coverage__c = 'Comprehensive' AND Asset__r.Asset_Identifier__c =: assetIdentifier];
        if(qInsurance.isEmpty()){
            
            //no coverage
            return str3;
        }
        List<Claim__c> qClaim = [select Id, Name, Type__c from Claim__c where Asset__r.Asset_Identifier__c =: assetIdentifier AND Insurance__c =: qInsurance[0].Id AND Type__c = 'Loss' LIMIT 1];
        if(!qClaim.isEmpty()){
            
            //return existing claim number
            retStr = qClaim[0].Name + str2;
            return retStr;
        }
        else{
            //new claim
            Claim__c newClaim = new Claim__c(Status__c = 'New', Type__c = 'Loss', Asset__c = assetList[0].Id, Insurance__c = qInsurance[0].Id, Contact__c = assetList[0].ContactId);
            insert newClaim;
            
            Claim__c newClaimQ = [select Name from Claim__c where Id =: newClaim.Id LIMIT 1];
            return newClaimQ.Name;
        }
    }
}