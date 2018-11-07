@isTest public class mm_noShowTriggerTest {
    static testMethod void test_mm_noShowTriggerTest(){
        
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        
                
        //create test custom setting:
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');
        
        // Create account
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Darth';
        con.LastName = 'Vader' ;
        con.Email ='Vader@Vader.com' ;
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
        adv.RecordTypeId = RT2.Id;
        adv.Primary_Contact__c = con.Id;
        adv.X3_Biggest_Money_Problems__c ='some text';
        adv.Pain_Money_Total__c =356;
        adv.Status__c= 'Active Prospect';
        adv.Service_Team__c = '2' ;
        adv.Designation__c  ='BD' ; 
        adv.Adviser_Coach__c = '00536000001OWzVAAW';
        adv.Firm_ID__c = '22222222' ;
        
        insert adv;
        
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
        
        //Create an Event
        Event__c evt = new Event__c();
        evt.Name = 'Test Event name';
        evt.Event_Type__c = 'Training Event';
        evt.Maximum_Registration__c = 50;
        evt.Course_Name__c='Other';
        evt.Event_Start_Date__c = System.today();
        evt.Event_End_Date__c = System.today();
        evt.Venue__c = ven.id;
        
        insert evt; 
        
        
        //create event reg for EVENT ABove
        Event_Registration__c ER = new Event_Registration__c();
        ER.Attendee_Type__c = 'Adviser';
        ER.Reg_Adviser__c = adv.id;
        ER.Event__c = evt.Id;
        ER.Contact__c =con.Id;
        ER.AutoLastEmailedDate__c = null;
        insert ER;
        
        Event_Registration__c ETR = [Select Id, Reg_Adviser__c,Event__c ,Confirmation_Number__c, Primary_Contact_Id__c from Event_Registration__c Where Id =: ER.Id limit 1];
        
        
        ETR.Status__c = 'No Show';
        
        update ETR;
        //lookup Task created by trigger
        Task ERTask =[select Priority, Subject, Status, WhatId, WhoId, OwnerId, Description from Task where WhatId =: ER.Reg_Adviser__c Limit 1];
        
    }
}