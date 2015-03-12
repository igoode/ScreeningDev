@RestResource(urlMapping='/user/*')
global  class RestResources 
{
	@HttpGet
	global static void activateUser()
    {	     
    	String userId = RestContext.request.params.get('uid');
    	for(User u : [SELECT 	ID
    				FROM 		User 
    				WHERE 		ID = :userID AND 
    							ISActive = false])
		{
            u.IsActive = true;
    		update u;
    	}
    }
}