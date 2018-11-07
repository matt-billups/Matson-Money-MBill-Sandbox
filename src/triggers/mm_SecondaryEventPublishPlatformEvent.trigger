/*
 * Author: Matt Billups
 * Date: 10/16/18
 * Purpose: Calls a method from a class to publish a platform event for Matson Events 
 *          when a related child (Secondary Event) is udpated or deleted
 */
trigger mm_SecondaryEventPublishPlatformEvent on Event__c (after update, after delete ) {

	List<Id> eventIds = new List<Id>();
	
	//Check if this is a delete DML
	if(Trigger.isDelete){
        List<Event__c> deletedEvents = Trigger.oldMap.values();
        for(Event__c deletedEvent : deletedEvents){
        	//Add the Id of the parent Matson Event to the list
			if(deletedEvent.Primary_Matson_Event__c != NULL) eventIds.add(deletedEvent.Primary_Matson_Event__c);
        }
	}

	//Check if this is an update DML
	if(Trigger.isUpdate){
		//Loop through all records in the trigger that are deleted or updated
		for(Event__c e : Trigger.new){
			//Add the Id of the parent Matson Event to the list
			if(e.Primary_Matson_Event__c != NULL) eventIds.add(e.Primary_Matson_Event__c);
		}
	}

	//Call the method to run the publishing of events
	if(!eventIds.isEmpty()){
		mm_PublishMatsonEventPlatformEvents.publishEvents(eventIds);
	}
}