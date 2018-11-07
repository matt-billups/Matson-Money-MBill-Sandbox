trigger SendEmailEventTrigger on Send_Email__e (after insert) {

    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

    OrgWideEmailAddress orgEmailAddress = ((IOrgWideEmailAddressesSelector)Application.Selector.newInstance(OrgWideEmailAddress.SObjectType)).getRegistrationEmailAddress();
    List<EmailTemplate> templates = ((IEmailTemplatesSelector)Application.Selector.newInstance(EmailTemplate.SObjectType)).selectAll();
    List<EmailTemplateLookupTable__c> emailTemplateLookupTables = ((IEmailTemplateLookupTableSelector)EmailTemplateLookupTableSelector.newInstance()).selectAll();
        
    Set<Id> setOfContactIDs = new Set<Id>();
    //Get all contact ID that are used
    for(Send_Email__e sendEmailEvent : Trigger.New){
        setOfContactIDs.add(sendEmailEvent.Contact_Id__c);
    }  
    system.debug('setOfContactIDs' + setOfContactIDs);
    List<contact> Contacts = ((IContactsSelector)PhoenixCore.Selector.newInstance(Contact.SobjectType)).selectById(setOfContactIDs);
                             
    system.debug('Contacts' + Contacts);
    Map<string,Id> mapOfTemplates = new Map<string, ID>();
    //set mapOfTemplates
    for(EmailTemplate template : templates)
    {
        mapOfTemplates.put(template.Name, template.Id);
    }
    
    Map<string, string> mapOfEmailTemplateTable = new Map<string,string>();
    // set mapOfEmailTemplateTable
    for(EmailTemplateLookupTable__c emailTempLookupTable : emailTemplateLookupTables )
    {
        mapOfEmailTemplateTable.put(emailTempLookupTable.Name,  emailTempLookupTable.EmailTemplateType__c);
    }
    
    Map<string, boolean> mapOfContacts = new Map<string, boolean>();
    //set mapOfContacts
    for(Contact con : Contacts)
    {
        mapOfContacts.put(con.id, con.Matson_Event_Marketing_Email_Opt_Out__c);
    }
    system.debug(mapOfContacts);
    //Start Trigger
    for(Send_Email__e sendEmailEvent : Trigger.New) {
        
       
        Id templateId = mapOfTemplates.get(sendEmailEvent.EmailTemplateName__c);
        string emailTemplateType = mapOfEmailTemplateTable.get(sendEmailEvent.EmailTemplateName__c);
        
        system.debug('templateId' + templateId);
        system.debug('emailTemplateType'+ emailTemplateType);
        
        
        if(templateId == null ||emailTemplateType == null ) {
            throw new fflib_Application.DeveloperException('Email Template ' + sendEmailEvent.EmailTemplateName__c + ' Not Found!');
        }

        //Create emails
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTemplateId(templateId);
        email.setTargetObjectId(sendEmailEvent.Contact_Id__c);
        email.setWhatId(sendEmailEvent.WhatId__c);
        email.setOrgWideEmailAddressId(orgEmailAddress.Id);
        email.setSaveAsActivity(true);

        //Fliter out emails to not send
        system.debug('should return false' + isContactOptedOutOfEmail(sendEmailEvent.Contact_Id__c, emailTemplateType));
        if(isTranactionalEmail( emailTemplateType) || (!isTranactionalEmail( emailTemplateType) && !isContactOptedOutOfEmail(sendEmailEvent.Contact_Id__c, emailTemplateType) ))
        {
            uow.registerEmail(email);
        }
    }
    //send the emails
    uow.commitWork();

    public static boolean isTranactionalEmail(string emailTemplateType)
    {

        return emailTemplateType =='Transactional';
    }

    public boolean isContactOptedOutOfEmail(Id contactId, string emailTemplateType ){
        
    boolean isContactMatsonEventMarketingEmailOptOut = mapOfContacts.get(contactId);
        system.debug('isContactMatsonEventMarketingEmailOptOut' + isContactMatsonEventMarketingEmailOptOut);
        if(isEmailTemplateTypeMatsonEventMarketing(emailTemplateType) && isContactMatsonEventMarketingEmailOptOut){
            return true;
        }
        else{
            return false;
        }
    }

    public boolean isEmailTemplateTypeMatsonEventMarketing(string emailTemplateType){
        return emailTemplateType == 'Matson Event Marketing';
    }

}