trigger mm_PreventDuplicateEventEventQuestionsonEvent on EventEventQuestion__c (before insert, before update) {
    for(EventEventQuestion__c obj: trigger.new){
        obj.EventEventQuestionDupeCheckHidden__c = obj.Event_Question__c;
        
    } 
}