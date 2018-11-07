/*
 * Author: Matt Billups
 * Date: 10/19/18
 * Purpose: Coverage for mm_EventExpensePublishPlatformEvent trigger
 * Note: There are no asserts used because there is no straightforward way to explicitly verify that an event was published via asserts
 */

@isTest
private class mm_EventExpensePublishPlatformEventTest
{
	@isTest
	static void testPublishedEventExpensePlatformEvent(){
		RecordType primary = getRecordType('Primary Matson Event');
		Event__c testEvent = createEvent('Test Event', primary.Id, NULL, NULL);
		Event_Expense__c testExpense = createExpense(testEvent.Id);
		update testExpense;
		delete testExpense;
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

    static Event_Expense__c createExpense(Id eventId){
    	Vendor__c v = new Vendor__c(Name = 'Test Vendor');
    	insert v;
    	Event_Expense__c expense = new Event_Expense__c();
    	expense.Event__c = eventId;
    	expense.Vendor_Name__c = v.Id;

    	insert expense;
    	return expense;
    }
}