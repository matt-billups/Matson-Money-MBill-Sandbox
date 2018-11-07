/*
 * Author: Matt Billups
 * Date: 10/16/18
 * Purpose: Calls a method from a class to publish a platform event for Matson Events 
 *          when a related child (Event Speaker) is udpated or deleted. Only on after delete because 
 *          Matson Event Speakers process builder does this on update.
 */
trigger mm_EventSpeakerPublishPlatformEvent on Matson_Event_Speaker__c (after insert, after update, after delete) {

	List<Id> eventIds = new List<Id>();

	//Check if this is a delete DML
	if(Trigger.isDelete){
        List<Matson_Event_Speaker__c> deletedSpeakers = Trigger.oldMap.values();
        for(Matson_Event_Speaker__c deletedSpeaker : deletedSpeakers){
        	//Add the Id of the parent Matson Event to the list
			if(deletedSpeaker.Matson_Event__c != NULL) eventIds.add(deletedSpeaker.Matson_Event__c);
        }
	}

	if(Trigger.isInsert || Trigger.isUpdate){
		//Loop through all records in the trigger that are deleted or updated
	 	for(Matson_Event_Speaker__c speaker : Trigger.new){
	 		//Add the Id of the parent Matson Event to the list
	 		if(speaker.Matson_Event__c != NULL) eventIds.add(speaker.Matson_Event__c);
	 	}
 	}

 	//Call the method to run the publishing of events
 	if(!eventIds.isEmpty()){
 		mm_PublishMatsonEventPlatformEvents.publishEvents(eventIds);
 	}
}