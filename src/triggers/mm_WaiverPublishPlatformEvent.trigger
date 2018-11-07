/*
 * Author: Matt Billups
 * Date: 10/17/18
 * Purpose: Calls a method from a class to publish a platform event for Matson Events 
 *          when a related child (Event Waiver) is udpated or deleted
 */

trigger mm_WaiverPublishPlatformEvent on Event_Waiver__c (after update, after delete) {
	
	List<Id> eventIds = new List<Id>();

	//Check if this is a delete DML
	if(Trigger.isDelete){
        List<Event_Waiver__c> deletedWaivers = Trigger.oldMap.values();
        for(Event_Waiver__c deletedWaiver : deletedWaivers){
        	//Add the Id of the parent Matson Event to the list
			if(deletedWaiver.Matson_Event__c != NULL) eventIds.add(deletedWaiver.Matson_Event__c);
        }
	}

	if(Trigger.isUpdate){
		//Loop through all records in the trigger that are deleted or updated
	 	for(Event_Waiver__c waiver : Trigger.new){
	 		//Add the Id of the parent Matson Event to the list
	 		if(waiver.Matson_Event__c != NULL) eventIds.add(waiver.Matson_Event__c);
	 	}
 	}

 	//Call the method to run the publishing of events
 	if(!eventIds.isEmpty()){
 		mm_PublishMatsonEventPlatformEvents.publishEvents(eventIds);
 	}
}