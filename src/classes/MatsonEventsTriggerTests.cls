@isTest
public class MatsonEventsTriggerTests {
    static testMethod void givenInsertEventsExpectPopulateHouseAccountSiteToken() {
        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ISettingsHelperService mockedSettingsHelperService = (ISettingsHelperService)mocks.mock(ISettingsHelperService.class);
        
        mocks.startStubbing();
        mocks.when(mockedSettingsHelperService.HouseAccountContactId()).thenReturn(fflib_IDGenerator.generate(Contact.SObjectType));
        mocks.when(mockedSettingsHelperService.CreateEventToken(fflib_Match.anyString())).thenReturn('token');
        mocks.stopStubbing();
        
        Application.Service.setMock(ISettingsHelperService.class, mockedSettingsHelperService);

        // When
        List<Event__c> createdEvents = createEvents();
        Set<Id> setOfEventIds = new Map<Id, SObject>(createdEvents).keySet();
        List<Event__c> eventsWithInfo = [SELECT House_Account_Site_Token__c FROM Event__c WHERE Id IN: setOfEventIds];
        
        // Then
        for (Event__c event : eventsWithInfo) {
            System.assertEquals('token', event.House_Account_Site_Token__c);
        }
    }
    
    static testMethod void givenUpdateEventsExpectPopulateHouseAccountSiteToken() {
        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ISettingsHelperService mockedSettingsHelperService = (ISettingsHelperService)mocks.mock(ISettingsHelperService.class);
        
        mocks.startStubbing();
        mocks.when(mockedSettingsHelperService.HouseAccountContactId()).thenReturn(fflib_IDGenerator.generate(Contact.SObjectType));
        mocks.when(mockedSettingsHelperService.CreateEventToken(fflib_Match.anyString())).thenReturn('token');
        mocks.stopStubbing();
        
        Application.Service.setMock(ISettingsHelperService.class, mockedSettingsHelperService);

        // When
        List<Event__c> createdEvents = createEvents();
        Set<Id> setOfEventIds = new Map<Id, SObject>(createdEvents).keySet();
        List<Event__c> eventsWithInfo = [SELECT House_Account_Site_Token__c FROM Event__c WHERE Id IN: setOfEventIds];
        
        for (Event__c event : eventsWithInfo) {
            System.assertEquals('token', event.House_Account_Site_Token__c);
            event.Maximum_Registration__c = 100;
        }
        
        mocks.startStubbing();
        mocks.when(mockedSettingsHelperService.CreateEventToken(fflib_Match.anyString())).thenReturn('token2');
        mocks.stopStubbing();
        update eventsWithInfo;
        eventsWithInfo = [SELECT House_Account_Site_Token__c FROM Event__c WHERE Id IN: setOfEventIds];
        
        // Then
        for (Event__c event : eventsWithInfo) {
            System.assertEquals('token2', event.House_Account_Site_Token__c); 
        }
    }

    static List<Event__c> createEvents() {
        return new List<Event__c> { createEvent('Test Event 1'), createEvent('Test Event 2') };
    }

    static Event__c createEvent(String eventName) {
        Event__c event = new Event__c();
        event.Name = eventName;
        event.Event_Start_Date__c = System.today().addDays(7);
        event.Event_End_Date__c = System.today().addDays(8);
        event.Email_Cancelled_Body__c = 'Cancelled Body';
        event.Email_Cancelled_Template__c = 'Matson Event Cancelled Email - Standard';
        event.Email_Invite_Body__c = 'Invite Body';
        event.Email_Invite_Template__c = '	Matson Event Invited Email - Standard';
        event.Email_Registered_Body__c = 'Registered Body';
        event.Email_Registered_Template__c = '	Matson Event Registered Email - Standard';
        event.Email_Reminder_1_Week_Body__c = '1 Week Body';
        event.Email_Reminder_1_Week_Template__c = '	Matson Event Reminder 1 Week Before Email - Standard';
        event.Email_Reminder_2_Week_Body__c = '2 Week Body';
        event.Email_Reminder_2_Week_Template__c = 'Matson Event Reminder 2 Weeks Before Email - Standard';
        event.Maximum_Registration__c = 50;
        event.Course_Name__c = 'Other';

        insert event;
        return event;
    }

    static ISettingsHelperService settingsHelperService() {
        return (ISettingsHelperService)Application.Service.newInstance(ISettingsHelperService.class);
    }
}