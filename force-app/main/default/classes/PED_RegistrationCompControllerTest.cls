@isTest
public class PED_RegistrationCompControllerTest {
  
    public static testMethod void TestCallingWebservice12(){   
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        Update user;
        
        ID recTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Fisica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneFisica = PED_TestUtility.createAccountData('Gupta');
        accountRecPersoneFisica.Nome__c = 'Aditya';
        accountRecPersoneFisica.RecordTypeId = recTypeID;
        accountRecPersoneFisica.OwnerId = user.Id;
        accountRecPersoneFisica.phone='12312312312';
        accountRecPersoneFisica.Nazionalita__c='Italiana';
        accountRecPersoneFisica.CodiceFiscale__c = 'GPTDTY80A01H501V';
        Insert accountRecPersoneFisica;
        
        Contact con = PED_TestUtility.createContactDataNullCode('Gupta', accountRecPersoneFisica.Id);
        con.FirstName = 'Aditya';
        con.Email = 'primoliv2@testorg.com';
        con.PED_ContactKey__c = 'ciao';
        con.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        Insert con; 
        
        User u2 = PED_TestUtility.CreateUserData('Test Asd1', Null);
        u2.Email='primoliv2@testorg.com';
        u2.Alias = 'pliv'; 
        u2.ProfileId = p.Id;
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare - aggiunto .pc
        u2.UserName='primoliv2@testorg.com.pc';
        u2.IsActive = true;
        u2.ContactId = con.Id;
        u2.LastName = con.LastName;
        insert u2;  
        
        Insert new PED_URLs__c(Name = 'Condizioni Generali');
        Insert new PED_List_of_Id_User__c(Name = 'UserIds', IdUserOwnerAccount__c = '0059E000000zkoP;0059E0000037eUD;0059E000001DWIN;0059E0000037eRs;0059E0000037eRs');
        Insert new PED_System_Constants__c(ID_Profile_Customer_Community_User_STD__c = '00e9E000000DrlEQAS');
        Insert new PED_Environment__c(Name = 'RetrieveInfoPodEndPoint', Value__c = 'https://4ele-collaudo-wssf.enel.it/SVILUPPO/SOAPServiceBinding/wrapperInfoPod');
        Insert new PED_Environment__c(Name = 'EnableServiceLogging', Value__c = 'True');
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new PED_RetrieveInfoPodWSTestMock2());    
        PED_RegistrationCompController.userRegistration(con);  
        Test.stopTest();
    }
    
    public static testMethod void TestCallingWebservice13(){   
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        Update user;
        
        ID recTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Fisica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneFisicaJuanin3 = PED_TestUtility.createAccountData('Giovanni');
        accountRecPersoneFisicaJuanin3.Nome__c = 'Alberini';
        accountRecPersoneFisicaJuanin3.RecordTypeId = recTypeID;
        accountRecPersoneFisicaJuanin3.OwnerId = user.Id;
        accountRecPersoneFisicaJuanin3.phone='12312312312';
        accountRecPersoneFisicaJuanin3.Nazionalita__c='Italiana';
        accountRecPersoneFisicaJuanin3.CodiceFiscale__c = 'GVNLRN17T29A512V';
        Insert accountRecPersoneFisicaJuanin3;
        
        Contact con = PED_TestUtility.createContactDataNullCode('Gupta', accountRecPersoneFisicaJuanin3.Id);
        con.FirstName = 'Aditya';
        con.Email = 'primoliv2@testorg.com';
        con.PED_ContactKey__c = 'ciao';
        con.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        Insert con; 
        
        User u2 = PED_TestUtility.CreateUserData('Test Asd1', Null);
        u2.Email='primoliv2@testorg.com';
        u2.Alias = 'pliv'; 
        u2.ProfileId = p.Id;
        u2.PED_AccOwnerCounter__c = 0;
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare - aggiunto .pc
        u2.UserName='primoliv2@testorg.com.pc';
        u2.IsActive = true;
        u2.ContactId = con.Id;
        u2.LastName = con.LastName;
        insert u2;  
        
        Insert new PED_URLs__c(Name = 'Condizioni Generali');
        Insert new PED_List_of_Id_User__c(Name = 'UserIds', IdUserOwnerAccount__c = '0059E000000zkoP;0059E0000037eUD;0059E000001DWIN;0059E0000037eRs;0059E0000037eRs');
        Insert new PED_System_Constants__c(ID_Profile_Customer_Community_User_STD__c = '00e9E000000DrlEQAS');
        Insert new PED_Environment__c(Name = 'RetrieveInfoPodEndPoint', Value__c = 'https://4ele-collaudo-wssf.enel.it/SVILUPPO/SOAPServiceBinding/wrapperInfoPod');
        Insert new PED_Environment__c(Name = 'EnableServiceLogging', Value__c = 'True');
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new PED_RetrieveInfoPodWSTestMock2());     
        PED_RegistrationCompController.userRegistration(con); 
        Test.stopTest();
    }
    
    public static testMethod void TestCallingWebservice8(){   
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        Update user;
        
        ID recTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Fisica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneFisicaJuanin3 = PED_TestUtility.createAccountData('Giovanni');
        accountRecPersoneFisicaJuanin3.Nome__c = 'Alberini';
        accountRecPersoneFisicaJuanin3.RecordTypeId = recTypeID;
        accountRecPersoneFisicaJuanin3.OwnerId = user.Id;
        accountRecPersoneFisicaJuanin3.phone='12312312312';
        accountRecPersoneFisicaJuanin3.Nazionalita__c='Italiana';
        accountRecPersoneFisicaJuanin3.CodiceFiscale__c = 'GVNLRN17T29A512V';
        Insert accountRecPersoneFisicaJuanin3;
        
        Contact con = PED_TestUtility.createContactDataNullCode('Gupta', accountRecPersoneFisicaJuanin3.Id);
        con.FirstName = 'Aditya';
        con.Email = 'primoliv2@testorg.com';
        con.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        Insert con; 
        
        User u2 = PED_TestUtility.CreateUserData('Test Asd1', Null);
        u2.Email='primoliv2@testorg.com';
        u2.Alias = 'pliv'; 
        u2.ProfileId = p.Id;
        u2.UserName='primoliv2@testorg.com';
        u2.IsActive = true;
        u2.ContactId = con.Id;
        u2.LastName = con.LastName;
        insert u2;  
        
        Insert new PED_URLs__c(Name = 'Condizioni Generali');
        Insert new PED_List_of_Id_User__c(Name = 'UserIds', IdUserOwnerAccount__c = '0059E000000zkoP;0059E0000037eUD;0059E000001DWIN;0059E0000037eRs;0059E0000037eRs');
        Insert new PED_System_Constants__c(ID_Profile_Customer_Community_User_STD__c = '00e9E000000DrlEQAS');
        Insert new PED_Environment__c(Name = 'RetrieveInfoPodEndPoint', Value__c = 'https://4ele-collaudo-wssf.enel.it/SVILUPPO/SOAPServiceBinding/wrapperInfoPod');
        Insert new PED_Environment__c(Name = 'EnableServiceLogging', Value__c = 'True');
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new PED_RetrieveInfoPodWSTestMock2());
       //DF PED_RegistrationCompController.CallingWebservice(con.id , accountRecPersoneFisicaJuanin3.id);  
        Test.stopTest();
    }
    
    public static testMethod void TestCallingWebservice(){   
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        Update user;
        
        ID recTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Fisica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneFisica = PED_TestUtility.createAccountData('Gupta');
        accountRecPersoneFisica.Nome__c = 'Aditya';
        accountRecPersoneFisica.RecordTypeId = recTypeID;
        accountRecPersoneFisica.OwnerId = user.Id;
        //accountRecPersoneFisica.PartitaIVA__c='11325690151';
        accountRecPersoneFisica.phone='12312312312';
        accountRecPersoneFisica.Nazionalita__c='Italiana';
        accountRecPersoneFisica.CodiceFiscale__c = 'GPTDTY80A01H501V';
        accountRecPersoneFisica.AccountRegistratoSulPortale__c = false;
        accountRecPersoneFisica.PED_DescrizioneKO_RIP__c = 'pippo';
        Insert accountRecPersoneFisica;
        
        Contact con = PED_TestUtility.createContactDataNullCode('Gupta', accountRecPersoneFisica.Id);
        con.FirstName = 'Aditya';
        con.Email = 'primoliv2@testorg.com';
        con.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        Insert con; 
        
        User u2 = PED_TestUtility.CreateUserData('Test Asd1', Null);
        u2.Email='primoliv2@testorg.com';
        u2.Alias = 'pliv'; 
        u2.ProfileId = p.Id;
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare - aggiunto .pc
        u2.UserName='primoliv2@testorg.com.pc';
        u2.IsActive = true;
        u2.ContactId = con.Id;
        u2.LastName = con.LastName;
        insert u2;  
        
        Insert new PED_URLs__c(Name = 'Condizioni Generali');
        Insert new PED_List_of_Id_User__c(Name = 'UserIds', IdUserOwnerAccount__c = '0059E000000zkoP;0059E0000037eUD;0059E000001DWIN;0059E0000037eRs;0059E0000037eRs');
        Insert new PED_System_Constants__c(ID_Profile_Customer_Community_User_STD__c = '00e9E000000DrlEQAS');
        Insert new PED_Environment__c(Name = 'RetrieveInfoPodEndPoint', Value__c = 'https://4ele-collaudo-wssf.enel.it/SVILUPPO/SOAPServiceBinding/wrapperInfoPod');
        Insert new PED_Environment__c(Name = 'EnableServiceLogging', Value__c = 'True');
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new PED_RetrieveInfoPodWSTestMock2());  
       //DF PED_RegistrationCompController.CallingWebservice(con.id , accountRecPersoneFisica.id);  
        Test.stopTest();
    }
    
    public static testMethod void TestCallingWebservice1(){   
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        Update user;
        
        ID PersonaGiuridicaRecTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Giuridica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneGirudica2 = PED_TestUtility.createAccountData('Marchisio');
        accountRecPersoneGirudica2.Nome__c = 'Claudio';
        accountRecPersoneGirudica2.RecordTypeId = PersonaGiuridicaRecTypeID;
        accountRecPersoneGirudica2.OwnerId = user.Id;
        accountRecPersoneGirudica2.PartitaIVA__c = '11325690151';
        accountRecPersoneGirudica2.CodiceFiscale__c = 'MRCCLD80C11F839S';
        Insert accountRecPersoneGirudica2;
        
        Contact con = PED_TestUtility.createContactDataNullCode('Gupta', null);
        con.FirstName = 'Aditya';
        con.Email = 'primoliv2@testorg.com';
        con.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        Insert con;         
        
        Insert new PED_URLs__c(Name = 'Condizioni Generali');
        Insert new PED_List_of_Id_User__c(Name = 'UserIds', IdUserOwnerAccount__c = '0059E000000zkoP;0059E0000037eUD;0059E000001DWIN;0059E0000037eRs;0059E0000037eRs');
        Insert new PED_System_Constants__c(ID_Profile_Customer_Community_User_STD__c = '00e9E000000DrlEQAS');
        Insert new PED_Environment__c(Name = 'RetrieveInfoPodEndPoint', Value__c = 'https://4ele-collaudo-wssf.enel.it/SVILUPPO/SOAPServiceBinding/wrapperInfoPod');
        Insert new PED_Environment__c(Name = 'EnableServiceLogging', Value__c = 'True');
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new PED_RetrieveInfoPodWSTestMock2());     
      //DF  PED_RegistrationCompController.CallingWebservice(con.id , accountRecPersoneGirudica2.id);  
        Test.stopTest();
    } 
    
    public static testMethod void TestCallingWebservice2(){   
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        Update user;
        
        ID PersonaGiuridicaRecTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Giuridica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneGirudica2 = PED_TestUtility.createAccountData('Marchisio');
        accountRecPersoneGirudica2.Nome__c = 'Claudio';
        accountRecPersoneGirudica2.RecordTypeId = PersonaGiuridicaRecTypeID;
        accountRecPersoneGirudica2.OwnerId = user.Id;
        accountRecPersoneGirudica2.PartitaIVA__c = '11325690151';
        accountRecPersoneGirudica2.CodiceFiscale__c = 'MRCCLD80C11F839S';
        Insert accountRecPersoneGirudica2;
        
        Contact con = PED_TestUtility.createContactDataNullCode('Gupta', null);
        con.FirstName = 'Aditya';
        con.Email = 'primoliv2@testorg.com';
        con.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        Insert con;         
        
        Insert new PED_URLs__c(Name = 'Condizioni Generali');
        Insert new PED_List_of_Id_User__c(Name = 'UserIds', IdUserOwnerAccount__c = '0059E000000zkoP;0059E0000037eUD;0059E000001DWIN;0059E0000037eRs;0059E0000037eRs');
        Insert new PED_System_Constants__c(ID_Profile_Customer_Community_User_STD__c = '00e9E000000DrlEQAS');
        Insert new PED_Environment__c(Name = 'RetrieveInfoPodEndPoint', Value__c = 'https://4ele-collaudo-wssf.enel.it/SVILUPPO/SOAPServiceBinding/wrapperInfoPod');
        Insert new PED_Environment__c(Name = 'EnableServiceLogging', Value__c = 'True');
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new PED_RetrieveInfoPodWSTestMock2());       
     //DF   PED_RegistrationCompController.CallingWebservice(con.id , accountRecPersoneGirudica2.id);  
        Test.stopTest();
    } 
    
    public static testMethod void atomicFunctionTest(){   
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        Update user;
        
        ID recTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Fisica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneFisica = PED_TestUtility.createAccountData('Gupta');
        accountRecPersoneFisica.Nome__c = 'Aditya';
        accountRecPersoneFisica.RecordTypeId = recTypeID;
        accountRecPersoneFisica.OwnerId = user.Id;
        accountRecPersoneFisica.phone='12312312312';
        accountRecPersoneFisica.Nazionalita__c='Italiana';
        accountRecPersoneFisica.CodiceFiscale__c = 'GPTDTY80A01H501V';
        Insert accountRecPersoneFisica;
        
        Contact con = PED_TestUtility.createContactDataNullCode('Gupta', accountRecPersoneFisica.Id);
        con.FirstName = 'Aditya';
        con.Email = 'primoliv2@testorg.com';
        con.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        Insert con; 
        
        User u2 = PED_TestUtility.CreateUserData('Test Asd1', Null);
        u2.Email='primoliv2@testorg.com';
        u2.Alias = 'pliv'; 
        u2.ProfileId = p.Id;
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare - aggiunto .pc
        u2.UserName='primoliv2@testorg.com.pc';
        u2.IsActive = true;
        u2.ContactId = con.Id;
        u2.LastName = con.LastName;
        insert u2;  
        
        Insert new PED_URLs__c(Name = 'Condizioni Generali');
        Insert new PED_List_of_Id_User__c(Name = 'UserIds', IdUserOwnerAccount__c = '0059E000000zkoP;0059E0000037eUD;0059E000001DWIN;0059E0000037eRs;0059E0000037eRs');
        Insert new PED_System_Constants__c(ID_Profile_Customer_Community_User_STD__c = '00e9E000000DrlEQAS');
        Insert new PED_Environment__c(Name = 'RetrieveInfoPodEndPoint', Value__c = 'https://4ele-collaudo-wssf.enel.it/SVILUPPO/SOAPServiceBinding/wrapperInfoPod');
        Insert new PED_Environment__c(Name = 'EnableServiceLogging', Value__c = 'True');
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new PED_RetrieveInfoPodWSTestMock2());
        PED_RegistrationCompController.updateAccount(con.Email , accountRecPersoneFisica.Id);
        PED_RegistrationCompController.updateContactPER(con.Id, con.Email, '12121');
        PED_RegistrationCompController.getNazionalityopts();        
        PED_RegistrationCompController.checkBlacklistedEmail(u2.Username);
        //PED_RegistrationCompController.sendRegistrationErrroMail('errore');  
        //PED_RegistrationCompController.createUser(con , con.id);  
        Test.stopTest();
    } 

    
 /*   public static testMethod  void testUserPGRegistration1() {
        system.debug('£££ TESTUSERPGREGISTRATION1');
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        // Update user;
        
        Id PersonaGiuridicaRecTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Giuridica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneGirudica2 = PED_TestUtility.createAccountData('Lippi');
        accountRecPersoneGirudica2.Nome__c = 'Claudio';
        accountRecPersoneGirudica2.RecordTypeId = PersonaGiuridicaRecTypeID;
        accountRecPersoneGirudica2.OwnerId = user.Id;
        accountRecPersoneGirudica2.PartitaIVA__c = '11325690151';
        accountRecPersoneGirudica2.CodiceFiscale__c = 'MRCCLD80C11F839S';
        accountRecPersoneGirudica2.AccountRegistratoSulPortale__c = false;
        Insert accountRecPersoneGirudica2;
        
        //Contact con1 = PED_TestUtility.createContactDataNullCode('Nana1', accountRecPersoneGirudica2.id);
        Contact con1 = new Contact();
        con1.AccountId = accountRecPersoneGirudica2.Id;
        con1.FirstName = 'Lala';
        con1.LastName = 'Nana';
        con1.Email = 'primoliv2@testorg.com';
        con1.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        con1.MobilePhone = '+3964654';
        con1.PED_MobilePhoneVerificato__c = true;
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare
        con1.OwnerId = user.Id;
       //PI
       //Insert con1;  
        
        User u4 = PED_TestUtility.CreateUserData('Test Asd2', Null);
        u4.Email='primoliv2@testorg.com';
        u4.Alias = 'pliv'; 
        u4.ProfileId = p.Id;
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare - aggiunto .pc
        u4.UserName='primoliv_6@testorg.com1.pc';
        u4.IsActive = true;
        u4.ContactId = con1.Id;
        u4.LastName = con1.LastName;
        u4.PED_Mobile_Registrazione__c = '+3964654';
        u4.PED_Data_Disabilitazione__c = system.now();
        //PI
        //insert u4;   
        Insert new PED_URLs__c(Name = 'Condizioni Generali');
        Insert new PED_List_of_Id_User__c(Name = 'UserIds', IdUserOwnerAccount__c = '0059E000000zkoP;0059E0000037eUD;0059E000001DWIN;0059E0000037eRs;0059E0000037eRs');
        Insert new PED_System_Constants__c(ID_Profile_Customer_Community_User_STD__c = '00e9E000000DrlEQAS');
        Insert new PED_Environment__c(Name = 'RetrieveInfoPodEndPoint', Value__c = 'https://4ele-collaudo-wssf.enel.it/SVILUPPO/SOAPServiceBinding/wrapperInfoPod');
        Insert new PED_Environment__c(Name = 'EnableServiceLogging', Value__c = 'True');
        
        System.RunAs(user){
            TEst.startTest();
            PED_RegistrationCompController.userPersonagiuridiRegistration(con1, accountRecPersoneGirudica2, 'Italiana');
            Test.stopTest();
        }
    }*/
    
   
    public static testMethod  void testUserPGRegistration4() {
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        Update user;
        
        Id PersonaGiuridicaRecTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Giuridica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneGirudica2 = PED_TestUtility.createAccountData('Marchisio');
        accountRecPersoneGirudica2.Nome__c = 'Claudio';
        accountRecPersoneGirudica2.RecordTypeId = PersonaGiuridicaRecTypeID;
        accountRecPersoneGirudica2.OwnerId = user.Id;
        accountRecPersoneGirudica2.PartitaIVA__c = '11325690151';
        accountRecPersoneGirudica2.CodiceFiscale__c = 'MRCCLD80C11F839S';
        Insert accountRecPersoneGirudica2;
        
        Contact con = PED_TestUtility.createContactDataNullCode('Gupta', accountRecPersoneGirudica2.id);
        con.FirstName = 'Aditya';
        con.Email = 'primoliv2@testorg.com';
        con.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare
        con.OwnerId = user.Id;
        Insert con;    
        
        User u3 = PED_TestUtility.CreateUserData('Test Asd2', Null);
        u3.Email='primoliv6@testorg.com';
        u3.Alias = 'pliv'; 
        u3.ProfileId = p.Id;
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare - aggiunto .pc
        u3.UserName='primoliv_6@testorg.com.pc';
        u3.IsActive = true;
        u3.ContactId = con.Id;
        u3.LastName = con.LastName;
        insert u3;
        
        Insert new PED_URLs__c(Name = 'Condizioni Generali');
        Insert new PED_List_of_Id_User__c(Name = 'UserIds', IdUserOwnerAccount__c = '0059E000000zkoP;0059E0000037eUD;0059E000001DWIN;0059E0000037eRs;0059E0000037eRs');
        Insert new PED_System_Constants__c(ID_Profile_Customer_Community_User_STD__c = '00e9E000000DrlEQAS');
        Insert new PED_Environment__c(Name = 'RetrieveInfoPodEndPoint', Value__c = 'https://4ele-collaudo-wssf.enel.it/SVILUPPO/SOAPServiceBinding/wrapperInfoPod');
        Insert new PED_Environment__c(Name = 'EnableServiceLogging', Value__c = 'True');
        
        TEst.startTest();
        PED_RegistrationCompController.userPersonagiuridiRegistration(con, accountRecPersoneGirudica2, 'Italiana');
        Test.stopTest();
    }
    
    public static testMethod  void testUserPGRegistration5() {
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        Update user;
        
        Id PersonaGiuridicaRecTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Giuridica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneGirudica4 = PED_TestUtility.createAccountData('Padoin');
        accountRecPersoneGirudica4.Nome__c = 'Simone';
        accountRecPersoneGirudica4.RecordTypeId = PersonaGiuridicaRecTypeID;
        accountRecPersoneGirudica4.OwnerId = user.Id;
        accountRecPersoneGirudica4.PartitaIVA__c = '00470470014';
        accountRecPersoneGirudica4.CodiceFiscale__c = 'PDNSMN79C16F839O';
        Insert accountRecPersoneGirudica4;
        
        Contact con = PED_TestUtility.createContactDataNullCode('Gupta', accountRecPersoneGirudica4.id);
        con.FirstName = 'Aditya';
        con.Email = 'primoliv2@testorg.com';
        con.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        Insert con;    
        
        Insert new PED_URLs__c(Name = 'Condizioni Generali');
        Insert new PED_List_of_Id_User__c(Name = 'UserIds', IdUserOwnerAccount__c = '0059E000000zkoP;0059E0000037eUD;0059E000001DWIN;0059E0000037eRs;0059E0000037eRs');
        Insert new PED_System_Constants__c(ID_Profile_Customer_Community_User_STD__c = '00e9E000000DrlEQAS');
        Insert new PED_Environment__c(Name = 'RetrieveInfoPodEndPoint', Value__c = 'https://4ele-collaudo-wssf.enel.it/SVILUPPO/SOAPServiceBinding/wrapperInfoPod');
        Insert new PED_Environment__c(Name = 'EnableServiceLogging', Value__c = 'True');
        
        TEst.startTest();
        PED_RegistrationCompController.userPersonagiuridiRegistration(con, accountRecPersoneGirudica4, 'Italiana');
        Test.stopTest();
    }
    
    
   
    public static testMethod  void testUserPGRegistration2() {
        system.debug('£££ TESTUSERPGREGISTRATION2');
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        Update user;
        
        Id recTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Fisica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneGirudica2 = PED_TestUtility.createAccountData('Marchisio');
        accountRecPersoneGirudica2.Nome__c = 'Claudio';
        accountRecPersoneGirudica2.RecordTypeId = recTypeID;
        accountRecPersoneGirudica2.OwnerId = user.Id;
        //accountRecPersoneGirudica2.PartitaIVA__c = '11325690151';
        accountRecPersoneGirudica2.CodiceFiscale__c = 'MRCCLD80C11F839S';
        accountRecPersoneGirudica2.AccountRegistratoSulPortale__c = false;
        Insert accountRecPersoneGirudica2;
        
        //Contact con = PED_TestUtility.createContactDataNullCode('Gupta', null);
        Contact con = new Contact();
	con.AccountId = accountRecPersoneGirudica2.Id;
        con.LastName = 'Gupta';
        con.FirstName = 'Aditya';
        con.Email = 'primoliv2@testorg.com';
        con.Codice_Fiscale__c = 'GPTDTY80A01H501V';
	con.MobilePhone = '+3964654';
        con.PED_MobilePhoneVerificato__c = true;
        con.OwnerId = user.Id;
        Insert con;         
        
        Insert new PED_URLs__c(Name = 'Condizioni Generali');
        Insert new PED_List_of_Id_User__c(Name = 'UserIds', IdUserOwnerAccount__c = '0059E000000zkoP;0059E0000037eUD;0059E000001DWIN;0059E0000037eRs;0059E0000037eRs');
        Insert new PED_System_Constants__c(ID_Profile_Customer_Community_User_STD__c = '00e9E000000DrlEQAS');
        Insert new PED_Environment__c(Name = 'RetrieveInfoPodEndPoint', Value__c = 'https://4ele-collaudo-wssf.enel.it/SVILUPPO/SOAPServiceBinding/wrapperInfoPod');
        Insert new PED_Environment__c(Name = 'EnableServiceLogging', Value__c = 'True');
        
        Test.startTest();
        PED_RegistrationCompController.userPersonagiuridiRegistration(con, accountRecPersoneGirudica2, 'Italiana');
        PED_RegistrationCompController.getUserAccountOwner(1);
        Test.stopTest();
    }

    
    public static testMethod  void testUserRegistration112() {
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        Update user;
        
        Id recTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Fisica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneFisica = PED_TestUtility.createAccountData('Gupta');
        accountRecPersoneFisica.Nome__c = 'Aditya';
        accountRecPersoneFisica.RecordTypeId = recTypeID;
        accountRecPersoneFisica.OwnerId = user.Id;
        accountRecPersoneFisica.phone='12312312312';
        accountRecPersoneFisica.Nazionalita__c='Italiana';
        accountRecPersoneFisica.CodiceFiscale__c = 'GPTDTY80A01H501V';
        Insert accountRecPersoneFisica;
        
        Account accountRecPersoneFisica2 = PED_TestUtility.createAccountData('Moggio');
        accountRecPersoneFisica2.Nome__c = 'Luca';
        accountRecPersoneFisica2.RecordTypeId = recTypeID;
        accountRecPersoneFisica2.OwnerId = user.Id;
        accountRecPersoneFisica2.phone='12312312312';
        accountRecPersoneFisica2.Nazionalita__c='Italiana';
        accountRecPersoneFisica2.CodiceFiscale__c = 'MGGLCU95M01F839L';
        Insert accountRecPersoneFisica2;
        
        Account accountRecPersoneFisicaJuanin3 = PED_TestUtility.createAccountData('Giovanni');
        accountRecPersoneFisicaJuanin3.Nome__c = 'Alberini';
        accountRecPersoneFisicaJuanin3.RecordTypeId = recTypeID;
        accountRecPersoneFisicaJuanin3.OwnerId = user.Id;
        accountRecPersoneFisicaJuanin3.phone='12312312312';
        accountRecPersoneFisicaJuanin3.Nazionalita__c='Italiana';
        accountRecPersoneFisicaJuanin3.CodiceFiscale__c = 'GVNLRN17T29A512V';
        Insert accountRecPersoneFisicaJuanin3;
        
        Contact contactRec = PED_TestUtility.createContactData('Gupta', accountRecPersoneFisica.Id);
        contactRec.FirstName = 'Aditya';
        contactRec.Email = 'primoliv@testorg.com';
        contactRec.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        insert (contactRec); 
        
        Contact contactRec_2 = PED_TestUtility.createContactDataNullCode('Moggio', accountRecPersoneFisica2.Id);
        contactRec_2.FirstName = 'Luca';
        contactRec_2.Email = 'primoliv2@testorg.com';
        contactRec_2.Codice_Fiscale__c = 'MGGLCU95M01F839L';
        insert (contactRec_2);  
        
        Contact contactRec_3 = PED_TestUtility.createContactDataNullCode('Giovanni', accountRecPersoneFisicaJuanin3.Id);
        contactRec_3.FirstName = 'Alberini';
        contactRec_3.Email = 'Piushprimoliv2@testorg.com';
        contactRec_3.Codice_Fiscale__c = 'GVNLRN17T29A512V';
        insert contactRec_3;           
        
        Test.startTest();
        PED_RegistrationCompController.userRegistration(contactRec);
        PED_RegistrationCompController.userRegistration(contactRec_2);    
        PED_RegistrationCompController.userRegistration(contactRec_3);           
        Test.stopTest();
    }
    
    public static testMethod  void testUserRegistration() {
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        Update user;
        
        Id recTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Fisica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneFisica = PED_TestUtility.createAccountData('Gupta');
        accountRecPersoneFisica.Nome__c = 'Aditya';
        accountRecPersoneFisica.RecordTypeId = recTypeID;
        accountRecPersoneFisica.OwnerId = user.Id;
        accountRecPersoneFisica.phone='12312312312';
        accountRecPersoneFisica.Nazionalita__c='Italiana';
        accountRecPersoneFisica.CodiceFiscale__c = 'GPTDTY80A01H501V';
        Insert accountRecPersoneFisica;
        
        Account accountRecPersoneFisica2 = PED_TestUtility.createAccountData('Moggio');
        accountRecPersoneFisica2.Nome__c = 'Luca';
        accountRecPersoneFisica2.RecordTypeId = recTypeID;
        accountRecPersoneFisica2.OwnerId = user.Id;
        accountRecPersoneFisica2.phone='12312312312';
        accountRecPersoneFisica2.Nazionalita__c='Italiana';
        accountRecPersoneFisica2.CodiceFiscale__c = 'MGGLCU95M01F839L';
        Insert accountRecPersoneFisica2;
        
        Account accountRecPersoneFisicaJuanin3 = PED_TestUtility.createAccountData('Giovanni');
        accountRecPersoneFisicaJuanin3.Nome__c = 'Alberini';
        accountRecPersoneFisicaJuanin3.RecordTypeId = recTypeID;
        accountRecPersoneFisicaJuanin3.OwnerId = user.Id;
        accountRecPersoneFisicaJuanin3.phone='12312312312';
        accountRecPersoneFisicaJuanin3.Nazionalita__c='Italiana';
        accountRecPersoneFisicaJuanin3.CodiceFiscale__c = 'GVNLRN17T29A512V';
        Insert accountRecPersoneFisicaJuanin3;
        
        Contact contactRec = PED_TestUtility.createContactData('Gupta', accountRecPersoneFisica.Id);
        contactRec.FirstName = 'Aditya';
        contactRec.Email = 'primoliv@testorg.com';
        contactRec.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare
        contactRec.OwnerId = user.Id;
        insert (contactRec); 
        
        Contact contactRec_2 = PED_TestUtility.createContactDataNullCode('Moggio', accountRecPersoneFisica2.Id);
        contactRec_2.FirstName = 'Luca';
        contactRec_2.Email = 'primoliv2@testorg.com';
        contactRec_2.Codice_Fiscale__c = 'MGGLCU95M01F839L';
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare
        contactRec_2.OwnerId = user.Id;
        insert (contactRec_2);  
        
        Contact contactRec_3 = PED_TestUtility.createContactDataNullCode('Giovanni', accountRecPersoneFisicaJuanin3.Id);
        contactRec_3.FirstName = 'Alberini';
        contactRec_3.Email = 'Piushprimoliv2@testorg.com';
        contactRec_3.Codice_Fiscale__c = 'GVNLRN17T29A512V';
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare
        contactRec_3.OwnerId = user.Id;
        insert contactRec_3;      
        
        User u2 = PED_TestUtility.CreateUserData('Test Asd1', Null);
        u2.Email='primoliv2@testorg.com';
        u2.Alias = 'pliv'; 
        u2.ProfileId = p.Id;
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare - aggiunto .pc
        u2.UserName='primoliv2@testorg.com.pc';
        u2.IsActive = true;
        u2.ContactId = contactRec_2.Id;
        u2.LastName = contactRec_2.LastName;
        u2.IsActive = true;
        insert u2; 
        
        Test.startTest();
        PED_RegistrationCompController.userRegistration(contactRec);
        PED_RegistrationCompController.userRegistration(contactRec_2);    
        PED_RegistrationCompController.userRegistration(contactRec_3);           
        Test.stopTest();
    }
    
    public static testMethod  void testUserRegistration1() {
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        //user.PED_AccOwnerCounter__c = 0.0;
        //user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        //Update user;
        
        ID recTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Fisica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneFisica2 = PED_TestUtility.createAccountData('Moggio');
        accountRecPersoneFisica2.Nome__c = 'Luca';
        accountRecPersoneFisica2.RecordTypeId = recTypeID;
        accountRecPersoneFisica2.OwnerId = user.Id;
        accountRecPersoneFisica2.phone='12312312312';
        accountRecPersoneFisica2.Nazionalita__c='Italiana';
        accountRecPersoneFisica2.CodiceFiscale__c = 'MGGLCU95M01F839L';
        Insert accountRecPersoneFisica2;
        
        Contact contactRec_2 = PED_TestUtility.createContactData('Moggio', accountRecPersoneFisica2.Id);
        contactRec_2.FirstName = 'Luca';
        contactRec_2.Email = 'primoliv2@testorg.com'; 
        contactRec_2.Codice_Fiscale__c = 'MGGLCU95M01F839L';
        insert contactRec_2;     
        
        Test.startTest();
        PED_RegistrationCompController.userRegistration(contactRec_2);            
        Test.stopTest();
    }

    public static testMethod  void testUserRegistration3() {
        User user = [SELECT Id, PED_AccOwnerCounter__c,PED_IsAPP__c FROM User WHERE Id =: UserInfo.getUserId()];
        
        Id recTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Fisica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneFisica2 = PED_TestUtility.createAccountData('Moggio');
        accountRecPersoneFisica2.Nome__c = 'Luca';
        accountRecPersoneFisica2.RecordTypeId = recTypeID;
        accountRecPersoneFisica2.OwnerId = user.Id;
        accountRecPersoneFisica2.phone='12312312312';
        accountRecPersoneFisica2.Nazionalita__c='Italiana';
        accountRecPersoneFisica2.CodiceFiscale__c = 'MGGLCU95M01F839L';
        Insert accountRecPersoneFisica2;
        
        Contact contactRec_2 = PED_TestUtility.createContactData('Moggio', accountRecPersoneFisica2.Id);
        contactRec_2.FirstName = 'Luca';
        contactRec_2.Email = 'primoliv2@testorg.com'; 
        contactRec_2.Codice_Fiscale__c = 'MGGLCU95M01F839L';
        insert contactRec_2;   
        
        Test.startTest();
        PED_RegistrationCompController.userRegistration(contactRec_2); 
       
        Test.stopTest();
    }

    
      public static testMethod  void testUserRegistrationtest() {
                  Test.startTest();

        User user = [SELECT Id, PED_AccOwnerCounter__c,PED_IsAPP__c FROM User WHERE Id =: UserInfo.getUserId()];
        
        Id recTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Fisica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
   
        Account accountRecPersoneFisica2 = PED_TestUtility.createAccountData('Moggio');
        accountRecPersoneFisica2.Nome__c = 'Luca';
        accountRecPersoneFisica2.RecordTypeId = recTypeID;
        accountRecPersoneFisica2.OwnerId = user.Id;
        accountRecPersoneFisica2.phone='12312312312';
        accountRecPersoneFisica2.Nazionalita__c='Italiana';
        accountRecPersoneFisica2.CodiceFiscale__c = 'MGGLCU95M01F839L';
        Insert accountRecPersoneFisica2;
        
        Contact contactRec_2 = PED_TestUtility.createContactData('Moggio', accountRecPersoneFisica2.Id);
        contactRec_2.FirstName = 'Luca';
        contactRec_2.Email = 'primoliv2@testorg.com'; 
        contactRec_2.Codice_Fiscale__c = 'MGGLCU95M01F839L';
        insert contactRec_2;   
        
         
        PED_RegistrationCompController.sendCodeOTPEmail('Test');
        PED_RegistrationCompController.checkOTPApexEmail('Test','Test');
        PED_RegistrationCompController.checkBlacklist('Test');
        //PED_RegistrationCompController.futureSendMailResetPassword('Test');
        Test.stopTest();
    }
    
   
    public static testMethod  void testUserRegistration2() {
        system.debug('£££ TESTUSERREGISTRATION2');
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        
        Id recTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Fisica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        //Account accountRecPersoneFisica = PED_TestUtility.createAccountData('Gupta');
        Account accountRecPersoneFisica = new Account();
        accountRecPersoneFisica.Name = 'Gupta';
        accountRecPersoneFisica.Nome__c = 'Aditya';
        accountRecPersoneFisica.RecordTypeId = recTypeID;
        accountRecPersoneFisica.OwnerId = user.Id;
        accountRecPersoneFisica.phone='12312312312';
        accountRecPersoneFisica.Nazionalita__c='Italiana';
        accountRecPersoneFisica.CodiceFiscale__c = 'GPTDTY80A01H501V';
        accountRecPersoneFisica.AccountRegistratoSulPortale__c = false;
        Insert accountRecPersoneFisica;
        
        //Contact contactRec = PED_TestUtility.createContactData('Gupta', null);
        Contact contactRec = new Contact();
        contactRec.AccountId = accountRecPersoneFisica.Id;
        contactRec.FirstName = 'Aditya';
        contactRec.LastName = 'Gupta';
        contactRec.Email = 'primoliv@testorg.com';
        contactRec.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare
        contactRec.OwnerId = user.Id;
        //insert (contactRec);         
        
        Test.startTest();
        PED_RegistrationCompController.userRegistration(contactRec);          
        Test.stopTest();
    }

    
    public static testMethod  void testUserPGRegistration22() {
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        // Update user;
        
        Id PersonaGiuridicaRecTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Giuridica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneGirudica2 = PED_TestUtility.createAccountData('Marchisio');
        accountRecPersoneGirudica2.Nome__c = 'Claudio';
        accountRecPersoneGirudica2.RecordTypeId = PersonaGiuridicaRecTypeID;
        accountRecPersoneGirudica2.OwnerId = user.Id;
        accountRecPersoneGirudica2.PartitaIVA__c = '11325690151';
        accountRecPersoneGirudica2.CodiceFiscale__c = 'MRCCLD80C11F839S';
        Insert accountRecPersoneGirudica2;
        
        Contact con = PED_TestUtility.createContactDataNullCode('Gupta', accountRecPersoneGirudica2.id);
        con.FirstName = 'Aditya';
        con.Email = 'primoliv2@testorg.com';         
        con.PED_ContactKey__c = 'ciao';
        con.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        Insert con;    
        
        User u3 = PED_TestUtility.CreateUserData('Test Asd2', Null);
        u3.Email='primoliv6@testorg.com';
        u3.Alias = 'pliv'; 
        u3.ProfileId = p.Id;
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare - aggiunto .pc
        u3.UserName='primoliv_6@testorg.com.pc';
        u3.IsActive = true;
        u3.ContactId = con.Id;
        u3.LastName = con.LastName;
        insert u3;
        
        Insert new PED_URLs__c(Name = 'Condizioni Generali');
        Insert new PED_List_of_Id_User__c(Name = 'UserIds', IdUserOwnerAccount__c = '0059E000000zkoP;0059E0000037eUD;0059E000001DWIN;0059E0000037eRs;0059E0000037eRs');
        Insert new PED_System_Constants__c(ID_Profile_Customer_Community_User_STD__c = '00e9E000000DrlEQAS');
        Insert new PED_Environment__c(Name = 'RetrieveInfoPodEndPoint', Value__c = 'https://4ele-collaudo-wssf.enel.it/SVILUPPO/SOAPServiceBinding/wrapperInfoPod');
        Insert new PED_Environment__c(Name = 'EnableServiceLogging', Value__c = 'True');
        
        TEst.startTest();
        PED_RegistrationCompController.userPersonagiuridiRegistration(con, accountRecPersoneGirudica2, 'Italiana');
        Test.stopTest();
    }
    
    public static testMethod  void testUserPGRegistration() {
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        // Update user;
        
        Id PersonaGiuridicaRecTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Giuridica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneGirudica2 = PED_TestUtility.createAccountData('Marchisio');
        accountRecPersoneGirudica2.Nome__c = 'Claudio';
        accountRecPersoneGirudica2.RecordTypeId = PersonaGiuridicaRecTypeID;
        accountRecPersoneGirudica2.OwnerId = user.Id;
        accountRecPersoneGirudica2.PartitaIVA__c = '11325690151';
        accountRecPersoneGirudica2.CodiceFiscale__c = 'MRCCLD80C11F839S';
        Insert accountRecPersoneGirudica2;
        
        Contact con = PED_TestUtility.createContactDataNullCode('Gupta', accountRecPersoneGirudica2.id);
        con.FirstName = 'Aditya';
        con.Email = 'primoliv2@testorg.com';
        con.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare
        con.OwnerId = user.Id;
        Insert con;    
        
        User u3 = PED_TestUtility.CreateUserData('Test Asd2', Null);
        u3.Email='primoliv6@testorg.com';
        u3.Alias = 'pliv'; 
        u3.ProfileId = p.Id;
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare - aggiunto .pc
        u3.UserName='primoliv_6@testorg.com.pc';
        u3.IsActive = true;
        u3.ContactId = con.Id;
        u3.LastName = con.LastName;
        insert u3;
        
        Insert new PED_URLs__c(Name = 'Condizioni Generali');
        Insert new PED_List_of_Id_User__c(Name = 'UserIds', IdUserOwnerAccount__c = '0059E000000zkoP;0059E0000037eUD;0059E000001DWIN;0059E0000037eRs;0059E0000037eRs');
        Insert new PED_System_Constants__c(ID_Profile_Customer_Community_User_STD__c = '00e9E000000DrlEQAS');
        Insert new PED_Environment__c(Name = 'RetrieveInfoPodEndPoint', Value__c = 'https://4ele-collaudo-wssf.enel.it/SVILUPPO/SOAPServiceBinding/wrapperInfoPod');
        Insert new PED_Environment__c(Name = 'EnableServiceLogging', Value__c = 'True');
        
        TEst.startTest();
        PED_RegistrationCompController.userPersonagiuridiRegistration(con, accountRecPersoneGirudica2, 'Italiana');
        Test.stopTest();
    }
    
    public static testMethod  void testMetodiRegFake() {
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        // Update user;
        
        Id PersonaGiuridicaRecTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Giuridica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneGirudica2 = PED_TestUtility.createAccountData('Marchisio');
        accountRecPersoneGirudica2.Nome__c = 'Claudio';
        accountRecPersoneGirudica2.RecordTypeId = PersonaGiuridicaRecTypeID;
        accountRecPersoneGirudica2.OwnerId = user.Id;
        accountRecPersoneGirudica2.PartitaIVA__c = '11325690151';
        accountRecPersoneGirudica2.CodiceFiscale__c = 'MRCCLD80C11F839S';
        accountRecPersoneGirudica2.AccountRegistratoSulPortale__c = false;
        Insert accountRecPersoneGirudica2;
        
        Contact con = PED_TestUtility.createContactDataNullCode('Gupta', accountRecPersoneGirudica2.id);
        con.FirstName = 'Aditya';
        con.LastName = 'Gupta';
        con.Email = 'primoliv2@testorg.com';
        con.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        con.MobilePhone = '+3964654';
        con.PED_MobilePhoneVerificato__c = true;
        Insert con;    
        
        User u3 = PED_TestUtility.CreateUserData('Test Asd2', Null);
        u3.Email='primoliv6@testorg.com';
        u3.Alias = 'pliv'; 
        u3.ProfileId = p.Id;
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare - aggiunto .pc
        u3.UserName='primoliv_6@testorg.com.pc';
        u3.IsActive = true;
        u3.ContactId = con.Id;
        u3.LastName = con.LastName;
        u3.PED_Mobile_Registrazione__c = '+3964654';
        insert u3;        
        
        TEst.startTest();
        PED_RegistrationCompController.checkRegistrationUserF(con, '+3964654','123');
        PED_RegistrationCompController.checkRegistrationUserG(con , accountRecPersoneGirudica2 ,  'Sedelegaled','+39565655','123'); 
        PED_RegistrationCompController.checkRegistrationPortaleTrader(con, accountRecPersoneGirudica2 ,  'Sedelegaled','+39565655','123'); 
        PED_RegistrationCompController.getUniqueIdNumeric(3);  
        PED_RegistrationCompController.checkOTPApex('+3964654' , '964654');
        PED_RegistrationCompController.RegistrationUserF(con, '+3964654', '123');
        Test.stopTest();
    }
    
    public static testMethod  void testCheckOTPApex() {
     	PED_OTP__c Otp = new PED_OTP__c();
        Otp.PED_CodiceOTP__c = '964654';
        Otp.PED_Telefono__c = '+3964654';
        Otp.PED_DateValidate__c = null;
        insert Otp; 
        PED_RegistrationCompController.checkOTPApex('+3964654' , '964654');
    }
    public static testMethod  void testCheckOTPApex2() {
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        // Update user;
        
        Id PersonaGiuridicaRecTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Giuridica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        Account accountRecPersoneGirudica2 = PED_TestUtility.createAccountData('Marchisio');
        accountRecPersoneGirudica2.Nome__c = 'Claudio';
        accountRecPersoneGirudica2.RecordTypeId = PersonaGiuridicaRecTypeID;
        accountRecPersoneGirudica2.OwnerId = user.Id;
        accountRecPersoneGirudica2.PartitaIVA__c = '11325690151';
        accountRecPersoneGirudica2.CodiceFiscale__c = 'MRCCLD80C11F839S';
        accountRecPersoneGirudica2.AccountRegistratoSulPortale__c = false;
        Insert accountRecPersoneGirudica2;
        
        Contact con = PED_TestUtility.createContactDataNullCode('Gupta', accountRecPersoneGirudica2.id);
        con.FirstName = 'Aditya';
        con.LastName = 'Gupta';
        con.Email = 'primoliv2@testorg.com';
        con.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        con.MobilePhone = '+3964654';
        con.PED_MobilePhoneVerificato__c = true;
        Insert con;    

        PED_OTP__c Otp = new PED_OTP__c();
       Otp.PED_CodiceOTP__c = '964654';
       Otp.PED_Telefono__c = '+3964654';
       Otp.PED_DateValidate__c = null;
       insert Otp; 
       PED_RegistrationCompController.checkOTPApex('+3964654' , '964654', 'Processo', accountRecPersoneGirudica2 , con , 'IP', true);
   }

    public static testMethod  void testMetodiRegFake2() {
        system.debug('£££ TESTMETODIREGFAKE2');
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        // Update user;
        
        Id PersonaGiuridicaRecTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Giuridica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneGirudica2 = PED_TestUtility.createAccountData('Lippi');
        accountRecPersoneGirudica2.Nome__c = 'Claudio';
        accountRecPersoneGirudica2.RecordTypeId = PersonaGiuridicaRecTypeID;
        accountRecPersoneGirudica2.OwnerId = user.Id;
        accountRecPersoneGirudica2.PartitaIVA__c = '11325690151';
        accountRecPersoneGirudica2.CodiceFiscale__c = 'MRCCLD80C11F839S';
        accountRecPersoneGirudica2.AccountRegistratoSulPortale__c = false;
        Insert accountRecPersoneGirudica2;
        
        //Contact con1 = PED_TestUtility.createContactDataNullCode('Nana1', accountRecPersoneGirudica2.id);
        Contact con1 = new Contact();
        con1.AccountId = accountRecPersoneGirudica2.Id;
        con1.FirstName = 'Lala';
        con1.LastName = 'Nana';
        con1.Email = 'primoliv2@testorg.com';
        con1.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        con1.MobilePhone = '+3964654';
        con1.PED_MobilePhoneVerificato__c = true;
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare
        con1.OwnerId = user.Id;
       //PI
       //Insert con1;  
        
        User u4 = PED_TestUtility.CreateUserData('Test Asd2', Null);
        u4.Email='primoliv2@testorg.com';
        u4.Alias = 'pliv'; 
        u4.ProfileId = p.Id;
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare - aggiunto .pc
        u4.UserName='primoliv_6@testorg.com1.pc';
        u4.IsActive = true;
        u4.ContactId = con1.Id;
        u4.LastName = con1.LastName;
        u4.PED_Mobile_Registrazione__c = '+3964654';
        u4.PED_Data_Disabilitazione__c = system.now();
        //insert u4;   
        
        Test.startTest();
        PED_RegistrationCompController.checkRegistrationUserF(con1, '+3964654', '123');
        system.debug('£££ A');
        PED_RegistrationCompController.checkRegistrationUserG(con1, accountRecPersoneGirudica2, 'Sedelegaled', '+39565655', '123');
        system.debug('£££ B');
        PED_RegistrationCompController.RegistrationUserF(con1, '+3964654', '123');
        system.debug('£££ C');
        PED_RegistrationCompController.RegistrationUserG(con1, accountRecPersoneGirudica2, 'Sedelegaled', '+39565655', '123');
        system.debug('£££ D');        
        PED_RegistrationCompController.RegistrationUserGTrader(con1, accountRecPersoneGirudica2, 'Sedelegaled', '+39565655', '123');
        system.debug('£££ E');       
        PED_RegistrationCompController.validationCFCont(con1);
        Test.stopTest();
    }

   /*DF public static testMethod void sendCodeOTPTest(){
        Test.startTest();
        Test.setMock(WebServiceMock.class, new PED_EnotifyWSMock('calloutValidateSMS_OK'));     
        PED_RegistrationCompController.sendCodeOTP('1213123');
        Test.stopTest();
    } DF*/
    
    public static testMethod  void testMetodiRegFake3() {
        system.debug('£££ TESTMETODIREGFAKE3');
        
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        // Update user;
        
        Id PersonaGiuridicaRecTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Giuridica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account accountRecPersoneGirudica2 = PED_TestUtility.createAccountData('Lippi');
        accountRecPersoneGirudica2.Nome__c = 'Claudio';
        accountRecPersoneGirudica2.RecordTypeId = PersonaGiuridicaRecTypeID;
        accountRecPersoneGirudica2.OwnerId = user.Id;
        accountRecPersoneGirudica2.PartitaIVA__c = '11325690151';
        accountRecPersoneGirudica2.CodiceFiscale__c = 'MRCCLD80C11F839S';
        accountRecPersoneGirudica2.AccountRegistratoSulPortale__c = false;
        Insert accountRecPersoneGirudica2;
        
        //Contact con1 = PED_TestUtility.createContactDataNullCode('Nana1', accountRecPersoneGirudica2.id);
        Contact con1 = new Contact();
        con1.AccountId = accountRecPersoneGirudica2.Id;
        con1.FirstName = 'Lala';
        con1.LastName = 'Nana';
        con1.Email = 'primoliv2@testorg.com';
        con1.Codice_Fiscale__c = 'GPTDTY80A01H501V';
        con1.MobilePhone = '+3964654';
        con1.PED_MobilePhoneVerificato__c = true;
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare
        con1.OwnerId = user.Id;
       //PI
       //Insert con1;  
        
        User u4 = PED_TestUtility.CreateUserData('Test Asd2', Null);
        u4.Email='primoliv2@testorg.com';
        u4.Alias = 'pliv'; 
        u4.ProfileId = p.Id;
        //MB 21022020 - Modfica per non assegnare al site guest user il contact che si sta per creare - aggiunto .pc
        u4.UserName='primoliv_6@testorg.com1.pc';
        u4.IsActive = true;
        u4.ContactId = con1.Id;
        u4.LastName = con1.LastName;
        u4.PED_Mobile_Registrazione__c = '+3964654';
        u4.PED_Data_Disabilitazione__c = system.now();
        //PI
        //insert u4;   

        Test.startTest();        
        PED_RegistrationCompController.RegistrationUserG(con1 , accountRecPersoneGirudica2 ,  'Sedelegaled','+39565655', '123');
        PED_RegistrationCompController.RegistrationUserGTrader(con1 , accountRecPersoneGirudica2 ,  'Sedelegaled','+39565655', '123');
        PED_RegistrationCompController.validationCFCont(con1);
        Test.stopTest();
    }
    public static testMethod  void logRegistrazioneRespintaTest(){ 
        Account acc = new Account(
            CodiceFiscale__c = 'MRCCLD80C11F839S',
            Name = 'Marchisio',
            Nome__c = 'Claudio'
        );
        insert acc;
        PED_List_of_Id_User__c cs = new PED_List_of_Id_User__c();
        cs.IdUserOwnerAccount__c = '00524000005vrQ8;00524000001jzbp';
        cs.Name= 'UserIds';
        insert cs;
        
        Contact con = new Contact(
            Codice_Fiscale__c = 'MRCCLD80C11F839S',
            LastName = 'Marchisio',
            Email = 'clacla@claclacla.it',
            PED_SocietaDiVendita__c = true,
            PED_Nazionalit__c = 'Italiana',
            FirstName = 'Claudio'
        );
        insert con;
        Test.startTest();
        PED_RegistrationCompController.logRegistrazioneRespinta(con, acc, '33333333333', 'SedeLeg', 'Motivazione_TEST', 'IPUtente');
        System.AssertEquals('Claudio', PED_RegistrationCompController.logRegistrazioneRespinta(con, null, '33333333333', 'SedeLeg', 'Motivazione_TEST', 'IPUtente').Nome__c);
        Test.stopTest();
    }

    public static testMethod  void checkRegistrationUserGFTest(){
        PED_List_of_Id_User__c cs = new PED_List_of_Id_User__c();
        cs.IdUserOwnerAccount__c = '00524000005vrQ8;00524000001jzbp';
        cs.Name= 'UserIds';
        insert cs;
        
		Id PersonaGiuridicaRecTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Giuridica').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];
        
        Account acc = new Account(
            CodiceFiscale__c = 'MRCCLD80C11F839S',
            Name = 'Marchisio',
            Nome__c = 'Claudio'
        );
        insert acc;
        Contact con = new Contact(
            Codice_Fiscale__c = 'MRCCLD80C11F839S',
            LastName = 'Marchisio',
            Email = 'primolirv2@testorg.com',
            PED_SocietaDiVendita__c = true,
            PED_Nazionalit__c = 'Italiana',
            FirstName = 'Claudio',
            AccountId = acc.Id
        );
        insert con;
               
        User user = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user.Email='primolirv2@testorg.com';
        user.PED_Data_Disabilitazione__c = datetime.now().addHours(-1);
        update user;
        
        Test.startTest();
        PED_RegistrationCompController.checkRegistrationUserG(con, acc, 'SedeLeg', 'Cell', 'IPUtente');
        PED_RegistrationCompController.checkRegistrationUserF(con, 'Cell', 'IPUtente');
        Test.stopTest();
    }

    public static testMethod  void sendCodeOTPEmailTest(){
        User user = [SELECT Id, PED_AccOwnerCounter__c, Username FROM User WHERE Id =: UserInfo.getUserId()];
        user.PED_AccOwnerCounter__c = 0.0;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user.Email='primolirv2@testorg.com';
        user.PED_Data_Disabilitazione__c = datetime.now();
        update user;
        Test.startTest();
        PED_RegistrationCompController.sendCodeOTPEmail(user.Username);
        Test.stopTest();
    }


}