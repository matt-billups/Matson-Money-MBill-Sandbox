/*
 * Author: Matt Billups
 * Date: 11/5/2018
 * Purpose: Create a new Fulfillment Request and related Task to send out the welcome kit for a Kids Camp registrant
 */
trigger mm_EventRegistrationCreateKidsCampWelcomeKitTask on Event_Registration__c (after insert, after update) 
{
	List<Task> tasksToInsert = new List<Task>();
	List<Fulfillment_Request__c> requestsToInsert = new List<Fulfillment_Request__c>();

	Product2 pieDay = [SELECT Id, Name FROM Product2 WHERE Name = 'Pie Day Welcome Kit'];
	Product2 economics = [SELECT Id, Name FROM Product2 WHERE Name = 'Let\'s Chat About Economics'];

	if(Trigger.isInsert){
		for(Event_Registration__c reg : Trigger.new){
			if(reg.Event__r.Secondary_Event_Type__c == 'Kids Program' && (reg.Attendee_Type__c == 'Kid age 3-7' || reg.Attendee_Type__c == 'Kid age 8-12')){

				Fulfillment_Request__c r = new Fulfillment_Request__c();

				if(reg.Attendee_Type__c == 'Kid age 3-7'){
					r.Product__c = pieDay.Id;
				}
				else if(reg.Attendee_Type__c == 'Kid age 8-12'){
					r.Product__c = economics.Id;
				}
				else{
					continue;
				}

				Task t = new Task();
				t.Subject = 'Send Kids Camp Welcome Kit';
				t.ActivityDate = Date.today();	
				t.WhatId = r.Id;

				requestsToInsert.add(r);
				tasksToInsert.add(t);
			}
		}


		//Database.saveResult[] results = Database.insert(requestsToInsert, TRUE);
		//Integer count = 0;
		//for(saveResult result : results){
		//	if(result.isSuccess){
		//		tasksToInsert[count].WhatId = result.getId();
		//	}
		//}

		for(Integer i = 0; i < requestsToInsert.size(); i++){
			tasksToInsert[i].WhatId = requestsToInsert[i].Id;
		}
	}
}