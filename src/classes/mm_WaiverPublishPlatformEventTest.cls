/*
 * Author: Matt Billups
 * Date: 10/19/18
 * Purpose: Coverage for mm_WaiverPublishPlatformEvent trigger
 * Note: There are no asserts used because there is no straightforward way to explicitly verify that an event was published via asserts
 */

@isTest
private class mm_WaiverPublishPlatformEventTest
{
	@isTest
	static void testPublishedWaiverPlatformEvent(){
		Event__c testEvent = createEvent('Test Event');
		Event_Waiver__c testWaiver = createWaiver(testEvent.Id);
		update testWaiver;
		delete testWaiver;
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

    static Event_Waiver__c createWaiver(Id eventId){
		Waiver__c w = new Waiver__c(Name = 'Test Waiver', Is_Active__c = TRUE);
		insert w;
		Event_Waiver__c waiver = new Event_Waiver__c();
		waiver.Matson_Event__c = eventId;
		waiver.Waiver__c = w.Id;

		insert waiver;
		return waiver;
	}
}