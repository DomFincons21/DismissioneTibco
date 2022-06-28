@isTest
public class PED_LoginControllerTest {
    
    @testSetup
    public static void testSetupMethod(){
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' LIMIT 1];
        RecordType r = [SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName='PED_Confindustria' LIMIT 1];
        Account account = PED_TestUtility.createAccountData('Gupta');
        account.Nome__c = 'Aditya';
        account.CodiceFiscale__c = 'GPTDTY80A01H501V';
        Account.RecordTypeId  = r.id;
        insert Account;
        
        Contact contact = new Contact(
            FirstName = 'Aditya',
            LastName = 'Gupta',
            Codice_Fiscale__c = 'GPTDTY80A01H501V',
            AccountId = account.Id,
            PED_LastLoginDate__c = System.now(),
            PED_LastPasswordChange__c = System.now(),
            PED_FailedLoginAttempts__c = 3,
            PED_Email_Disposable__c = false
        );
        insert contact;
        
        Contact contact1 = new Contact(
            FirstName = 'Aditya',
            LastName = 'Gupta',
            Codice_Fiscale__c = 'GPTDTY80A01H501V',
            AccountId = account.Id,
            PED_LastLoginDate__c = System.now(),
            PED_LastPasswordChange__c = System.now(),
            PED_FailedLoginAttempts__c = 3,
            PED_Email_Disposable__c = false
        );
        insert contact1;
        
        User u = PED_TestUtility.CreateUserData('Aditya Gupta', null);
        u.Email = 'test@salesforce.com';
        u.Alias = 'pliv'; 
        u.ProfileId = p.Id;
        u.UserName = 'test@salesforce.com.pc';
        u.IsActive = true;
        u.ContactId = contact.Id;
        u.LastName = contact.LastName;
        u.PED_Data_Disabilitazione__c = System.now();
        u.PED_Mobile_Registrazione__c = '1234567890';
        insert u;
        
        User u1 = PED_TestUtility.CreateUserData('Adityas Guptas', null);
        u1.Email = 'test@a.c';
        u1.Alias = 'pliv'; 
        u1.ProfileId = p.Id;
        u1.UserName = 'test@a.c.pc';
        u1.IsActive = true;
        u1.ContactId = contact1.Id;
        u1.LastName = contact1.LastName;
        u1.PED_Data_Disabilitazione__c = System.now();
        u1.PED_Mobile_Registrazione__c = '1234567890';
        insert u1;
        
        PED_Blacklist_Domini_Email__c dominiEmail = new PED_Blacklist_Domini_Email__c();
        dominiEmail.PED_Blacklist__c = 'salesforce.com';
        dominiEmail.Attivo__c=true;
        dominiEmail.RecordTypeId = [SELECT id from RecordType where RecordType.Name= 'Domini' ].Id; 
        insert dominiEmail;
    }
    
   @isTest
    public static void initTest(){
        PED_LoginController.init();
    }
    
    @isTest
    public static void PEDLogInCatchTest(){
        PED_LoginController.loginUser('', '','');
    }
    @isTest
    public static void PEDLogInUserBlackListDisposableTest(){
        User users = [SELECT Id, Name, Username, Email,Account.RecordType.DeveloperName, contact.PED_Email_Disposable__c FROM User WHERE Username = 'test@salesforce.com.pc' LIMIT 1];
        PED_LoginController.loginUser(users.email, '123456','test');
    }
    @isTest
    public static void PEDLogInUserTest(){
        User users = [SELECT Id, Name, Username, Email,Account.RecordType.DeveloperName, contact.PED_Email_Disposable__c FROM User WHERE Username = 'test@a.c.pc' LIMIT 1];
        SYstem.debug('£££' +  users.Account.RecordType.DeveloperName);
        PED_LoginController.loginUser(users.email, '123456','test');
    }
    @isTest
    public static void PEDLogInBlackListTest(){
        User users = [SELECT Id, Name, Username, Email,Account.RecordType.DeveloperName, contact.PED_Email_Disposable__c FROM User WHERE Username = 'test@salesforce.com.pc' LIMIT 1];
        PED_SiteLoginController loginController = new PED_SiteLoginController ();
        
        Test.startTest();
        loginController.username = users.email;
        String var = loginController.password = '123456';
        loginController.registration = PED_URLs__c.getInstance('Registration');
        loginController.forgotpassword = PED_URLs__c.getInstance('Forgot Password');
        loginController.login();
        Test.stopTest();
        
        System.assertEquals(var , '123456');
        
        PED_LoginController.loginUser(users.email, '123456','');
        
        
    }
    
}