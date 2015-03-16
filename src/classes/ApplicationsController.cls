public without sharing class ApplicationsController 
{
    public List<Applicant__c> Applications 
    {
    	get
    	{
    		if(Applications == null)
    		{
system.debug(ThisUser);    			
	    		Set<ID> accountIDs = new Set<ID>();
	    		accountIDs.add(ThisUser.Contact.AccountID);
	    		for(Account a : [SELECT ID
	    						FROM Account
	    						WHERE ParentID = :ThisUser.Contact.AccountID OR 
	    							Parent.ParentID = :ThisUser.Contact.AccountID])
    			{
    				accountIDs.add(a.ID);
    			}  	
system.debug(accountIDs);  
				accountIDs.remove(null); 			
	    		Applications = [SELECT ID, NAme,Current_Last_Name__c,Current_First_Name__c

	    				FROM Applicant__c
	    				WHERE Referring_Organisation__c IN :accountIDs];
	    	}
	    	return Applications;
    	}
    	set;
    }

    public User ThisUser 
    {
    	get
    	{
    		if(ThisUser == null)
    		{
    			ThisUser = [SELECT Name, AccountID, Contact.AccountID, Contact.Account.ParentId, Contact.Account.Parent.ParentId, Account_ID__c FROM USer WHERE ID = :UserInfo.getUserId()];
    		}
    		return ThisUser;
    	}
    	set;
    }
}