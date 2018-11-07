/*
 * Author: Matt Billups
 * Date: 10/19/18
 * Purpose: Coverage for mm_QuestionPublishPlatformEvent trigger
 * Note: There are no asserts used because there is no straightforward way to explicitly verify that an event was published via asserts
 */

@isTest
private class mm_QuestionPublishPlatformEventTest
{
	@isTest
	static void testPublishedQuestionPlatformEvent(){
		Event__c testEvent = createEvent('Test Event');
		EventEventQuestion__c testQuestion = createQuestion(testEvent.Id);
		delete testQuestion;
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

    static EventEventQuestion__c createQuestion(Id eventId){
		RecordType questionRT = [SELECT Id FROM RecordType WHERE Name = 'New' AND SObjectType = 'EventQuestion__c'];
		EventQuestion__c q = new EventQuestion__c(Question_Text__c = 'Test question', RecordTypeId = questionRT.Id);
		insert q;
		EventEventQuestion__c question = new EventEventQuestion__c();
		question.Matson_Event__c = eventId;
		question.Event_Question__c = q.Id;
		question.IsActive__c = TRUE;
		question.Sort_Order__c = 1;
		question.Question_Type__c = 'Registration';

		insert question;
		return question;
	}
}