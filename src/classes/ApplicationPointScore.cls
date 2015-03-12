public class ApplicationPointScore 
{
   	@InvocableMethod(label='Calculate Score')
   	public static List<DocumentScore> getDocumentScore(List<ID> applicationID) 
   	{
       List<DocumentScore> results = new List<DocumentScore>();
        /*Integer classBCategories = 0;
        for(Document__c d : [SELECT ID, Type__c FROM Document__c WHERE Application__c = :applicationID])
        {
			DocumentScore ds = new DocumentScore();
		    if(d.Category__c == 'A')
		    {
		    	ds.Score += 70;
		    }
		    else if(d.Category__c == 'B')
		    {
		    	classBCategories++;
		    	ds.Score += classBCategories <= 1 ? 40 : 25;
		    }
		    else if(d.Category__c == 'C')
		    {
		    	ds.Score += 25;
		    }
		    results.add(ds);
      	}*/
      	return results;
   }

   public class DocumentScore
   {
   		public DocumentScore()
   		{
   			score = 0;
   		}

   		@InvocableVariable(required=true)
   		public Integer score;
   }
}