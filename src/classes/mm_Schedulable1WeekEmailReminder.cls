global class mm_Schedulable1WeekEmailReminder implements Schedulable
{
    global void execute(SchedulableContext SC) 
    {
        
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
        
        List<EmailTemplate> emailTemplates = emailTemplatesSelector().selectAll();
        
        Map<String, string> allTemplatesMap = getAllEmailTemplateIdandTemplateNameMap(emailTemplates);
        Map<Id, string> mapOFEmailTemplateIdandHTML = getAllEmailTemplateIdandHTML(emailTemplates);
        
        OrgWideEmailAddress orgEmailAddress = orgWideEmailAddressesSelector().getRegistrationEmailAddress();
        
        date eventStartDate = getEventStartDate();
        
        List<Event_Registration__c> listOfRegistrations = getEventRegistrations(eventStartDate);
        
        
        //get set of unque Event Ids. 
        Map<Id, string> mapOfEventIDAndAgenda = new Map<Id, string>();
        for(Event_Registration__c eventRegistration :listOfRegistrations){
            
            if((mapOfEventIDAndAgenda.size() > 0 && !mapOfEventIDAndAgenda.containsKey(eventRegistration.Event__c))|| mapOfEventIDAndAgenda.size() < 1 ){
                
                PageReference emailAgendaPage= Page.EmailAgenda;
                emailAgendaPage.getParameters().put('EventId', eventRegistration.Event__c);
                string agendaHTMLSTring;
                
                if(!Test.isRunningTest())
               {
                 agendaHTMLSTring = emailAgendaPage.getContent().toString();   
               }
                else{
                    agendaHTMLSTring = '<input type="hidden" name="j_id0:j_id1" value="j_id0:j_id1" /> </form>';
                }
                
                agendaHTMLSTring = agendaHTMLSTring.substringAfterLast('<input type="hidden" name="j_id0:j_id1" value="j_id0:j_id1" />');
                agendaHTMLSTring = agendaHTMLSTring.substringBefore('</form>');
                
                mapOfEventIDAndAgenda.put(eventRegistration.Event__c, agendaHTMLSTring);
            }          
        }
        
        sendEmails(listOfRegistrations, uow, orgEmailAddress.Id, allTemplatesMap, mapOFEmailTemplateIdandHTML, mapOfEventIDAndAgenda );
    }
    
    private Date getEventStartDate() {
        date todaysDate;
        List <Test_Mode__c> test = [Select Name, System_Test_Date__c ,isTestMode__c From Test_Mode__c limit 1];
        
        
        if(!test.isEmpty() && test[0].isTestMode__c == True )
        {
            todaysDate = test[0].System_Test_Date__c;
        }
        else
        {
            todaysDate = system.today();
        }
        
        return todaysDate.addDays(3);
    }
    
    private List<Event_Registration__c> getEventRegistrations(Date eventStartDate) {
        
        return eventRegistrationsSelector().selectActiveEFT1RegistationByEventStartDate(eventStartDate);
    }
    
    private void sendEmails(List<Event_Registration__c> listOfRegistrations, fflib_ISObjectUnitOfWork uow, Id orgWideEmailAddressId, Map<string, string> allTemplatesMap, Map<Id, string> mapOFEmailTemplateIdandHTML, Map<Id, string> mapOfEventIDAndAgenda) {
        List<Messaging.SingleEmailMessage> listOfEmails = new List<Messaging.SingleEmailMessage>();
         system.debug('mapOFEmailTemplateIdandHTM' + mapOFEmailTemplateIdandHTML);
         system.debug('allTemplatesMap' +allTemplatesMap);
        
        for(Event_Registration__c registration : listOfRegistrations)
        {          
            Id emailTemplateId = allTemplatesMap.get(registration.Event__r.Email_Reminder_1_Week_Template__c);
            system.debug('Registration'+ registration);
            string HTMLAgenda  = mapOfEventIDAndAgenda.get(registration.Event__c);
            system.debug(HTMLAgenda);
            string emailHTML = mapOFEmailTemplateIdandHTML.get(emailTemplateId);
            system.debug(emailHTML);
             uow.registerEmail(createEmailMessage(registration, orgWideEmailAddressId, emailTemplateId, HTMLAgenda, emailHTML ));
        }
     
       
         uow.commitWork();
    }
    
    private string placeAgendaInEmailHTML(string emailHTML, string HTMLAgenda ){
        system.debug(emailHTML.indexOf('{AgendaGoesHere}'));
        return emailHTML.replace('{AgendaGoesHere}', HTMLAgenda); 
    }
    
    private void publishSendEmailEvents(List<Event_Registration__c> listOfRegistrations) {
        
        List<Send_Email__e> listOfSendEmailEvents = new List<Send_Email__e>();
        
        for(Event_Registration__c registration : listOfRegistrations)
        {
            listOfSendEmailEvents.add(new Send_Email__e(Contact_Id__c = registration.Contact__c,
                                                        EmailTemplateName__c = registration.Event__r.Email_Reminder_1_Week_Template__c,
                                                        WhatId__c = registration.Id));       
        }
        
        List<Database.SaveResult> results = EventBus.publish(listOfSendEmailEvents);
    }
    
    private Messaging.Email createEmailMessage(Event_Registration__c eventRegistration, Id orgWideEmailAddressId, Id emailTemplateId, string agendaHTML, string emailHTML) {
       
        emailHTML = emailHTML.replace('{!Event__c.Name}', eventRegistration.Event__r.Name);
       	emailHTML = emailHTML.replace('{!Event_Registration__c.Attendee_First_Name__c}', eventRegistration.Attendee_First_Name__c);
        emailHTML = emailHTML.replace('{!Event__c.Email_Reminder_1_Week_Body__c}',eventRegistration.Event__r.Email_Reminder_1_Week_Body__c);
        emailHTML = emailHTML.replace('{!Event__c.Event_Start_Date__c}', eventRegistration.Event__r.Formatted_Start_Date__c);
        emailHTML = emailHTML.replace('{!Event__c.Event_End_Date__c}', eventRegistration.Event__r.Formatted_End_Date__c);
        emailHTML = placeAgendaInEmailHTML(emailHTML, agendaHTML);      
        emailHTML = emailHTML.replace('{!Event__c.Venue__c}', eventRegistration.Venue_Name__c);
        emailHTML = emailHTML.replace('{!Event__c.Venue_Street_Address_1__c}' , eventRegistration.Event__r.Venue_Street_Address_1__c);
        emailHTML = emailHTML.replace('{!Event__c.Venue_City__c}', eventRegistration.Event__r.Venue_City__c);
        emailHTML = emailHTML.replace('{!Event__c.Venue_State__c}', eventRegistration.Event__r.Venue_State__c);
        emailHTML = emailHTML.replace('{!Event__c.Venue_Postal_Code__c}', eventRegistration.Event__r.Venue_Postal_Code__c);
        emailHTML = emailHTML.replace('{!UPDATEREG}', eventRegistration.Registration_Site_URL__c);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setHtmlBody(emailHTML);
        email.setTargetObjectId(eventRegistration.Contact__c);
        email.setWhatId(eventRegistration.Id);
        email.setOrgWideEmailAddressId(orgWideEmailAddressId);
        email.setSaveAsActivity(true); 
        email.setSubject('Reminder - '+ eventRegistration.Event__r.Name);
    
        return (Messaging.Email) email;
    }
    private Map<string, string> getAllEmailTemplateIdandTemplateNameMap(List<EmailTemplate> emailTemplates)
    {
        Map<string, string> mapEmailTemaplate = new Map<string, string>();
        for(EmailTemplate template : emailTemplates )
        {
            mapEmailTemaplate.put(template.Name, template.Id ); 
            
        }
        return mapEmailTemaplate;
    }
    private Map<Id, string> getAllEmailTemplateIdandHTML(List<EmailTemplate> emailTemplates){
        Map<id, string> mapEmailTemaplate = new Map<Id, string>();
        for(EmailTemplate template : emailTemplates )
        {
            mapEmailTemaplate.put(template.Id, template.HtmlValue); 
            
        }
        return mapEmailTemaplate;
        
    }
    
    private static IOrgWideEmailAddressesSelector orgWideEmailAddressesSelector() {
        return ((IOrgWideEmailAddressesSelector)Application.Selector.newInstance(OrgWideEmailAddress.SObjectType));
    }
    
    private static IEmailTemplatesSelector emailTemplatesSelector() {
        return ((IEmailTemplatesSelector)Application.Selector.newInstance(EmailTemplate.SObjectType));
    }
    private static IMatsonEventRegistrationsSelector eventRegistrationsSelector() {
        return ((IMatsonEventRegistrationsSelector)Application.Selector.newInstance(Event_Registration__c.SObjectType));
    }
    private static IEventDaysSelector eventDaysSelector() {
        return (IEventDaysSelector)Application.Selector.newInstance(Event_Days__c.SObjectType);
    }
    
}