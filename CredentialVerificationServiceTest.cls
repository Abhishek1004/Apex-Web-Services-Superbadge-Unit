@isTest
private class CredentialVerificationServiceTest {
	
    @testSetup
    static void makeData(){
        
        //contact
        Contact testContact = new Contact(LastName = 'Doe');
        insert testContact;
        
        //contact 2
        Contact testContact2 = new Contact(LastName = 'Does');
        insert testContact2;
        
        //contact 3
        Contact testContact3 = new Contact(LastName = 'Doesh');
        insert testContact3;
        
        //certification
        Certification__c cert = new Certification__c(Name='SfdcCertification');
        insert cert;
        
        //Contact Certification 1
        Date issueDate1 = Date.today();
        Contact_Certification__c testCertification1 = new Contact_Certification__c(isActive__c = true, Certification__c = cert.Id, Issue_Date__c = issueDate1, Contact__c = testContact.Id);
        insert testCertification1;
        
        //Contact Certification 2
        Date issueDate2 = Date.today().addYears(-2);
        Contact_Certification__c testCertification2 = new Contact_Certification__c(isActive__c = false, Certification__c = cert.Id, Issue_Date__c = issueDate2, Contact__c = testContact2.Id);
        insert testCertification2;
    }
    
    @isTest
    static void noRecordTest(){
        
        String lastName1 = 'Dowes';
        String lastName2 = 'Doesh';
        String certName = 'SfdcCertification';
        
        Test.startTest();
        String responseStr1 = CredentialVerificationService.verifyCredential(lastName1, certName);
        String responseStr2 = CredentialVerificationService.verifyCredential(lastName2, certName);
        Test.stopTest();
        
        System.assertEquals('No record found', responseStr1);
        System.assertEquals('No record found', responseStr2);
    }
    
    @isTest
    static void validRenewalTest(){
        
        String lastName3 = 'Doe';
        String lastName4 = 'Does';
        Contact_Certification__c qContactCert1 = [select Name from Contact_Certification__c where Contact__r.LastName =: lastName3 LIMIT 1];
        Contact_Certification__c qContactCert2 = [select Name from Contact_Certification__c where Contact__r.LastName =: lastName4 LIMIT 1];
        
        String certName2 = qContactCert1.Name;
        String certName3 = qContactCert2.Name;
        
        Test.startTest();
        String responseStr3 = CredentialVerificationService.verifyCredential(lastName3, certName2);
        String responseStr4 = CredentialVerificationService.verifyCredential(lastName4, certName3);
        Test.stopTest();
        
        System.assertEquals('Valid', responseStr3);
        System.assertEquals('Needs Renewal', responseStr4);
    }
}