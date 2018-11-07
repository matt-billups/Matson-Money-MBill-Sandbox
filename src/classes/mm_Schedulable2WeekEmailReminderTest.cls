@isTest public with sharing class mm_Schedulable2WeekEmailReminderTest {
    static testMethod void Schedulable1WeekEmailReinderTest()
    {
                RecordType RT = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser' and SobjectType='Adviser__c'];
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        
        
        // Create account not needed in dev6 but needed in QA
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        
        insert acc;
      
 		//create test custom setting:
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234'); 
 

        
        Contact con = new Contact();
        
        con.FirstName = 'Darth';
        con.LastName = 'Vader' ;
        con.Email ='Vader@example.com' ;
        con.Office_Phone__c = '4561328888';
        con.MailingStreet = '1 DeathStar rd';
        con.MailingCity = 'Mason';
        con.MailingState = 'Ohio';
        con.MailingPostalCode = '45040';
        con.AccountId = acc.Id;
        
        insert con;
        
        // Create an Advisor 
        
        Adviser__c adv = new Adviser__c();
        adv.Company__c = 'Test comp';
        adv.RecordTypeId = RT.Id;
        adv.Primary_Contact__c = con.Id;
        adv.Status__c = 'Active Adviser';
        adv.Service_Team__c = '2' ;
        adv.Designation__c  = 'BD' ; 
        adv.Adviser_Coach__c = '00536000001OWzVAAW';
        adv.Firm_ID__c = '22222222' ;
        
        
        insert adv;
        
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
        evt.Name = 'Test Event name';
        evt.Event_Type__c = 'Training Event';
        evt.Course_Name__c='Other'; 
        evt.Venue__c = ven.id;
        evt.Email_Cancelled_Template__c = 'Matson Event Cancelled Email - Standard';
        evt.Email_Registered_Template__c = 'Matson Event Registered Email - Standard';
        evt.Email_Invite_Template__c = 'Matson Event Invited Email - Standard';
        evt.Email_Reminder_1_Week_Template__c = 'Matson Event Reminder 1 Week Before Email - Standard';
        evt.Email_Reminder_2_Week_Template__c = 'Matson Event Reminder 2 Weeks Before Email - Standard';
        evt.Event_Description__c = 'test';
        evt.Email_Invite_Body__c = 'test';
        evt.Email_Registered_Body__c = 'test';
        evt.Email_Cancelled_Body__c = 'test';
        evt.Event_Start_Date__c = System.today() + 14;
        evt.Event_End_Date__c =  System.today() + 15;
        evt.Maximum_Registration__c = 100;
        insert evt;
        
        
        //Insert new event Registraion
        Event_Registration__c evr = new Event_Registration__c();
        evr.Event__c = evt.Id;
        evr.Attendee_Type__c = 'Adviser';
        evr.Reg_Adviser__c =  adv.id;
        evr.Status__c = 'Registered';
        
        insert evr;

        
        mm_Schedulable2WeekEmailReminder s=new  mm_Schedulable2WeekEmailReminder();
        s.execute(null) ;
    }

}