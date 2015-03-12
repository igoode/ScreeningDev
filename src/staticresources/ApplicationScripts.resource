var applicationDetailId;
var applicationId;
var activeCallback;
j$ = jQuery.noConflict();
j$(document).ready(function()
{    			
	j$("#inputDOB").datepicker({format: 'dd/mm/yyyy', viewMode: 2});
	j$("[id^='inputResFrom']").datepicker({format: 'dd/mm/yyyy', viewMode: 2});
	j$("[id^='inputResTo']").datepicker({format: 'dd/mm/yyyy', viewMode: 2});
	j$('.alert .close').parent().hide();    			
	j$('.alert .close').click(function(e)
		{
			j$('#errMsg span').html('');
			j$(this).parent().hide();
		});

	j$('[name=100PtAOptions]').change(function()
		{
			j$('#100PtA').html(j$(this).prop('checked') ? 70 : 0);
			var callerID = this.id;
			j$('[name=100PtAOptions]').each(function(index, element)
				{
					if(element.id != callerID) 
					{
						j$(element).prop('checked', false);
					}
				}); 	
			calc100PtTotal();			
		});

	j$('[name=100PtBOptions]').change(function()
		{
			var bScore = 0; 
			j$('[name=100PtBOptions]:checked').each(function(index,element)
				{
					bScore = bScore + (index == 0 ? 40 : 25);
				});

			j$('#100PtB').html(bScore); 
			calc100PtTotal();		 				
		});

	j$('[name=100PtCOptions]').change(function()
		{
			j$('#100PtC').html(j$('[name=100PtCOptions]:checked').length * 25);  
			calc100PtTotal();		 				
		});

	var prevNameRows = 1;
	j$("#addPrevName").click(function()
		{
			j$('#prevName' + prevNameRows).html("<td>"+ (prevNameRows + 1) +"</td><td><input name='prevFirstName" + prevNameRows + "' type='text' placeholder='Previous First Name' class='form-control input-md prevName'  /> </td><td><input  name='prevLastName" + prevNameRows +"' type='text' placeholder='Previous Last Name'  class='form-control input-md prevName'></td>");

			j$('#prevNameTbl').append('<tr id="prevName' + (prevNameRows + 1) + '"></tr>');
			prevNameRows++; 
		});

	j$('#delPrevName').click(function()
		{
			 if(prevNameRows > 1)
			 {
				j$('#prevName' + (prevNameRows - 1)).html('');
				prevNameRows--;
			 }
		});

	j$("#addPrevAddr").click(function()
		{	
			var html = j$('#prevAddrTbl tr:last').html();
			j$('#prevAddrTbl tr:last').after('<tr>' + html + '</tr>');
			var rowId = j$('#prevAddrTbl tr:last td[data-id="rowId"]').text();
			j$('#prevAddrTbl tr:last td[data-id="rowId"]').text(parseInt(++rowId));
			j$("[id^='inputResFrom']").datepicker({format: 'dd/mm/yyyy', viewMode: 2});
			j$("[id^='inputResTo']").datepicker({format: 'dd/mm/yyyy', viewMode: 2});
		});

	j$("#delPrevAddr").click(function()
		{	
			if(j$('#prevAddrTbl tr').length > 1)
			{
				j$('#prevAddrTbl tr:last').remove();
			}
		});

	j$('.nextBtn').click(function ()
		{	   
			switch (this.id)
			{
				case 'nextBtn1':
					saveApplicationDetails();					
					break;		
				case 'nextBtn2':
					savePrevNames();
					break;		
				case 'nextBtn3':
					saveContactDetails();
					break;		
				case 'nextBtn4':
					savePrevAddresses();
					break;		
				case 'nextBtn5':
					saveDeclaration();
					break;		
				case 'nextBtn7':
					saveConsent();
					break;		
				default:
					break;
			} 	
			
		});

	j$('[name=titleRadioOptions]').click(function(event)
		{ 
			if(event.currentTarget.id === 'titleRadio5') 
			{
				j$('[name=other_text]').removeAttr('disabled');
			}
			else 
			{
				j$('[name=other_text]').attr('disabled', 'disabled');
			}
	});	      		
});

function saveApplicationDetails()
{
	var title = j$("input[name=titleRadioOptions]:checked").val();
	if(title == 'Other')
	{
		title = j$("input[name=other_text]").val();
	}
	var applDetails = 	{ 
							Id: applicationDetailId,
							Current_First_Name__c: j$("#firstName").val(), 
							Current_Last_Name__c: j$("#lastName").val(),
							Current_Middle_Names__c: j$("#middleName").val(),
							Title__c: title,
							Gender__c:  j$("input[name=genderRadioOptions]:checked").val(),
							Date_of_Birth__c: getDateObject(j$("#inputDOB").val()),
							Town_City_of_Birth__c: j$("#inputBirthTown").val(),
							State_Territory_of_Birth__c: j$("selBirthState option:selected").text(),
							Country_of_Birth__c: j$("#selBirthCountry option:selected").text(),
							Aboriginal_or_Torres_Strait_Islander__c: getBooleanRadioValue(j$("input[name=atsiRadioOptions]:checked").val())
						};
	var save = new RemoteObjectModel.ApplDetail(applDetails);
	activeCallback = 'ApplicationDetail';
	save.upsert(saveCallback); 			
}

function saveApplication()
{
	var title = j$("input[name=titleRadioOptions]:checked").val();
	if(title == 'Other')
	{
		title = j$("input[name=other_text]").val();
	}
	var applDetails = 	{ 
							Id: applicationId,
							Applicant_Detail__c: applicationDetailId,
							Application_Type__c: j$('#selApplType').val()
						};
	var save = new RemoteObjectModel.Appl(applDetails);
	activeCallback = 'Application';
	save.upsert(saveCallback); 			
}

function saveContactDetails()
{
	var applDetails = 	{ 
							Id: applicationDetailId,
							Unit_No__c: j$('#form3 input[data-name=Unit_No__c]').val(),
							Street_No__c: j$('#form3 input[data-name=Street_No__c]').val(),
							Street_Name__c: j$('#form3 input[data-name=Street_Name__c]').val(),
							Suburb_Town__c: j$('#form3 input[data-name=Suburb_Town__c]').val(),
							State__c: j$('#form3 input[data-name=State__c]').val(),
							Postcode__c: j$('#form3 input[data-name=Postcode__c]').val(),
							Period_of_Residence_From__c: getDateObject(j$('#form3 input[data-name=Period_of_Residence_From__c]').val()),
							Period_of_Residence_To__c: getDateObject(j$('#form3 input[data-name=Period_of_Residence_To__c]').val()),
							Telephone_H__c: j$('#inputConHomePh').val(),
							Telephone_W__c: j$('#inputConWorkPh').val(),
							Telephone_M__c: j$('#inputConMobPh').val(),
							Email_Address__c: j$('#inputConEmail').val(),
							Current_Postal_Address__c: j$('#inputConPostAddr').val(),
							Current_Postal_Suburb__c: j$('#inputConPostSurburb').val(),
							Current_Postal_State__c: j$('#selConPostState option:selected').val(),
							Current_Postal_Postcode__c: j$('#inputConPostPostcode').val()
						};

	var save = new RemoteObjectModel.Appl(applDetails);
	activeCallback = 'ContactDetail';
	save.upsert(saveCallback); 									
}

function saveConsent()
{
	
	/*var applDetails = 	{ 
							Id: applicationId,
							Consent_to_obtain_personal_information__c: getBooleanRadioValue(j$('#form5 input[name=inputConsent]:checked').val())
						}; 	
	updateApplication('Consent', applDetails);*/				
}

function savePrevNames()
{
	j$('#prevNameTbl tr').each(function(index,element)
		{
			if(j$(element).find("input").length > 0)
			{
				var lastName = j$(element).find(".prevName").val();
				if(lastName && lastName.length > 0)
				{
					var prevNameDetails = 	{ 
												Id: j$(element).data('sfID'),
												Application__c: applicationId,
												First_and_Middle_Names__c: j$(element).find(".firstName").val(), 
												Last_Name__c: lastName, 
												Type__c: 'Name'
											};		
					var save = new RemoteObjectModel.PrevRecord(prevNameDetails);
					activeCallback = 'PrevName';
					if(applicationId)
					{
						save.upsert(saveCallback);
					}
				}
			}  
		}); 	
}

function savePrevAddresses()
{
	/*j$('#prevAddrTbl tr').each(function (index, element)
		{
			var addrDetails = 	{ 
									Application__c: applicationId,
									Unit_No__c: j$(element).find('input[data-name=Unit_No__c]').val(),
									Street_No__c: j$(element).find('input[data-name=Street_No__c]').val(),
									Street_Name__c: j$(element).find('input[data-name=Street_Name__c]').val(),
									Suburb__c: j$(element).find('input[data-name=Suburb__c]').val(),
									Country__c: j$(element).find('select[data-name=Country__c] option:selected').val(),
									State__c: j$(element).find('select[data-name=State__c] option:selected').val(),
									Postcode__c:  j$(element).find('input[data-name=Postcode__c]').val(),
									Period_of_Residence_From__c: getDateObject(j$(element).find('input[data-name=Period_of_Residence_From__c]').val()),
									Period_of_Residence_To__c: getDateObject(j$(element).find('input[data-name=Period_of_Residence_To__c]').val()),
									Type__c: 'Address'
								};
			var save = new RemoteObjectModel.PrevRecord(addrDetails);
			activeCallback = 'PrevAddr';
			if(applicationId)
			{
				save.update(saveCallback);
			}
			else
			{
				save.upsert(saveCallback);
			}
		});		*/
j$('#acc5').collapse('toggle');
}	

function saveDeclaration()
{
	/*var declDetails = 	{ 
							Id: applicationId,
							Declaration_1__c: getBooleanRadioValue(j$('#form5 input[name=inputDec1]:checked').val()),
							Declaration_2__c: getBooleanRadioValue(j$('#form5 input[name=inputDec2]:checked').val()),
							Declaration_3__c: getBooleanRadioValue(j$('#form5 input[name=inputDec3]:checked').val()),
							Declaration_4__c: getBooleanRadioValue(j$('#form5 input[name=inputDec4]:checked').val()),
							Declaration_5__c: getBooleanRadioValue(j$('#form5 input[name=inputDec5]:checked').val()),
							Declaration_6__c: getBooleanRadioValue(j$('#form5 input[name=inputDec6]:checked').val()),
							Declaration_7__c: getBooleanRadioValue(j$('#form5 input[name=inputDec7]:checked').val()),
							Declaration_8__c: getBooleanRadioValue(j$('#form5 input[name=inputDec8]:checked').val()),
							Declaration_9__c: getBooleanRadioValue(j$('#form5 input[name=inputDec9]:checked').val())									
						};
	updateApplication('Declaration', declDetails);	*/
}	

function updateApplication(currentStep, applDetails)
{
	var save = new RemoteObjectModel.Appl(applDetails);
	activeCallback = currentStep;
	save.upsert(saveCallback); 
}					

function saveCallback(err, record, event)
{
	if(err) 
	{
		showError(err.message);              	
		return;
	}
	j$('.panel-collapse').removeClass('in');
	switch(activeCallback)
	{
		case 'ApplicationDetail':
			applicationDetailId = record[0];
			saveApplication();
			break;
		case 'Application':
			j$('#acc2').collapse('toggle');
			applicationId = record[0];
			break;
		case 'PrevName':
			j$('#acc3').collapse('toggle');
			return record[0];
			break;
		case 'ContactDetail': 
			j$('#acc4').collapse('toggle');
			break;
		case 'PrevAddr':
			j$('#acc5').collapse('toggle');
			return record[0];
			break;
		case 'Declaration': 
			j$('#acc6').collapse('toggle');
			break;
		case 'Consent':
			j$('#acc8').collapse('toggle');
			break;
		default: 
	}
}

function showError(msg)
{
	j$('#errMsg span').html(msg).parent().show();    
}

function calc100PtTotal()
{
	j$('#100PtTot').html(parseInt(j$('#100PtA').html()) + parseInt(j$('#100PtB').html()) + parseInt(j$('#100PtC').html()));
}

function getDateObject(dtString)
{
	if(dtString)
	{
		return new Date(dtString);
	}
	return;
}

function getBooleanRadioValue(selectedValue)
{
	if(selectedValue)
	{
		return selectedValue == 'Yes';
	}
	return;
}