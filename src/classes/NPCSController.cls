public class NPCSController 
{
    public void submitCheck()
    {
    	String xml = '';
    	HttpRequest request = new HttpRequest();
    	request.setEndpoint('https://nss-ws-xint.crimtrac.gov.au/nss-ws/CheckSubmission');
    	request.setMethod('POST');
    	request.setTimeout(10000);
    	request.setBody(xml);
    	HttpResponse response = (new Http()).send(request);
    	system.debug(response.getBody());
    }

}