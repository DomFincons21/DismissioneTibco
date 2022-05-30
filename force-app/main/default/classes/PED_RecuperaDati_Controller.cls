public without sharing class PED_RecuperaDati_Controller {
    
    @AuraEnabled
    public static string sendOtp(String contactId) {
        Contact contact = [SELECT Id, PED_MobilePhoneVerificato__c, MobilePhone FROM Contact WHERE Id =: contactId];
        return PED_RegistrationCompController.sendCodeOTP(contact.MobilePhone);   
    }

    @AuraEnabled
    public static String checkToken(String contactId, String otp) {
        Contact contact = [SELECT Id, PED_MobilePhoneVerificato__c, MobilePhone FROM Contact WHERE Id =: contactId];
        return PED_RegistrationCompController.checkOTPApex(contact.MobilePhone, otp); 
    }  
   
    @AuraEnabled
    public Static List<String> getNazionalityopts(){
        return PED_RegistrationCompController.getNazionalityopts();
    }
   
    @AuraEnabled
    public static string modifyUsernamePersonaFisica(Contact usrcontact){
        //username += '.pc';
        Datetime yestDate = Datetime.now().addHours(-24);
        if(Test.isRunningTest()) {
            yestDate = yestDate.addDays(2);
        }
        List<User> usersList = [SELECT Id, ContactId, LastPasswordChangeDate FROM User WHERE contact.PED_Nazionalit__c =: usrcontact.PED_Nazionalit__c AND contact.Codice_Fiscale__c =: usrcontact.Codice_Fiscale__c AND isActive = true AND contactId != null AND LastPasswordChangeDate <: yestDate LIMIT 1];
        if(!usersList.isEmpty()){
            User u = usersList[0];
            Contact contact = [SELECT Id, PED_MobilePhoneVerificato__c, MobilePhone FROM Contact WHERE Id =: u.ContactId];
            if(contact.PED_MobilePhoneVerificato__c){
                String token = PED_RegistrationCompController.getUniqueIdNumeric(5);
                String status = PED_EnotifyController.callValidateSMS(contact.MobilePhone, token);
                if(status == Label.PED_OK){                
                    PED_OTP__c Otp = new PED_OTP__c();
                    Otp.PED_CodiceOTP__c = token;
                    Otp.PED_Telefono__c = contact.MobilePhone;
                    Otp.PED_DateValidate__c = null;
                    upsert Otp PED_Telefono__c; 
                    //return contact.Id + '||' + encrypt(contact.MobilePhone);
                    return contact.Id + '||' + contact.MobilePhone.substring(0,contact.MobilePhone.length()-5) + '*****';
                }
                else
                    return 'ErrorEnotify||';
            }
            else{
                string fileUrl = PED_URLs__c.getInstance('ModuloCellulare').PED_URLVal__c;        
                return 'KO||' + fileUrl;
            }
        }
        else
            return '24Hours||';
    }
   
    @AuraEnabled
    public static string recoveryUsernamePersonaGiuridica(Contact contact, Account account, String sedeLegale){
        string usernameOsc = '';
        string email = '';
        //MB Enti
        List<Account> acc = [SELECT Id FROM Account WHERE Nazionalita__c =: sedeLegale AND PartitaIVA__c =: account.PartitaIVA__c AND CodiceFiscale__c =: account.CodiceFiscale__c AND RecordType.Name = 'Persona Giuridica' LIMIT 1];
        //MB Enti
        /*
        if(account.PED_IsEnte__c)
            acc = [SELECT Id FROM Account WHERE Nazionalita__c =: sedeLegale AND CodiceFiscale__c =: account.CodiceFiscale__c AND RecordType.Name='Persona Giuridica' LIMIT 1];
        else
            acc = [SELECT Id FROM Account WHERE Nazionalita__c =: sedeLegale AND PartitaIVA__c =: account.PartitaIVA__c AND RecordType.Name='Persona Giuridica' LIMIT 1];
        */
        if(acc.size() > 0){
            List<Contact> contacts = [SELECT Id FROM Contact WHERE FirstName =: contact.FirstName AND LastName =: contact.LastName AND Codice_Fiscale__c =: contact.Codice_Fiscale__c AND AccountId =: acc[0].Id];
            List<id> idContacts = new List<id>();
            for(Contact c : contacts)
                idContacts.add(c.id);
            
            List<User> u = [SELECT Id, Username FROM User WHERE ContactId IN: idContacts AND isActive = true];
            if(u.size() > 0){
                email = u[0].Username.removeEnd('.pc');
                usernameOsc = email.substring(0,5) + '*******' + email.substring(email.indexOf('@'));
                //return 'OK||' + encrypt(u[0].Username.removeEnd('.pc'));
                return 'OK||' + usernameOsc;
            }
            else
                return 'KO';
        }
        else
            return 'KO';
    }
    
    @AuraEnabled
    public static string recoveryUsernamePersonaFisica(Contact contact){
        string usernameOsc = '';
        string email = '';
        List<Contact> contacts = [SELECT Id FROM Contact WHERE PED_Nazionalit__c =: contact.PED_Nazionalit__c AND Codice_Fiscale__c =: contact.Codice_Fiscale__c  AND Account.RecordType.Name = 'Persona Fisica'];
        List<id> idContacts = new List<id>();
        for(Contact c : contacts) 
            idContacts.add(c.id);
        //CB aggiunta nome per persona fisica che chiede la username
        List<User> u = [SELECT Id, Username, Contact.FirstName, Contact.LastName FROM User WHERE ContactId IN: idContacts AND isActive = true AND contactId != null];
        if(u.size()>0){
            //return 'OK||' + encrypt(u[0].Username.removeEnd('.pc')) + '||' + u[0].Contact.FirstName + '||' + u[0].Contact.LastName;
            email = u[0].Username.removeEnd('.pc');
            usernameOsc = email.substring(0,5) + '*******' + email.substring(email.indexOf('@'));
            return 'OK||' + usernameOsc + '||' + u[0].Contact.FirstName + '||' + u[0].Contact.LastName;
        }
        else
            return 'KO';
    }
    
    @AuraEnabled
    public static string recoveryPassword(String email){
        try{
            email += '.pc';
            User usr;
            List<User> u = [SELECT Id, FirstName, ContactId, Email, LastName, LastPasswordChangeDate, Username FROM User WHERE Username =: email AND isActive = true AND ContactId != null];
            if(u.size() == 0)
                return 'NO_USER';
            else{
                usr = u[0];
                Datetime startDate = system.now();
                Datetime endDate = usr.LastPasswordChangeDate;
                //MB Fix Cambio Password
                if(endDate != null){
                    decimal minutes = (startDate.getTime() - decimal.valueOf(endDate.getTime()))/1000/60;
                    if(minutes <= 1440)
                        return 'NO_CHANGE';
                }
            } 
            PED_RecuperaDati_Controller.sendOtpEmail(usr);
        }
        catch(Exception e){
            return e.getStackTraceString();
        }
        return 'OK';
    }
   
    @AuraEnabled
    public static string checkOTP(String otpToken, String email){
        email += '.pc';
        DateTime scadenzaOtp = DateTime.now();
        Integer OTPMinuti = Integer.valueOf(Label.PED_ScadenzaOTP);
        scadenzaOtp = scadenzaOtp.addMinutes((-1) * OTPMinuti);
        List<PED_OTP__c> otp = [SELECT Id FROM PED_OTP__c WHERE PED_Email__c =: email AND PED_CodiceOTP__c =: otpToken AND LastModifiedDate >=: scadenzaOtp];
        if(otp.size() > 0){                
            for(PED_OTP__c o : otp)
                o.PED_DateValidate__c = DateTime.now();
            update otp;
            return 'OK';
        }
        else
            return 'KO'; 
    }
   
    public static void sendOtpEmail(User uObj){  
        string emailTemplateDevName = 'PED_OTPEmail';
        string otpCode = PED_RegistrationCompController.getUniqueIdNumeric(5);
        EmailTemplate et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName =: emailTemplateDevName LIMIT 1];
        String subject = et.Subject;
        String htmlBody = et.HtmlValue;
        htmlBody = htmlBody.replace('{!OTPCODE}', otpCode);
        htmlBody = htmlBody.replace('{!SCADENZA_OTP}', Label.PED_ScadenzaOTP);
        OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'no-reply@e-distribuzione.com'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(owea.size() > 0 )
            mail.setOrgWideEmailAddressId(owea[0].Id);
        mail.setTemplateId(et.id);
        mail.setSaveAsActivity(false);
        mail.setSubject(subject);
        mail.setHtmlBody(htmlBody);
        mail.setTargetObjectId(uObj.Id);
        string em = uObj.Username.removeEnd('.pc');
        List<String> address = new List<String>();
        address.add(em);
        mail.setToAddresses(address);
        if(!Test.isRunningTest())
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        PED_OTP__c otp = new PED_OTP__c();
        otp.PED_CodiceOTP__c = otpCode;
        otp.PED_Email__c = uObj.Username;
        otp.PED_DateValidate__c = null;
        upsert otp PED_Email__c; 
    }
        
    @AuraEnabled
    public static string recoveryPasswordFromUsername(String email, /*String oldEmail,*/ String idContact){
        try{
            if(PED_CheckBlacklistedEmail.checkBlacklistedEmail(email))
                return 'blacklistedEmail';
            if(PED_CheckBlacklistedEmail.checkBlacklistedSpecifiedEmail(email))
                return 'blacklistedAddressEmail';
            //oldEmail += '.pc';
            email += '.pc';
            User usr;
            List<User> u = [SELECT Id, FirstName, ContactId, Email, LastName, LastPasswordChangeDate, Username FROM User WHERE /*Username =: oldEmail AND */isActive = true AND ContactId =: idContact];
            List<User> u2 = [SELECT Id, FirstName, ContactId, Email, LastName, LastPasswordChangeDate, Username FROM User WHERE Username =: email AND isActive = true];
            if(u2.size() > 0)
                return 'ERROR_EMAIL';
            else{
                usr = u[0];
                usr.Username = email;
                PED_RecuperaDati_Controller.sendOtpEmail(usr);
            }             
        }
        catch(Exception e){
            return e.getStackTraceString();
        }
        return 'OK';
    }
    
    @AuraEnabled
    public static string updateUser(String email, /*String oldEmail*/String contactId){
        try{
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Giuridica').getRecordTypeId();
            Id personaFisicaRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Fisica').getRecordTypeId();

            //String username = oldEmail+'.pc';
            User usr= [SELECT Id, Email, Username, AccountId, ContactId FROM User WHERE /*Username =: username*/isActive = true AND ContactId =: contactId LIMIT 1];  
            usr.Email = email;
            usr.Username = email + '.pc';
            update usr;
            
            contact con = [
                SELECT Id, Email, PED_email_da_confermare__c, PED_Sottoscrizione_e_notify__c, FirstName, LastName, Account.Name, Account.CodiceFiscale__c, 
                    Account.PartitaIVA__c, Account.PED_IsEnte__c, PED_MobilePhoneVerificato__c, MobilePhone, PED_ContattoTelegram__c, PED_Contatto_Preferito__c,
                    Account.RecordTypeId
                FROM Contact 
                WHERE Id =: usr.ContactId];
            
            PED_ConfermaEmailCTRL.updateContactEmail(email, con.Id);
            Account accountcurrentUser = [SELECT Id, Name, Email__c, RecordTypeId FROM Account WHERE Id =: usr.AccountId];
            RecordType recordtype = [SELECT Id, Name FROM RecordType WHERE Id =: accountcurrentUser.RecordTypeId];
            
            if(con.PED_Sottoscrizione_e_notify__c){
                //PED_ConfermaEmailCTRL.upsertUserInfo(usr.Id, con.FirstName, con.LastName, con.Account.Name, con.Account.CodiceFiscale__c, con.Account.PartitaIVA__c, con.PED_Contatto_Preferito__C, con.MobilePhone, con.PED_ContattoTelegram__c, email, con.Account.PED_IsEnte__c, con.PED_MobilePhoneVerificato__c);
                //DOM gestione ente
                if(con.Account.RecordTypeId.equals(personaFisicaRecTypeId)){
                    System.debug('******persona fisica******');
                    PED_ConfermaEmailCTRL.upsertUserInfo(usr.Id,con.firstName,con.lastName,con.account.name,con.account.CodiceFiscale__c,con.account.PartitaIVA__c,'',con.mobilePhone,con.PED_ContattoTelegram__c,email, con.PED_MobilePhoneVerificato__c, true);
                } else {
                    if(con.Account.RecordTypeId.equals(devRecordTypeId)){
                        if(con.account.PED_IsEnte__c){
                            System.debug('******persona giuridica ente******');
                            PED_ConfermaEmailCTRL.upsertUserInfo(usr.Id,con.FirstName, con.LastName, con.account.name, con.account.CodiceFiscale__c, '' ,'', con.mobilePhone,con.PED_ContattoTelegram__c,email,con.PED_MobilePhoneVerificato__c, true);
                        } else {
                            System.debug('******persona giuridica NON ente******');
                            PED_ConfermaEmailCTRL.upsertUserInfo(usr.Id,con.FirstName, con.LastName, con.account.name, '', con.account.PartitaIVA__c,'', con.mobilePhone,con.PED_ContattoTelegram__c,email,con.PED_MobilePhoneVerificato__c, true);
                        }
                    } 
                }
            }
            if((recordtype.Name) == 'Persona Fisica')
                PED_ConfermaEmailCTRL.updateAccountEmail(email,usr.AccountId);
        }
        catch(Exception e){
            return e.getStackTraceString();
        }
        return 'OK';
    }

}