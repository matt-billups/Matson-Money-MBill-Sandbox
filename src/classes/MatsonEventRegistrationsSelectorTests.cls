@isTest
public with sharing class MatsonEventRegistrationsSelectorTests {

    private static testMethod void givenNewInstanceExpectCorrectSelector() {

        // When
        Object selector = MatsonEventRegistrationsSelector.newInstance();

        // Then
        System.assert(selector instanceof IMatsonEventRegistrationsSelector);
    }

    private static testMethod void givenGetSObjectTypeExpectEmailTemplate() {

        // Given
        MatsonEventRegistrationsSelector sut = new MatsonEventRegistrationsSelector();
        SObjectType expectedType = Event_Registration__c.SObjectType;

        // When
        SObjectType actualType = sut.getSObjectType();

        // Then
        System.assertEquals(expectedType, actualType);
    }

    private static testMethod void givenGetSObjectFieldListExpectCorrectFields() {

        // Given
        MatsonEventRegistrationsSelector sut = new MatsonEventRegistrationsSelector();
        List<Schema.SObjectField> expectedFields = new List<Schema.SObjectField> {
            	Event_Registration__c.Id,
                Event_Registration__c.Adviser_Number_Hidden__c,
                Event_Registration__c.Adviser_Email__c,
                Event_Registration__c.Attendee_First_Name__c,
                Event_Registration__c.Attendee_Email__c,
                Event_Registration__c.Attendee_Last_Name__c,
                Event_Registration__c.Attendee_Name__c,
                Event_Registration__c.Attendee_Nickname__c,
                Event_Registration__c.Contact__c,
                Event_Registration__c.Event__c,
                Event_Registration__c.Event_Email_Opt_Out_URL__c,
				Event_Registration__c.Reg_Adviser__c,
                Event_Registration__c.Registration_Site_URL__c,
                Event_Registration__c.Status__c,
                Event_Registration__c.Venue_Name__c
        };

        // When
        List<Schema.SObjectField> actualFields = sut.getSObjectFieldList();

        // Then
        System.assertEquals(expectedFields, actualFields);
    }
    
        private static testMethod void givenSelectByIdExepctCorrectRegistrations() {
        // Given
        Contact contact = createContact();
        Venue__c venue = createVenue();
        Event__c event = createEvent(venue.Id);
        Event_Registration__c eventRegistration = createEventRegistration(event.Id, contact.Id);
        MatsonEventRegistrationsSelector sut = new MatsonEventRegistrationsSelector();
        
        // When
        List<Event_Registration__c> returnedRegistrations = sut.selectById(new Set<Id> { eventRegistration.Id });
        
        // Then
        System.assertEquals(1, returnedRegistrations.size());
        System.assertEquals(eventRegistration.Adviser_Email__c, returnedRegistrations[0].Adviser_Email__c);
    }
    
    private static testMethod void givenSelectRegistrationWithEventFieldsByIdExpectRegistrations() {
        // Given
        Contact contact = createContact();
        Venue__c venue = createVenue();
        Event__c event = createEvent(venue.Id);
        Event_Registration__c eventRegistration = createEventRegistration(event.Id, contact.Id);
        MatsonEventRegistrationsSelector sut = new MatsonEventRegistrationsSelector();
        
        // When
        Event_Registration__c returnedRegistration = sut.selectRegistrationWithEventFieldsById(eventRegistration.Id);
        
        // Then
        System.assertEquals(eventRegistration.Adviser_Email__c, returnedRegistration.Adviser_Email__c);
        System.assertEquals(event.Name, returnedRegistration.Event__r.Name);
    }
    
    private static testMethod void givenSelectActiveEFT1RegistationByEventStartDateExpectRegistrations() {
        // Given
        Contact contact = createContact();
        Venue__c venue = createVenue();
        Event__c event = createEvent(venue.Id);
        Event_Registration__c eventRegistration = createEventRegistration(event.Id, contact.Id);
        MatsonEventRegistrationsSelector sut = new MatsonEventRegistrationsSelector();
        
        // When
        List<Event_Registration__c> returnedRegistrations = sut.selectActiveEFT1RegistationByEventStartDate(System.today().addDays(30));
        
        // Then
        System.assertEquals(1, returnedRegistrations.size());
        System.assertEquals(eventRegistration.Adviser_Email__c, returnedRegistrations[0].Adviser_Email__c);
    }
    
    private static testMethod void givenGetSelectAllQueryExpectCorrectQuery() {
        // Given
        MatsonEventRegistrationsSelector sut = new MatsonEventRegistrationsSelector();
        
        // When
        String actualQuery = sut.getSelectAllQuery();
        
        // Then
        System.assert(actualQuery.contains('FROM Event_Registration__c'));
    }
    
    private static Event__c createEvent(Id venueId) {
        Event__c evt = new Event__c();
        evt.Name = 'Test Event';
        evt.Venue__c = venueId;
        evt.Event_Start_Date__c = System.today().addDays(30);
        evt.Event_End_Date__c = System.today().addDays(30);
        evt.Email_Cancelled_Body__c = 'Cancelled Body';
        evt.Email_Cancelled_Template__c = 'Matson Event Cancelled Email - Standard';
        evt.Email_Invite_Body__c = 'Invite Body';
        evt.Email_Invite_Template__c = 'Matson Event Invited Email - Standard';
        evt.Email_Registered_Body__c = 'Registered Body';
        evt.Email_Registered_Template__c = 'Matson Event Registered Email - Standard';
        evt.Email_Reminder_1_Week_Body__c = 'Reminder 1 Week Body';
        evt.Email_Reminder_1_Week_Template__c = 'Matson Event Reminder 1 Week Before Email - Standard';
        evt.Email_Reminder_2_Week_Body__c = 'Reminder 2 Week Body';
        evt.Email_Reminder_2_Week_Template__c = 'Matson Event Reminder 2 Weeks Before Email - Standard';
        evt.Maximum_Registration__c = 50;
        evt.Course_Name__c = 'Other';
        
        insert evt;
        return evt;
    }
    
    private static Event_Registration__c createEventRegistration(Id eventId, Id contactId) {
        Event_Registration__c evtReg = new Event_Registration__c();
        evtReg.Attendee_Email__c = 'test@example.com';
        evtReg.Event__c = eventId;
        evtReg.Contact__c = contactId;
        evtReg.Adviser_Email__c = 'adviser@example.com';
        evtReg.Attendee_Type__c = 'Guest';
        evtReg.Status__c = 'Registered';
        
        insert evtReg;
        return evtReg;
    }
    
    private static Venue__c createVenue() {
        Venue__c venue = new Venue__c();
        venue.Name = 'Test Venue';
        venue.Street_Address_1__c = '5955 Deerfield Blvd';
        venue.City__c = 'Mason';
        venue.Venue_State__c = 'OH';
        venue.Postal_Code_Zip__c = '45040';
        venue.Concierge__c = 'Mason';
        
        insert venue;
        return venue;
    }
    
    private static Contact createContact() {
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'McTest';
        con.Email = 'test.mctest@example.com';
        
        insert con;
        return con;
    }
}