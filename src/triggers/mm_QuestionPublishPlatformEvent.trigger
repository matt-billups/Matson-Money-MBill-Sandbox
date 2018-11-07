/*
 * Author: Matt Billups
 * Date: 10/17/18
 * Purpose: Calls a method from a class to publish a platform event for Matson Events 
 *          when a related child (Event Question) is udpated or deleted. Only done on after delete 
 *          because thee Even Event Question process builders does this on update.
 */

trigger mm_QuestionPublishPlatformEvent on EventEventQuestion__c (after delete) {

List<Id> eventIds = new List<Id>();

	//Check if this is a delete DML
	if(Trigger.isDelete){
        List<EventEventQuestion__c> deletedQuestions = Trigger.oldMap.values();
        for(EventEventQuestion__c deletedQuestion : deletedQuestions){
        	//Add the Id of the parent Matson Event to the list
			if(deletedQuestion.Matson_Event__c != NULL) eventIds.add(deletedQuestion.Matson_Event__c);
        }
	}

 	//Call the method to run the publishing of events
 	if(!eventIds.isEmpty()){
 		mm_PublishMatsonEventPlatformEvents.publishEvents(eventIds);
 	}
}