/*
 * Author: Matt Billups
 * Date: 10/16/18
 * Purpose: Calls a method from a class to publish a platform event for Matson Events 
 *          when a related child (Agenda) is udpated or deleted. Only done on after delete because
 *          there is an existing process builder that publishes the platform event on update.
 */

trigger mm_AgendaPublishPlatformEvent on Event_Days__c (after delete) {

	List<Id> eventIds = new List<Id>();

    List<Event_Days__c> deletedAgendas = Trigger.oldMap.values();
    for(Event_Days__c deletedAgenda : deletedAgendas){
    	//Add the Id of the parent Matson Event to the list
		if(deletedAgenda.Matson_Event__c != NULL) eventIds.add(deletedAgenda.Matson_Event__c);
    }

	//Call the method to run the publishing of events
	if(!eventIds.isEmpty()){
		mm_PublishMatsonEventPlatformEvents.publishEvents(eventIds);
	}
}