public class mm_ResendInviteEmail {
    @AuraEnabled
    public static void sendEmail(Id recordId) {
        
        IMatsonEventRegistrationsSelector selector = ((IMatsonEventRegistrationsSelector)Application.Selector.newInstance(Event_Registration__c.SObjectType));
        Event_Registration__c eventRegistration =  selector.selectRegistrationWithEventFieldsById(recordId);


        List<Send_Email__e> resendInvitedEmail = new List<Send_Email__e>();
        resendInvitedEmail.add(new Send_Email__e(Contact_Id__c = eventRegistration.Contact__c,
                                                 EmailTemplateName__c = eventRegistration.Event__r.Email_Invite_Template__c,
                                                 WhatId__c = eventRegistration.Id));
        List<Database.SaveResult> results = EventBus.publish(resendInvitedEmail);
        
    }
    
}