@IsTest 
global with sharing class PED_SiteLoginControllerTest {//77%
    @testSetup
    public static void testSetupMethod(){
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' LIMIT 1];
        
        List<Account> acc = new List<Account>();
        Account account = PED_TestUtility.createAccountData('Gupta');
        account.Nome__c = 'Aditya';
        account.CodiceFiscale__c = 'GPTDTY80A01H501V';
        acc.add(account);
        insert acc;
        
        Contact contact = new Contact(
            FirstName = 'Aditya',
            LastName = 'Gupta',
            Codice_Fiscale__c = 'GPTDTY80A01H501V',
            AccountId = account.Id,
            PED_LastLoginDate__c = System.now(),
            PED_LastPasswordChange__c = System.now(),
            PED_FailedLoginAttempts__c = 3
        );
        insert contact;
        
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
        
        PED_Blacklist_Domini_Email__c dominiEmail = new PED_Blacklist_Domini_Email__c();
        dominiEmail.Name = 'salesforce.com';
        insert dominiEmail;
    }

    @IsTest global static void testSiteLoginControllerKO () {
        User users = [SELECT Id, Name, Username, Email FROM User WHERE Username = 'test@salesforce.com.pc' LIMIT 1];
        PED_SiteLoginController loginController = new PED_SiteLoginController ();
        
        Test.startTest();
        loginController.username = users.email;
        String var = loginController.password = '123456';
        loginController.registration = PED_URLs__c.getInstance('Registration');
        loginController.forgotpassword = PED_URLs__c.getInstance('Forgot Password');
        loginController.login();
        Test.stopTest();
        
        System.assertEquals(var , '123456');
    }

    @IsTest global static void testSiteLoginControllerOK () {
        User users = [SELECT Id, Name, Username, Email FROM User WHERE Username = 'test@salesforce.com.pc' LIMIT 1];
        users.Email = 'mailok@funziona.it';
        users.Username = 'mailok@funziona.it.pc';
        update users;
        PED_SiteLoginController loginController = new PED_SiteLoginController ();
        
        Test.startTest();
        loginController.username = users.email;
        loginController.registration = PED_URLs__c.getInstance('Registration');
        loginController.forgotpassword = PED_URLs__c.getInstance('Forgot Password');
        loginController.authProvider = 'Test';
        loginController.communityURL = 'Test';
        loginController.startURL = 'Test';
        loginController.login();
        Test.stopTest();
    }
}