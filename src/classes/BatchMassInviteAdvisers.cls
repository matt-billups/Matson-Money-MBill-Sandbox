// Tested by mm_MassAdviserInviteControllerTest

global class BatchMassInviteAdvisers implements Database.Batchable<sObject>, Database.Stateful
{
    String query;
    String eventId;
    String[] adviserIds;
    Integer recordsProcessed = 0;
    Integer successfulInvites = 0;
    
    global BatchMassInviteAdvisers(String q, String event, String[] advisers)
    {
        query = q;
        eventId = event;
        adviserIds = advisers;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Adviser__c> scope)
    {
        List<Event_Registration__c> regsToBeInserted = new List<Event_Registration__c>();
        
        for (Adviser__c adv : scope)
        {
            Event_Registration__c reg = new Event_Registration__c();
            reg.Reg_Adviser__c = adv.Id;
            reg.Event__c = eventId;
            reg.Status__c = 'Invited';
            reg.Attendee_Type__c = 'Adviser';
            
            regsToBeInserted.add(reg);
            recordsProcessed++;
        }
        
        insert regsToBeInserted;
        successfulInvites = successfulInvites + regsToBeInserted.size();
    }
    
    global void finish(Database.BatchableContext bc)
    {
        OrgWideEmailAddress owa = [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress LIMIT 1];
        
        // Send completion email
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setToAddresses(new List<String> { UserInfo.getUserEmail() });
        msg.setSenderDisplayName('Mass Invite Advisers Processing');
        msg.setSubject('Requested Job Completed');
        msg.setPlainTextBody('Successfully sent ' + successfulInvites + ' of ' + recordsProcessed + ' invites.');
        
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { msg });
    }
}