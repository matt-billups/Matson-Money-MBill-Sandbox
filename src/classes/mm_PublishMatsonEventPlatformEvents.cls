/*
* Author: Matt Billups
* Date: 10/16/18
* Purpose: Contains a method that publishes Platform Events for Matson Events when a child object is updated or deleted.
*/

public without sharing class mm_PublishMatsonEventPlatformEvents {
    
    public static void publishEvents(List<Id> eventIds) {
        Set<Matson_Event_Updated__e> platformEventsSet = new Set<Matson_Event_Updated__e>();

        //Loop through the list of Event Ids and assign the value to a new Platform Event record
        
        for(Id eventId : eventIds){
           
            Matson_Event_Updated__e pEvent = new Matson_Event_Updated__e(Event_ID__c = eventId);
            if(!platformEventsSet.contains(pEvent)) platformEventsSet.add(pEvent);
        }
        
        //Publish the Platform Events
        List<Matson_Event_Updated__e> platformEventsList = new List<Matson_Event_Updated__e>();
        platformEventsList.addAll(platformEventsSet);
        List<Database.SaveResult> results = EventBus.publish(platformEventsList);
        //Inspect publishing result for each event
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                System.debug('Successfully published event.');
            } else {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('Error returned: ' +
                                 err.getStatusCode() +
                                 ' - ' +
                                 err.getMessage());
                }
            }      
        }

    }
}