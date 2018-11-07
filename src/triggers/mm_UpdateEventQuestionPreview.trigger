trigger mm_UpdateEventQuestionPreview on EventEventQuestion__c (before insert) {
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
    Map<Id, EventQuestion__c> eventquestions = new Map<Id, EventQuestion__c> ([select Id, Question_Text__c   from EventQuestion__c where Id in :questionIds ]);
    
    //Update the EventQuestion record to In Use  
    for (EventEventQuestion__c EEQ: trigger.new){
        if (EEQ.Event_Question__c != null){
            EventQuestion__c EQ =  eventquestions.get(EEQ.Event_Question__c) ;
            //if Event_Question_Preview__c is not equal to the QuestionText
            If(EQ.Question_Text__c <> EEQ.Event_Question_Preview__c){
                if (EQ.Question_Text__c.length()>255)
                {
                    EEQ.Event_Question_Preview__c = EQ.Question_Text__c.substring(0,255);
                }
                Else{
                    EEQ.Event_Question_Preview__c = EQ.Question_Text__c;
                }

            }
            
        }
        
    }

}