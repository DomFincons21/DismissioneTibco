@IsTest 
public with sharing class PED_ForgotPasswordControllerTest 
{
   /*@isTest static void testForgotPasswordController()
    {
        PED_ForgotPasswordController forgotPassword = new PED_ForgotPasswordController();
        
        Test.startTest();
        String var = forgotPassword.username = 'test@salesforce.com'; 
        forgotPassword.forgotPassword();
        forgotPassword.Cancel();
        Test.stopTest();
        System.assertEquals(var , 'test@salesforce.com');
    }*/
    @testSetup
    public static void testSetUpData() {
        //test data for Logged in user
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        //test data for profile
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
 
        System.runAs(user) {
            Account account = PED_TestUtility.createAccountData('Gupta');
            account.Nome__c = 'Aditya';
            //account.RecordTypeId = devRecordTypeId;
            account.OwnerId = user.Id;
            account.phone='12312312312';
            account.Nazionalita__c='Italiana';
            account.CodiceFiscale__c = 'GPTDTY80A01H501V';
            account.PED_IsEnte__c = false;
            Insert account;
            
            Contact contactRec = PED_TestUtility.createContactData('Gupta', account.Id);
            contactRec.FirstName = 'Aditya';
            contactRec.Email = 'abc@test.com';
            contactRec.Codice_Fiscale__c = 'GPTDTY80A01H501V';
            Insert contactRec; 
            
            //test data for user
            User u = PED_TestUtility.CreateUserData('Test Asd', Null);
            u.Email='primoliv@testorg.com.pc';
            u.Alias = 'pliv'; 
            u.ProfileId = p.Id;
            u.UserName='primoliv@testorg.com.pc';
            u.IsActive = true;
            u.ContactId = contactRec.Id;
            u.LastName = contactRec.LastName;
            u.FirstName = contactRec.FirstName;
            insert u;
            System.debug('Portal User After Insert =====<> '  + u);
            System.debug('Portal User Contact =====<> '  + u.ContactId);
            System.debug('Portal User Account =====<> '  + u.AccountId);
            
            EmailTemplate emailTemp = new EmailTemplate(isActive = true, DeveloperName = 'PED_NoReset_PSW', FolderId  = UserInfo.getUserId(), TemplateType= 'Text', Name = 'test');
            emailTemp.HtmlValue = u.LastName;
            emailTemp.HtmlValue = u.FirstName;
            Insert emailTemp;  
        }

    }
    
    @isTest static void testForgotPasswordController() {
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        System.runAs(user) {
            User userRec = [Select Id, Name, UserName, AccountId, Contact.Id, ContactId, Contact.Account.Id, Contact.Account.RecordTypeId From User Where UserName = 'primoliv@testorg.com.pc' Limit 1];
            //userRec.Username = 'primoliv@testorg.com'+'.pc';
            //Update userRec;
            Test.startTest();
            try {
                PED_ForgotPasswordController forgotPasswordCntrl = new PED_ForgotPasswordController();
                forgotPasswordCntrl.username = userRec.UserName; 
                forgotPasswordCntrl.forgotPassword();
                //forgotPasswordCntrl.Cancel();    
            } catch(Exception e) {
                
            }
            Test.stopTest();    
        }
    }
    
    @isTest static void testForgotPasswordControllerCancel() {
        User uObj = [Select Id, Name, UserName, FirstName, LastName, AccountId, Contact.Id, ContactId, Contact.Account.Id, Contact.Account.RecordTypeId From User Where UserName = 'primoliv@testorg.com.pc' Limit 1];
        Test.startTest();  
            PED_ForgotPasswordController forgotPasswordCntrl = new PED_ForgotPasswordController();
            forgotPasswordCntrl.Cancel();
            PED_ForgotPasswordController.SendEmail(uObj);
        Test.stopTest();
    }
    
    @isTest static void testForgotPasswordControllerNegative() {
        User uObj = [Select Id, Name, UserName, FirstName, LastName, AccountId, Contact.Id, ContactId, Contact.Account.Id, Contact.Account.RecordTypeId From User Where UserName = 'primoliv@testorg.com.pc' Limit 1];
        Test.startTest();  
            PED_Blacklist_Domini_Email__c domainEmail = new PED_Blacklist_Domini_Email__c();
            Insert domainEmail; 
            PED_ForgotPasswordController forgotPasswordCntrl = new PED_ForgotPasswordController();
            forgotPasswordCntrl.username = uObj.UserName; 
            try {
                forgotPasswordCntrl.forgotPassword();    
            } catch(Exception e) {}
        Test.stopTest();
    }
    
}