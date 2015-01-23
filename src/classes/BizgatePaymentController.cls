public class BizgatePaymentController 
{	
    public String XMLString
    {
    	get
    	{
    		if(XMLString == null)
    		{
    			String xml = getXML();
    			xml = xml.escapeHtml4();
    			XMLString = EncodingUtil.urlEncode(xml, 'UTF-8');
    		}
    		return XMLString;
    	}
    	set;
    }

    public void openBizgate()
    {

    }

    public String sendPayment()
    {
    	Http http = new Http();
    	HttpRequest request = new HttpRequest();
    	request.setEndpoint('https://www.bizgate.sa.gov.au/GlobalPayments/Index.aspx');
    	//request.
    	return null;
    }

    private List<InvoiceItem> getItems()
    {
    	List<InvoiceItem> items = new List<InvoiceItem>();
    	items.add(new InvoiceItem('Bread', 34.34, 1));
    	items.add(new InvoiceItem('Milk', 2.15, 5));
    	items.add(new InvoiceItem('Beer', 45.24, 16));
    	return items;
    }

    private String getXML()
    {
		XmlStreamWriter writer = new XmlStreamWriter();
		writer.writeStartDocument('UTF-8', '1.0');
			writer.writeStartElement('', 'GpfRequest', '');
				writer.writeStartElement('', 'AccountNumber', '');
					writer.writeCharacters('108');
				writer.writeEndElement();
				writer.writeStartElement('', 'AuthenticationToken', '');
					writer.writeAttribute('', '', 'Type', 'password');
						writer.writeStartElement('', 'Password', '');
							writer.writeCharacters('bizgate');
						writer.writeEndElement();
				writer.writeEndElement();
				writer.writeStartElement('', 'ProcessId', '');
					writer.writeCharacters('11223344');
				writer.writeEndElement();
				writer.writeStartElement('', 'BzCustomerId', '');
				writer.writeEndElement();
				writer.writeStartElement('', 'CentCost', '');
					writer.writeCharacters('395');
				writer.writeEndElement();
				writer.writeStartElement('', 'CentShipping', '');
					writer.writeCharacters('100');
				writer.writeEndElement();
				writer.writeStartElement('', 'Comment', '');
					writer.writeCharacters('Lorem ipsum dolor sit amet');
				writer.writeEndElement();
				writer.writeStartElement('', 'ReturnUrl', '');
					writer.writeCharacters('http://localhost/SampleGpfAgency/Response.aspx');
				writer.writeEndElement();
				writer.writeStartElement('', 'CustomerReferenceNumber', '');
					writer.writeCharacters('111222333444');
				writer.writeEndElement();
				writer.writeStartElement('', 'PaymentType', '');
					writer.writeCharacters('1');
				writer.writeEndElement();
				writer.writeStartElement('', 'StoringAccountDetailsPrompt', '');
					writer.writeCharacters('true');
				writer.writeEndElement();
				writer.writeStartElement('', 'Items', '');
					for(InvoiceItem item : getItems())
					{
						writer.writeStartElement('', 'Item', '');
							writer.writeStartElement('', 'Name', '');
								writer.writeCharacters(item.Name);
							writer.writeEndElement();
							writer.writeStartElement('', 'ItemCentCost', '');
								writer.writeCharacters(item.Cost);
							writer.writeEndElement();
							writer.writeStartElement('', 'Quantity', '');
								writer.writeCharacters(item.Quantity);
							writer.writeEndElement();
						writer.writeEndElement();
					}
				writer.writeEndElement();
			writer.writeEndElement();
		writer.writeEndDocument();

		Dom.Document doc = new dom.Document();
		doc.load(writer.getXmlString());
		System.Crypto.signXml('RSA-SHA256', doc.getRootElement(), null, 'Bizgate'); 
		return doc.toXmlString(); 
    }

    public class InvoiceItem
    {
    	public InvoiceItem(String pName, Decimal pCost, Decimal pQuantity)
    	{
    		Name = pName;
    		Cost = String.valueOf(pCost);
    		Quantity = String.valueOf(pQuantity);
    	}

    	public String Name
    	{
    		get;
    		private set;
    	}
    	public String Cost
    	{
    		get;
    		private set;
    	}
    	public String Quantity
    	{
    		get;
    		private set;
    	}
    }
}