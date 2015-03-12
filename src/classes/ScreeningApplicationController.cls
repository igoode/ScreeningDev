global with sharing class ScreeningApplicationController 
{
	private static final String AGED_CARE = 'Aged Care Sector Employment';
	private static final String CHILD_RELATED = 'Child Related Employment';
	private static final String DISABILITY_SERVICES = 'Disability Services Employment';
	private static final String GENERAL_EMPLOYMENT = 'General Employment Probity';
	private static final String VULNERABLE_PERSON = 'Vulnerable Person Related Employment';

	@RemoteAction
	global static List<Application_Declaration_and_Consents__c> getQuestions(String applicationID, String recordTypeName, String applicationType)
	{
		List<Application_Declaration_and_Consents__c> questions = new List<Application_Declaration_and_Consents__c>();

		questions = [SELECT 	ID,
									Question_Text__c,
									Response__c,
									Question_Number__c
							FROM	Application_Declaration_and_Consents__c
							WHERE 	Application__c = :applicationID
							ORDER BY Question_Number__c];

		if(questions.isEmpty())
		{
			Integer questionNumber = 0;
			for(Declaration_and_Consent__c dc : getDefaultQuestions(recordTypeName, applicationType))
			{
				Application_Declaration_and_Consents__c adc = new Application_Declaration_and_Consents__c();
				adc.Question_Text__c = dc.Text__c;
				adc.Question_Number__c = ++questionNumber;
				questions.add(adc);
			}
		}
		return questions;
	}

	private static List<Declaration_and_Consent__c> getDefaultQuestions(String recordTypeName, String applicationType)
	{
		if(applicationType == AGED_CARE)
		{
			return [SELECT 	Ordinal_Aged_Care__c,
							Text__c 
					FROM 	Declaration_and_Consent__c
					WHERE 	RecordType.Name = :recordTypeName AND 
							Ordinal_Aged_Care__c != null
					ORDER BY Ordinal_Aged_Care__c];
		}
		else if(applicationType == CHILD_RELATED)
		{
			return [SELECT 	Ordinal_Child_Related__c,
							Text__c 
					FROM 	Declaration_and_Consent__c
					WHERE 	RecordType.Name = :recordTypeName AND 
							Ordinal_Child_Related__c != null
					ORDER BY Ordinal_Child_Related__c];
		}
		else if(applicationType == DISABILITY_SERVICES)
		{
			return [SELECT 	Ordinal_Disability_Services__c,
							Text__c 
					FROM 	Declaration_and_Consent__c
					WHERE 	RecordType.Name = :recordTypeName AND 
							Ordinal_Disability_Services__c != null
					ORDER BY Ordinal_Disability_Services__c];
		}
		else if(applicationType == GENERAL_EMPLOYMENT)
		{
			return [SELECT 	Ordinal_General_Employment__c,
							Text__c 
					FROM 	Declaration_and_Consent__c
					WHERE 	RecordType.Name = :recordTypeName AND 
							Ordinal_General_Employment__c != null
					ORDER BY Ordinal_General_Employment__c];
		}
		else if(applicationType == VULNERABLE_PERSON)
		{
			return [SELECT 	Ordinal_Vulnerable_Person__c,
							Text__c 
					FROM 	Declaration_and_Consent__c
					WHERE 	RecordType.Name = :recordTypeName AND 
							Ordinal_Vulnerable_Person__c != null
					ORDER BY Ordinal_Vulnerable_Person__c];
		}
		return new List<Declaration_and_Consent__c>();
	}
}