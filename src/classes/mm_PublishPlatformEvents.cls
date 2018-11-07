public with sharing class mm_PublishMatsonEventPlatformEvents {
	
	public static void publishEvents(List<Id> eventIds) {
		List<Matson_Event_Updated__e> events = new List<Matson_Event_Updated__e>();
		for(Id eventId : eventIds){
			Matson_Event_Updated__e pEvent = new Matson_Event_Updated__e(Event_ID__c = eventId);
			events.add(pEvent);
		}

		//Publish the Platform Events
		List<Database.SaveResult> results = EventBus.publish(events);
		// Inspect publishing result for each event
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