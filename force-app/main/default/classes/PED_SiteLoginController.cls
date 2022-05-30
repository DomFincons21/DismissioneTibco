global with sharing class PED_SiteLoginController {
    global String username {get; set;}
    global String password {get; set;}
    global PED_URLs__c registration {get;set;}
    global PED_URLs__c forgotpassword {get;set;}
    global PED_URLs__c faq { get; set;} 
    global String communityURL {get; set;}
    global String startURL {get; set;} 
    global String authProvider {get; set;}
    global Boolean isApp {get; set;}
     
    global PageReference login() {
        String userSuffix = username + Label.PED_EmailSuffixPC; 
        if(PED_CheckBlacklistedEmail.checkBlacklistedEmail(username)){
            List<User> uList = PED_SiteLoginControllerHelper.checkDisposable(userSuffix); //MM spostata la query nel metodo without sharing per visibilità
            if(!uList.isEmpty()){
                if(!uList[0].contact.PED_Email_Disposable__c){
                    Contact c = new contact();
                    c.Id = uList[0].contactId;
                    PED_CheckBlacklistedEmail.flagDisposable(c);
                }
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.PED_EmailBlacklistedOld));
            return null;
        }
        String startUrl = System.currentPageReference().getParameters().get('startUrl');
        //CB gestione utente confindustria *
        User u = PED_SiteLoginControllerHelper.selectUser(userSuffix);
        //if(PED_SiteLoginControllerHelper.checkConfindustria(userSuffix))
        if(u.Account.RecordType.DeveloperName == 'PED_Confindustria'){
            if(u.PED_FineValiditaUtenza__c == null || u.PED_FineValiditaUtenza__c <= system.today()){
                //PED_SiteLoginControllerHelper.sendOtpMail(u);
                startUrl += 'ped-otpmailconfindustria'; 
            }
            else
                startUrl += 'ped-disclaimerconfindustria';
        }
        //MB Ribaltamento Campi User su Contact
        PageReference loginUrl = Site.login(userSuffix, password, startUrl);
        System.debug('@@@loginurl: '+loginUrl);
        PED_SiteLoginControllerHelper.updateUser(u);
        return loginUrl;
    }
    
    global PED_SiteLoginController () {
        String url;
        if(!Test.isRunningTest())
        	url = EncodingUtil.urlDecode(String.valueOf(ApexPages.currentPage()), 'UTF-8');
        else
            url = 'display=touch&login_hint=username';
        System.debug('@@url = '+ url);
        if(url.contains('display')){
            for(string s : url.split('&')){
                if(s.contains('display'))
                    isApp = s.split('=')[1].replace(']','') == 'touch'; //se viene messo alla fine devo togliere cmq la ]
                if(s.contains('login_hint'))
                    username = s.split('=')[1].replace('%40','@').replace(']','');
            }
            //isApp = url.split('display=')String.valueOf(ApexPages.currentPage().getParameters().get('display')) == 'touch';
            //if(url.contains('login_hint')){
            //    username = ApexPages.currentPage().getParameters().get('login_hint');
            //}
            if(!isApp){
                registration = PED_URLs__c.getInstance('Registration');  
                forgotpassword = PED_URLs__c.getInstance('Forgot Password');
                faq = PED_URLs__c.getInstance('FAQ'); 
            }
            else{
                registration = PED_URLs__c.getInstance('RegistrationApp');
                forgotpassword = PED_URLs__c.getInstance('Forgot Password App');
            }
        }
        else{
            registration = PED_URLs__c.getInstance('Registration');  
            forgotpassword = PED_URLs__c.getInstance('Forgot Password');
            faq = PED_URLs__c.getInstance('FAQ'); 
        }
    } 
}