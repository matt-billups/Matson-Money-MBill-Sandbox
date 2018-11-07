/*
 * Author: Matt Billups
 * Date: 10/17/18
 * Purpose: Calls a method from a class to publish a platform event for Matson Events 
 *          when a related child (Custom Tab) is udpated or deleted
 */

trigger mm_CustomTabPublishPlatformEvent on Custom_Tab__c (after insert, after update, after delete) {

	List<Id> eventIds = new List<Id>();

	//Check if this is a delete DML
	if(Trigger.isDelete){
        List<Custom_Tab__c> deletedTabs = Trigger.oldMap.values();
        for(Custom_Tab__c deletedTab : deletedTabs){
        	//Add the Id of the parent Matson Event to the list
			if(deletedTab.Matson_Event__c != NULL) eventIds.add(deletedTab.Matson_Event__c);
        }
	}

	if(Trigger.isInsert || Trigger.isUpdate){
		//Loop through all records in the trigger that are deleted or updated
	 	for(Custom_Tab__c tab : Trigger.new){
	 		//Add the Id of the parent Matson Event to the list
	 		if(tab.Matson_Event__c != NULL) eventIds.add(tab.Matson_Event__c);
	 	}
 	}

 	//Call the method to run the publishing of events
 	if(!eventIds.isEmpty()){
 		mm_PublishMatsonEventPlatformEvents.publishEvents(eventIds);
 	}
}