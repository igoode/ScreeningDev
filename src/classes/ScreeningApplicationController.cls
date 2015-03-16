global with sharing class ScreeningApplicationController 
{
	private static final String AGED_CARE = 'Aged Care Sector Employment';
	private static final String CHILD_RELATED = 'Child Related Employment';
	private static final String DISABILITY_SERVICES = 'Disability Services Employment';
	private static final String GENERAL_EMPLOYMENT = 'General Employment Probity';
	private static final String VULNERABLE_PERSON = 'Vulnerable Person Related Employment';

	@RemoteAction
	global static List<Application_Declaration_and_Consents__c> getQuestions(String applicationID, String recordTypeName, String applicationTypes)
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
			for(Declaration_and_Consent__c dc : getDefaultQuestions(recordTypeName, applicationTypes))
			{
				Application_Declaration_and_Consents__c adc = new Application_Declaration_and_Consents__c();
				adc.Question_Text__c = dc.Text__c;
				adc.Question_Number__c = ++questionNumber;
				questions.add(adc);
			}
		}
		return questions;
	}

	@RemoteAction
	global static void submitApplications(String applicantID)
	{
		List<Previous_Detail__c> previousDetails = new List<Previous_Detail__c>();
		for(Applicant__c applicant : [SELECT 	Id, 
												Name, 
												Contact__c, 
												Title__c, 
												Current_Last_Name__c, 
												Current_First_Name__c, 
												Current_Middle_Names__c, 
												Gender__c, 
												Town_City_of_Birth__c, 
												State_Territory_of_Birth__c, 
												Country_of_Birth__c, 
												Aboriginal_or_Torres_Strait_Islander__c, 
												Unit_No__c, 
												Street_No__c, 
												Street_Name__c, 
												Suburb_Town__c, 
												State__c, 
												Postcode__c, 
												Period_of_Residence_From__c, 
												Period_of_Residence_To__c, 
												Telephone_H__c, 
												Telephone_W__c, 
												Telephone_M__c, 
												Email_Address__c, 
												Current_Postal_Address__c, 
												Current_Postal_Suburb__c, 
												Current_Postal_State__c, 
												Current_Postal_Postcode__c, 
												Application_Type__c, 
												Date_of_Birth__c, 
												B_Documents__c, 
												X100_Point_Score__c, 
												A_Documents__c, 
												C_Documents__c, 
												Document_Score__c, 
												Referring_Organisation__c,
												(SELECT Id, 
														Name, 
														RecordTypeId, 
														Unit_No__c, 
														Street_No__c, 
														Street_Name__c, 
														Suburb__c, 
														State__c, 
														Postcode__c, 
														Period_of_Residence_From__c, 
														Period_of_Residence_To__c, 
														Applicant__c, 
														Country__c, 
														Type__c, 
														First_and_Middle_Names__c, 
														Last_Name__c, 
														Application__c 
												FROM Previous_Details__r)
										FROM 	Applicant__c 
										WHERE 	Id = :applicantID AND 
												Submitted__c = null])
		{			
			for(String applicationType : applicant.Application_Type__c.split(';'))
			{
				Application__c application = new Application__c(Applicant__c = applicant.ID);
												application.Title__c = applicant.Title__c;
												application.Current_Last_Name__c = applicant.Current_Last_Name__c; 
												application.Current_First_Name__c = applicant.Current_First_Name__c; 
												application.Current_Middle_Names__c = applicant.Current_Middle_Names__c;
												application.Gender__c = applicant.Gender__c ;
												application.Town_City_of_Birth__c = applicant.Town_City_of_Birth__c; 
												application.State_Territory_of_Birth__c = applicant.State_Territory_of_Birth__c ;
												application.Country_of_Birth__c = applicant.Country_of_Birth__c;
												application.Aboriginal_or_Torres_Strait_Islander__c = applicant.Aboriginal_or_Torres_Strait_Islander__c;
												application.Unit_No__c = applicant.Unit_No__c;
												application.Street_No__c = applicant.Street_No__c;
												application.Street_Name__c = applicant.Street_Name__c;
												application.Suburb_Town__c = applicant.Suburb_Town__c;
												application.State__c = applicant.State__c;
												application.Postcode__c = applicant.Postcode__c;
												application.Period_of_Residence_From__c = applicant.Period_of_Residence_From__c;
												application.Period_of_Residence_To__c = applicant.Period_of_Residence_To__c;
												application.Telephone_H__c = applicant.Telephone_H__c;
												application.Telephone_W__c = applicant.Telephone_W__c;
												application.Telephone_M__c = applicant.Telephone_M__c;
												application.Email_Address__c = applicant.Email_Address__c;
												application.Current_Postal_Address__c = applicant.Current_Postal_Address__c;
												application.Current_Postal_Suburb__c = applicant.Current_Postal_Suburb__c;
												application.Current_Postal_State__c = applicant.Current_Postal_State__c;
												application.Current_Postal_Postcode__c = applicant.Current_Postal_Postcode__c;
												application.Application_Type__c = applicant.Application_Type__c;
												application.Date_of_Birth__c = applicant.Date_of_Birth__c;
				insert application;	
				for(Previous_Detail__c pd : applicant.Previous_Details__r)	
				{
					Previous_Detail__c newPd = pd.clone(false, true);
					newPd.Applicant__c = null;
					newPd.Application__c = application.ID;
					previousDetails.add(pd);
				}		
			}
			insert previousDetails;
			applicant.Submitted__c = DateTime.now();
			update applicant;
		}
	}

	private static List<Declaration_and_Consent__c> getDefaultQuestions(String recordTypeName, String applicationTypes)
	{
		List<Declaration_and_Consent__c> declarations = new List<Declaration_and_Consent__c>();
		for(String applicationType : applicationTypes.split(';'))
		{
			if(applicationType == AGED_CARE)
			{
				declarations.add([SELECT 	Ordinal_Aged_Care__c,
											Text__c 
									FROM 	Declaration_and_Consent__c
									WHERE 	RecordType.Name = :recordTypeName AND 
											Ordinal_Aged_Care__c != null
									ORDER BY Ordinal_Aged_Care__c]);
			}
			else if(applicationType == CHILD_RELATED)
			{
				declarations.add([SELECT 	Ordinal_Child_Related__c,
											Text__c 
									FROM 	Declaration_and_Consent__c
									WHERE 	RecordType.Name = :recordTypeName AND 
											Ordinal_Child_Related__c != null
									ORDER BY Ordinal_Child_Related__c]);
			}
			else if(applicationType == DISABILITY_SERVICES)
			{
				declarations.add([SELECT 	Ordinal_Disability_Services__c,
											Text__c 
									FROM 	Declaration_and_Consent__c
									WHERE 	RecordType.Name = :recordTypeName AND 
											Ordinal_Disability_Services__c != null
									ORDER BY Ordinal_Disability_Services__c]);
			}
			else if(applicationType == GENERAL_EMPLOYMENT)
			{
				declarations.add([SELECT 	Ordinal_General_Employment__c,
											Text__c 
									FROM 	Declaration_and_Consent__c
									WHERE 	RecordType.Name = :recordTypeName AND 
											Ordinal_General_Employment__c != null
									ORDER BY Ordinal_General_Employment__c]);
			}
			else if(applicationType == VULNERABLE_PERSON)
			{
				declarations.add([SELECT 	Ordinal_Vulnerable_Person__c,
											Text__c 
									FROM 	Declaration_and_Consent__c
									WHERE 	RecordType.Name = :recordTypeName AND 
											Ordinal_Vulnerable_Person__c != null
									ORDER BY Ordinal_Vulnerable_Person__c]);
			}
		}
		return declarations;
	}
}