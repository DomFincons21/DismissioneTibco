public with sharing class PED_LoginController {
    
    @AuraEnabled
    public static ReturnInfo init(){
        ReturnInfo info = new ReturnInfo();
        info.loginInfo = [SELECT PED_InfoTab__c, PED_ForgotPassword__c, PED_Faq__c, PED_MaIntenanceOn__c, PED_MaintenanceText__c,PED_LoginClassica__c,PED_RegistrationPage__c,PED_ConfermaModalErrorSPID__c,PED_AnnullaModalErrorSPID__c,PED_Giorno_Apertura_Portale__c,PED_Giorno_Chiusura_Portale__c,
                          PED_LoginSPID__c FROM PED_LoginInformation__mdt WHERE DeveloperName='PED_DefaultPage' LIMIT 1];
        info.MaintenanceOn = isMaIntenanceOn(info.loginInfo);
        return info;
    }
    
    @AuraEnabled
    public static String loginUser(String username, String password, String startUrl){
        try{
            String userSuffix = username + Label.PED_EmailSuffixPC;
            system.debug('@@userSuffix -> ' + userSuffix);
            if(PED_CheckBlacklistedEmail.checkBlacklistedEmail(username)){
                List<User> uList = PED_SiteLoginControllerHelper.checkDisposable(userSuffix); //MM spostata la query nel metodo without sharing per visibilità
                if(!uList.isEmpty()){
                    if(!uList[0].contact.PED_Email_Disposable__c){
                        Contact c = new contact();
                        c.Id = uList[0].contactId;
                        PED_CheckBlacklistedEmail.flagDisposable(c);
                    }   
                }
                String err = 'KO:' + Label.PED_EmailBlacklistedOld;
                return err;
            }
            if(startUrl == null || startUrl == '')
                startUrl = Site.getBaseRequestUrl();
            System.debug('@@@baseUrl: '+Site.getBaseRequestUrl() + ' base Custom url ' + Site.getBaseCustomUrl());
            System.debug('@@@startUrl: '+startUrl);
            User u = PED_SiteLoginControllerHelper.selectUser(userSuffix);
            //CB aggiunta campi gestione SPID
            u.PED_SpidCode__c = '';
			u.PED_RedirectUrlSPID__c = null;
            
			//CB SPID END 
            //CB gestione utente confindustria START
            //if(PED_SiteLoginControllerHelper.checkConfindustria(userSuffix))
            if(u.Account.RecordType.DeveloperName == 'PED_Confindustria'){
                if(u.PED_FineValiditaUtenza__c == null || u.PED_FineValiditaUtenza__c <= system.today()){
                    //PED_SiteLoginControllerHelper.sendOtpMail(u);
                    startUrl += '/ped-otpmailconfindustria'; 
                }
                else
                    startUrl += '/ped-disclaimerconfindustria';
            }
            //CB gestione utente confindustria END
            //MB Ribaltamento Campi User su Contact
            PageReference loginUrl = Site.login(userSuffix, password, startUrl);
            PED_SiteLoginControllerHelper.updateUser(u);
            System.debug('@@@url: '+loginUrl);
            System.debug('@@@loginUrl: '+loginUrl.getUrl());
            return 'OK:' + String.valueOf(loginUrl.getUrl());
        }
        catch(Exception e){
            String stackTrace;
            stackTrace = 'Cause: ' + e.getCause() + '\n'
                            + 'Line number: ' + e.getLineNumber() + '\n'
                            + 'Message: ' + e.getMessage() + '\n'
                            + 'Exception type: ' + e.getTypeName() + '\n'
                            + '----- Stack Trace -----\n' +
                            e.getStackTraceString();
            System.debug('stackTrace ' + stackTrace);
            system.debug('@@errore' + e);
            return String.valueOf(stackTrace);
        }
    }
    
    private static Boolean isMaIntenanceOn(PED_LoginInformation__mdt loginInfo){
        if(loginInfo.PED_Giorno_Chiusura_Portale__c < System.Now() && System.Now()< loginInfo.PED_Giorno_Apertura_Portale__c)
            return true;
        else 
            return false;
    }
    
    public class ReturnInfo {
        @AuraEnabled
        public PED_LoginInformation__mdt loginInfo = new PED_LoginInformation__mdt() ;
        @AuraEnabled
        public Boolean maintenanceOn;
    }
}