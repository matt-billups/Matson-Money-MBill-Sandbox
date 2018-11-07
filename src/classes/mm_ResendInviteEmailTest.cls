@isTest public with sharing class  mm_ResendInviteEmailTest {
   
    static String templateName = 'Invited Email';
    
    static testMethod void givenResendInviteToBeSent() {
        
        //given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IMatsonEventRegistrationsSelector mockedEventRegistrationsSelector = (IMatsonEventRegistrationsSelector)mocks.mock(IMatsonEventRegistrationsSelector.class); 
        Event__c fakeEvent = fakeEvent();
        Contact fakeContact =  fakeContact();
        Event_Registration__c fakeRegistration = fakeEvent_Registration(fakeEvent, fakeContact);
        EmailTemplate fakeEmailTemplate = fakeEmailTemplate(); 


        mocks.startStubbing();  
        mocks.when(mockedEventRegistrationsSelector.sObjectType()).thenReturn(Event_Registration__c.SObjectType);
        mocks.when(mockedEventRegistrationsSelector.selectRegistrationWithEventFieldsById(fakeRegistration.Id)).thenReturn(fakeRegistration);         
        mocks.stopStubbing();
        
        
        Application.Selector.setMock(mockedEventRegistrationsSelector); 
    
        
        //When
        Test.startTest();
        mm_ResendInviteEmail.sendEmail(fakeRegistration.Id);           
        Test.stopTest();
        
        
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
        emailTemplate.Name = templateName;
        emailTemplate.Subject = 'Your Invited';
        emailTemplate.HtmlValue = '<html>Hello {!Event_Registration__c.Adviser_Email__c}</html>';  
        return emailTemplate;
    }  
    static Event_Registration__c fakeEvent_Registration(Event__c event1, Contact con ){
        Event_Registration__c registration = new Event_Registration__c();
        registration.Id = fflib_IDGenerator.generate(Event_Registration__c.SObjectType);
        registration.Event__c = event1.Id;
        registration.Contact__c = Con.Id;
        return registration;
        
    }
    static Event__c fakeEvent()
    {
        Event__c event1 = new Event__c();
        event1.Id = fflib_IDGenerator.generate(Event__c.SObjectType);
        return event1;
    }
    
}