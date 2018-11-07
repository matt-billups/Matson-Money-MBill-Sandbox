trigger mm_MatsonEvent_Set_RegistrationEndDate on Event__c (before insert) {
    for (Event__c obj:trigger.new){
         if (obj != null && obj.Event_End_Date__c != null && obj.RegistrationEndDate__c == null) {
            obj.RegistrationEndDate__c =  obj.Event_End_Date__c ;
        }
    }
}