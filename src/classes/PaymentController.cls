public class PaymentController 
{
 
	private final String PAYMENT_URL = 'https://www.bpoint.com.au/evolve/service.asmx';
	private final String AUTHENTICATION_URL = 'https://www.bpoint.com.au/payconnect/auth.aspx';
	private final String MERCHANT_NUMBER = '5353165922228100';
	private final String USERNAME =  'apiuser';//'admin';
	private final String PASSWORD = 'A36yioU3G2';//'vfCHH685g63';

	public String getPaymentToken(Decimal paymentAmnt, String refNum)
	{
		HttpRequest req = getRequest(AUTHENTICATION_URL);

		String body = 	'in_merchant_number=' +  EncodingUtil.urlEncode(MERCHANT_NUMBER, 'UTF-8') +
						'&in_merchant_username=' +  EncodingUtil.urlEncode(USERNAME, 'UTF-8') + 
						'&in_merchant_password=' +  EncodingUtil.urlEncode(PASSWORD, 'UTF-8') +
						'&in_amount=' +  EncodingUtil.urlEncode(String.valueOf(paymentAmnt), 'UTF-8') + 
						'&in_merchant_reference=Invoice123' +
						'&in_crn1=' +  EncodingUtil.urlEncode(refNum, 'UTF-8');
				
		req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		req.setHeader('Content-Length', String.valueOf(body.length()));
		req.setBody(body)	;
system.debug(req);		
system.debug(req.getBody());		
		HttpResponse response = new Http().send(req);
		return response.getBody();						

	}

	private HttpRequest getRequest(String url)
	{
		HttpRequest req = new HttpRequest();
		req.setMethod('POST');
		req.setEndpoint(url);
		return req;
	}

}