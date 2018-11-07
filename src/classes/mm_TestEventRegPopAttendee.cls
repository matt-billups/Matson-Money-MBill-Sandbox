@isTest
public class mm_TestEventRegPopAttendee {
    
    @isTest static void testEventRegPopAttendee() {
        // Test data setup
        // Create a contact, adviser and event and then insert
        //create test custom setting:
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');
        
        RecordType RT = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser' and SobjectType='Adviser__c'];
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        
        
        // Create account not needed in dev6 but needed in QA
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        insert acc;
        
        // Create adviser contact
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
        
        // Create an Adviser 
        Adviser__c adv = new Adviser__c();
        adv.Company__c = 'Test comp';
        adv.RecordTypeId = RT2.Id;
        adv.Primary_Contact__c = con.Id;
        adv.Status__c = 'Active Prospect';
        adv.Service_Team__c = '2' ;
        adv.Designation__c  = 'BD' ; 
        adv.Adviser_Coach__c = '00536000001OWzVAAW';
        adv.Firm_ID__c = '22222222' ;
        insert adv;
        
        // Create Attendee Contact
        Contact con1 = new Contact();
        con1.FirstName = 'Luke';
        con1.LastName = 'Skywalker' ;
        con1.Email ='LukeLuke@Empire.com' ;
        con1.Office_Phone__c = '1115561415';
        con1.MailingStreet = '1 Tatooine blvd';
        con1.MailingCity = 'Cincinnati';
        con1.MailingState = 'Ohio';
        con1.MailingPostalCode = '45219';
        con1.AccountId = acc.Id;
        insert con1;
        
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
        evt.Course_Name__c='Entrepreneur Foundation Training Session 1'; 
        evt.Venue__c = ven.id;
        evt.Event_Start_Date__c = System.today() + 90;
        evt.Event_End_Date__c =  System.today() + 95;
        evt.Maximum_Registration__c = 100;
        insert evt;
        
        // Create a Registration
        Event_Registration__c er = new Event_Registration__c();
        er.Attendee_Type__c = 'Adviser';
        er.Reg_Adviser__c = adv.Id;
        er.Event__c = evt.Id;
        insert er;
        
        // test ER Attendee contact is set to ADV primary contact
        System.AssertEquals(er.Contact__c, er.Reg_Adviser__r.Primary_Contact__c);
        
        // set ER Attendee contact to not equal ADV primary contact
        try{
            er.Contact__c = con1.Id;
            update er;
        }
        catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Attendee Contacts cannot be added to records with an Attendee Type of Adviser. Please change the Attendee Type or remove the Attendee and create another Registration for this person if desired.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }        
    }
}