/*
 * Author: Matt Billups
 * Date: 10/16/18
 * Purpose: Calls a method from a class to publish a platform event for Matson Events 
 *          when a related child (Event Registration) is udpated or deleted
 */

trigger mm_EventRegistrationPublishPlatformEvent on Event_Registration__c (after update, after delete) {

	List<Id> eventIds = new List<Id>();

	//Check if this is a delete DML
	if(Trigger.isDelete){
        List<Event_Registration__c> deletedRegs = Trigger.oldMap.values();
        for(Event_Registration__c deletedReg : deletedRegs){
        	//Add the Id of the parent Matson Event to the list
			if(deletedReg.Event__c != NULL && !eventIds.contains(deletedReg.Event__c)) eventIds.add(deletedReg.Event__c);
        }
	}

	if(Trigger.isUpdate){
		//Loop through all records in the trigger that are deleted or updated
 		for(Event_Registration__c er : Trigger.new){
 			//Add the Id of the parent Matson Event to the list
 			if(er.Event__c != NULL && !eventIds.contains(er.Event__c)) eventIds.add(er.Event__c);
 		}
	}

 	//Call the method to run the publishing of events
 	
 	if(!eventIds.isEmpty()){
 		mm_PublishMatsonEventPlatformEvents.publishEvents(eventIds);
	}
}