@isTest
public class PED_RecuperaDati_Controller_Test {

    @testSetup 
    public static void testSetUpData() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Giuridica').getRecordTypeId();
        Id personaFisicaRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Fisica').getRecordTypeId();
        
        insert new PED_URLs__c(Name = 'Condizioni Generali');
        insert new PED_List_of_Id_User__c(Name = 'UserIds', IdUserOwnerAccount__c = '0059E000000zkoP;0059E0000037eUD;0059E000001DWIN;0059E0000037eRs;0059E0000037eRs');
        insert new PED_System_Constants__c(ID_Profile_Customer_Community_User_STD__c = '00e9E000000DrlEQAS');

        insert new PED_ServiceSettings__c (Name = 'Enotify-callDeleteUser', PED_Endpoint__c = 'https://test/SVILUPPO/SOAPServiceBinding/wrapperInfoPod', PED_ClientId__c = 'test', PED_ClientSecret__c = 'test');
        insert new PED_ServiceSettings__c (Name = 'Enotify-callDeleteSubscriptions', PED_Endpoint__c = 'https://test/SVILUPPO/SOAPServiceBinding/wrapperInfoPod', PED_ClientId__c = 'test', PED_ClientSecret__c = 'test');
        insert new PED_ServiceSettings__c (Name = 'Enotify-getSubscriptions', PED_Endpoint__c = 'https://test/SVILUPPO/SOAPServiceBinding/wrapperInfoPod', PED_ClientId__c = 'test', PED_ClientSecret__c = 'test');
        insert new PED_ServiceSettings__c (Name = 'Enotify-callUpsertSubscriptions', PED_Endpoint__c = 'https://test/SVILUPPO/SOAPServiceBinding/wrapperInfoPod', PED_ClientId__c = 'test', PED_ClientSecret__c = 'test');
        insert new PED_ServiceSettings__c (Name = 'Enotify-callUpsertUserInfo', PED_Endpoint__c = 'https://test/SVILUPPO/SOAPServiceBinding/wrapperInfoPod', PED_ClientId__c = 'test', PED_ClientSecret__c = 'test');
        insert new PED_ServiceSettings__c (Name = 'Enotify-callValidateSMS', PED_Endpoint__c = 'https://test/SVILUPPO/SOAPServiceBinding/wrapperInfoPod', PED_ClientId__c = 'test', PED_ClientSecret__c = 'test');

        PED_EncryptedSettings__c val = new PED_EncryptedSettings__c (
            Name = 'RetrievePEDToken',
            PED_ClientId__c = '',
            PED_ClientSecret__c = '',
            PED_Endpoint__c = 'http://test/ms/common/api/bontfnsubsmgmt/jwt/bontfnsubsmgmt/token',
            PED_GrantType__c = 'password',
            PED_Password__c = 'C3LO$4!p$1111!',
            PED_Username__c = '111111'
            );
        insert val;
        
        //test data for Logged in user
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        //test data for profile
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
 
        System.runAs(user) {
            
            Account account = PED_TestUtility.createAccountData('Prova');
            account.Nome__c = 'Test';
            account.RecordTypeId = devRecordTypeId;
            account.CodiceFiscale__c = 'PRVTST96H30F205V';
            account.PartitaIVA__c='00000000000';
            insert account;
            
            //test data for Contact
            Contact contact = new Contact();
            contact.FirstName = 'Aditya';
            contact.LastName = 'Gupta';
            contact.Codice_Fiscale__c = 'GPTDTY80A01H501V';
            contact.Email = 'primoliv@testorg.com';
            contact.AccountId = account.Id;
            contact.MobilePhone = '+393331122444';
            contact.PED_Nazionalit__c = 'Italiana';
            contact.PED_MobilePhoneVerificato__c = true;
            contact.PED_Sottoscrizione_e_notify__c = true;
            insert contact;
            
            //test data for user
            User u = PED_TestUtility.CreateUserData('Test Asd', Null);
            u.Email='primoliv@testorg.com';
            u.Alias = 'pliv'; 
            u.ProfileId = p.Id;
            u.UserName='primoliv@testorg.com.pc';
            u.IsActive = true;
            u.ContactId = contact.Id;
            u.LastName = contact.LastName;
            insert u;
        
            System.debug('Portal User After Insert =====<> '  + u);
            System.debug('Portal User Contact =====<> '  + u.ContactId);
            System.debug('Portal User Account =====<> '  + u.AccountId);
            
            Delega__c delegaobj = PED_TestUtility.createDelegaData();
            delegaobj.PED_Delegato__c = user.id;
            insert delegaobj;    
        }

    }

    @isTest 
    static void sendOtp(){
        Contact cont = [SELECT Id FROM Contact WHERE Codice_Fiscale__c = 'GPTDTY80A01H501V' LIMIT 1];

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new PED_EnotifyWSMock('callValidateSMSOK')); 
        PED_RecuperaDati_Controller.sendOtp(cont.Id);
        Test.stopTest();
    }
    
    /*@isTest
    static void updateUser1(){
        String RecTypeId = [SELECT Id FROM RecordType WHERE Name = 'Persona Giuridica' AND SobjectType = 'Account'].Id;
        Account accobj = new Account(
            Name = 'test',
            PED_IsEnte__c = true,
            CodiceFiscale__c = '80000000000',
            Nazionalita__c = 'Afgana',
            Email__c  = 'marco@gmail.com',
            RecordTypeId = RecTypeId
        );
        insert accobj;
        
        contact conobj = new Contact(
            MobilePhone = '3933076123',
            Codice_Fiscale__c = 'TSTTST80A01H501G',
            LastName = 'test',
            FirstName = 'test',
            AccountId = accobj.Id,
            PED_MobilePhoneVerificato__c = true
        );
        insert conobj;

        PED_OTP__c p = new PED_OTP__c(PED_Email__c = 'primoliv@testorg.com.pc');
        insert p;

        Contact cont = [SELECT Id FROM Contact WHERE Codice_Fiscale__c = 'GPTDTY80A01H501V' LIMIT 1];
        
        Test.startTest();
        PED_RecuperaDati_Controller.checkOTP('test', 'primoliv@testorg.com');
        PED_RecuperaDati_Controller.updateUser('test', 'test@gmail.com');
        PED_RecuperaDati_Controller.recoveryPasswordFromUsername('test@testorg.com', cont.Id);
        PED_RecuperaDati_Controller.recoveryUsernamePersonaGiuridica(conobj, accobj, 'test');
        Test.stopTest();
    }*/

    @isTest
    static void checkToken(){
        Contact cont = [SELECT Id FROM Contact WHERE Codice_Fiscale__c = 'GPTDTY80A01H501V' LIMIT 1];

        Test.startTest();
        PED_RecuperaDati_Controller.checkToken(cont.Id, '123456');
        Test.stopTest();
    }

    @isTest
    static void getNazionalityopts(){
        Test.startTest();
        PED_RecuperaDati_Controller.getNazionalityopts();
        Test.stopTest();
    }
    
    @isTest
    static void modifyUsernamePersonaFisica(){
        User u = [SELECT Id, LastPasswordChangeDate FROM User WHERE Username = 'primoliv@testorg.com.pc' LIMIT 1];
        System.resetPassword(u.Id, false);
        Contact cont = [SELECT Id, PED_Nazionalit__c, Codice_Fiscale__c FROM Contact WHERE Codice_Fiscale__c = 'GPTDTY80A01H501V' LIMIT 1];

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new PED_EnotifyWSMock('callValidateSMSOK'));
        PED_RecuperaDati_Controller.modifyUsernamePersonaFisica(cont);
        Test.stopTest();
    }
    
    @isTest
    static void recoveryUsernamePersonaGiuridica(){
        Account acc = [SELECT Id, PartitaIVA__c, CodiceFiscale__c, (SELECT Id, Firstname, Lastname, Codice_Fiscale__c FROM Contacts WHERE Codice_Fiscale__c ='GPTDTY80A01H501V') FROM Account WHERE CodiceFiscale__c = 'PRVTST96H30F205V' LIMIT 1];

        Test.startTest();
        PED_RecuperaDati_Controller.recoveryUsernamePersonaGiuridica(acc.contacts[0], acc, 'Italiana');
        Test.stopTest();
    }
    
    @isTest
    static void recoveryUsernamePersonaFisica(){

        String RecTypeId = [SELECT Id FROM RecordType WHERE Name = 'Persona Fisica' AND SobjectType = 'Account'].Id;
        Account accobj = new Account(
            Name = 'BIANCHI ROBERTO',
            Nome__c = 'ROBERTO',
            RecordTypeId = RecTypeId,
            CodiceFiscale__c = 'BNCRRT96H30L682T',
            Nazionalita__c = 'Italiana',
            Email__c = 'marco@gmail.com'
        );
        insert accobj;
        
        Contact contact=new Contact(
            LastName = 'BIANCHI',
            FirstName = 'ROBERTO',
            Codice_Fiscale__c = 'BNCRRT96H30L682T',
            OwnerId = UserInfo.getUserId(),
            AccountId = accobj.Id,
            PED_Nazionalit__c = 'Italiana'
        );
        insert contact;
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' LIMIT 1];
        User u1 = new User(
            Alias = 'pliv',
            Email = 'primoliv@testorg.com',
            EmailEncodingKey = 'UTF-8',
            FirstName = 'Test',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p1.Id,
            contactid = contact.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testingcambiaemail@test.com.pc'
        );
        insert u1;

        Contact cont = [SELECT Id, PED_Nazionalit__c, Codice_Fiscale__c FROM Contact WHERE Codice_Fiscale__c = 'BNCRRT96H30L682T'];
        Test.startTest();
        PED_RecuperaDati_Controller.recoveryUsernamePersonaFisica(cont);
        Test.stopTest();
    }
    
    @isTest
    static void checkOTP(){
        insert new PED_OTP__c(
            PED_Email__c = 'primoliv@testorg.com.pc',
            PED_CodiceOTP__c = '664781'
        );
        
        Test.startTest();
        PED_RecuperaDati_Controller.checkOTP('664781','primoliv@testorg.com');
        Test.stopTest();
    }
    
    @isTest
    static void sendOtpEmail(){
        User u = [SELECT Id, Username FROM User WHERE Username = 'primoliv@testorg.com.pc' LIMIT 1];
        Test.startTest();
        PED_RecuperaDati_Controller.sendOtpEmail(u);
        Test.stopTest();
    }

    @isTest
    static void recoveryPasswordFromUsername(){
        User u = [SELECT Id, ContactId FROM User WHERE Username = 'primoliv@testorg.com.pc' LIMIT 1];

        System.runAs(u){
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new PED_EnotifyWSMock('callUpsertUsersInfoOK'));
            PED_RecuperaDati_Controller.recoveryPasswordFromUsername('primoliv88@testorg.com', u.ContactId);
            PED_RecuperaDati_Controller.updateUser('primoliv3@testorg.com', u.ContactId);
            Test.stopTest();
        }  
    }

    @isTest
    static void recoveryPassword(){
        Test.startTest();
        PED_RecuperaDati_Controller.recoveryPassword('primoliv@testorg.com');
        Test.stopTest();
    }
}