trigger EventsTrigger on Event__c (
    after delete, after insert, after update, after undelete, before delete, before insert, before update) {
        
        ApplicationDomain.triggerHandler(Events.class);
        
}