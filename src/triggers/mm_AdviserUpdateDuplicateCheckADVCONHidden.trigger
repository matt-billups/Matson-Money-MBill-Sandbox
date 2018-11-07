trigger mm_AdviserUpdateDuplicateCheckADVCONHidden on Adviser__c (before update, before insert) {
 for (Adviser__c obj: trigger.new){
        
        obj.DuplicateCheckADVCONHidden__c = obj.Primary_Contact__c;
 }   
}