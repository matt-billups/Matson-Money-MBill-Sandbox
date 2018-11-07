/*
 * Author: Matt Billups
 * Purpose: Test class to cover code in the mm_ClearMatsonEventPrimaryEventField.trigger 
 * Action: Creates two Matson Event records with specific record types.
 * Then updates the secondary event to be primary, and ensures the Primary Matson Event field is cleared out.
 */

@isTest
public with sharing class mm_ClearSecondaryMatsonEventFieldsTest {

    static testMethod void mm_ClearSecondaryMatsonEventFieldsTest () {

        RecordType primaryRT = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Primary_Matson_Event'];
        RecordType secondaryRT = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Secondary_Matson_Event'];

        Event__c primaryEvent = createEvent('Test Primary Event', primaryRT.Id, NULL, NULL);
        Event__c secondaryEvent = createEvent('Test Secondary Event', secondaryRT.Id, primaryEvent.Id, 'Bike/Run/Walk');

        secondaryEvent.RecordTypeId = primaryRT.Id;
        update secondaryEvent;

        Event__c updatedEvent = [SELECT Id, Primary_Matson_Event__c, Secondary_Event_Type__c FROM Event__c WHERE Id =: secondaryEvent.Id];
        System.assert(updatedEvent.Primary_Matson_Event__c == NULL);
        System.assert(updatedEvent.Secondary_Event_Type__c == NULL);
    }
    
    static Event__c createEvent(String eventName, Id recordType_Id, Id primEventId, String secondaryEventType) {
        Event__c event = new Event__c();
        event.Name = eventName;
        event.RecordTypeId = recordType_Id;
        event.Primary_Matson_Event__c = primEventId;
        event.Event_Start_Date__c = System.today().addDays(7);
        event.Event_End_Date__c = System.today().addDays(8);
        event.Email_Cancelled_Body__c = 'Cancelled Body';
        event.Email_Cancelled_Template__c = 'Matson Event Cancelled Email - Standard';
        event.Email_Invite_Body__c = 'Invite Body';
        event.Email_Invite_Template__c = '  Matson Event Invited Email - Standard';
        event.Email_Registered_Body__c = 'Registered Body';
        event.Email_Registered_Template__c = '  Matson Event Registered Email - Standard';
        event.Email_Reminder_1_Week_Body__c = '1 Week Body';
        event.Email_Reminder_1_Week_Template__c = ' Matson Event Reminder 1 Week Before Email - Standard';
        event.Email_Reminder_2_Week_Body__c = '2 Week Body';
        event.Email_Reminder_2_Week_Template__c = 'Matson Event Reminder 2 Weeks Before Email - Standard';
        event.Maximum_Registration__c = 50;
        event.Course_Name__c = 'Other';
        event.Secondary_Event_Type__c = secondaryEventType;

        insert event;
        return event;
    }
}