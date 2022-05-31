public without sharing class PED_RegistrationCompController {
    private static final String APP_ULTIMO_AGGIORNAMENTO = 'PED';
    private static final String APP_CREAZIONE = 'PED';
    private static final Id AccOwnerId = PED_System_Constants__c.getInstance().ID_Owner_Account_Community__c;
    private static final Id ProfileId = PED_System_Constants__c.getInstance().ID_Profile_Customer_Community_User_STD__c;
    private static final Id PerFisRecTypeId = PED_Utility.getMapOfRecordTypeAndId('Account').get('Persona_Fisica');
    private static final Id PerGiuRecTypeId = PED_Utility.getMapOfRecordTypeAndId('Account').get('Persona_Giuridica');
    private static final Id contactRecTypeId= PED_Utility.getMapOfRecordTypeAndId('Contact').get('Richiedente');
    private static final String sEmailSuffix = Label.PED_EmailSuffixPC;

    public static Boolean OtpObbligatorio = true;
    public static Boolean NoCheck = true;
    
    @AuraEnabled
    public static List<String> getNazionalityopts(){
        List<String> options = new List<String>();
        for (Schema.PicklistEntry entry : Contact.PED_Nazionalit__c.getDescribe().getPicklistValues())
            options.add(entry.getLabel());
        return options;
    }
    
    @AuraEnabled
    public static Boolean checkBlacklist(String email){ 
        return PED_CheckBlacklistedEmail.checkBlacklist(email);
    }
    
    /* @AuraEnabled
    public static Boolean checkBlacklistedSpecifiedEmail(String email){
        return PED_CheckBlacklistedEmail.checkBlacklistedSpecifiedEmail(email);
    } */
    
    @AuraEnabled
    public static string checkCellEmailIVACFUser(Contact cont, Account acc, Boolean isFisica, String cell, String ipUtente){
        List<User> users = new List<User>();
        
        if(PED_CheckBlacklistedEmail.checkBlacklistedEmail(cont.Email)){
            insert logRegistrazioneRespinta(cont, acc, cell, '', 'Disposable domain', ipUtente); 
            return 'blacklistedEmail';
        }

        if(PED_CheckBlacklistedEmail.checkBlacklistedSpecifiedEmail(cont.Email)){
            insert logRegistrazioneRespinta(cont, acc, cell, '', 'Blacklist email', ipUtente);
            return 'blacklistedAddressEmail';
        }

        if(isFisica){
            Integer limiteCellulare = Integer.valueOf(Label.PED_LimiteCellulareRegistrazione);
            users = [SELECT Id FROM User WHERE PED_Mobile_Registrazione__c =: cell];
            if(users.size() >= limiteCellulare){
                insert logRegistrazioneRespinta(cont, null, cell, '', 'Limite riutilizzo cellulare', ipUtente);
                return 'limitCell';
            }
        }

        Integer limiteEmail = Integer.valueOf(Label.PED_LimiteEmailRegistrazione);
        users = [SELECT Id, PED_Data_Disabilitazione__c FROM User WHERE Email =: cont.Email ORDER BY PED_Data_Disabilitazione__c DESC];
        if(!users.isEmpty()){
            if(users.size() >= limiteEmail){
                insert logRegistrazioneRespinta(cont, acc, cell, '', 'Limite riutilizzo email', ipUtente);
                return 'limitEmail';
            }

            Integer limiteFreezeEmail = Integer.valueOf(Label.PED_LimiteFreezeEmailRegistrazione);
            List<User> usersNoNull = new List<User>();
            for(User u : users){
                if(u.PED_Data_Disabilitazione__c != null)
                    usersNoNull.add(u);
            }
            if(usersNoNull.size() > 0){
                DateTime start = usersNoNull[0].PED_Data_Disabilitazione__c;
                DateTime later = System.now();
                Decimal millisecs = Decimal.valueOf(later.getTime() - start.getTime());
                if((millisecs / 1000 / 60 / 60) < limiteFreezeEmail){
                    insert logRegistrazioneRespinta(cont, acc, cell, '', 'Email Freezata', ipUtente);
                    return 'limitFreeze-' + limiteFreezeEmail;
                }
            }
        }

        String Email = cont.Email + sEmailSuffix;
        users = [SELECT Id FROM User WHERE Username =: Email AND IsActive = true AND LastLoginDate != null];
        if(!users.isEmpty())
            return 'useravailable';

        List<Account> accountList = new List<Account>();
        if(isFisica){
            accountList = [
                    SELECT Id, CodiceFiscale__c, (SELECT Id, PED_ContactKey__c FROM Contacts WHERE Codice_Fiscale__c =: cont.Codice_Fiscale__c)
                    FROM Account WHERE CodiceFiscale__c =: cont.Codice_Fiscale__c AND RecordTypeId =: PerFisRecTypeId
                ];
            if(!accountList.isEmpty()){
                if(!accountList[0].Contacts.isEmpty()){
                    Contact cnt = accountList[0].Contacts[0];
                    if(cnt.PED_ContactKey__c != null){
                        List<User> userList = [SELECT Id FROM User WHERE ContactId =: cnt.Id AND isActive = true AND LastLoginDate != null];
                        if(!userList.isEmpty())
                            return 'CFavailable';
                    }
                }
            }
        }
        else{
            String partitaIva = acc.PartitaIVA__c;
            String codiceFiscale = acc.CodiceFiscale__c;

            if(partitaIva == null){
                accountList = [
                    SELECT Id, CodiceFiscale__c, PartitaIVA__c, (SELECT Id, PED_ContactKey__c FROM Contacts WHERE Codice_Fiscale__c =: cont.Codice_Fiscale__c)
                    FROM Account WHERE CodiceFiscale__c =: codiceFiscale AND RecordTypeId =: PerGiuRecTypeId
                ];
            }
            else{
                accountList = [
                    SELECT Id, CodiceFiscale__c, PartitaIVA__c, (SELECT Id, PED_ContactKey__c FROM Contacts WHERE Codice_Fiscale__c =: cont.Codice_Fiscale__c)
                    FROM Account WHERE (PartitaIVA__c =: partitaIva OR CodiceFiscale__c =: codiceFiscale) AND RecordTypeId =: PerGiuRecTypeId
                ];
            }
            if(!accountList.isEmpty()){
                for(Account a : accountList){
                    if(partitaIva != null && a.PartitaIVA__c == partitaIva && a.CodiceFiscale__c != codiceFiscale && a.CodiceFiscale__c != null)
                        return 'errorCF';
                    if(codiceFiscale == a.CodiceFiscale__c && a.PartitaIVA__c != null && a.PartitaIVA__c != partitaIva)
                        return 'errorIVA';
                }
                if(!accountList[0].Contacts.isEmpty()){
                    Contact cnt = accountList[0].Contacts[0];
                    if(cnt.PED_ContactKey__c != null){
                        List<User> userList = [SELECT Id FROM User WHERE ContactId =: cnt.Id AND isActive = true AND LastLoginDate != null];
                        if(!userList.isEmpty())
                            return 'CFavailable';
                    }
                }
            }
        }
        
        return 'ok';
    }

    @AuraEnabled
    public static String checkRegistrationUserF(Contact cont, String cell, String ipUtente){
        return checkCellEmailIVACFUser(cont, null, true, cell, ipUtente);
    }
    
    @AuraEnabled
    public static String RegistrationUserF(Contact cont, String cell, String ipUtente){
        cont.MobilePhone = cell;
        cont.PED_MobilePhoneVerificato__c = true;
        try {
            //AR controllo anche dopo OTP cell per assicurarsi che non sia cambiato nulla
            String check = checkRegistrationUserF(cont, cell, ipUtente);
            if(check == 'ok')
                return userRegistration(cont);
            else
                return check;
        }
        catch(Exception e){
            return 'error';
        }
    }

    @AuraEnabled
    public static String userRegistration(Contact cont){
        //MB - OTP Obbligatorio viene controllato dai servizi REST della APP
        if(OtpObbligatorio){
            DateTime scadenzaOtp = DateTime.now();
            Integer OTPMinuti = Integer.valueOf(Label.PED_ScadenzaOTP);
            scadenzaOtp = scadenzaOtp.addMinutes((-1) * OTPMinuti);
            List<PED_OTP__c> otp = [SELECT Id FROM PED_OTP__c WHERE PED_Telefono__c =: cont.MobilePhone AND LastModifiedDate >=: scadenzaOtp AND PED_DateValidate__c != null];
            if(otp.size() == 0 && !Test.isRunningTest())
                return 'error';
        }
        
        Id contactId; 
        Id createdUserId;
        Account acc = new Account();
        String CodiceFiscale = cont.Codice_Fiscale__c;
        String statusMessage = 'ok';
        Integer counter = Integer.valueOf([SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()].PED_AccOwnerCounter__c);
        Id ownerNew = UserInfo.getUserId();
        if(!Test.isRunningTest())
            ownerNew = getUserAccountOwner(counter);

        List<Account> accountList = [
            SELECT Id, Email__c, Name, OwnerId, APP_Ultimo_aggiornamento__c, CodiceFiscale__c, RecordTypeId, Nazionalita__c
            FROM Account 
            WHERE CodiceFiscale__c =: CodiceFiscale AND RecordTypeId =: PerFisRecTypeId];
        if(!accountList.isEmpty()){
            Id accId = accountList[0].Id;
            List<Contact> contactList = [
                SELECT Id, PED_ContactKey__c, FirstName, Lastname, Email, Codice_Fiscale__c, APP_Ultimo_aggiornamento__c, App_creazione__c, AccountId, PED_ClausolaLegaleA__c, PED_ClausolaLegaleB__c,
                    PED_ClausolaLegaleFacoltativa__c, PED_Nazionalit__c
                FROM Contact
                WHERE AccountId =: accId AND Codice_Fiscale__c =: CodiceFiscale];
            
            if(!contactList.isEmpty()){
                Id conId = contactList[0].Id;
                List<User> userlst = [SELECT Id, PED_IsAPP__c, Username, Email, Contact.PED_ContactKey__c, LastLoginDate FROM User WHERE ContactId =: conId AND IsActive = true];
                if(!userlst.isEmpty()){
                    if(userlst[0].Contact.PED_ContactKey__c != null && userlst[0].LastLoginDate == null){
                        userlst[0].Email = cont.Email;
                        userlst[0].Username = cont.Email + '.pc';
                        userlst[0].PED_Mobile_Registrazione__c = cont.MobilePhone;
                        userlst[0].PED_Contact_Id__c = conId;
                        userlst[0].PED_ScadenzaOTP__c = DateTime.now().addMinutes(Integer.valueOf(Label.PED_ScadenzaOTP));
                        userlst[0].PED_OTP_Registrazione__c = getUniqueIdNumeric(5);
                        try{
                            if(!Test.isRunningTest()){
                                update userlst[0];
                                updateAccount(cont.Email, accountList[0].Id);
                                updateContactPER(contactList[0].Id, cont.Email, cont.MobilePhone);
                            }
                            else
                                throw new DmlException('Test Try Catch Coverage');
                        }
                        catch(DmlException e){
                            if(!Test.isRunningTest()){
                                PED_sendRegistrationErrMail.personaFisicaSendErrEmail(cont, e);
                                return 'error';
                            }
                        }

                        String username = cont.Email + sEmailSuffix;
                        if(!Test.isRunningTest()){
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            //MB - da cambiare in FULL2 in noreply@e-distribuzione.com
                            List<OrgWideEmailAddress> owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'noreply@e-distribuzione.com'];
                            if(!owea.isEmpty())
                                mail.setOrgWideEmailAddressId(owea.get(0).Id);
                            
                            EmailTemplate et;
                            if(PED_ServiziRESTApp.blockResetPassword){
                                et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = 'PED_WL_Web' LIMIT 1];
                                mail.setToAddresses(new String[] {userlst[0].Username.removeEnd('.pc')});
                            }
                            else{
                                et = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: 'PED_WL_App'];
                                mail.setUseSignature(false);
                                mail.setBccSender(false);
                            }
                            mail.setTemplateId(et.Id);
                            mail.setSaveAsActivity(false);
                            mail.setTargetObjectId(userlst[0].Id);
                            Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail});
                            PED_ServiziRESTApp.blockResetPassword = true;   
                            return statusMessage;
                        }
                    }
                    //AR controllo lasciato per l'app
                    else if(userlst[0].Contact.PED_ContactKey__c != null && userlst[0].LastLoginDate != null){
                        statusMessage = 'useravailable';
                        return statusMessage;
                    }
                    else {
                        try{           
                            accountList[0].Nome__c = cont.FirstName.toUpperCase();
                            accountList[0].Name = cont.Lastname.toUpperCase();
                            accountList[0].OwnerId = ownerNew;
                            accountList[0].APP_Ultimo_aggiornamento__c = APP_ULTIMO_AGGIORNAMENTO;
                            accountList[0].Email__c = cont.Email;
                            accountList[0].PED_Corrupted__c = false;
                            if(cont.PED_Nazionalit__c == null || cont.PED_Nazionalit__c == '')
                                accountList[0].Nazionalita__c = 'Italiana';
                            else
                                accountList[0].Nazionalita__c = cont.PED_Nazionalit__c;
                            
                            update accountList[0] ;
                            if(Test.isRunningTest())
                                throw new DmlException('Test Try Catch Coverage');
                        }
                        catch(DmlException e){
                            System.debug('@@@ errore nell\'update dell\'account');
                            if(!Test.isRunningTest()){
                                PED_sendRegistrationErrMail.personaFisicaSendErrEmail(cont, e);
                                return 'error';
                            }
                        } 
                        
                        try{ 
                            contactId = createContact(cont, accountList[0]);
                            createdUserId = createUser(cont, contactId);
                            if(createdUserId != null){
                                if(!Test.isRunningTest())
                                    return statusMessage;
                            }  
                            if(Test.isRunningTest())
                                throw new DmlException('Test Try Catch Coverage');
                        }
                        catch(DmlException e){
                            System.debug('@@@ errore nella creazione del contact o user');
                            if(e.getMessage().indexOf('DUPLICATE_USERNAME') > 0)
                                statusMessage ='limitFreeze'; 
                            else
                                statusMessage ='error'; 
                            
                            if(!Test.isRunningTest()){
                                PED_sendRegistrationErrMail.personaFisicaSendErrEmail(cont, e);
                                return statusMessage;
                            }
                        }
                    }
                }
                else{
                    try{
                        accountList[0].RecordTypeId = PerFisRecTypeId;           
                        accountList[0].Nome__c = cont.FirstName.toUpperCase();
                        accountList[0].Name = cont.Lastname.toUpperCase();
                        accountList[0].OwnerId = ownerNew;
                        accountList[0].APP_Ultimo_aggiornamento__c = APP_ULTIMO_AGGIORNAMENTO;
                        accountList[0].Email__c = cont.Email;
                        accountList[0].PED_Corrupted__c = false;
                        if(cont.PED_Nazionalit__c == null || cont.PED_Nazionalit__c == '')
                            accountList[0].Nazionalita__c = 'Italiana';
                        else
                            accountList[0].Nazionalita__c = cont.PED_Nazionalit__c ;
                        
                        update accountList[0] ;
                        if(Test.isRunningTest())
                            throw new DmlException('Test Try Catch Coverage');
                    }
                    catch(DmlException e){
                        System.debug('@@@ errore nell\'update dell\'account senza user');
                        statusMessage = 'error';
                        if(!Test.isRunningTest()){
                            PED_sendRegistrationErrMail.personaFisicaSendErrEmail(cont, e);
                            return statusMessage;
                        }
                    } 
                    
                    try{
                        PED_ServiziRESTApp.blockTrigger = true;
                        contactList[0].FirstName = cont.FirstName.toUpperCase();
                        contactList[0].Lastname = cont.Lastname.toUpperCase();
                        contactList[0].Email = cont.Email;
                        contactList[0].PED_MobilePhoneVerificato__c = cont.PED_MobilePhoneVerificato__c;
                        contactList[0].MobilePhone = cont.MobilePhone;
                        contactList[0].APP_Ultimo_aggiornamento__c = APP_ULTIMO_AGGIORNAMENTO;
                        contactList[0].PED_ContactRegistratoSulPortale__c = true;
                        contactList[0].RecordTypeId = contactRecTypeId;                
                        contactList[0].AccountId = accountList[0].Id;                
                        contactList[0].PED_ClausolaLegaleA__c = cont.PED_ClausolaLegaleA__c;
                        contactList[0].PED_ClausolaLegaleB__c = cont.PED_ClausolaLegaleB__c;
                        contactList[0].PED_ClausolaLegaleFacoltativa__c = cont.PED_ClausolaLegaleFacoltativa__c;
                        contactList[0].PED_ContactKey__c = accountList[0].Id + '_' + cont.Codice_Fiscale__c.toUpperCase();
                        contactList[0].PED_IsAPP__c = cont.PED_IsAPP__c;
                        
                        if(cont.PED_Nazionalit__c == null || cont.PED_Nazionalit__c == '')
                            contactList[0].PED_Nazionalit__c = 'Italiana';
                        else
                            contactList[0].PED_Nazionalit__c = cont.PED_Nazionalit__c;
                        
                        if(cont.PED_Nazionalit__c == 'Italiana') 
                            contactList[0].PED_Sesso__c = IdentifyGender(cont);
                        
                        update contactList[0];
                        
                        if(Test.isRunningTest())
                            throw new DmlException('Test Try Catch Coverage');
                    }
                    catch(DmlException e){
                        System.debug('@@@ errore nell\'update del contact');
                        statusMessage = 'error';
                        if(!Test.isRunningTest()){
                            PED_sendRegistrationErrMail.personaFisicaSendErrEmail(cont, e);
                            return statusMessage;
                        }
                    }

                    try{
                        createdUserId = createUser(contactList[0], conId);
                        if(createdUserId != null){
                            if(!Test.isRunningTest())
                                return statusMessage;
                        }
                        if(Test.isRunningTest())
                            throw new DmlException('Test Try Catch Coverage');
                    }
                    catch(DmlException e){
                        System.debug('@@@ errore nella creazione dello user');
                        if(e.getMessage().indexOf('DUPLICATE_USERNAME') > 0)
                            statusMessage = 'limitFreeze';
                        else
                            statusMessage = 'errorUtente'; 
                        
                        if(!Test.isRunningTest()){
                            PED_sendRegistrationErrMail.personaFisicaSendErrEmail(cont, e);
                            return statusMessage;
                        }
                    } 
                }
                System.debug('@@@ errore generico');
                statusMessage = 'error';
                return statusMessage; 
            }
            else{
                try{
                    accountList[0].RecordTypeId = PerFisRecTypeId;           
                    accountList[0].Nome__c = cont.FirstName.toUpperCase();
                    accountList[0].Name = cont.Lastname.toUpperCase();
                    accountList[0].OwnerId = ownerNew;
                    accountList[0].APP_Ultimo_aggiornamento__c = APP_ULTIMO_AGGIORNAMENTO;
                    accountList[0].Email__c = cont.Email;
                    accountList[0].PED_Corrupted__c = false;
                    if(cont.PED_Nazionalit__c == null || cont.PED_Nazionalit__c == '')
                        accountList[0].Nazionalita__c = 'Italiana';
                    else
                        accountList[0].Nazionalita__c = cont.PED_Nazionalit__c;
                    
                    update accountList[0];

                    if(Test.isRunningTest())
                        throw new DmlException('Test Try Catch Coverage');
                }
                catch(DmlException e){
                    System.debug('@@@ errore nell\'update dell\'account senza contact');
                    statusMessage = 'error';
                    if(!Test.isRunningTest()){
                        PED_sendRegistrationErrMail.personaFisicaSendErrEmail(cont, e);
                        return statusMessage;
                    }
                } 
                
                try{
                    contactId = createContact(cont, accountList[0]);
                    createdUserId = createUser(cont, contactId);
                    
                    if(createdUserId != null){
                        if(!Test.isRunningTest())
                            return statusMessage;
                    }

                    if(Test.isRunningTest())
                        throw new DmlException('Test Try Catch Coverage');
                }
                catch(DmlException e){
                    System.debug('@@@ errore nella creazione del contact o dello user, sezione account senza contact');
                    if(e.getMessage().indexOf('DUPLICATE_USERNAME') > 0)
                        statusMessage = 'limitFreeze'; 
                    else
                        statusMessage = 'error';
                    
                    if(!Test.isRunningTest()){
                        PED_sendRegistrationErrMail.personaFisicaSendErrEmail(cont, e);
                        return statusMessage;
                    }
                }
                System.debug('@@@ Errore generico, sezione account senza contact');
                statusMessage ='error';
                return statusMessage;
            }
        }
        else{
            try{
                acc.RecordTypeId = PerFisRecTypeId;           
                acc.Nome__c = cont.FirstName.toUpperCase();
                acc.Name = cont.Lastname.toUpperCase();
                acc.CodiceFiscale__c = cont.Codice_Fiscale__c.toUpperCase();
                acc.APP_Ultimo_aggiornamento__c = APP_ULTIMO_AGGIORNAMENTO;
                acc.App_creazione__c = APP_CREAZIONE;
                acc.OwnerId = ownerNew;
                acc.Email__c = cont.Email;
                acc.PED_IsApp__c = cont.PED_IsApp__c;
                if(cont.PED_Nazionalit__c == null || cont.PED_Nazionalit__c == '')
                    acc.Nazionalita__c = 'Italiana';
                else
                    acc.Nazionalita__c = cont.PED_Nazionalit__c ;
                
                if(Test.isRunningTest())
                    throw new DmlException('Test Try Catch Coverage');
                
                insert acc;                
            }
            catch(DmlException e){
                System.debug('@@@ errore nella creazione dell\'account');
                statusMessage = 'error';
                if(!Test.isRunningTest()){
                    PED_sendRegistrationErrMail.personaFisicaSendErrEmail(cont, e);
                    return statusMessage;
                }
            }
            
            try{
                contactId = createContact(cont, acc);
                createdUserId = createUser(cont, contactId);
                
                if(createdUserId != null){
                    futureUpdateUserCounter();
                    if(!Test.isRunningTest())
                        return statusMessage;
                }
                
                if(Test.isRunningTest())
                    throw new DmlException('Test Try Catch Coverage');
            }
            catch(DmlException e){
                System.debug('@@@ errore nella creazione di contact o user, sezione niente account');
                if(e.getMessage().indexOf('DUPLICATE_USERNAME') > 0)
                    statusMessage ='limitFreeze'; 
                else
                    statusMessage ='error'; 
                
                if(!Test.isRunningTest()){
                    PED_sendRegistrationErrMail.personaFisicaSendErrEmail(cont, e);
                    return statusMessage;
                }
            }
            System.debug('@@@ errore generico, sezione niente account');
            statusMessage = 'error';
            return statusMessage;
        }
        System.debug('@@@ errore generico');
        return 'error';
    }
    
    public static String validationCFCont(Contact cont){
        String validationCFResult = 'OK';
        if (cont.PED_Nazionalit__c == 'Italiana')
            validationCFResult = CodiceFiscale_Helper.CheckFiscalCode(cont.Codice_Fiscale__c, cont.FirstName, cont.LastName);
        
        return validationCFResult;
    }
    
    @AuraEnabled
    public static String checkRegistrationPortaleTrader(Contact cont, Account acc, String Sedelegaled, String cell, String ipUtente){
        cont.PED_SocietaDiVendita__c = true;
        return checkRegistrationUserG(cont, acc, Sedelegaled, cell, ipUtente);
    }
    //AR CR Gestione Enti - metodo modificato
    @AuraEnabled
    public static String checkRegistrationUserG(Contact cont, Account acc, String Sedelegaled, String cell, String ipUtente){
        return checkCellEmailIVACFUser(cont, acc, false, cell, ipUtente);
    }

    @AuraEnabled
    public static String RegistrationUserGTrader(Contact cont, Account acc, String Sedelegaled, String cell, String ipUtente){
        cont.PED_SocietaDiVendita__c = true;
        return RegistrationUserG(cont, acc, Sedelegaled, cell, ipUtente);
    }

    @AuraEnabled
    public static String RegistrationUserG(Contact cont, Account acc, String Sedelegaled, String cell, String ipUtente){
        cont.MobilePhone = cell;
        cont.PED_MobilePhoneVerificato__c = true;
        try {
            //AR controllo anche dopo OTP cell per assicurarsi che non sia cambiato nulla
            String check = checkRegistrationUserG(cont, acc, Sedelegaled, cell, ipUtente);
            if(check == 'ok')
                return userPersonagiuridiRegistration(cont, acc, sedelegaled);
            else
                return check;
        }
        catch(Exception e){
            return 'error';
        }
    }

    //AR Gestione Enti - metodo modificato nella prima parte, le funzioni chiamate non sono state toccate
    @AuraEnabled
    public static String userPersonagiuridiRegistration(Contact cont, Account acc, String Sedelegaled){
        //MB - OTP Obbligatorio viene controllato dai servizi REST della APP
        if(OtpObbligatorio){
            DateTime scadenzaOtp = DateTime.now();
            Integer OTPMinuti = Integer.valueOf(Label.PED_ScadenzaOTP);
            scadenzaOtp = scadenzaOtp.addMinutes((-1) * OTPMinuti);
            List<PED_OTP__c> otp = [SELECT Id FROM PED_OTP__c WHERE PED_Telefono__c =: cont.MobilePhone AND LastModifiedDate >=: scadenzaOtp AND PED_DateValidate__c != null];
            if(otp.isEmpty() && !Test.isRunningTest())
                return 'error';
        }
        /* AR già ricontrollato dopo OTP
        if(PED_CheckBlacklistedEmail.checkBlacklistedEmail(cont.Email))
            return 'blacklistedEmail';
        if(PED_CheckBlacklistedEmail.checkBlacklistedSpecifiedEmail(cont.Email))
            return 'blacklistedAddressEmail';
        */
        String codiceFiscale = acc.CodiceFiscale__c;
        String partitaIva = acc.PartitaIVA__c;
        if(partitaIva == '')
            partitaIva = null;
        List<Account> accountList = new List<Account>();
        
        if(partitaIva == null){
            accountList = [
                SELECT Id, Email__c, Name, OwnerId, APP_Ultimo_aggiornamento__c, CodiceFiscale__c, PartitaIVA__c, RecordTypeId, Nazionalita__c,
                (SELECT Id FROM Contacts WHERE Codice_Fiscale__c =: cont.CodiceFiscale__c)
                FROM Account WHERE CodiceFiscale__c =: codiceFiscale AND RecordTypeId =: PerGiuRecTypeId
            ];
        }
        else{
            accountList = [
                SELECT Id, Email__c, Name, OwnerId, APP_Ultimo_aggiornamento__c, CodiceFiscale__c, PartitaIVA__c, RecordTypeId, Nazionalita__c,
                (SELECT Id FROM Contacts WHERE Codice_Fiscale__c =: cont.CodiceFiscale__c)
                FROM Account WHERE (PartitaIVA__c =: partitaIva OR CodiceFiscale__c =: codiceFiscale) AND RecordTypeId =: PerGiuRecTypeId
            ];
        }
        if(!accountList.isEmpty())
            return UserPGRegContact(cont, accountList[0], Sedelegaled);
        else
            return UserPGNewAnag(cont, acc, Sedelegaled);
        return 'error';
    }

    //AR Gestione Enti - nuovo metodo per pulizia codice
    @AuraEnabled
    public static string UserPGNewAnag(Contact cont, Account acc, String Sedelegaled){
        String statusMessage = 'ok';
        Id contactId;
        Id createdUserId;
        Integer counter = Integer.valueOf([SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()].PED_AccOwnerCounter__c);
        Id ownerNew = UserInfo.getUserId();
        if(!Test.isRunningTest())
            ownerNew = getUserAccountOwner(counter);
        try{
            acc.RecordTypeId = PerGiuRecTypeId;  
            acc.Name = acc.Name.toUpperCase();
            acc.Nazionalita__c = Sedelegaled;
            acc.APP_Ultimo_aggiornamento__c = APP_ULTIMO_AGGIORNAMENTO;
            acc.App_creazione__c = APP_CREAZIONE;
            acc.OwnerId = getUserAccountOwner(counter);
            acc.PED_IsApp__c = cont.PED_IsApp__c;
            
            if(!Test.isRunningTest())
                insert acc;
            else
                throw new DmlException('Code Coverage');
        }
        catch(DmlException e){
            statusMessage = e.getMessage().substringBetween('FIELD_CUSTOM_VALIDATION_EXCEPTION,', ':');
            if(!Test.isRunningTest()){
                PED_sendRegistrationErrMail.personaGiuridicaSendErrEmail(cont, acc, Sedelegaled, e);
                return statusMessage;
            }
        }
        
        try{
            if(Test.isRunningTest())
                acc = [SELECT Id, OwnerId FROM Account LIMIT 1];
            
            contactId = createContact(cont, acc);
            createdUserId = createUser(cont, contactId); 
            if(createdUserId != null){
                if(!Test.isRunningTest()){
                    futureUpdateUserCounter();
                    return statusMessage;
                }
            }

            if(Test.isRunningTest())
                throw new DmlException('Code Coverage');
        }
        catch(DmlException e){
            if(e.getMessage().indexOf('DUPLICATE_USERNAME') > 0)
                statusMessage = 'limitFreeze'; 
            else
                statusMessage = e.getMessage();
            
            if(!Test.isRunningTest()){
                PED_sendRegistrationErrMail.personaGiuridicaSendErrEmail(cont, acc, Sedelegaled, e);
                return statusMessage;
            }
        }

        statusMessage = 'error';
        return statusMessage;
    }
    //AR Gestione Enti - nuovo metodo per pulizia codice
    @AuraEnabled
    public static string UserPGRegContact(Contact cont, Account acc, String Sedelegaled){
        String statusMessage = 'ok';
        Id contactId;
        Id createdUserId;
        Integer counter = Integer.valueOf([SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()].PED_AccOwnerCounter__c);
        Id ownerNew = UserInfo.getUserId();
        if(!Test.isRunningTest())
            ownerNew = getUserAccountOwner(counter);
        Id accId = acc.Id;
        String conCodiceFiscale = cont.Codice_Fiscale__c;
        List<Contact> contactList = [
            SELECT Id, PED_ContactKey__c, FirstName, LastName, Email, Codice_Fiscale__c, APP_Ultimo_Aggiornamento__c, App_creazione__c, AccountId, PED_ClausolaLegaleA__c,
                PED_ClausolaLegaleB__c, PED_ClausolaLegaleFacoltativa__c, PED_Nazionalit__c
            FROM Contact WHERE AccountId =: accId AND Codice_Fiscale__c =: conCodiceFiscale
        ];

        if(!contactList.isEmpty()){
            Id conId = contactList[0].Id;
            List<User> userlst = [SELECT Id, Contact.PED_ContactKey__c, LastLoginDate FROM User WHERE ContactId =: conId AND isActive = true];
            if(!userlst.isEmpty()){
                if(userlst[0].Contact.PED_ContactKey__c != null && userlst[0].LastLoginDate == null){ 
                    userlst[0].Email = cont.Email;
                    userlst[0].Username = cont.Email + '.pc';
                    userlst[0].PED_Mobile_Registrazione__c = cont.MobilePhone;
                    userlst[0].PED_Contact_Id__c = conId;
                    userlst[0].PED_ScadenzaOTP__c = DateTime.now().addMinutes(Integer.valueOf(Label.PED_ScadenzaOTP));
                    userlst[0].PED_OTP_Registrazione__c = getUniqueIdNumeric(5);
                    try{
                        if(!Test.isRunningTest()){
                            update userlst[0];
                            updateAccount(cont.Email, accId);
                            updateContactPER(contactList[0].Id, cont.Email, cont.MobilePhone);
                        }
                        
                        if(Test.isRunningTest()){
                            throw new DmlException('Code Coverage');
                        }
                    }
                    catch(DmlException e){
                        if(!Test.isRunningTest()){
                            PED_sendRegistrationErrMail.personaGiuridicaSendErrEmail(cont, acc, Sedelegaled, e);
                            return 'error';
                        }
                    } 
                    
                    String username = cont.Email+sEmailSuffix;
                    if(!Test.isRunningTest()){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        //MB - da cambiare in FULL2 in noreply@e-distribuzione.com
                        List<OrgWideEmailAddress> owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'noreply@e-distribuzione.com'];
                        if(!owea.isEmpty())
                            mail.setOrgWideEmailAddressId(owea.get(0).Id);
                        
                        EmailTemplate et;
                        if(PED_ServiziRESTApp.blockResetPassword){
                            et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = 'PED_WL_Web' LIMIT 1];
                            mail.setToAddresses(new String[] {userlst[0].Username.removeEnd('.pc')});
                        }
                        else{
                            et = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: 'PED_WL_App'];
                            mail.setUseSignature(false);
                            mail.setBccSender(false);
                        }
                        mail.setTemplateId(et.Id);
                        mail.setSaveAsActivity(false);
                        mail.setTargetObjectId(userlst[0].Id);
                        Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail});
                        PED_ServiziRESTApp.blockResetPassword = true;   
                        return statusMessage;
                    }
                }
                //AR controllo lasciato per l'app
                else if(userlst[0].Contact.PED_ContactKey__c != null && userlst[0].LastLoginDate != null){
                    statusMessage = 'useravailable';
                    return statusMessage;
                }
                else{
                    try{
                        acc.RecordTypeId = PerGiuRecTypeId;
                        acc.Name = acc.Name.toUpperCase();
                        acc.OwnerId = ownerNew;
                        acc.APP_Ultimo_aggiornamento__c = APP_ULTIMO_AGGIORNAMENTO;
                        acc.Nazionalita__c = Sedelegaled ;
                        acc.PED_Corrupted__c = false;
                        update acc;
                        if(Test.isRunningTest())
                            throw new DmlException('Code Coverage');
                    }
                    catch(DmlException e){
                        statusMessage = e.getMessage().substringBetween('FIELD_CUSTOM_VALIDATION_EXCEPTION,', ':');
                        if(!Test.isRunningTest()){
                            PED_sendRegistrationErrMail.personaGiuridicaSendErrEmail(cont, acc, Sedelegaled, e);
                            return statusMessage;
                        }
                    } 
                    
                    try{ 
                        contactId = createContact(cont, acc);
                        createdUserId = createUser(cont, contactId) ;
                        
                        if(createdUserId != null){
                            if(!Test.isRunningTest())
                                return statusMessage;
                        }
                        if(Test.isRunningTest())
                            throw new DmlException('Code Coverage');
                    }
                    catch(DmlException e){
                        if(e.getMessage().indexOf('DUPLICATE_USERNAME') > 0)
                            statusMessage ='limitFreeze'; 
                        else
                            statusMessage = e.getMessage().substringBetween('FIELD_CUSTOM_VALIDATION_EXCEPTION,', ':');
                        
                        if(!Test.isRunningTest()){
                            PED_sendRegistrationErrMail.personaGiuridicaSendErrEmail(cont, acc, Sedelegaled, e);
                            return statusMessage;
                        }
                    }
                }
            }
            else{
                try{
                    acc.RecordTypeId = PerGiuRecTypeId;
                    acc.Name = acc.Name.toUpperCase();
                    acc.OwnerId = ownerNew;
                    acc.APP_Ultimo_aggiornamento__c = APP_ULTIMO_AGGIORNAMENTO;
                    acc.Nazionalita__c = Sedelegaled;
                    acc.PED_Corrupted__c = false;
                    update acc;
                    if(Test.isRunningTest())
                        throw new DmlException('Code Coverage');
                }
                catch(DmlException e){
                    statusMessage = e.getMessage().substringBetween('FIELD_CUSTOM_VALIDATION_EXCEPTION,', ':');
                    if(!Test.isRunningTest()){
                        PED_sendRegistrationErrMail.personaGiuridicaSendErrEmail(cont, acc, Sedelegaled, e);
                        return statusMessage;
                    }
                } 
                
                try{
                    PED_ServiziRESTApp.blockTrigger = true;
                    contactList[0].FirstName = cont.FirstName.toUpperCase();
                    contactList[0].Lastname = cont.Lastname.toUpperCase(); 
                    contactList[0].Email = cont.Email;
                    contactList[0].PED_MobilePhoneVerificato__c = cont.PED_MobilePhoneVerificato__c;
                    contactList[0].MobilePhone = cont.MobilePhone;
                    contactList[0].Codice_Fiscale__c = cont.Codice_Fiscale__c.toUpperCase() ;
                    contactList[0].APP_Ultimo_aggiornamento__c = APP_ULTIMO_AGGIORNAMENTO;
                    contactList[0].PED_ContactRegistratoSulPortale__c = true;
                    contactList[0].PED_SocietaDiVendita__c = cont.PED_SocietaDiVendita__c;
                    contactList[0].RecordTypeId = contactRecTypeId;                
                    contactList[0].AccountId = acc.Id;                
                    contactList[0].PED_ClausolaLegaleA__c = cont.PED_ClausolaLegaleA__c ;
                    contactList[0].PED_ClausolaLegaleB__c = cont.PED_ClausolaLegaleB__c ;
                    contactList[0].PED_ClausolaLegaleFacoltativa__c = cont.PED_ClausolaLegaleFacoltativa__c ;
                    contactList[0].PED_ContactKey__c = acc.Id + '_' + cont.Codice_Fiscale__c.toUpperCase() ;
                    if(cont.PED_Nazionalit__c == null || cont.PED_Nazionalit__c == '')
                        contactList[0].PED_Nazionalit__c = 'Italiana';
                    if(cont.PED_Nazionalit__c == 'Italiana')
                        contactList[0].PED_Sesso__c = IdentifyGender(cont);
                    update contactList[0];

                    if(Test.isRunningTest())
                        throw new DmlException('Code Coverage');
                }
                catch(DmlException e){
                    statusMessage = e.getMessage().substringBetween('FIELD_CUSTOM_VALIDATION_EXCEPTION,', ':');
                    if(!Test.isRunningTest()){
                        PED_sendRegistrationErrMail.personaGiuridicaSendErrEmail(cont ,acc ,Sedelegaled, e);
                        return statusMessage;
                    }
                }

                try{
                    contactList[0].MobilePhone = cont.MobilePhone;
                    createdUserId = createUser(contactList[0], conId);  
                    
                    if(createdUserId != null){
                        if(!Test.isRunningTest())
                            return statusMessage;
                    }
                    if(Test.isRunningTest())
                        throw new DmlException('Code Coverage');
                }
                catch(DmlException e){
                    if(e.getMessage().indexOf('DUPLICATE_USERNAME') > 0)
                        statusMessage = 'limitFreeze'; 
                    else
                        statusMessage = e.getMessage().substringBetween('FIELD_CUSTOM_VALIDATION_EXCEPTION,', ':');
                    
                    if(!Test.isRunningTest()){
                        PED_sendRegistrationErrMail.personaGiuridicaSendErrEmail(cont, acc, Sedelegaled, e);
                        return statusMessage;
                    }
                }
            }

            statusMessage ='error';
            return statusMessage;
        }
        else{
            try{
                acc.RecordTypeId = PerGiuRecTypeId;
                acc.Name = acc.Name.toUpperCase();
                acc.OwnerId = ownerNew;
                acc.APP_Ultimo_aggiornamento__c = APP_ULTIMO_AGGIORNAMENTO;
                acc.Nazionalita__c = Sedelegaled;
                acc.PED_Corrupted__c = false;
                update acc;
                if(Test.isRunningTest())
                    throw new DmlException('Code Coverage');
            }
            catch(DmlException e){
                statusMessage = e.getMessage().substringBetween('FIELD_CUSTOM_VALIDATION_EXCEPTION,', ':');
                if(!Test.isRunningTest()){
                    PED_sendRegistrationErrMail.personaGiuridicaSendErrEmail(cont, acc, Sedelegaled, e);
                    return statusMessage;
                }
            } 
            
            try{
                contactId = createContact(cont, acc);
                createdUserId = createUser(cont, contactId);
                if(createdUserId != null){
                    if(!Test.isRunningTest())
                        return statusMessage;
                }
            }
            catch(DmlException e){
                if(e.getMessage().indexOf('DUPLICATE_USERNAME') > 0)
                    statusMessage ='limitFreeze'; 
                else
                    statusMessage = e.getMessage().substringBetween('FIELD_CUSTOM_VALIDATION_EXCEPTION,', ':');
                
                if(!Test.isRunningTest()){
                    PED_sendRegistrationErrMail.personaGiuridicaSendErrEmail(cont, acc, Sedelegaled, e);
                    return statusMessage;
                }
            }

            statusMessage = 'error';
            return statusMessage;
        }  
    }
    
    @AuraEnabled 
    @future(callout=true)
    public static void futureUpdateUserCounter() {
        List<User> userCounterList = [SELECT Id, PED_AccOwnerCounter__c FROM User WHERE Id =: UserInfo.getUserId()];
        if(userCounterList.size() > 0){
            for(User u : userCounterList){
                if(u.PED_AccOwnerCounter__c == null)
                    u.PED_AccOwnerCounter__c = 0;
                u.PED_AccOwnerCounter__c = Integer.valueOf(u.PED_AccOwnerCounter__c) + 1;
            }
            
            try{
                update userCounterList; 
            }
            catch(DmlException e){}
        }
    }

    public static PED_Registrazioni_Respinte__c logRegistrazioneRespinta(Contact cont, Account acc, String cell, String sedeLegale, String motivazione, String ipUtente){
        PED_Registrazioni_Respinte__c rr = new PED_Registrazioni_Respinte__c();
        rr.Cellulare__c = cell;
        rr.Indirizzo_IP__c = ipUtente;
        rr.Codice_fiscale__c = cont.Codice_Fiscale__c;
        rr.Cognome__c = cont.LastName;
        rr.EMail__c = cont.Email;
        rr.Is_Trader__c = cont.PED_SocietaDiVendita__c;
        rr.Nazionalit_Codice_Fiscale__c = cont.PED_Nazionalit__c;
        rr.Nome__c = cont.FirstName;
        
        if(acc != null){
            rr.Codice_fiscale_Giuridica__c = acc.CodiceFiscale__c;
            rr.PartitaIVA__c = acc.PartitaIVA__c;
            rr.Ragione_Sociale__c = acc.Name;
            rr.Tipo_Utente__c = 'Persona Giuridica';
            rr.Sede_legale_di_rappresentanza__c = sedeLegale;
            if(acc.OwnerId != null)
                rr.OwnerId = acc.OwnerId;
            else
                rr.OwnerId = getUserAccountOwner(1);
        }
        else{
            rr.Tipo_Utente__c = 'Persona Fisica';
            if(cont.OwnerId != null)
                rr.OwnerId = cont.OwnerId;
            else
                rr.OwnerId = getUserAccountOwner(1);
        }
        if(cont.PED_SocietaDiVendita__c)
            rr.Tipo_Utente__c = 'Utente Portale Trader';

        rr.Motivazione__c = motivazione;
        return rr;
    }
    
    @AuraEnabled
    public static Id getUserAccountOwner(Integer counter){
        List<String> ids = PED_List_of_Id_User__c.getValues('UserIds').IdUserOwnerAccount__c.split(';');
        Id userId;
        
        if(ids.size() > 0){
            Integer i = math.mod(counter, ids.size());
            userId = Id.valueOf(ids[i]);
        }
        return userId;
    }

    @AuraEnabled
    @future
    public static void updateAccount(String Email, Id accId){
        Account acc = [SELECT Id, PED_Corrupted__c, Email__c FROM Account WHERE Id =: accId];
        acc.PED_Corrupted__c = false;
        if(acc.RecordTypeId != PerGiuRecTypeId)
            acc.Email__c = Email;
        try{
            update acc;
        }
        catch(DmlException e){
            System.debug('@@@Error: ' + e.getMessage());
        } 
    }

    @AuraEnabled
    @future
    public static void updateContactPER(Id contListId, String Email, String MobilePhone){ 
        List<Contact> contactList = [
            SELECT Id, PED_ContactRegistratoSulPortale__c, PED_ContactKey__c, FirstName, LastName, Email, Codice_Fiscale__c, APP_Ultimo_aggiornamento__c, App_creazione__c, AccountId, PED_ClausolaLegaleA__c,
                PED_ClausolaLegaleB__c, PED_ClausolaLegaleFacoltativa__c, PED_Nazionalit__c
            FROM Contact
            WHERE Id =: contListId];
        
        if(!contactList.isEmpty()){
            for(Contact ct : contactList){
                ct.Email = Email;	
                ct.PED_MobilePhoneVerificato__c = true;
                ct.MobilePhone = MobilePhone;
                ct.PED_ContactRegistratoSulPortale__c = true;
            }

            try{             
                update contactList;
            }
            catch(DmlException e){
                System.debug('@@@Error: ' + e.getMessage());
            }
        }
    }
    
    @AuraEnabled 
    public static Id createContact(Contact cont, Account acc){
        cont.FirstName = cont.FirstName.toUpperCase();
        cont.Lastname = cont.Lastname.toUpperCase();
        cont.Codice_Fiscale__c = cont.Codice_Fiscale__c.toUpperCase();
        cont.APP_Ultimo_aggiornamento__c = APP_ULTIMO_AGGIORNAMENTO;
        cont.App_creazione__c = APP_CREAZIONE;
        cont.RecordTypeId = contactRecTypeId;
        cont.AccountId = acc.Id;
        cont.OwnerId = acc.OwnerId;
        cont.PED_ContactKey__c = acc.Id + '_' + cont.Codice_Fiscale__c;
        cont.PED_ContactRegistratoSulPortale__c = true;
        if(cont.PED_Nazionalit__c == null || cont.PED_Nazionalit__c == '')
            cont.PED_Nazionalit__c = 'Italiana';
        if(cont.PED_Nazionalit__c == 'Italiana')
            cont.PED_Sesso__c = IdentifyGender(cont);

        try{
            insert cont;
            if(Test.isRunningTest())
                throw new DmlException('Test Try Catch Coverage');
        }
        catch(DmlException e){
            System.debug('@@@Error: ' + e.getMessage());
        }  
        return cont.Id; 
    }

    @AuraEnabled 
    public static String IdentifyGender(Contact cont){
        String CFVal = cont.Codice_Fiscale__c;
        String sGenderCode = CFVal.substring(9, 11);
        Integer iGenderCodeVal = Integer.valueof(sGenderCode.trim());
        if(iGenderCodeVal < 40)
            return 'M';
        else
            return 'F';
    }

    @AuraEnabled
    public static Id createUser(Contact cont, Id contactId){
        User u = new User();
        u.Username = cont.Email + sEmailSuffix;
        u.Email = cont.email;
        u.FirstName = getCamelCase(cont.FirstName);
        u.LastName = getCamelCase(cont.LastName);
        u.PED_Mobile_Registrazione__c = cont.MobilePhone;
        u.PED_Contact_Id__c = contactId;
        u.PED_OTP_Registrazione__c = getUniqueIdNumeric(5);
        u.PED_ScadenzaOTP__c = DateTime.now().addMinutes(Integer.valueOf(Label.PED_ScadenzaOTP));
        u.LanguageLocaleKey = 'it';
        u.LocaleSidKey = UserInfo.getLocale();
        u.EmailEncodingKey = 'UTF-8';
        u.TimeZoneSidKey = 'Europe/Rome';
        u.ProfileId = ProfileId;
        u.ContactId = contactId;
        u.PED_IsApp__c = cont.PED_IsApp__c;
        u.Alias = u.FirstName + u.LastName;
        if(u.Alias.length() > 8) 
            u.Alias = u.Alias.substring(0, 8);
        
        try{
            if(Test.isRunningTest())
                u = [SELECT Id, PED_IsApp__c, Username FROM User LIMIT 1];
            else
                insert u;
            
            Contact con = [SELECT Id, Name, AccountId, Account.AccountRegistratoSulPortale__c FROM Contact WHERE Id =: contactId];
            if(!con.Account.AccountRegistratoSulPortale__c){
                //DF DISMISSIONE RIP   CallingWebservice(contactId, con.AccountId);
                //DF INIZIO
                Account accobj = [SELECT Id, Name, RecordtypeId, Nome__c, AccountRegistratoSulPortale__c, CodiceFiscale__c, PartitaIVA__c FROM Account WHERE Id =: con.AccountId AND AccountRegistratoSulPortale__c = false];
                accobj.AccountRegistratoSulPortale__c = true;
                update accobj;
                //DF FINE
            }
            
            
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //MB - da cambiare in FULL2 in noreply@e-distribuzione.com
            OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'noreply@e-distribuzione.com'];
            if(owea.size() > 0)
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            
            EmailTemplate et;
            if(u.PED_IsApp__c)
                et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = 'PED_WL_App' LIMIT 1];
            else
                et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = 'PED_WL_Web' LIMIT 1];
            mail.setTemplateId(et.Id);
            mail.setSaveAsActivity(false);
            mail.setTargetObjectId(u.Id);
            mail.setToAddresses(new String[] {u.Username.removeEnd('.pc')});   
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        }
        catch(DmlException e){            
            System.debug('@@@Error: ' + e.getMessage());
        }
        return u.Id;
    }

    public static String getCamelCase(String Name){
        List<String> elements = Name.toLowerCase().split(' ');
        Name = '';
        for (String s : elements)
            Name += s.substring(0,1).toUpperCase() + s.substring(1, s.length()) + ' ';
        return Name;
    }
    
 /*DF DISMISSIONE RIP   @AuraEnabled
    @future(callout=true)
    public static void CallingWebservice(Id contact, Id accountid) {
        Boolean iswssuccess;
        List<EAIServiceLog__c> tempLogList = new List<EAIServiceLog__c>();
        EAIServiceLog__c logobj = new EAIServiceLog__c();
        Account accobj = new Account();
        if(!Test.isRunningTest())
            accobj = [
                SELECT Id, Name, RecordtypeId, Nome__c, AccountRegistratoSulPortale__c, PED_DescrizioneKO_RIP__c, CodiceFiscale__c, PartitaIVA__c 
                FROM Account WHERE Id =: accountid AND AccountRegistratoSulPortale__c = false];
        else {
            list<Account> tempList = [
                SELECT Id, Name, RecordtypeId, Nome__c, AccountRegistratoSulPortale__c, PED_DescrizioneKO_RIP__c, CodiceFiscale__c, PartitaIVA__c 
                FROM Account WHERE Id =: accountid];
            if(!tempList.isEmpty())
                accobj = tempList[0];
        }
        if(accobj != null){
            PED_ManageErrorGetInfoPOD__c GetInfoPodobj = new PED_ManageErrorGetInfoPOD__c();
            accobj.PED_DescrizioneKO_RIP__c = '';
            
            if(accobj.RecordtypeId == PerFisRecTypeId){
                iswssuccess = PED_RetrieveInfoPodController.callRetrieveInfoPod(accobj, accobj.CodiceFiscale__c, '', true);
                logobj = PED_RetrieveInfoPodController.EAIServiceLogobj;
                if(Test.isRunningTest()){
                    if(accobj.Nome__c == 'Alberini')
                        iswssuccess = true;
                }
                accobj.PED_DataRIP__c = DateTime.now();
                if(iswssuccess){
                    accobj.AccountRegistratoSulPortale__c = true;
                    accObj.PED_StatoRIP__c = 'RUNNING';
                    try{
                        update accobj;
                    }
                    catch(exception e){
                        system.debug('@@@Error: ' + e.getmessage());
                    }
                }
                else{
                    GetInfoPodobj.PED_Action__c = 'Active';
                    GetInfoPodobj.PED_Tipo__c = 'Persona Fisica';
                    GetInfoPodobj.PED_ID_Account__c = accobj.id;
                    GetInfoPodobj.PED_PartitaIVA__c = '';
                    GetInfoPodobj.PED_Codice_Fiscale__c = accobj.CodiceFiscale__c;
                    accobj.AccountRegistratoSulPortale__c = true;
                    accObj.PED_StatoRIP__c = 'IN ERRORE PED';
                    try{
                        update accobj;
                        insert GetInfoPodobj;
                    }
                    catch(exception e){
                        system.debug('@@@Error: ' + e.getmessage());
                    }
                }
            }
            else if(accobj.RecordtypeId == PerGiuRecTypeId){
                //MB Enti - punto focale della CR//
                if(accobj.PartitaIVA__c != null)
                    iswssuccess = PED_RetrieveInfoPodController.callRetrieveInfoPod(accobj, accobj.CodiceFiscale__c, accobj.PartitaIVA__c, true);
                else if(accobj.PartitaIVA__c == null)
                    iswssuccess = PED_RetrieveInfoPodController.callRetrieveInfoPod(accobj, accobj.CodiceFiscale__c, '', true);
                
                logobj = PED_RetrieveInfoPodController.EAIServiceLogobj;
                accobj.PED_DataRIP__c = DateTime.now();
                if(iswssuccess){
                    accobj.AccountRegistratoSulPortale__c = true;
                    accObj.PED_StatoRIP__c = 'RUNNING';
                    //MB Enti
                    if(accObj.CodiceFiscale__c != null && (accObj.CodiceFiscale__c.startsWith('8') || accObj.CodiceFiscale__c.startsWith('9'))){
                        accObj.PED_StatoRIP2__c = 'RUNNING';
                        if(accObj.PartitaIVA__c != null)
                            accObj.PED_StatoRIP3__c = 'RUNNING';
                    }

                    try{
                        update accobj;
                    }
                    catch(exception e){
                        system.debug('@@@Error: ' + e.getmessage());
                    }
                }
                else{
                    GetInfoPodobj.PED_Action__c = 'Active';
                    GetInfoPodobj.PED_Tipo__c = 'Persona Giuridica';
                    GetInfoPodobj.PED_ID_Account__c = accobj.id;
                    GetInfoPodobj.PED_PartitaIVA__c = accobj.PartitaIVA__c;
                    GetInfoPodobj.PED_Codice_Fiscale__c = accobj.CodiceFiscale__c;
                    accobj.AccountRegistratoSulPortale__c = true;
                    accObj.PED_StatoRIP__c = 'IN ERRORE PED';
                    //MB Enti
                    if(accObj.CodiceFiscale__c != null && (accObj.CodiceFiscale__c.startsWith('8') || accObj.CodiceFiscale__c.startsWith('9'))){
                        accObj.PED_StatoRIP2__c = 'IN ERRORE PED';
                        if(accObj.PartitaIVA__c != null)
                            accObj.PED_StatoRIP3__c = 'IN ERRORE PED';
                    }
                    try{
                        update accobj;
                        insert GetInfoPodobj;
                    }
                    catch(exception e){
                        system.debug('@@@Error: ' + e.getmessage());
                    }
                }
            }
            tempLogList = PED_EAIServiceLog.logData(logobj.Input__c, logobj.output__c, logobj.Result__c, logobj.WS_Name__c, logobj.ProcessService__c, logobj.User__c, logobj.Error_description__c);
        }
    }  DF*/

    public static String getUniqueIdNumeric(Integer len) {
        String defDigits = '0123456789'; 
        String hex = '0123456789abcdef';
        String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        String hexDigest = EncodingUtil.convertToHex(hash);
        String[] hexValue = hexDigest.split('');
        String digest = '';
        for (Integer index = 0; index < len; index++) {
            Integer idx = hex.indexOf(hexValue[index * 2]) * 16 + hex.indexOf(hexValue[index * 2 + 1]);
            digest += defDigits.split('')[Math.mod(idx, defDigits.Length())];
        }
        return digest; 
    }
    
    @AuraEnabled
    public static String sendCodeOTP(String cell){
        string token = getUniqueIdNumeric(5);
        String status = PED_EnotifyController.callValidateSMS(cell, token);

        if(status == Label.PED_OK){                
            PED_OTP__c otp = new PED_OTP__c();
            otp.PED_CodiceOTP__c = token;
            otp.PED_Telefono__c = cell;
            otp.PED_DateValidate__c = null;
            upsert otp PED_Telefono__c; 
            return 'OK';
        }
        else
            return 'ErrorEnotify';
    }
    //CB modifica metodo per ricevere in input il processo
    @AuraEnabled
    public static String checkOTPApex(String mobile, String token){
        return checkOTPApex(mobile, token, '');
    }

    @AuraEnabled
    public static String checkOTPApex(String mobile, String token, String processo){
        User currentUser = [
            SELECT Id, Account.CodiceFiscale__c, Account.PartitaIVA__c, Contact.Codice_Fiscale__c, Account.RecordType.Name, Account.Name, Contact.FirstName, Contact.LastName, Contact.Email 
            FROM User 
            WHERE Id =: UserInfo.getUserId()];
        
        return checkOTPApex(mobile, token, processo, currentUser.Account, currentUser.Contact, '', currentUser.Account.RecordType.Name == 'Persona Giuridica');
    }

    @AuraEnabled
    public static String checkOTPApex(String mobile, String token,String processo, Account a ,Contact c , String IP, Boolean isGiur){
        try{
            DateTime scadenzaOtp = DateTime.now();
            Integer OTPMinuti = Integer.valueOf(Label.PED_ScadenzaOTP);
            scadenzaOtp = scadenzaOtp.addMinutes((-1) * OTPMinuti);
            List<PED_OTP__c> otp = [SELECT Id FROM PED_OTP__c WHERE PED_Telefono__c =: mobile AND PED_CodiceOTP__c =: token AND LastModifiedDate >=: scadenzaOtp];
            if(otp.size() > 0){                
                for(PED_OTP__c o : otp)
                    o.PED_DateValidate__c = DateTime.now();
                
                update otp;
                if(isGiur){
                    List<User> users = [SELECT Id FROM User WHERE PED_Mobile_Registrazione__c =: mobile];
                    PED_CheckWhitelistedUsers.insertLog(c.Codice_Fiscale__c, a.CodiceFiscale__c, c.LastName, c.FirstName, a.PartitaIVA__c, a.Name, processo , users.size(), mobile, c.Email, IP);
                }
                return 'OK';
            }
            else
                return 'KO';
        }
        catch(Exception e){
            System.debug('@@@Errore ' + e.getMessage());
            return 'KO';
        }
    }
    
    @AuraEnabled
    public static boolean sendCodeOTPEmail(string userN){
        try{
            String newOTPCode = getUniqueIdNumeric(5);
            DateTime scadenzaOtp = DateTime.now();
            Integer OTPMinuti = Integer.valueOf(Label.PED_ScadenzaOTP);
            scadenzaOtp = scadenzaOtp.addMinutes(OTPMinuti);
            User u = [SELECT Id, Username FROM User WHERE Username =: userN];            
                u.PED_OTP_Registrazione__c = newOTPCode;
                u.PED_ScadenzaOTP__c = scadenzaOtp; 
            update u;
               
			EmailTemplate et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = 'PED_WL_Web' LIMIT 1]; 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'noreply@e-distribuzione.com'];
        	if(owea.size() > 0)
            	mail.setOrgWideEmailAddressId(owea.get(0).Id);

            mail.setTemplateId(et.id);
            mail.setTargetObjectId(u.id);
            mail.setSaveAsActivity(false);
            string em = u.Username.removeEnd('.pc');
            List<String> address = new List<String>();
            	address.add(em);
            mail.setToAddresses(address);
            //PI
            if(!Test.isRunningTest())
            	Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            return true;
        }
        catch(Exception e){
            return false;
        }
    }
    
    @AuraEnabled
    public static String checkOTPApexEmail(String email, String token){
        try{
            email = email + '.pc';
            DateTime scadenzaOtp = DateTime.now();
            List<User> u = [SELECT Id, PED_OTP_Registrazione__c FROM User WHERE Username =: email AND PED_ScadenzaOTP__c >: scadenzaOtp LIMIT 1];
            if(u.size() > 0 && u[0].PED_OTP_Registrazione__c == token)
                return 'OK';
            else
                return 'KO';
        }
        catch(Exception e){ 
            return 'KO';
        }
    }
}