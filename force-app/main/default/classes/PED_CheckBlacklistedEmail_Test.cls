@isTest
private class PED_CheckBlacklistedEmail_Test {
    static testMethod void method1() {
        PED_Blacklisted_Email__c pbl = new PED_Blacklisted_Email__c();
        RecordType rt = [SELECT Id FROM RecordType WHERE RecordType.DeveloperName = 'WildCard' LIMIT 1];
        pbl.RecordTypeId = rt.Id;
        pbl.Email__c = 'merope';
        insert pbl; 
        
        PED_Blacklisted_Email__c pbl2 = new PED_Blacklisted_Email__c();
        RecordType rt2 = [SELECT Id FROM RecordType WHERE RecordType.DeveloperName = 'Standard' LIMIT 1];
        pbl2.RecordTypeId = rt2.Id;
        pbl2.Email__c = 'iygasdfas@asddgsfg.df';
        insert pbl2;
        
        PED_Blacklist_Domini_Email__c bd = new PED_Blacklist_Domini_Email__c();
        bd.Name = 'pippo.com';
        insert bd;

        Contact contact = new Contact();
        contact.FirstName = 'Aditya';
        contact.LastName = 'Gupta';
        contact.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        insert contact;
        
        PED_CheckBlacklistedEmail.checkBlacklistedSpecifiedEmail('iygasdfas@asddgsfg.df');
        PED_CheckBlacklistedEmail.checkBlacklistedSpecifiedEmail('merope@gmail.com');
        PED_CheckBlacklistedEmail.checkBlacklistedEmail('merope@pippo.com');
        PED_CheckBlacklistedEmail.flagDisposable(contact);
    }
}