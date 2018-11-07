public class mm_AmericanDreamCancelledThrowAway {
    @AuraEnabled
    public static void sendEventCancelledEmail(id EventrecordId, string recordstoskip) {
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        Event__c EVT = [Select Id                             
                        from Event__c where id =:EventrecordId ];
        
        Integer IntRectoSkip = Integer.valueOf(recordstoskip);
        List<Event_Registration__c> EVR = [Select Id, Attendee_First_Name__c,Attendee_Email__c, Adviser_Coach_Email__c, Contact__c
                                           
                                           from Event_Registration__c where Event__c =:EventrecordId AND (Status__c = 'Invited' OR  Status__c = 'Registered') OFFSET :IntRectoSkip ];
        
        List<EmailTemplate> emailTemplates = [Select id, HtmlValue, Body from EmailTemplate where Name = 'Matson Event American Dream Cancelled Email'];
        
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];  
        
        for(Event_Registration__c EVRList : EVR){
            
            
            if (emailTemplates.size() > 0) {
                
                EmailTemplate emailTemplate = emailTemplates[0];
                
                //New instance of a single email message
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                // The email template ID used for the email
                email.setTemplateId(emailTemplate.Id);
                
                String htmlBody = emailTemplate.HtmlValue;
                htmlBody = htmlBody.replace('{!Contact.FirstName}', EVRList.Attendee_First_Name__c);
                htmlBody = htmlBody.replace('{!Contact.Email}', EVRList.Attendee_Email__c);
                
                
                String plainBody = emailTemplate.Body;
                email.setHtmlBody(htmlBody);
                email.setSubject('American Dream Experience Date Change');
                email.setTargetObjectId(EVRList.Contact__c);
                email.setWhatId(EVRList.Id);
                email.setReplyTo(EVRList.Adviser_Coach_Email__c);
                email.setOrgWideEmailAddressId(owa.id);
                email.setSaveAsActivity(true); 
                
                allmsg.add(email);
                //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
                
                
            }
            
        }
        if(!allmsg.isEmpty())
        {
            Messaging.sendEmail(allmsg,false); 
        }
        Else
        {
            system.Debug('SENDING EMAIL THROUGH Cancelled American dream list is empty)'); 
        } 
    }
    
}