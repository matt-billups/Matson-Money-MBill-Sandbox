@isTest
public class EventRegistrationsTriggerTest
{
    static void init()
    {
        //create test custom setting:
        //privateKey
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');
        
        // Create account
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        
        insert acc;
        //create Track
        Track__c tra = new Track__c();
        tra.Name = 'testtrack';
        
        insert tra;
        
        //Create a Venue
        Venue__c ven = new Venue__c();
        
        ven.Name = 'testVenue';
        ven.Street_Address_1__c = '18760 N Pima Rd';
        ven.City__c ='Scottsdale';
        ven.Venue_State__c = 'AZ';
        ven.Postal_Code_Zip__c = '85255';
        ven.Country__c = 'United States';
        ven.Concierge__c = 'Mason';
        
        insert ven;
        
        //Create an Event
        Event__c evt = new Event__c();
        evt.Name = 'American Dream Experience Test Event name';
        evt.Event_Type__c = 'Training Event';
        evt.Maximum_Registration__c = 50;
        evt.Event_Start_Date__c = System.today() + 5;
        evt.Course_Name__c = 'Other'; 
        evt.Venue__c = ven.Id;
        evt.Track__c = tra.Id;
        evt.Event_Start_Date__c = System.today() + 55;
        evt.Event_End_Date__c  = System.today() + 56;
        evt.ShowOnWebsite__c = true;
        evt.Event_Description__c = 'test';
        evt.Email_Invite_Body__c = 'test';
        evt.Email_Registered_Body__c = 'test';
        evt.Email_Cancelled_Body__c = 'test';
        
        insert evt;
        
        List<Contact> contacts = new List<Contact>();
        
        // Create a contact
        Contact con = new Contact();
        con.FirstName = 'Darth';
        con.LastName = 'Vader' ;
        con.Email ='Vader@Vader.com';
        con.Office_Phone__c = '4561328888';
        con.MailingStreet = '1 DeathStar rd';
        con.MailingCity = 'Mason';
        con.MailingState = 'Ohio';
        con.MailingPostalCode = '45040';
        con.AccountId = acc.Id;
        
        contacts.add(con);
        
        // Create a contact
        Contact con2 = new Contact();
        con2.FirstName = 'Luke';
        con2.LastName = 'Skywalker' ;
        con2.Email ='Luke@Skywalker.com';
        con2.Office_Phone__c = '5555550123';
        con2.MailingStreet = '1 Tatooine rd';
        con2.MailingCity = 'Mason';
        con2.MailingState = 'Ohio';
        con2.MailingPostalCode = '45040';
        con2.AccountId = acc.Id;
        
        contacts.add(con2);
        
        insert contacts;
        
        List<Adviser__c> advisers = new List<Adviser__c>();
        
        // Create an Advisor
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        Adviser__c adv = new Adviser__c();
        adv.Company__c = 'Test comp';
        adv.RecordTypeId = RT2.Id;
        adv.Primary_Contact__c = con.Id;
        adv.X3_Biggest_Money_Problems__c ='some text';
        adv.Pain_Money_Total__c =356;
        adv.Status__c= 'Active Prospect';
        adv.Service_Team__c = '2' ;
        adv.Designation__c  ='BD' ; 
        adv.Adviser_Coach__c = '00536000001OWzVAAW';
        adv.Firm_ID__c = '22222222' ;
        adv.Legacy_RepNo__c = 123456;
        
        advisers.add(adv);
        
        Adviser__c adv2 = new Adviser__c();
        adv2.Company__c = 'Test comp';
        adv2.RecordTypeId = RT2.Id;
        adv2.Primary_Contact__c = con2.Id;
        adv2.X3_Biggest_Money_Problems__c ='some text';
        adv2.Pain_Money_Total__c =356;
        adv2.Status__c= 'Active Prospect';
        adv2.Service_Team__c = '2' ;
        adv2.Designation__c  ='BD' ; 
        adv2.Adviser_Coach__c = '00536000001OWzVAAW';
        adv2.Firm_ID__c = '22222222' ;
        adv2.Legacy_RepNo__c = 987654;
        
        advisers.add(adv2);
        
        insert advisers;
    }
    
    static testMethod void testCreateEventTokenOnBeforeInsert()
    {
        init();
        
        Event__c evt = [SELECT Id FROM Event__c WHERE Name = 'American Dream Experience Test Event name'];
        Adviser__c adv = [SELECT Id FROM Adviser__c WHERE Legacy_RepNo__c = 123456];
        Contact con = [SELECT Id FROM Contact WHERE Email = 'Vader@Vader.com'];
        
        String valueToHash =   String.valueOf(con.Id) + String.valueOf(evt.Id);
        String expectedToken = mm_SettingsHelper.CreateEventToken(valueToHash);
        
        Test.startTest();
        
        // Create an Event Registration
        Event_Registration__c eventRegistration = new Event_Registration__c();
        eventRegistration.Event__c = evt.Id;
        eventRegistration.Status__c = 'Registered';
        eventRegistration.T_Shirt_Size__c = 'XL';
        eventRegistration.Reg_Adviser__c = adv.Id;
        eventRegistration.Attendee_Type__c = 'Adviser';
        eventRegistration.Waiver_Status__c = 'Electronically Signed';
        
        insert eventRegistration;
        
        eventRegistration = [SELECT Registration_Site_Token__c FROM Event_Registration__c WHERE Id =: eventRegistration.Id];
        
        System.assertEquals(expectedToken, eventRegistration.Registration_Site_Token__c);
        
        Test.stopTest();
    }
    
    static testMethod void testCreateEventTokenOnBeforeUpdate()
    {
        init();
        
        Event__c evt = [SELECT Id FROM Event__c WHERE Name = 'American Dream Experience Test Event name'];
        Adviser__c adv = [SELECT Id FROM Adviser__c WHERE Legacy_RepNo__c = 123456];
        Contact con = [SELECT Id FROM Contact WHERE Email = 'Vader@Vader.com'];
        Contact con2 = [SELECT Id FROM Contact WHERE Email = 'Luke@Skywalker.com'];
        Adviser__c adv2 = [SELECT Id FROM Adviser__c WHERE Legacy_RepNo__c = 987654];
        
        // Create an Event Registration
        Event_Registration__c eventRegistration = new Event_Registration__c();
        eventRegistration.Event__c = evt.Id;
        eventRegistration.Status__c = 'Registered';
        eventRegistration.T_Shirt_Size__c = 'XL';
        eventRegistration.Reg_Adviser__c = adv.Id;
        eventRegistration.Attendee_Type__c = 'Adviser';
        eventRegistration.Waiver_Status__c = 'Electronically Signed';
        
        insert eventRegistration;
        
        String valueToHash = String.valueOf(con2.Id) + String.valueOf(evt.Id);
        String expectedToken = mm_SettingsHelper.CreateEventToken(valueToHash);
        
        Test.startTest();
        
        eventRegistration.Contact__c = null;
        eventRegistration.Reg_Adviser__c = adv2.Id;
        update eventRegistration;
        
        eventRegistration = [SELECT Registration_Site_Token__c FROM Event_Registration__c WHERE Id =: eventRegistration.Id];
        
        System.assertEquals(expectedToken, eventRegistration.Registration_Site_Token__c);
        
        Test.stopTest();
    }
}