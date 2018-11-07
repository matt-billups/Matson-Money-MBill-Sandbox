trigger mm_DeleteEEQWhenParentMatsonEventDeleted on Event__c (before delete) {
    //Loop through all records in the Trigger.new collection of deleted events
    //To store parent ids
    list<id> EventIds=new list<id>();
    for(Event__c eventVar:trigger.old)
    {
        EventIds.add(eventVar.id);
    }  
    //Collecting all child records related to Parent records
    list<EventEventQuestion__c> listOfEventEventQuestion=[select id from EventEventQuestion__c where Matson_Event__c in :EventIds];
    
    //deleting child records
    delete listOfEventEventQuestion;
    
}