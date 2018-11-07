trigger mm_EventQuestionOptionSetToLocked on EventQuestion__c (after insert, after update) {
    //get recordtype ids
    RecordType RTLocked =[select ID From RecordType where name = 'Locked'and SobjectType='EventQuestionOption__c'];
    RecordType RTInUse =[select ID From RecordType where name = 'In Use'and SobjectType='EventQuestion__c'];
    
    Map < Id,  EventQuestion__c > mapEventQuestion = new Map < Id, EventQuestion__c >();
    List<EventQuestionOption__c> listEventQuestionOption = new List<EventQuestionOption__c>();
    
    //get Ids of Event Questions that are being updated and set to 'In Use' (locked), where the Question options need to be locked.
    for(EventQuestion__c EQ : trigger.new)
        if(EQ.RecordTypeId == RTInUse.id ) 
    {
        mapEventQuestion.put(EQ.Id, EQ); 
    }
   //Find those EventQuestion Options that reference the updated Event Question
    listEventQuestionOption = [ SELECT Event_Question__c, RecordTypeId FROM EventQuestionOption__c WHERE Event_Question__c IN : mapEventQuestion.keySet() ];
    //if that list has records in it, and the recordtype is not already locked, set recordtype to locked
    if ( listEventQuestionOption.size() > 0 ) {
        for ( EventQuestionOption__c EQO : listEventQuestionOption ) {
            EQO.RecordTypeId = RTLocked.Id;
        }
        
        update listEventQuestionOption;
    }
}