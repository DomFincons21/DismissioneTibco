public without sharing class PED_CheckBlacklistedEmail {
    @AuraEnabled
    public static Boolean checkBlacklistedEmail(String email){
    	String dominio = email.substringAfter('@');
    	List<PED_Blacklist_Domini_Email__c> checkDomain = [SELECT Id FROM PED_Blacklist_Domini_Email__c WHERE Name =: dominio];
		if(!checkDomain.isEmpty())
			return true;
		else
			return false;
	}
    
    @AuraEnabled
    public static void flagDisposable(Contact c){
		c.PED_Email_Disposable__c = true;
        update c;        
	}
	
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