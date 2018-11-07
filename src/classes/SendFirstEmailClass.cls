public class SendFirstEmailClass {
    @AuraEnabled
    public static List<EmailMessage> SendCongratFirstStepsEmail(Id parentId)
    {
        EmailTemplate templateId = [Select id, DeveloperName from EmailTemplate where DeveloperName = 'first_step_email'];
        Adviser__c adv = [Select Primary_Contact__c, Adviser_Coach__r.Email from Adviser__c where Id= : parentId];
		List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress Org =  [Select id From OrgWideEmailAddress where Address = 'registration@matsonmoney.com' ][0];
        //New instance of a single email message
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTemplateId(templateId.Id);
        email.setTargetObjectId(adv.Primary_Contact__c);
        email.setWhatId(parentId);
        email.setReplyTo(adv.Adviser_Coach__r.Email);
        email.setOrgWideEmailAddressId(Org.Id);
        email.setSaveAsActivity(true); 
        allmsg.add(email);
        
		 Messaging.sendEmail(allmsg,false); 

        List<EmailMessage> EM =  [Select CreatedBy.Name, MessageDate from EmailMessage where  Subject ='Congratulations On Your First Step!' and  RelatedToId = :parentId];
    
        return EM;
    }
    @AuraEnabled
    public static List<EmailMessage> GetCongratFirstStepsEmail(Id parentId)
    {
        List<EmailMessage> EM =  [Select CreatedBy.Name, MessageDate from EmailMessage where  Subject ='Congratulations On Your First Step!' and  RelatedToId = :parentId];
    
        return EM;
    }
    
}