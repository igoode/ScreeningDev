trigger trgApplication_BI on Application__c(before insert) 
{
	Map<String, RecordType> recordTypesByName = new Map<String, RecordType>();
	for(RecordType rt : [SELECT ID, 
								Name 
						FROM 	RecordType 
						WHERE 	sObjectType = 'Application__c'])
	{
		recordTypesByName.put(rt.Name, rt);
	}
	for(Application__c appl : Trigger.new)
	{
		if(String.isNotBlank(appl.Application_Type__c))
		{
			appl.RecordTypeId = recordTypesByName.get(appl.Application_Type__c).ID;
		}
	}
}