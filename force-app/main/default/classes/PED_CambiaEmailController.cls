public without sharing class PED_CambiaEmailController {
    
    //private static final Id AccOwnerId = PED_System_Constants__c.getInstance().ID_Owner_Account_Community__c;
    
    // KJS
    @AuraEnabled 
    public static String updateEmail_NEW_AS(string newEmail){ 
    	if(PED_CheckBlacklistedEmail.isDomainInBlacklist(newEmail)){
        	return 'blacklistedEmail';
            system.debug('blacklistedEmail');
        }
        string uName =newEmail+'.pc';
        string status='';
        List<User> userListWithNewEmailUsername =[SELECT Id, Email, Username FROM User WHERE Username =: uName OR Email =:newEmail ];
        if(userListWithNewEmailUsername.size() > 0){
            status= 'UserExistWithEmail';
            system.debug('UserExistWithEmail');
        }else{
            status= 'SendEmail';
            // upadte contact PED_email_da_confermare__c to the new email
            system.debug('SendEmail');
            user currentUser = [SELECT Id, Email, FirstName, LastName, Username, AccountId, ContactId, Contact.Email FROM User WHERE Id = :UserInfo.getUserId() Limit 1];
            contact con = [select id,email,PED_email_da_confermare__c,PPW_PraticaInVolo__c,PPW_FlagAnagraficaCompleta__c,PPW_RichiestaModifica__c from contact where id=:currentUser.ContactId];
            con.PED_email_da_confermare__c = newEmail;  
           
            //Added for PPW 
            if(con.PPW_PraticaInVolo__c==true && con.PPW_FlagAnagraficaCompleta__c==true){
                con.PPW_RichiestaModifica__c=true;
            }
            update con; 
            
            //SendEmail(currentUser.FirstName, currentUser.LastName, con.id, con.PED_email_da_confermare__c);//MMAGNA 03022018 Change Email CM
        }
        
        return status; 
        
    }    
    
    //MMAGNA 20180225 – Change Email CM - Invoke From Trigger
    public static string checkEmail_CM(list<Contact> listOfContact){
        
        list<string> ListUsername = new list<String>();
        map<Id, string> MapEmail = new map<Id, string>();
        list<Id> ListcontId = new list<Id>();
        
        for(Contact c:listOfContact){
            ListUsername.add(c.PED_email_da_confermare__c + '.pc');
            MapEmail.put(c.Id, c.PED_email_da_confermare__c);
            ListcontId.add(c.Id);
        }
        
        list<User> listOfUser = [Select Id, Username,Email,ContactId from User where isactive= true and Username in :ListUsername];
        system.debug(listOfUser.size() + ' ' + ListUsername);
        
        if(listOfUser.size() > 0)
            return 'Email già utilizzata da un altro utente del portale';
        else
        {
            for(Contact c:listOfContact)
            if(Ped_Utility.checkContact(c.id)){
                SendEmail(c.FirstName, c.LastName, c.Id, c.PED_email_da_confermare__c);
            }
            return 'OK';
        }
    }
    
    //MMAGNA 03022018 Change Email CM
    public static void SendEmail(string FirstName, string LastName, string ContactID, string NewEmail ){
        if(Ped_Utility.checkContact(ContactId)){
            EmailTemplate et = [SELECT id,Subject, HtmlValue, Body FROM EmailTemplate WHERE developerName = 'PED_Cambia_Email'];
            
            // process the merge fields
            String subject = et.Subject;
            String htmlBody = et.HtmlValue;
            htmlBody = htmlBody.replace('{!User.FirstName}', FirstName);
            htmlBody = htmlBody.replace('{!User.LastName}', LastName);
            htmlBody = htmlBody.replace('{!$Label.PED_LinkToConfermaEmailBtn}', Label.PED_LinkToConfermaEmailBtn);
            htmlBody = htmlBody.replace('{!Contact.Id}', ContactID);
            htmlBody = htmlBody.replace('{!Contact.PED_Email_da_confermare__c}', NewEmail);
            
            //build the email message
            string senderowea = PED_Environment__c.getInstance('no-replyMailSender').Value__c;
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :senderowea];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea[0].Id);
            }
            mail.setTemplateId(et.id);
            mail.setSaveAsActivity(false);
            mail.setSubject(subject);
            mail.setHtmlBody(htmlBody);
            List<String> sendTo = new List<String>();
            sendTo.add(NewEmail); // Specify to whom the email should be sent to.
            system.debug('sendTo-----------------'+sendTo);
            mail.setToAddresses(sendTo);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}); 
        }  
        
  
    }         
    
}