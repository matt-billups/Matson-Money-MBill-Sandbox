trigger One_Fetured_Hotel_Per_Event on Event_Hotel__c (before Update, before Insert) {
    
    set<string> eventIds = new set<string>();
    set<Id> EventsWithFeaturedHotels = new set<ID>();
    map<Id,Id> EventsWithFeaturedHotelsMAp = new map<Id,Id>();
    
         for(Event_Hotel__c eventHotel: Trigger.new)
     {    
         if(eventHotel.Featured__c)
         {
           eventIds.add(eventHotel.Matson_Event__c);  
         }     
     }
    
   List<Event_Hotel__c> EventHotelsWithSameEventAndFeatured = [select id, Featured__c, Matson_Event__c
              from Event_Hotel__c where Matson_Event__c in :eventIds and Featured__c = true ];
    
    for(Event_Hotel__c eventHotel : EventHotelsWithSameEventAndFeatured)
    {
        EventsWithFeaturedHotels.add(eventHotel.Matson_Event__c);  
		EventsWithFeaturedHotelsMAp.put(eventHotel.Matson_Event__c , eventHotel.Id); 
    }
        
     for(Event_Hotel__c EventHotel: Trigger.new)
     {    
         string eventID = eventHotel.Matson_Event__c;
         if(EventHotel.Featured__c && EventsWithFeaturedHotels.contains(eventHotel.Matson_Event__c) && EventsWithFeaturedHotelsMAp.get(EventHotel.Matson_Event__c) != EventHotel.id )
         {            
            EventHotel.addError('Only one featured hotel can be selected per event.');
         }
     }            
}