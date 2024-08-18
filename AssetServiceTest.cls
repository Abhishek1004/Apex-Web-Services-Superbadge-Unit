@isTest
private class AssetServiceTest {
	
    @testSetup
    static void makeData(){
        
        //account
        Account testAccount = new Account(Name='Test Account1');
        insert testAccount;
        
        //contact
        Contact testContact = new Contact(FirstName='Test', LastName='Contact', AccountId=testAccount.Id);
        insert testContact;
        
        //asset1
        Asset testAsset1 = new Asset(Name='Test Asset 1',AccountId =testAccount.Id,ContactId=testContact.id, Asset_Identifier__c='Asset001', Status='Available');
        insert testAsset1;
        
        //asset2
        Asset testAsset2 = new Asset(Name='Test Asset 2',AccountId =testAccount.Id,ContactId=testContact.id, Asset_Identifier__c='Asset002', Status='Available');
        insert testAsset2;
        
        //asset2
        Asset testAsset3 = new Asset(Name='Test Asset 3',AccountId =testAccount.Id,ContactId=testContact.id, Asset_Identifier__c='Asset003', Status='Available');
        insert testAsset3;
        
        //insurance1
        Insurance__c testInsurance1 = new Insurance__c(Asset__c=testAsset2.Id, Coverage__c='Comprehensive', Active__c=true);
        insert testInsurance1;
        
        //insurance2
        Insurance__c testInsurance2 = new Insurance__c(Asset__c=testAsset3.Id, Coverage__c='Comprehensive', Active__c=true);
        insert testInsurance2;
        
        //claim
        Claim__c testClaim = new Claim__c(Status__c = 'New', Type__c = 'Loss', Asset__c = testAsset2.Id, Insurance__c = testInsurance1.Id, Contact__c = testContact.Id);
        insert testClaim;
        
    }
    
    @isTest
    static void invalidAssetTest(){
        
        String assetIdentifier = 'test';
        String responseAPI = AssetService.reportLostDevice(assetIdentifier);
        
        System.assertEquals(responseAPI, 'No device found.');
    }
    
    @isTest
    static void noCoverageTest(){
        
        String assetIdentifier = 'Asset001';
        String responseAPI = AssetService.reportLostDevice(assetIdentifier);
        
        Asset qAsset1 = [select Id, Status from Asset where Asset_Identifier__c =: assetIdentifier LIMIT 1];
        
        System.assertEquals(responseAPI, 'No coverage. Asset status adjusted to Lost.');
        System.assertEquals('Lost', qAsset1.Status);
    }
    
    @isTest
    static void alreadyFiledTest(){
        
        String assetIdentifier = 'Asset002';
        String responseAPI = AssetService.reportLostDevice(assetIdentifier);
        
        Asset qAsset2 = [select Id, Status from Asset where Asset_Identifier__c =: assetIdentifier LIMIT 1];
        
        Claim__c qClaim1 = [select Id, Name from Claim__c where Asset__c =: qAsset2.Id LIMIT 1];
        String expectedStr = qClaim1.Name + ' already filed.';
        
        System.assertEquals(responseAPI, expectedStr);
        System.assertEquals('Lost', qAsset2.Status);
    }
    
    @isTest
    static void insertClaimTest(){
        
        String assetIdentifier = 'Asset003';
        String responseAPI = AssetService.reportLostDevice(assetIdentifier);
        
        Asset qAsset3 = [select Id, Status from Asset where Asset_Identifier__c =: assetIdentifier LIMIT 1];
        
        Claim__c qClaim2 = [select Id, Name from Claim__c where Asset__c =: qAsset3.Id LIMIT 1];
        
        System.assertNotEquals(responseAPI, null);
        System.assertEquals('Lost', qAsset3.Status);
    }
}