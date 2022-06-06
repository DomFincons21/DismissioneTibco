@isTest
public class PED_CambiaEmailControllerTest {

    @testSetup   
    public static void initialize() {    
        PED_Environment__c settings = new PED_Environment__c();
        settings.Name= 'no-replyMailSender';
        settings.value__c = 'no-reply@crm.e-distribuzione.com';
        insert settings;   
    }

    
    public static testmethod void testUpdateEmail_NEW_AS(){  
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1]; 
        UserRole ur = [select developername, name, id from userRole where developername = 'Back_Office' limit 1];
        
        User u = new User(UserRoleId = ur.Id,Alias = 'pliv', Email='primoliv@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='primoliv3@testorg.com');
        insert u;
        system.runas(u){
            
            List<Account> acclist = new List<Account>();   
            Account accobj = new Account();
            accobj.Name= 'test';
            accobj.PartitaIVA__c = '';
            accobj.CodiceFiscale__c = '04731870657';
            accobj.Nazionalita__c='Afgana';
            accobj.Website = 'webb';
            accobj.Fax = '2323434345';
            accobj.PPW_SLeg_Toponimo__c = 'V';
            accobj.PPW_SLeg_Indirizzo__c = 'Roma';
            accobj.PPW_SLeg_Civico__c = '3';
            accobj.PPW_SLeg_CAP__c='20123';
            accobj.PPW_SLeg_Localit__c='Centro';
            accobj.PPW_SLeg_Comune__c='Milano';
            accobj.PPW_SLeg_Provincia__c='MI';
            accobj.PPW_SLeg_Nazione__c ='ITA';
            accobj.APP_Ultimo_aggiornamento__c ='PED';
            accobj.App_creazione__c ='CM';
            accobj.Email__c  = 'marco@gmail.com'; 
            //accobj.Owner = 'u.id';
            
            
            
            insert accobj;
            
            List<Contact> conlist = new List<Contact>();
            contact conobj = new Contact();
            conobj.LastName = 'test';
            conobj.MailingCity = 'test';
            conobj.PPW_Res_Toponimo__c= 'testtest';
            conobj.PPW_Res_Indirizzo__c='test1';
            conobj.PPW_Res_Civico__c='test2';
            conobj.PPW_Res_CAP__c='test3';
            conobj.PPW_Res_Comune__c='test4';
            conobj.PPW_Res_Localit__c='test5';
            conobj.PPW_Res_Provincia__c='te';
            conobj.PPW_Res_Nazione__c='test6';
            conobj.HomePhone='0000000';
            conobj.Email='test@gmail.com';
            conobj.Salutation='Mr';
            conobj.PED_Sesso__c='p';
            //conobj.Birthdate=2017-04-10;
            conobj.OtherPhone='1555';
            conobj.MobilePhone='8861374502';
            //conobj.PED_Civico__c='test7';
            conobj.PED_Istruzione__c='testold';
            conobj.Fax='42';
            conobj.PPW_NazioneNascita__c='Italia';
            conobj.PPW_MailPEC__c='lbianchi@test.pec.it';
            //conobj.PPW_Cellulare__c='3471111111';
            conobj.PED_Cellulare2__c='885136';
            // conobj.PPW_Telefono__c='0391111111';
            conobj.PED_Professione__c='engineer';
            conobj.Codice_Fiscale__c='TSTTST80A01H501G';
            conobj.LastName='test'; 
            conobj.FirstName='test';
            conobj.PED_ClausolaLegaleA__c=  false;
            conobj.PED_ClausolaLegaleB__c=false;
            conobj.PED_ClausolaLegaleFacoltativa__c=false;
            conobj.APP_Ultimo_aggiornamento__c ='PED';
            conobj.App_creazione__c ='CM';
            conobj.PED_POD_Validate__c= true;
            conobj.Accountid = accobj.id;
            conobj.Ownerid = userinfo.getUserId();
            conobj.PED_email_da_confermare__c='primoliv3@testorg.com.pc';
            conobj.PPW_PraticaInVolo__c=true;
            conobj.PPW_FlagAnagraficaCompleta__c=true;
            //conobj.Email = 'test@gmail.com';
            
            insert conobj;
            
            
            
            Profile p1 = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];  //PED Partner Community User  
            //  UserRole ur1 = [select developername, name, id from userRole where developername = 'testDataPartnerUser' limit 1];
            
            User u1 = new User(Alias = 'pliv', Email='testingcambiaemail@test.com', 
                               EmailEncodingKey='UTF-8',FirstName='Test', LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p1.Id, contactid=conobj.id,
                               TimeZoneSidKey='America/Los_Angeles', UserName='testingcambiaemail@test.com');
            insert u1;
            //conobj.OwnerId = u1.id;
            conobj.Email='testingcambiaemail@test.com';
            conobj.PED_email_da_confermare__c='primoliv3@testorg.com';
            update conobj;
            
            
            system.runAs(u1){  
                
                try{
                    System.test.startTest();
                    PED_CambiaEmailController.updateEmail_NEW_AS('primoliv@testorg.com');
                    PED_CambiaEmailController.checkEmail_CM(conlist);
                    PED_CambiaEmailController.SendEmail('Testing','Test',conobj.id,conobj.PED_email_da_confermare__c);
                    
                    System.test.stopTest();
                }catch(Exception e){
                    
                }
            } 
            
        }
    }
    
    
    
    public static testmethod void testUpdateEmail_NEW_AS1(){  
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1]; 
        UserRole ur = [select developername, name, id from userRole where developername = 'Back_Office' limit 1];
        
        User u = new User(UserRoleId = ur.Id,Alias = 'pliv', Email='primoliv@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='primoliv3@testorg.com');
        insert u;
        system.runas(u) {
            List<Account> acclist = new List<Account>();   
            Account accobj = new Account();
            accobj.Name= 'test';
            accobj.PartitaIVA__c = '';
            accobj.CodiceFiscale__c = '04731870657';
            accobj.Nazionalita__c='Afgana';
            accobj.Website = 'webb';
            accobj.Fax = '2323434345';
            accobj.PPW_SLeg_Toponimo__c = 'V';
            accobj.PPW_SLeg_Indirizzo__c = 'Roma';
            accobj.PPW_SLeg_Civico__c = '3';
            accobj.PPW_SLeg_CAP__c='20123';
            accobj.PPW_SLeg_Localit__c='Centro';
            accobj.PPW_SLeg_Comune__c='Milano';
            accobj.PPW_SLeg_Provincia__c='MI';
            accobj.PPW_SLeg_Nazione__c ='ITA';
            accobj.APP_Ultimo_aggiornamento__c ='CM';
            accobj.App_creazione__c ='CM';
            accobj.Email__c  = 'marco@gmail.com';
            //accobj.Owner = 'u.id';
            
            
            
            insert accobj;
            
            List<Contact> conlist = new List<Contact>();
            contact conobj = new Contact();
            conobj.LastName = 'test';
            conobj.MailingCity = 'test';
            conobj.PPW_Res_Toponimo__c= 'testtest';
            conobj.PPW_Res_Indirizzo__c='test1';
            conobj.PPW_Res_Civico__c='test2';
            conobj.PPW_Res_CAP__c='test3';
            conobj.PPW_Res_Comune__c='test4';
            conobj.PPW_Res_Localit__c='test5';
            conobj.PPW_Res_Provincia__c='te';
            conobj.PPW_Res_Nazione__c='test6';
            conobj.HomePhone='0000000';
            conobj.Email='test@gmail.com';
            conobj.Salutation='Mr';
            conobj.PED_Sesso__c='p';
            //conobj.Birthdate=2017-04-10;
            conobj.OtherPhone='1555';
            conobj.MobilePhone='8861374502';
            //conobj.PED_Civico__c='test7';
            conobj.PED_Istruzione__c='testold';
            conobj.Fax='42';
            conobj.PPW_NazioneNascita__c='Italia';
            conobj.PPW_MailPEC__c='lbianchi@test.pec.it';
            //conobj.PPW_Cellulare__c='3471111111';
            conobj.PED_Cellulare2__c='885136';
            // conobj.PPW_Telefono__c='0391111111';
            conobj.PED_Professione__c='engineer';
            conobj.Codice_Fiscale__c='TSTTST80A01H501G';
            conobj.LastName='test'; 
            conobj.FirstName='test';
            conobj.PED_ClausolaLegaleA__c=  false;
            conobj.PED_ClausolaLegaleB__c=false;
            conobj.PED_ClausolaLegaleFacoltativa__c=false;
            conobj.APP_Ultimo_aggiornamento__c ='PED';
            conobj.App_creazione__c ='CM';
            conobj.PED_POD_Validate__c= true;
            conobj.Accountid = accobj.id;
            conobj.Ownerid = userinfo.getUserId();
            conobj.PED_email_da_confermare__c='primoliv3@testorg.com';
            conobj.PPW_PraticaInVolo__c=true;
            conobj.PPW_FlagAnagraficaCompleta__c=true;
            //conobj.Email = 'test@gmail.com';
            
            insert conobj;
            
            
            
            try{
                System.test.startTest();
                PED_CambiaEmailController.updateEmail_NEW_AS('primoliv@testorg.com');
                PED_CambiaEmailController.checkEmail_CM(conlist);
                PED_CambiaEmailController.SendEmail('Testing','Test',conobj.id,'test@gmail.com');
                
                System.test.stopTest();
            }catch(Exception e){
                
            }    
        }
        
    }
    
    public static testmethod void testUpdateEmail_NEW_AS3(){  
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1]; 
        UserRole ur = [select developername, name, id from userRole where developername = 'Back_Office' limit 1];
        
        User u = new User(UserRoleId = ur.Id,Alias = 'pliv', Email='primoliv@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='primoliv3@testorg.com');
        insert u;
        system.runas(u){
            
            List<Account> acclist = new List<Account>();   
            Account accobj = new Account();
            accobj.Name= 'test';
            
            accobj.PartitaIVA__c = '';
            accobj.CodiceFiscale__c = '04731870657';
            accobj.Nazionalita__c='Afgana';
            accobj.Email__c  = 'marco@gmail.com';
            
            
            insert accobj;
            
            List<Contact> conlist = new List<Contact>();
            contact conobj = new Contact();
            conobj.LastName = 'test';
            conobj.Email='primoliv@testorg.com';
            conobj.PED_email_da_confermare__c = 'primoliv@testorg.com';
            conobj.Accountid = accobj.id;
            conobj.Ownerid = userinfo.getUserId();
            conobj.Codice_Fiscale__c='TSTTST80A01H501G';
            conobj.LastName='test'; 
            conobj.FirstName='test';
            
            
            insert conobj;
            conlist.add(conobj);
            
            
            Profile p1 = [SELECT Id FROM Profile WHERE Name='PED Customer Community Login User' limit 1];  //PED Partner Community User  
            //  UserRole ur1 = [select developername, name, id from userRole where developername = 'testDataPartnerUser' limit 1];
            
            User u1 = new User(Alias = 'pliv', Email='primoliv@testorg.com', 
                               EmailEncodingKey='UTF-8',FirstName='Test', LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p1.Id, contactid=conobj.id,
                               TimeZoneSidKey='America/Los_Angeles', UserName='testingcambiaemail@test.com');
            insert u1;
            //conobj.OwnerId = u1.id;
            conobj.Email='testingcambiaemail@test.com';
            conobj.PED_email_da_confermare__c='primoliv3@testorg.com';
            conobj.PPW_PraticaInVolo__c=true;
            conobj.PPW_FlagAnagraficaCompleta__c=true;
            update conobj;
            
            
            system.runAs(u1){  
                
                try{
                    System.test.startTest();
                    PED_CambiaEmailController.updateEmail_NEW_AS('primoliv@testorg.com');
                    PED_CambiaEmailController.checkEmail_CM(conlist);
                    
                    System.test.stopTest();
                }catch(Exception e){
                    
                }
            } 
            
        }
    }
    
    
}