/*
 * Author: Matt Billups
 * Date: 10/16/18
 * Purpose: Calls a method from a class to publish a platform event for Matson Events 
 *          when a related child (Event Hotel) is udpated or deleted
 */
trigger mm_HotelPublishPlatformEvent on Event_Hotel__c (after delete) {

	List<Id> eventIds = new List<Id>();

    List<Event_Hotel__c> deletedHotels = Trigger.oldMap.values();
    for(Event_Hotel__c deletedHotel : deletedHotels){
    	//Add the Id of the parent Matson Event to the list
		if(deletedHotel.Matson_Event__c != NULL) eventIds.add(deletedHotel.Matson_Event__c);
    }

 	//Call the method to run the publishing of events
 	if(!eventIds.isEmpty()){
 		mm_PublishMatsonEventPlatformEvents.publishEvents(eventIds);
 	}
}