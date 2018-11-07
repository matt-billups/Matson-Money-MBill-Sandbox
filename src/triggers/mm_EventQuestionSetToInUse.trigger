trigger mm_EventQuestionSetToInUse on EventEventQuestion__c (after insert, after update) {
    //get recordtype ids
    RecordType RTInUse =[select ID From RecordType where name = 'In Use'and SobjectType='EventQuestion__c'];
    
    //get eventquestion records that are used in the EventEventQuestion in the trigger
    
    Set<Id> questionIds = new Set<Id>();
    for (EventEventQuestion__c EEQ : Trigger.new) {
        if (EEQ.Event_Question__c != null) {
            questionIds.add(EEQ.Event_Question__c);
        }
    } 
    // keep query outside for loop
    Map<Id, EventQuestion__c> eventquestions = new Map<Id, EventQuestion__c> ([select Id, RecordTypeId  from EventQuestion__c where Id in :questionIds ]);
    
    //Update the EventQuestion record to In Use  
    for (EventEventQuestion__c EEQ: trigger.new){
        if (EEQ.Event_Question__c != null){
            EventQuestion__c EQ =  eventquestions.get(EEQ.Event_Question__c) ;
            //if Event Question record type is not InUse then set to InUse
            If(EQ.RecordTypeId <> RTInUse.Id){
                EQ.RecordTypeId = RTInUse.Id;
                update EQ; 
            }
            
        }
        
    }
    
}