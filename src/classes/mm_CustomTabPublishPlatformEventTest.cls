/*
 * Author: Matt Billups
 * Date: 10/19/18
 * Purpose: Coverage for mm_CustomTabPublishPlatformEvent trigger
 * Note: There are no asserts used because there is no straightforward way to explicitly verify that an event was published via asserts
 */

@isTest
private class mm_CustomTabPublishPlatformEventTest
{
	@isTest
	static void testPublishedCustomTabPlatformEvent(){
		Event__c testEvent = createEvent('Test Event');
		Custom_Tab__c testTab = createCustomTab(testEvent.Id);
		update testTab;
		delete testTab;
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

    static Custom_Tab__c createCustomTab(Id eventId){
		Custom_Tab__c tab = new Custom_Tab__c();
		tab.Matson_Event__c = eventId;
		tab.Name = 'Test Tab';

		insert tab;
		return tab;
	}
}