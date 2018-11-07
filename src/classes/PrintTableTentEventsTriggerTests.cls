@isTest
public class PrintTableTentEventsTriggerTests {
    static testMethod void test() {
        Test.startTest();
        Database.SaveResult result = EventBus.publish(fakePrintTableTentEvent());
        Test.stopTest();
    }
    
    private static Print_Table_Tent__e fakePrintTableTentEvent() {
        Print_Table_Tent__e fake = new Print_Table_Tent__e(Printer_Id__c = 'abc-123', Attendee_First_Name__c = 'Test', Attendee_Last_Name__c = 'McTest');
        return fake;
    }
}