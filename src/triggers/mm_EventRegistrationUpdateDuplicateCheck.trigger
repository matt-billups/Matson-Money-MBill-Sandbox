trigger mm_EventRegistrationUpdateDuplicateCheck on Event_Registration__c (before insert, before update) {
        for (Event_Registration__c obj: trigger.new){
            
            if (obj.Event__c <> Null )
            {
                  
              obj.DuplicateCheckHidden__c = obj.Event__c + ','+ obj.Contact__c ;
            }
            
        
    }
}