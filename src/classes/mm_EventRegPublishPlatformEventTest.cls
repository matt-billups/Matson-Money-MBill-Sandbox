/*
 * Author: Matt Billups
 * Date: 10/18/18
 * Purpose: Coverage for mm_EventRegistrationPublishPlatformEvent trigger
 * Note: There are no asserts used because there is no straightforward way to explicitly verify that an event was published via asserts
 */

@isTest
private class mm_EventRegPublishPlatformEventTest
{
	@isTest
	static void testPublishedEventRegistrationPlatformEvent(){
		RecordType primary = getRecordType('Primary Matson Event');
		Event__c event = createEvent('Test Event', primary.Id, NULL, NULL);
		Contact c = createContact();
		Event_Registration__c testRegistration = createRegistration(event.Id, c.Id);
        update testRegistration;
		delete testRegistration;
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

    static RecordType getRecordType(String rtName){
    	RecordType rt = [SELECT Id FROM RecordType WHERE Name =: rtName];
    	return rt;
    }

    static Contact createContact(){
    	Contact c = new Contact();
    	c.FirstName = 'Test';
    	c.LastName = 'Contact';
    	c.Email = 'test@test.com';

    	insert c;
    	return c;
    }

    static Event_Registration__c createRegistration(Id eventId, Id contactId){
    	Event_Registration__c reg = new Event_Registration__c();
    	reg.Event__c = eventId;
    	reg.Status__c = 'Queued';
    	reg.Attendee_Type__c = 'Client';
    	reg.Contact__c = contactId;

    	insert reg;
    	return reg;
    }
}