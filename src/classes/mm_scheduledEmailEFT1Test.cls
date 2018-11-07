@isTest public class mm_scheduledEmailEFT1Test {
    
    
    static testMethod void scheduledEmailEFT1TestMorning()
    {
        // Test data setup
        List<User> coaches = [SELECT Id, Name, isActive FROM User WHERE User.Profile.Name = 'Sales' AND isActive = true];
        RecordType RT = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        
        
        //create test custom setting:
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234'); 
        
        // create account
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        insert acc;
        
        Product2 p = new Product2();
        p.Name = 'Test Water';
        p.ProductCode = 'WBWP';
        p.IsActive = true;
        insert p;
        
        // create venue
        Venue__c ven = new Venue__c();
        ven.Name = 'testVenue';
        ven.Street_Address_1__c = '18760 N Pima Rd';
        ven.City__c ='Scottsdale';
        ven.Venue_State__c = 'AZ';
        ven.Postal_Code_Zip__c = '85255';
        ven.Country__c = 'United States';
        ven.Concierge__c = 'Mason';
        insert ven; 
        
        Date eventDate = system.today().addDays(50);
        // create event
        Event__c evt = new Event__c();
        evt.Course_Name__c = 'Entrepreneur Foundation Training Session 1';
        evt.Name = 'This is a test';
        evt.Event_Start_Date__c = eventDate ;
        evt.Event_End_Date__c = eventDate;
        evt.Event_Description__c = 'stuff';
        evt.Maximum_Registration__c = 100;
        evt.Venue__c = ven.Id;
        insert evt;
        
        // contact for registered status
        Contact con1 = new Contact();
        con1.FirstName = 'Chester1';
        con1.LastName = 'Tester1';
        con1.Email = 'example1@adviser.com';
        con1.Office_Phone__c = '8376290231';
        con1.MailingStreet = '1284 Test Ave';
        con1.MailingCity = 'Cincinnati';
        con1.MailingStateCode = 'OH';
        con1.MailingPostalCode = '45219';
        con1.AccountId = acc.Id;
        insert con1;
        
        // adviser for registered status
        Adviser__c adv1 = new Adviser__c();
        adv1.RecordTypeId = RT.Id;
        adv1.Primary_Contact__c = con1.Id;
        adv1.Status__c = 'Active Prospect';
        adv1.Adviser_Coach__c = coaches[1].Id;
        adv1.Inventory_Date__c = system.today();
        adv1.X3_Biggest_Money_Problems__c = 'stufff';
        adv1.Pain_Money_Total__c = 10.00;
        insert adv1;
        
        
        //registration for registered status
        Event_Registration__c reg = new Event_Registration__c();
        reg.Event__c = evt.Id;
        reg.Status__c = 'Registered';
        reg.Attendee_Type__c = 'Adviser';
        reg.Reg_Adviser__c = adv1.Id;
        reg.AutoLastEmailedDate__c = system.today().addDays(-1);
        insert reg; 
        
        Date daysFromEvent35 = eventDate.addDays(-35);
        Date daysFromEvent32 = eventDate.addDays(-32);
        Date daysFromEvent22 = eventDate.addDays(-22);
        Date daysFromEvent18 = eventDate.addDays(-18);
        Date daysFromEvent3 = eventDate.addDays(-3);
        
        
        Test_Mode__c testDate = new Test_Mode__c();
        testDate.isTestMode__c = true;
        testDate.System_Test_Date__c = daysFromEvent35;
        insert testDate;
        
        Test.startTest();
        
        mm_ScheduledEmailEFT1 eft1Emails = new mm_ScheduledEmailEFT1();
        eft1Emails.EFT1EmailsmorningSechudled();    
        
        testDate.System_Test_Date__c = daysFromEvent32;
        update testDate;   
        eft1Emails = new mm_ScheduledEmailEFT1();
        eft1Emails.EFT1EmailsmorningSechudled();    
        
        
        testDate.System_Test_Date__c = daysFromEvent22 ;
        update testDate;       
        eft1Emails = new mm_ScheduledEmailEFT1();        
        eft1Emails.EFT1EmailsmorningSechudled();   
        
        testDate.System_Test_Date__c = daysFromEvent3 ;
        update testDate;       
        eft1Emails = new mm_ScheduledEmailEFT1();        
        eft1Emails.EFT1EmailsmorningSechudled(); 

        Test.stopTest();
    }   
    
}