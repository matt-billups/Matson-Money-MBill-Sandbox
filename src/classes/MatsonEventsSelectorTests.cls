@isTest
public with sharing class MatsonEventsSelectorTests {

    private static testMethod void givenNewInstanceExpectCorrectSelector() {

        // When
        Object selector = MatsonEventsSelector.newInstance();

        // Then
        System.assert(selector instanceof IMatsonEventsSelector);
    }

    private static testMethod void givenGetSObjectTypeExpectMatsonEvent() {

        // Given
        MatsonEventsSelector sut = new MatsonEventsSelector();
        SObjectType expectedType = Event__c.SObjectType;

        // When
        SObjectType actualType = sut.getSObjectType();

        // Then
        System.assertEquals(expectedType, actualType);
    }

    private static testMethod void givenGetSObjectFieldListExpectCorrectFields() {

        // Given
        MatsonEventsSelector sut = new MatsonEventsSelector();
        List<Schema.SObjectField> expectedFields = new List<Schema.SObjectField> {
            	Event__c.Id,
                Event__c.Name,
                Event__c.Email_Cancelled_Body__c,
                Event__c.Email_Cancelled_Template__c,
                Event__c.Course_Name__c,
                Event__c.Email_Invite_Body__c,
                Event__c.Email_Invite_Template__c,
                Event__c.Email_Registered_Body__c,
                Event__c.Email_Registered_Template__c,
                Event__c.Email_Reminder_1_Week_Body__c,
                Event__c.Email_Reminder_1_Week_Template__c,
                Event__c.Email_Reminder_2_Week_Body__c,
                Event__c.Email_Reminder_2_Week_Template__c,
                Event__c.Event_End_Date__c,
                Event__c.Event_Status__c,
                Event__c.Event_Start_Date__c,
                Event__c.Formatted_End_Date__c,                    
                Event__c.Formatted_Start_Date__c,
                Event__c.Venue_City__c,
                Event__c.Venue_Postal_Code__c,
                Event__c.Venue_State__c,
                Event__c.Venue_Street_Address_1__c,
            	Event__c.Internal_Event_Name__c
        };

        // When
        List<Schema.SObjectField> actualFields = sut.getSObjectFieldList();

        // Then
        System.assertEquals(expectedFields, actualFields);
    }
    
    private static testMethod void givenSelectByIdExpectEvents() {
        // Given
        Event__c event = createEvent();
        MatsonEventsSelector sut = new MatsonEventsSelector();

        // When
        List<Event__c> returnedEvents = sut.selectById(new Set<Id> { event.Id });

        // Then
        System.assertEquals(1, returnedEvents.size());
        System.assertEquals(event.Name, returnedEvents[0].Name);
    }

    private static Event__c createEvent() {
        Event__c event = new Event__c();
        event.Name = 'Test Event';
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
}