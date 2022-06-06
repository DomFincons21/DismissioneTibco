/**
 * An apex page controller that exposes the site forgot password functionality
 */
public without sharing class PED_ForgotPasswordController{
    public String username {get; set;} 
    public String displayName{get; set;}
    public PageReference forgotPassword() {
        displayName=username ;
        //PGALE START Mostra il + quando viene passata la username nell'URL
        if (displayName.contains('+')){
   			displayName = displayName.replace('+', '%2B');
		}
        // PGALE END
        if(PED_CheckBlacklistedEmail.checkBlacklistedEmail(username)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.PED_EmailBlacklistedOld));
            return null;
        } 
        if(Test.isRunningTest()) {
           username=username;
        } else {
            username=username+'.pc';    
        }
        //MMAGNA START
        Datetime startDate = system.now();// Start date
        boolean success = true;
        try{
        	User uObj = [SELECT Id,LastPasswordChangeDate,FirstName,LastName,ContactId From User Where Username =: username Limit 1];
	        if(uObj != null) {
	            Datetime endDate = uObj.LastPasswordChangeDate;//End Date
	            decimal minutes = (startDate.getTime() - decimal.valueOf(endDate.getTime()))/1000/60;
	            system.debug(minutes);
	            if(minutes > 1440)//passate 24h
	                success = Site.forgotPassword(username);
	            else
	                SendEmail(uObj);
	        }
	        //MMAGNA END
	        PageReference pr =new PageReference('/apex/PED_ForgotPasswordConfirm?usr='+displayName);
	        pr.setRedirect(true);
	        if (success) {
	            return pr;
	        } 
	        System.debug('PED_ForgotPasswordController END');
	         return null;
        }catch(Exception e)
        {
        	System.debug('*** PED_ForgotPasswordController, email non corrispondente a utente di community');
        	PageReference pr =new PageReference('/apex/PED_ForgotPasswordConfirm?usr='+displayName);
        	pr.setRedirect(true);
	        if (success) {
	            return pr;
	        } 
        }
        return null;
    }
    public PageReference Cancel(){
    PageReference pr1 = Page.PED_SiteLogin;
        pr1.setRedirect(true);
        return pr1; 
        } 
    
    //MMAGNA START
    public static void SendEmail(User uObj){ 
        
        if(!PED_Utility.checkContact(uObj.ContactId)){
            return;  
        }
        
        EmailTemplate et = [SELECT id,Subject, HtmlValue, Body FROM EmailTemplate WHERE developerName = 'PED_NoReset_PSW' Limit 1];
        system.debug('SendEmail');
        // process the merge fields
        String subject = et.Subject;
        String htmlBody = et.HtmlValue;
        htmlBody = htmlBody.replace('{!User.FirstName}', uObj.FirstName);
        htmlBody = htmlBody.replace('{!User.LastName}', uObj.LastName);
       //build the email message
       String senderowea = PED_Environment__c.getInstance('noreplyMailSender').Value__c;
       OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:senderowea];
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       if ( owea.size() > 0 ) {
           mail.setOrgWideEmailAddressId(owea[0].Id);
       }
       mail.setTemplateId(et.id);
       mail.setSaveAsActivity(false);
       mail.setSubject(subject);
       mail.setHtmlBody(htmlBody);
       mail.setTargetObjectId(uObj.ContactId);
       if(!Test.isRunningTest()){
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
       }
    }//MMAGNA END
    
}