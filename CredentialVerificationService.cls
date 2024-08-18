global class CredentialVerificationService {

    webservice static String verifyCredential(String contactLastName, String contactCertificationName){
        
        String str1 = 'No record found';
        List<Contact> contactsList = [select Id from Contact where LastName =: contactLastName LIMIT 1];
        if(contactsList.isEmpty()){
            return str1;
        }
        List<Contact_Certification__c> contactCertList = [select Id, isActive__c from Contact_Certification__c where Contact__r.LastName =: contactLastName AND Name =: contactCertificationName LIMIT 1];
        if(contactCertList.isEmpty()){
            return str1;
        }
        if(contactCertList[0].isActive__c){
            return 'Valid';
        }
        else{
            return 'Needs Renewal';
        }
    }
}