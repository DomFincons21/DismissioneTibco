@isTest
private class PED_CheckBlacklistedEmail_Test {


    @TestSetup
    static void makeData(){

        PED_Blacklist_Domini_Email__c pbl = new PED_Blacklist_Domini_Email__c();
        RecordType rt = [SELECT Id FROM RecordType WHERE RecordType.DeveloperName = 'MailWildCard' and SobjectType = 'PED_Blacklist_Domini_Email__c' LIMIT 1];
        pbl.RecordTypeId = rt.Id;
        pbl.Attivo__c = true;
        pbl.PED_Blacklist__c = 'merope';
        insert pbl; 
      
        PED_Blacklisted_Email__c wc = new PED_Blacklisted_Email__c();
        RecordType rtt = [SELECT Id FROM RecordType WHERE RecordType.DeveloperName = 'WildCard' and SobjectType = 'PED_Blacklisted_Email__c' LIMIT 1];
        wc.RecordTypeId = rtt.Id;
        wc.Email__c = 'merope';
        insert wc; 

        PED_Blacklisted_Email__c pbl2 = new PED_Blacklisted_Email__c();
        RecordType rt2 = [SELECT Id FROM RecordType WHERE RecordType.DeveloperName = 'Standard' and SobjectType = 'PED_Blacklisted_Email__c'  LIMIT 1];
        pbl2.RecordTypeId = rt2.Id;
        pbl2.Email__c = 'iygasdfas@asddgsfg.df';
        insert pbl2;
        
        PED_Blacklist_Domini_Email__c bd = new PED_Blacklist_Domini_Email__c();
        RecordType rt3 = [SELECT Id FROM RecordType WHERE RecordType.Name = 'Domini'  and SobjectType = 'PED_Blacklist_Domini_Email__c' LIMIT 1];
        bd.RecordTypeId = rt3.id;
        bd.Attivo__c = true;
        bd.PED_Blacklist__c = 'pippo.com';
        System.debug(bd);
        insert bd;

        PED_Blacklist_Domini_Email__c bd1 = new PED_Blacklist_Domini_Email__c();
        RecordType rt4 = [SELECT Id FROM RecordType WHERE RecordType.Name = 'Mail' and SobjectType = 'PED_Blacklist_Domini_Email__c'  LIMIT 1];
        bd1.RecordTypeId = rt4.id;
        bd1.Attivo__c = true;
        bd1.PED_Blacklist__c = 'marco.speranza@finconsgroup.com';
        System.debug(bd1);
        insert bd1;
        

        Contact contact = new Contact();
        contact.FirstName = 'Aditya';
        contact.LastName = 'Gupta';
        contact.Codice_Fiscale__c = 'GPTDTY80A01H501V';
       // contact.PED_Email_Disposable__c = false;
        insert contact;
    }

    @isTest
    public static void flagDisposableTest() {

        Contact contact = [Select id from Contact where FirstName = 'Aditya' and LastName = 'Gupta' limit 1];
        PED_CheckBlacklistedEmail.flagDisposable(contact);
       // System.assert(contact.PED_Email_Disposable__c, 'Must be true');
    }
    @isTest
    public static void checkBlacklistedSpecifiedEmailFalseTest() {

       Boolean flag =  PED_CheckBlacklistedEmail.checkBlacklistedSpecifiedEmail('iygasdfas@asddgsfg.df');
       //System.assert(flag, 'Domain in blak List');

       /*  PED_CheckBlacklistedEmail.checkBlacklistedSpecifiedEmail('merope@gmail.com');
        */
     }
    @isTest
    public static void checkBlacklistedSpecifiedEmailTrueTest() {

       Boolean flag =  PED_CheckBlacklistedEmail.checkBlacklistedSpecifiedEmail('checktrue@asddgsfg.df');
       System.assert(!flag, 'Domain in blak List');

      
     }
    @isTest
    public static void checkIsBlacklistedEmailTest() {
        System.assert(PED_CheckBlacklistedEmail.checkBlacklist('merope@pippo.com'), 'Domain in blak List');
     }

    @isTest
    public static void checkNotInBlacklistedEmailTest() {
        System.assert(!PED_CheckBlacklistedEmail.checkBlacklist('marco@finconsgroup.com'), 'Domain in blak List');
     }
  
    @isTest
    public static void isDomainInBlacklistTest() {
        System.assert(PED_CheckBlacklistedEmail.isDomainInBlacklist('merope@pippo.com'), 'Domain in blak List');
     }
    @isTest
    public static void isDomainInBlacklistIsEmptyTest() {
        System.assert(!PED_CheckBlacklistedEmail.isDomainInBlacklist('merope@pippa.com'), 'Domain in blak List');
     }
    @isTest
    public static void isMailInBlacklistTest() {
        System.assert(PED_CheckBlacklistedEmail.isMailInBlacklist('marco.speranza@finconsgroup.com'), 'Domain in blak List');
     }
    @isTest
    public static void isMailInBlacklistEmptyTest() {
        System.assert(!PED_CheckBlacklistedEmail.isMailInBlacklist('marco@finconsgroup.com'), 'Domain in blak List');
     }
  
    @isTest
    public static void isMailInBlacklistWildCardTest() {
        System.assert(!PED_CheckBlacklistedEmail.isMailInBlacklist('marco@finconsgroup.com'), 'Domain in blak List');
     }
  

     

}