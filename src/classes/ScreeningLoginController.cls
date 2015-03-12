public class ScreeningLoginController
{
	private final String NS_SOAP = 'http://schemas.xmlsoap.org/soap/envelope/';
	private final String NS_SF = 'urn:partner.soap.sforce.com';
	private final String LOGIN_ENDPOINT = 'https://ap1.salesforce.com/services/Soap/u/29.0';
	private final String SF_STARTURL = 'https://ap1.salesforce.com/secur/frontdoor.jsp';
	private final String SITE_STARTURL = '/apex/Home';
	private final String SITE_USERTYPE = 'CSPLitePortal';

	public String username {get; set;}
    public String password {get; set;}

    public PageReference login()
    {
    	try
    	{
	        for(User u : [	SELECT 	Id,
	        						IsActive,
	        						UserType
							FROM 	User
							WHERE 	Username = :username])
			{
				if(!u.IsActive)
		  		{
		  			Integer status = activateUser(u.ID);
		  			if(status!= 200)
		  			{
		  				return SCException.formatException(String.valueOf(status));
		  			}
		  		}
				if(u.UserType == SITE_USERTYPE)
				{
				  	return Site.login(username, password, SITE_STARTURL);
				}
				else
				{
			  		String sessID = sfLogin();
			  		if(String.isBlank(sessID))
			  		{
			  			return SCException.formatException('Username/password not found.');
			  		}
			  		PageReference pg = new PageReference(SF_STARTURL);
		  			pg.getParameters().put('sid', sessID);
		  			return pg.setRedirect(true);
			  	}
			}
			return SCException.formatException('Username/password not found, would you like to create an account?');
    	}
    	catch(Exception ex)
    	{
        	return SCException.formatException(ex);
    	}
    }

	private String sfLogin()
	{
	    // As per http://wiki.developerforce.com/page/Enterprise_Login
	    HttpRequest req = new HttpRequest();
	    req.setMethod('POST');   
	    req.setTimeout(60000);
	    req.setEndpoint(LOGIN_ENDPOINT);
	    req.setHeader('Content-Type', 'text/xml;charset=UTF-8');        
	    req.setHeader('SOAPAction', '""');
	    req.setBody('<Envelope xmlns="' + NS_SOAP + '"><Header/><Body><login xmlns="' + NS_SF + '"><username>' +
	    				username + 
	    				'</username><password>' + 
	    				password + 
	    				'</password></login></Body></Envelope>');        
	    HttpResponse res =  new Http().send(req);
	    if(res.getStatusCode() != 200)
	    {
	        Dom.Document responseDocument = res.getBodyDocument();
	        Dom.Xmlnode rootElm = responseDocument.getRootElement(); // soapenv:Envelope
	        Dom.Xmlnode bodyElm = rootElm.getChildElement('Body', NS_SOAP); // soapenv:Body 
	        Dom.Xmlnode faultElm = bodyElm.getChildElement('Fault', NS_SOAP); // soapenv:Fault
	        Dom.Xmlnode faultStringElm = faultElm.getChildElement('faultstring', null); // faultstring          
	        throw new SCException(faultStringElm.getText()); 
	    }
	    // As per http://wiki.developerforce.com/page/Enterprise_Login
	    Dom.Document responseDocument = res.getBodyDocument();
	    Dom.Xmlnode rootElm = responseDocument.getRootElement(); // soapenv:Envelope
	    Dom.Xmlnode bodyElm = rootElm.getChildElement('Body', NS_SOAP); // soapenv:Body 
	    Dom.Xmlnode loginResponseElm = bodyElm.getChildElement('loginResponse', NS_SF); // loginResponse
	    Dom.Xmlnode resultElm = loginResponseElm.getChildElement('result', NS_SF); // result
	    Dom.Xmlnode sessionIdElm = resultElm.getChildElement('sessionId', NS_SF); // sessionId
	    return sessionIdElm.getText();
	}

	public Integer activateUser(String userID)
	{
	    HttpRequest req = new HttpRequest();
	    req.setMethod('GET');   
	    req.setTimeout(60000);
	    req.setHeader('Authorization','Basic '+ UserInfo.getSessionId());
	    req.setEndpoint('https://screening-unit-developer-edition.ap1.force.com/services/apexrest/user/activateUser?uid=' + userID);	    
	    HttpResponse response = new Http().send(req);
		return response.getStatusCode();
	}
}