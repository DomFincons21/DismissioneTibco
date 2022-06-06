public without sharing class PED_CheckBlacklistedEmail {

	/** 
	 *  Check the email address from a specified domain
	 * @return True if his domain is not inside blacklist
	 * ! TO DISMISS
	 */
    @AuraEnabled
    public static Boolean checkBlacklistedEmail(String email){
    	String dominio = email.substringAfter('@');
    	List<PED_Blacklist_Domini_Email__c> checkDomain = [SELECT Id FROM PED_Blacklist_Domini_Email__c WHERE Name =: dominio];
		if(!checkDomain.isEmpty())
			return true;
		else
			return false;
	}
	
	/** 
	 * Oggetto Blacklist: 
	 * 		PED_Blacklist_Domini_Email__c
	 * Fields in DISMISSIONE:
	 * 		Standard -> Full email address @ -> Mail
	 * 		Wildcard -> Part of the email address -> MailWildCard
	 * Tipologia:
	 * 		Automatico -> Record GitHub
	 * 		Manuale -> Record in PED_Blacklisted_Email__c
	 * 
	 * 1. Registrazione/ Login
	 * 		 a) bloccare dominio con i valori : 
	 * 			Tipologia -> Manuale
	 * 			RecordType -> Domini
	 * 			Active -> True
	 * @return True if the email address is all blacklist
	 */
	@AuraEnabled
	public static Boolean checkBlacklist(String email){
		try {
			if(isDomainInBlacklist(email) ||  isMailInBlacklist(email) || isMailWildCardInBlacklist(email)){
				return true;
			}else{
				return false;
			}

		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
			return true;
		}
	}

	/**
	 * @return True if domain in blacklist - false if not.
	 */
	@AuraEnabled
	public static boolean isDomainInBlacklist(String email){
			// 1. Is Domain in BlackList: LOGIN O REGISTRO
			 String dominio = email.substringAfter('@');
			 System.debug(dominio);
			 List<PED_Blacklist_Domini_Email__c> checkDomain = [select id, Attivo__c, Tipologia__c, RecordType.Name from PED_Blacklist_Domini_Email__c  WHERE PED_Blacklist__c =: dominio and Attivo__c=true and RecordType.Name= 'Domini']; 

			 if(checkDomain.isEmpty())
			 	return false;
			 else
				 return true;
		
	}
	/**
	 * @return True if mail in blacklist - false if not.
	 */
	@AuraEnabled
	public static boolean isMailInBlacklist(String email){
		System.debug(email);
		List<PED_Blacklist_Domini_Email__c> checkEmails = [select id, Attivo__c, Tipologia__c, RecordType.Name, PED_Blacklist__c from PED_Blacklist_Domini_Email__c WHERE Attivo__c=true and RecordType.Name= 'Mail']; 

		for(PED_Blacklist_Domini_Email__c emails: checkEmails){
			if(emails.PED_Blacklist__c.equals(email))
				return true;
			System.debug(emails);
		}
		return false;
	}
	/**
	 * @return True if mail in blacklist - false if not.
	 */
	@AuraEnabled
	public static boolean isMailWildCardInBlacklist(String email){
		System.debug(email);
		List<PED_Blacklist_Domini_Email__c> checkEmails = [select id, Attivo__c, Tipologia__c, RecordType.Name, PED_Blacklist__c from PED_Blacklist_Domini_Email__c WHERE Attivo__c=true and RecordType.Name= 'MailWildCard']; 

		for(PED_Blacklist_Domini_Email__c emails: checkEmails){
			if(emails.PED_Blacklist__c.equals(email))
				return true;
			System.debug(emails);
		}
		return false;
	}
    
	/**
	 * Update the field controller about email address from the contact
	 */
    @AuraEnabled
    public static void flagDisposable(Contact c){
		c.PED_Email_Disposable__c = true;
        update c;        
	}
	
	/**
	 * 	TODO - DISMISSIONE
	 */
	@AuraEnabled
	public static Boolean checkBlacklistedSpecifiedEmail(String email){
    	String blackEmail = email.substringBefore('@') + '%';
    	String query = 'SELECT Id, Email__c FROM PED_Blacklisted_Email__c WHERE RecordType.Name = \'WildCard\' LIMIT 10000';
    	List<String> listEmailBl = new List<String>();
		Database.QueryLocator q = Database.getQueryLocator(query);
		Database.QueryLocatorIterator it =  q.iterator();
		while (it.hasNext()){
		    PED_Blacklisted_Email__c bklEmailDB = (PED_Blacklisted_Email__c)it.next();
		    if(blackEmail.contains(bklEmailDB.email__c))
		    	return true;
		}
		
		List<PED_Blacklisted_Email__c> checkDomain = [SELECT Id FROM PED_Blacklisted_Email__c WHERE Email__c =: email AND RecordType.Name = 'Standard' LIMIT 1];
		if(!checkDomain.isEmpty())
			return true;
		else
			return false;
	}
}