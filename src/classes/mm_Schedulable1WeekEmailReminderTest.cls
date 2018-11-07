@isTest public with sharing class mm_Schedulable1WeekEmailReminderTest {
    static String templateName = 'Matson Event Reminder 1 Week Before Email - Standard';
    
    static testMethod void given1WeekEmailReminderEmailsToBeSent()
    {
        //given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IOrgWideEmailAddressesSelector mockedEmailAddressSelector = (IOrgWideEmailAddressesSelector)mocks.mock(IOrgWideEmailAddressesSelector.class); 
        IMatsonEventRegistrationsSelector mockedEventRegistrationsSelector = (IMatsonEventRegistrationsSelector)mocks.mock(IMatsonEventRegistrationsSelector.class);
        IEmailTemplatesSelector mockedTemplatesSelector = (IEmailTemplatesSelector)mocks.mock(IEmailTemplatesSelector.class);
        IMatsonEventsSelector mockedMatsonEventSelector =(IMatsonEventsSelector)mocks.mock(IMatsonEventsSelector.class);
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        Application.UnitOfWork.setMock(mockUow); 
        
        
        RecordType RT = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser' and SobjectType='Adviser__c'];
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234'); 
        List<EmailTemplate> fakeEmailTemplateList = new List<EmailTemplate>();
        fakeEmailTemplateList.add(fakeEmailTemplate());
        
        Contact fakeContact =  fakeContact();
        sfab_FabricatedSObject fakeEvent = fakeEvent();
        List<Event_Registration__c> fakeRegistrationList = new List<Event_Registration__c>();
        Event_Registration__c eventreg = fakeEvent_Registration(fakeEvent);
        fakeRegistrationList.add(eventreg);
        
        OrgWideEmailAddress fakeOrgEmailAddress = fakeOrgWideEmailAddress();
        
        mocks.startStubbing();
        mocks.when(mockedTemplatesSelector.sObjectType()).thenReturn(EmailTemplate.SObjectType);
        mocks.when(mockedTemplatesSelector.selectAll()).thenReturn(fakeEmailTemplateList);
        mocks.when(mockedEmailAddressSelector.sObjectType()).thenReturn(OrgWideEmailAddress.SObjectType);
        mocks.when(mockedEmailAddressSelector.getRegistrationEmailAddress()).thenReturn(fakeOrgEmailAddress); 
        mocks.when(mockedEventRegistrationsSelector.SObjectType()).thenReturn(Event_Registration__c.SObjectType);
        mocks.when(mockedEventRegistrationsSelector.selectActiveEFT1RegistationByEventStartDate(system.today().addDays(3))).thenReturn(fakeRegistrationList);
        
        system.debug('fakeRegistrationList'+fakeRegistrationList);
        mocks.stopStubbing();
        
        Application.Selector.setMock(mockedTemplatesSelector); 
        Application.Selector.setMock(mockedEmailAddressSelector); 
        Application.Selector.setMock(mockedEventRegistrationsSelector); 
        
        //When
        mm_Schedulable1WeekEmailReminder s=new  mm_Schedulable1WeekEmailReminder();
        s.execute(null) ;
        
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
    }
    static testMethod void givenTestMode1WeekEmailReminderEmailsToBeSent(){
        
        //given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IOrgWideEmailAddressesSelector mockedEmailAddressSelector = (IOrgWideEmailAddressesSelector)mocks.mock(IOrgWideEmailAddressesSelector.class); 
        IMatsonEventRegistrationsSelector mockedEventRegistrationsSelector = (IMatsonEventRegistrationsSelector)mocks.mock(IMatsonEventRegistrationsSelector.class);
        IEmailTemplatesSelector mockedTemplatesSelector = (IEmailTemplatesSelector)mocks.mock(IEmailTemplatesSelector.class);
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        Application.UnitOfWork.setMock(mockUow); 
        
        
        RecordType RT = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser' and SobjectType='Adviser__c'];
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234'); 
        List<EmailTemplate> fakeEmailTemplateList = new List<EmailTemplate>();
        fakeEmailTemplateList.add(fakeEmailTemplate());
        
        Contact fakeContact =  fakeContact();
        sfab_FabricatedSObject fakeEvent = fakeEvent();
        List<Event_Registration__c> fakeRegistrationList = new List<Event_Registration__c>();
        fakeRegistrationList.add(fakeEvent_Registration(fakeEvent));
        
        OrgWideEmailAddress fakeOrgEmailAddress = fakeOrgWideEmailAddress();
        
        mocks.startStubbing();
        mocks.when(mockedTemplatesSelector.sObjectType()).thenReturn(EmailTemplate.SObjectType);
        mocks.when(mockedTemplatesSelector.selectAll()).thenReturn(fakeEmailTemplateList);
        mocks.when(mockedEmailAddressSelector.sObjectType()).thenReturn(OrgWideEmailAddress.SObjectType);
        mocks.when(mockedEmailAddressSelector.getRegistrationEmailAddress()).thenReturn(fakeOrgEmailAddress); 
        mocks.when(mockedEventRegistrationsSelector.SObjectType()).thenReturn(Event_Registration__c.SObjectType);
        mocks.when(mockedEventRegistrationsSelector.selectActiveEFT1RegistationByEventStartDate(system.today().addDays(3))).thenReturn(fakeRegistrationList);
        mocks.stopStubbing();
        
        Application.Selector.setMock(mockedTemplatesSelector); 
        Application.Selector.setMock(mockedEmailAddressSelector); 
        Application.Selector.setMock(mockedEventRegistrationsSelector); 
        
        //When
        Test_Mode__c TM = New Test_Mode__c();
        TM.isTestMode__c = true;
        TM.System_Test_Date__c = system.Today();
        insert TM;
        mm_Schedulable1WeekEmailReminder s=new  mm_Schedulable1WeekEmailReminder();
        s.execute(null) ;
        
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
        emailTemplate.Subject = 'Your January 2018 Entrepreneur’s Foundation Training';
        emailTemplate.HtmlValue = '<html>Hello {!Event_Registration__c.Adviser_Email__c}</html>';  
        emailTemplate.Id =  fflib_IDGenerator.generate(Schema.EmailTemplate.sobjectType);
        return emailTemplate;
    }  
    static Event_Registration__c fakeEvent_Registration(sfab_FabricatedSObject event1){
        
        sfab_FabricatedSObject stuff = new sfab_FabricatedSObject(Event_Registration__c.class);
        stuff.setField(Event_Registration__c.Id, fflib_IDGenerator.generate(Event_Registration__c.SObjectType));
        stuff.setParent('Event__r', event1);
        stuff.setField(Event_Registration__c.Attendee_First_Name__c, 'peolple');
        stuff.setField(Event_Registration__c.Venue_Name__c, 'peolple');
        stuff.setField(Event_Registration__c.Registration_Site_URL__c, 'peolple');
        
        return ( Event_Registration__c)stuff.toSObject();
        
    }    
    static sfab_FabricatedSObject fakeEvent()
    {
        sfab_FabricatedSObject stuff = new sfab_FabricatedSObject(Event__c.class);
        stuff.setField(Event__c.Id, fflib_IDGenerator.generate(Event__c.SObjectType));
        stuff.setField(Event__c.Email_Reminder_1_Week_Template__c, templateName);
        stuff.setField(Event__c.Event_Start_Date__c, system.today().addDays(3));
        stuff.setField(Event__c.Name, 'this event');
        
         stuff.setField(Event__c.Email_Reminder_1_Week_Body__c, 'this event');
         stuff.setField(Event__c.Formatted_Start_Date__c, 'this event');
         stuff.setField(Event__c.Formatted_End_Date__c, 'this event');
         stuff.setField(Event__c.Venue_Street_Address_1__c, 'this event');
         stuff.setField(Event__c.Venue_State__c, 'this event');
         stuff.setField(Event__c.Venue_City__c, 'this event');
         stuff.setField(Event__c.Venue_Postal_Code__c, 'this event');
        
        return stuff;    
    }
    static OrgWideEmailAddress fakeOrgWideEmailAddress(){
        OrgWideEmailAddress fakeOrgEmailAddress = new OrgWideEmailAddress();
        fakeOrgEmailAddress.Id =  fflib_IDGenerator.generate(OrgWideEmailAddress.SObjectType);
        return fakeOrgEmailAddress;
    }
    
}