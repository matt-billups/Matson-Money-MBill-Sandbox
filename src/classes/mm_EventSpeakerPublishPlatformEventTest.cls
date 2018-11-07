/*
 * Author: Matt Billups
 * Date: 10/19/18
 * Purpose: Coverage for mm_EventSpeakerPublishPlatformEvent trigger
 * Note: There are no asserts used because there is no straightforward way to explicitly verify that an event was published via asserts
 */

@isTest
private class mm_EventSpeakerPublishPlatformEventTest
{
	@isTest
	static void testPublishedEventSpeakerPlatformEvent(){
		Event__c testEvent = createEvent('Test Event');
		Contact testContact = createContact();
		Matson_Event_Speaker__c testSpeaker = createSpeaker(testEvent.Id, testContact.Id);
        update testSpeaker;
		delete testSpeaker;
	}

	static Event__c createEvent(String eventName) {
		RecordType primary = [SELECT Id FROM RecordType WHERE Name = 'Primary Matson Event'];

        Event__c event = new Event__c();
        event.Name = eventName;
        event.RecordTypeId = primary.Id;
        event.Primary_Matson_Event__c = NULL;
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
        event.Secondary_Event_Type__c = NULL;

        insert event;
        return event;
    }

    static Contact createContact(){
    	Contact c = new Contact();
    	c.FirstName = 'Test';
    	c.LastName = 'Contact';
    	c.Email = 'test@test.com';

    	insert c;
    	return c;
    }

    static Matson_Event_Speaker__c createSpeaker(Id eventId, Id contactId){
		Matson_Event_Speaker__c speaker = new Matson_Event_Speaker__c();
		speaker.Matson_Event__c = eventId;
		speaker.Speaker_Contact__c = contactId;
		speaker.Sort_Order__c = 1;

		insert speaker;
		return speaker;
	}
}