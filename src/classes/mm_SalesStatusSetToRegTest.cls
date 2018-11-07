@isTest
public class mm_SalesStatusSetToRegTest {
    
    
    
    @isTest static void testSalesStatusToRegWithRegistationAlreadyCreated() {
        Event__c fakeEvent = createFakeEvent();
        Contact fakeContact = fakeContact();
        
        RecordType RT = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        List<User> coaches = [SELECT Id, Name, isActive FROM User WHERE User.Profile.Name = 'Sales' AND isActive = true];
        
        Adviser__c adv = new Adviser__c();
        adv.RecordTypeId = RT.Id;
        adv.Primary_Contact__c = fakeContact.Id;
        adv.Status__c = 'Active Prospect';
        adv.Adviser_Coach__c = coaches[1].Id;
        adv.Inventory_Date__c = system.today();
        adv.X3_Biggest_Money_Problems__c = 'stufff';
        adv.Pain_Money_Total__c = 10.00;
        insert adv;
        
        test.startTest();
        Event_Registration__c registration = new Event_Registration__c();
        registration.Attendee_Type__c = 'Adviser';
        registration.Reg_Adviser__c = adv.Id;
        registration.Event__c = fakeEvent.Id;
        registration.Status__c='Invited';
        insert registration;
        
        adv.Sales_Status__c ='Registered for EFT Session 1';    
        update adv;
        test.stopTest();
        
        
        
    }
    
    @isTest static void testSalesStatusToRegWithRegistationWithOutReg(){
        Event__c fakeEvent = createFakeEvent();
        Contact fakeContact = fakeContact();
        
        RecordType RT = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        List<User> coaches = [SELECT Id, Name, isActive FROM User WHERE User.Profile.Name = 'Sales' AND isActive = true];
        
        Adviser__c adv = new Adviser__c();
        adv.RecordTypeId = RT.Id;
        adv.Primary_Contact__c = fakeContact.Id;
        adv.Status__c = 'Active Prospect';
        adv.Adviser_Coach__c = coaches[1].Id;
        adv.Inventory_Date__c = system.today();
        adv.X3_Biggest_Money_Problems__c = 'stufff';
        adv.Pain_Money_Total__c = 10.00;
        insert adv;
        
        test.startTest();
        adv.Sales_Status__c ='Registered for EFT Session 1';    
        update adv;
        test.stopTest();
        
    }
    @isTest static void testSalesStatusToAttendedWithRegistation(){
        
        Event__c fakeEvent = createFakeEvent();
        Contact fakeContact = fakeContact();
        
        RecordType RT = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        List<User> coaches = [SELECT Id, Name, isActive FROM User WHERE User.Profile.Name = 'Sales' AND isActive = true];
        
        Adviser__c adv = new Adviser__c();
        adv.RecordTypeId = RT.Id;
        adv.Primary_Contact__c = fakeContact.Id;
        adv.Status__c = 'Active Prospect';
        adv.Adviser_Coach__c = coaches[1].Id;
        adv.Inventory_Date__c = system.today();
        adv.X3_Biggest_Money_Problems__c = 'stufff';
        adv.Pain_Money_Total__c = 10.00;
        insert adv;
        
        test.startTest();
        Event_Registration__c registration = new Event_Registration__c();
        registration.Attendee_Type__c = 'Adviser';
        registration.Reg_Adviser__c = adv.Id;
        registration.Event__c = fakeEvent.Id;
        registration.Status__c='Registered';
        insert registration;
        
        fakeEvent.Event_Start_Date__c = system.today() -1;
        fakeEvent.Event_End_Date__c = system.today() -1;
        update fakeEvent;
        
        adv.Sales_Status__c ='EFT Session 1 Attended';    
        update adv;
        test.stopTest();
        
    } 
    
    
    @isTest static Event__c createFakeEvent()
    {
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
        
        // create event
        Event__c evt = new Event__c();
        evt.Course_Name__c = 'Entrepreneur Foundation Training Session 1';
        evt.Name = 'This is a test';
        evt.Event_Start_Date__c = system.today() +1;
        evt.Event_End_Date__c = system.today()+1;
        evt.Event_Description__c = 'stuff';
        evt.Maximum_Registration__c = 100;
        evt.Venue__c = ven.Id;
        insert evt;
        return evt;
    } 
    @isTest static Contact fakeContact(){
        
        // create account
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        insert acc;
        
        // contact for registered status
        Contact con = new Contact();
        con.FirstName = 'Chester';
        con.LastName = 'Tester';
        con.Email = 'example@adviser.com';
        con.Office_Phone__c = '9376290231';
        con.MailingStreet = '1234 Test Ave';
        con.MailingCity = 'Cincinnati';
        con.MailingStateCode = 'OH';
        con.MailingPostalCode = '45219';
        con.AccountId = acc.Id;
        
        
        insert con;
        return con;
    }
    @isTest static void testSalesStatusToRegisteredWithoutEFT1Event(){
        
        Contact fakeContact = fakeContact();
        RecordType RT = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        
        List<User> coaches = [SELECT Id, Name, isActive FROM User WHERE User.Profile.Name = 'Sales' AND isActive = true];
        Adviser__c adv = new Adviser__c();
        adv.RecordTypeId = RT.Id;
        adv.Primary_Contact__c = fakeContact.Id;
        adv.Status__c = 'Active Prospect';
        adv.Adviser_Coach__c = coaches[1].Id;
        adv.Inventory_Date__c = system.today();
        adv.X3_Biggest_Money_Problems__c = 'stufff';
        adv.Pain_Money_Total__c = 10.00;
        insert adv;
        
        test.startTest();
        try{
            adv.Sales_Status__c = 'Registered for EFT Session 1';
            update adv;  
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown2A =  e.getMessage().contains('There are no Entrepreneur Foundation Training Session 1 Scheduled');
            
        }
        test.stopTest();
        
    }
    @isTest static void testSalesStatusToAttendedWithoutEFT1Registration(){
        
                Contact fakeContact = fakeContact();
        RecordType RT = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        
        List<User> coaches = [SELECT Id, Name, isActive FROM User WHERE User.Profile.Name = 'Sales' AND isActive = true];
        Adviser__c adv = new Adviser__c();
        adv.RecordTypeId = RT.Id;
        adv.Primary_Contact__c = fakeContact.Id;
        adv.Status__c = 'Active Prospect';
        adv.Adviser_Coach__c = coaches[1].Id;
        adv.Inventory_Date__c = system.today();
        adv.X3_Biggest_Money_Problems__c = 'stufff';
        adv.Pain_Money_Total__c = 10.00;
        insert adv;
        
        test.startTest();
        try{
            adv.Sales_Status__c = 'EFT Session 1 Attended';
            update adv;  
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown2A =  e.getMessage().contains('There is no Entrepreneur Foundation Training Session 1 Registration for ' + adv.Name +' that has a status of Registered or Attended, if you found this message in error, please manually add Adviser to event with the desired status.');
            
        }
        test.stopTest();
    }
    
}