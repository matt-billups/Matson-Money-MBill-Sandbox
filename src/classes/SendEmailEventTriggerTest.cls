@isTest public class SendEmailEventTriggerTest {
    
    static String templateName = 'Matson Event Date Change Email - Standard';
    
    static testMethod void givenSendTranactionalEmailExpectEmailsToBeSent()
    {
        //given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IEmailTemplatesSelector mockedTemplatesSelector = (IEmailTemplatesSelector)mocks.mock(IEmailTemplatesSelector.class);
        IEmailTemplateLookupTableSelector mockedEmailTemplateLookupTableSelector = (IEmailTemplateLookupTableSelector)mocks.mock(IEmailTemplateLookupTableSelector.class);
        IOrgWideEmailAddressesSelector mockedEmailAddressSelector = (IOrgWideEmailAddressesSelector)mocks.mock(IOrgWideEmailAddressesSelector.class); 
        IContactsSelector mockedContactSelector = (IContactsSelector)mocks.mock(IContactsSelector.class);
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        
        
        Event__c fakeEvent = fakeEvent();
        Event_Registration__c fakeRegistration = fakeEvent_Registration(fakeEvent);
        Contact fakeContact =  fakeContact();
        
        EmailTemplate fakeEmailTemplate = fakeEmailTemplate(); 
        EmailTemplateLookupTable__c fakeEmailTemplLookup =  fakeEmailTemplateLookup(fakeEmailTemplate, 'Transactional');

        List<Send_Email__e> fakeSendEmailEvent = fakeSendEmailEvent(fakeContact.Id, templateName, fakeRegistration.Id);
        OrgWideEmailAddress fakeOrgEmailAddress = fakeOrgWideEmailAddress();
        List<EmailTemplate>fakeEmailTemplateList = new List<EmailTemplate>();
        fakeEmailTemplateList.add(fakeEmailTemplate);
        List<EmailTemplateLookupTable__c> listOfEmailTemplateLookUpTable = new List<EmailTemplateLookupTable__c>();
        listOfEmailTemplateLookUpTable.add(fakeEmailTemplLookup);
        fakeContact.Matson_Event_Marketing_Email_Opt_Out__c= false;
        
        list<Contact> listOfContact = new list<Contact>();
        listOfContact.add(fakeContact);
        
        
        Set<Id> idSet = new Set<Id>();
        idset.add(fakeContact.Id);
        
        mocks.startStubbing();
        mocks.when(mockedTemplatesSelector.sObjectType()).thenReturn(EmailTemplate.SObjectType);
        mocks.when(mockedTemplatesSelector.selectAll()).thenReturn(fakeEmailTemplateList);
        mocks.when(mockedEmailAddressSelector.sObjectType()).thenReturn(OrgWideEmailAddress.SObjectType);
        mocks.when(mockedEmailAddressSelector.getRegistrationEmailAddress()).thenReturn(fakeOrgEmailAddress); 
        mocks.when(mockedEmailTemplateLookupTableSelector.sObjectType()).thenReturn(EmailTemplateLookupTable__c.SObjectType);
        mocks.when(mockedEmailTemplateLookupTableSelector.selectAll()).thenReturn(listOfEmailTemplateLookUpTable);
        mocks.when(mockedContactSelector.SObjectType()).thenReturn(Contact.sobjectType);
        mocks.when(mockedContactSelector.selectById(idset)).thenReturn(listOfContact);
        
        
        mocks.stopStubbing();
        
        Application.UnitOfWork.setMock(mockUow); 
        Application.Selector.setMock(mockedTemplatesSelector); 
        Application.Selector.setMock(mockedEmailAddressSelector);
        Application.Selector.setMock(mockedEmailTemplateLookupTableSelector);
        PhoenixCore.Selector.setMock(mockedContactSelector);
        
        //When
        Test.startTest();
        
        List<Database.SaveResult> results2 = EventBus.publish(fakeSendEmailEvent);
        Test.stopTest();
        
        // Then
        ((fflib_SobjectUnitOfWork) mocks.verify(mockUow,
                                                mocks
                                                .times(1)
                                                .description('email sb constructed')))
        .registerEmail((Messaging.SingleEmailMessage) fflib_Match.anyObject());
        
        
        ((fflib_SobjectUnitOfWork) mocks.verify(mockUow,
                                                mocks
                                                .times(1)
                                                .description('email sb sent')))
        .commitWork();
        
        
        fflib_ArgumentCaptor capturedEmailArg = 
            fflib_ArgumentCaptor.forClass(Messaging.SingleEmailMessage.class);
        
        ((fflib_SobjectUnitOfWork) mocks.verify(mockUow, 1))
        .registerEmail((Messaging.SingleEmailMessage)capturedEmailArg.capture());
        
        Object actualEmailAsObject = capturedEmailArg.getValue();
        
        Messaging.SingleEmailMessage actualEmail = (Messaging.SingleEmailMessage) actualEmailAsObject;
        
        System.assertEquals(fakeOrgEmailAddress.Id, 
                            actualEmail.getOrgWideEmailAddressId(),
                            'OrgWideEmailAddressId is incorrect');
        
        System.assertEquals(fakeEmailTemplate.Id,
                            actualEmail.getTemplateId(),
                            'incorrect Email Template Id');
        
        System.assertEquals(fakeContact.Id,
                            actualEmail.getTargetObjectId(),
                            'incorrect Target Id');
        
        System.assertEquals(fakeRegistration.Id,
                            actualEmail.getWhatId(),
                            'incorrect What Id');
        
        
    }
    static testMethod void givenSendMarketingEventEmailExpectEmailsToBeSent(){
        
        //given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IEmailTemplatesSelector mockedTemplatesSelector = (IEmailTemplatesSelector)mocks.mock(IEmailTemplatesSelector.class);
        IEmailTemplateLookupTableSelector mockedEmailTemplateLookupTableSelector = (IEmailTemplateLookupTableSelector)mocks.mock(IEmailTemplateLookupTableSelector.class);
        IOrgWideEmailAddressesSelector mockedEmailAddressSelector = (IOrgWideEmailAddressesSelector)mocks.mock(IOrgWideEmailAddressesSelector.class); 
        IContactsSelector mockedContactSelector = (IContactsSelector)mocks.mock(IContactsSelector.class);
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        
        
        Event__c fakeEvent = fakeEvent();
        Event_Registration__c fakeRegistration = fakeEvent_Registration(fakeEvent);
        Contact fakeContact1 =  fakeContact();
        fakeContact1.Matson_Event_Marketing_Email_Opt_Out__c = false;
        
        EmailTemplate fakeEmailTemplate = fakeEmailTemplate(); 
        
        EmailTemplateLookupTable__c fakeEmailTemplLookup =  fakeEmailTemplateLookup(fakeEmailTemplate, 'Matson Event Marketing');
       
        OrgWideEmailAddress fakeOrgEmailAddress = fakeOrgWideEmailAddress();
        Set<Id> idSet = new Set<Id>();
        idset.add(fakeContact1.Id);
        
        list<Contact> listOfContact = new list<Contact> ();
        listOfContact.add(fakeContact1);
        
        List<EmailTemplate>fakeEmailTemplateList = new List<EmailTemplate>();
        fakeEmailTemplateList.add(fakeEmailTemplate);
        List<EmailTemplateLookupTable__c> listOfEmailTemplateLookUpTable = new List<EmailTemplateLookupTable__c>();
        listOfEmailTemplateLookUpTable.add(fakeEmailTemplLookup);
        
      
        
        mocks.startStubbing();
        mocks.when(mockedTemplatesSelector.sObjectType()).thenReturn(EmailTemplate.SObjectType);
        mocks.when(mockedTemplatesSelector.selectAll()).thenReturn(fakeEmailTemplateList);
        mocks.when(mockedEmailAddressSelector.sObjectType()).thenReturn(OrgWideEmailAddress.SObjectType);
        mocks.when(mockedEmailAddressSelector.getRegistrationEmailAddress()).thenReturn(fakeOrgEmailAddress); 
        mocks.when(mockedEmailTemplateLookupTableSelector.sObjectType()).thenReturn(EmailTemplateLookupTable__c.SObjectType);
        mocks.when(mockedEmailTemplateLookupTableSelector.selectAll()).thenReturn(listOfEmailTemplateLookUpTable);
        mocks.when(mockedContactSelector.SObjectType()).thenReturn(Contact.sobjectType);
        mocks.when(mockedContactSelector.selectById(idset)).thenReturn(listOfContact);
        mocks.stopStubbing();
        
        Application.UnitOfWork.setMock(mockUow);
        Application.Selector.setMock(mockedTemplatesSelector); 
        Application.Selector.setMock(mockedEmailAddressSelector);
        Application.Selector.setMock(mockedEmailTemplateLookupTableSelector);
        PhoenixCore.Selector.setMock(mockedContactSelector);
               
        //When
        Test.startTest();
        
        List<Send_Email__e> fakeSendEmailEvent = fakeSendEmailEvent(fakeContact1.Id, templateName, fakeRegistration.Id);
        List<Database.SaveResult> results2 = EventBus.publish(fakeSendEmailEvent);
        Test.stopTest();
        
                // Then
        ((fflib_SobjectUnitOfWork) mocks.verify(mockUow,
                                                mocks
                                                .times(1)
                                                .description('email sb constructed')))
        .registerEmail((Messaging.SingleEmailMessage) fflib_Match.anyObject());
      
        
        ((fflib_SobjectUnitOfWork) mocks.verify(mockUow,
                                                mocks
                                                .times(1)
                                                .description('email sb sent')))
        .commitWork();
        
        
        fflib_ArgumentCaptor capturedEmailArg = 
            fflib_ArgumentCaptor.forClass(Messaging.SingleEmailMessage.class);
        
        ((fflib_SobjectUnitOfWork) mocks.verify(mockUow, 1))
        .registerEmail((Messaging.SingleEmailMessage)capturedEmailArg.capture());
        
        Object actualEmailAsObject = capturedEmailArg.getValue();
        
        Messaging.SingleEmailMessage actualEmail = (Messaging.SingleEmailMessage) actualEmailAsObject;
        
        System.assertEquals(fakeOrgEmailAddress.Id, 
                            actualEmail.getOrgWideEmailAddressId(),
                            'OrgWideEmailAddressId is incorrect');
        
        System.assertEquals(fakeEmailTemplate.Id,
                            actualEmail.getTemplateId(),
                            'incorrect Email Template Id');
        
        System.assertEquals(fakeContact1.Id,
                            actualEmail.getTargetObjectId(),
                            'incorrect Target Id');
        
        System.assertEquals(fakeRegistration.Id,
                            actualEmail.getWhatId(),
                            'incorrect What Id');
    }
    static testMethod void givenSendMarketingEventEmailExpectEmailsNotToBeSent(){
        
        //given
        
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IEmailTemplatesSelector mockedTemplatesSelector = (IEmailTemplatesSelector)mocks.mock(IEmailTemplatesSelector.class);
        IEmailTemplateLookupTableSelector mockedEmailTemplateLookupTableSelector = (IEmailTemplateLookupTableSelector)mocks.mock(IEmailTemplateLookupTableSelector.class);
        IContactsSelector mockedContactSelector = (IContactsSelector)mocks.mock(IContactsSelector.class);
        IOrgWideEmailAddressesSelector mockedEmailAddressSelector = (IOrgWideEmailAddressesSelector)mocks.mock(IOrgWideEmailAddressesSelector.class);  
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        Application.UnitOfWork.setMock(mockUow); 
        
        Event__c fakeEvent = fakeEvent();
        Event_Registration__c fakeRegistration = fakeEvent_Registration(fakeEvent);
        Contact fakeContact =  fakeContact();
      	fakeContact.Matson_Event_Marketing_Email_Opt_Out__c= true;
        
        EmailTemplate fakeEmailTemplate = fakeEmailTemplate(); 
        EmailTemplateLookupTable__c fakeEmailTemplLookup =  fakeEmailTemplateLookup(fakeEmailTemplate, 'Matson Event Marketing');
        List<Send_Email__e> fakeSendEmailEvent = fakeSendEmailEvent(fakeContact.Id, templateName, fakeRegistration.Id);
        OrgWideEmailAddress fakeOrgEmailAddress = fakeOrgWideEmailAddress();
        Set<Id> idSet = new Set<Id>();
        idset.add(fakeContact.Id);
        
        list<Contact> listOfContact = new list<Contact> ();
        listOfContact.add(fakeContact);
        
        List<EmailTemplate>fakeEmailTemplateList = new List<EmailTemplate>();
        fakeEmailTemplateList.add(fakeEmailTemplate);
        List<EmailTemplateLookupTable__c> listOfEmailTemplateLookUpTable = new List<EmailTemplateLookupTable__c>();
        listOfEmailTemplateLookUpTable.add(fakeEmailTemplLookup);
        
        mocks.startStubbing();
        mocks.when(mockedTemplatesSelector.sObjectType()).thenReturn(EmailTemplate.SObjectType);
        mocks.when(mockedTemplatesSelector.selectAll()).thenReturn(fakeEmailTemplateList);
        mocks.when(mockedEmailAddressSelector.sObjectType()).thenReturn(OrgWideEmailAddress.SObjectType);
        mocks.when(mockedEmailAddressSelector.getRegistrationEmailAddress()).thenReturn(fakeOrgEmailAddress); 
        mocks.when(mockedEmailTemplateLookupTableSelector.sObjectType()).thenReturn(EmailTemplateLookupTable__c.SObjectType);
        mocks.when(mockedEmailTemplateLookupTableSelector.selectAll()).thenReturn(listOfEmailTemplateLookUpTable);
        mocks.when(mockedContactSelector.SObjectType()).thenReturn(Contact.sobjectType);
        mocks.when(mockedContactSelector.selectById( idset)).thenReturn(listOfContact);
        mocks.stopStubbing();
        
        Application.Selector.setMock(mockedTemplatesSelector); 
        Application.Selector.setMock(mockedEmailAddressSelector);
        Application.Selector.setMock(mockedEmailTemplateLookupTableSelector);
        PhoenixCore.Selector.setMock(mockedContactSelector);
        //When
        Test.startTest();
        
        List<Database.SaveResult> results2 = EventBus.publish(fakeSendEmailEvent);
        Test.stopTest();
        
        // Then
        fflib_ArgumentCaptor capturedEmailArg = 
            fflib_ArgumentCaptor.forClass(Messaging.SingleEmailMessage.class);
        
        ((fflib_SobjectUnitOfWork) mocks.verify(mockUow, 0))
        .registerEmail((Messaging.SingleEmailMessage)capturedEmailArg.capture());
        
    }
    
    static testMethod void givenSendEmailWhenNullRequestExpectException()
    {  
        
        //given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IEmailTemplatesSelector mockedTemplatesSelector = (IEmailTemplatesSelector)mocks.mock(IEmailTemplatesSelector.class);
        IOrgWideEmailAddressesSelector mockedEmailAddressSelector = (IOrgWideEmailAddressesSelector)mocks.mock(IOrgWideEmailAddressesSelector.class); 
        IContactsSelector mockedContactSelector = (IContactsSelector)mocks.mock(IContactsSelector.class);
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        Application.UnitOfWork.setMock(mockUow); 
        
        
        Event__c fakeEvent = fakeEvent();
        Event_Registration__c fakeRegistration = fakeEvent_Registration(fakeEvent);
        Contact fakeContact =  fakeContact();
        List<Send_Email__e> fakeSendEmailEvent = fakeSendEmailEvent(fakeContact.Id, templateName, fakeRegistration.Id);
        OrgWideEmailAddress fakeOrgEmailAddress = fakeOrgWideEmailAddress();
        
        mocks.startStubbing();
        mocks.when(mockedTemplatesSelector.sObjectType()).thenReturn(EmailTemplate.SObjectType);
        mocks.when(mockedTemplatesSelector.selectAll()).thenReturn(null);
        mocks.when(mockedEmailAddressSelector.sObjectType()).thenReturn(OrgWideEmailAddress.SObjectType);
        mocks.when(mockedEmailAddressSelector.getRegistrationEmailAddress()).thenReturn(fakeOrgEmailAddress); 
        mocks.stopStubbing();
        
        Application.Selector.setMock(mockedTemplatesSelector); 
        Application.Selector.setMock(mockedEmailAddressSelector); 
        
        //When
        
        test.startTest();
        try{ 
            List<Database.SaveResult> results = EventBus.publish(fakeSendEmailEvent);
        }
        catch(fflib_Application.DeveloperException e){   
            system.debug(e);
            Boolean expectedExceptionThrown =  e.getMessage().contains('Email Template ' + templateName + ' Not Found!') ? true : false;             
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        Test.stopTest();
    }  
    
    static List<Send_Email__e> fakeSendEmailEvent(string contactID,string tempName, string registrationId){       
        List<Send_Email__e> Send1WeekEmails = new List<Send_Email__e>();
        Send1WeekEmails.add(new Send_Email__e(Contact_Id__c =  contactID,
                                              EmailTemplateName__c = tempName, 
                                              WhatId__c = registrationId));  
        return Send1WeekEmails;
    } 
    static Contact fakeContact()
    {
        Contact con = new Contact();
        con.Id = fflib_IDGenerator.generate(Contact.SObjectType);
        return con;
    }
    
    static EmailTemplate fakeEmailTemplate()
    {
        EmailTemplate emailTemplate = new EmailTemplate();
        //emailTemplate.Id = fflib_IDGenerator.generate(Schema.EmailTemplate.SObjectType);
        emailTemplate.Name = templateName;
        emailTemplate.DeveloperName ='This_Name';
        emailTemplate.TemplateType = 'Custom';
        emailTemplate.Subject = 'Your January 2018 Entrepreneur’s Foundation Training';
        emailTemplate.HtmlValue = '<html>Hello {!Event_Registration__c.Adviser_Email__c}</html>';  
        emailTemplate.FolderId = [select id, name from folder where name ='Matson Events Marketing Emails'][0].id;
        insert emailTemplate;
        return emailTemplate;
    }  
    static EmailTemplateLookupTable__c fakeEmailTemplateLookup(EmailTemplate fakeEmailTemplate, string typeName){
        EmailTemplateLookupTable__c ETLT = new EmailTemplateLookupTable__c();
        ETLT.EmailTemplateId__c = fakeEmailTemplate.Id;
        ETLT.EmailTemplateType__c = typeName;
        ETLT.IsActive__c = true;
        ETLT.Name = fakeEmailTemplate.Name;
        return ETLT;
        
    }
    static Event_Registration__c fakeEvent_Registration(Event__c event1){
        Event_Registration__c registration = new Event_Registration__c();
        registration.Id = fflib_IDGenerator.generate(Event_Registration__c.SObjectType);
        registration.Event__c = event1.Id;
        return registration;
        
    }
    
    static Event__c fakeEvent()
    {
        Event__c event1 = new Event__c();
        event1.Id = fflib_IDGenerator.generate(Event__c.SObjectType);
        return event1;
    }
    static OrgWideEmailAddress fakeOrgWideEmailAddress(){
        OrgWideEmailAddress fakeOrgEmailAddress = new OrgWideEmailAddress();
        fakeOrgEmailAddress.Id =  fflib_IDGenerator.generate(OrgWideEmailAddress.SObjectType);
        return fakeOrgEmailAddress;
    }   
}