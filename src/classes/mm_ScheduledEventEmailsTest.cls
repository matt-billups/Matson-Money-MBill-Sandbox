@isTest public class mm_ScheduledEventEmailsTest {
    static testMethod void mm_ScheduledEventEmailsTest()
    {
		Product2 p = new Product2();
        p.Name = 'Test Water';
        p.ProductCode = 'WBWP';
		p.IsActive = true;
		insert p;
        
        Test.startTest();
        mm_ScheduledEventEmails emails = new mm_ScheduledEventEmails();
        emails.execute(null) ;
        Test.stopTest();
    }
    
    
}