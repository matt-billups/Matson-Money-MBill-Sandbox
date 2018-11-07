@IsTest public class mm_AmericanDreamCancelledThrowAwayTEST {
    
    static testMethod void test_mm_AmericanDreamCancelledThrowAwayTEST() {
        // Test data setup
        // Create a contact, adviser and event and then insert
        
        //create test custom setting:
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');

        // Create account not needed in dev6 but needed in QA
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        
        insert acc;
        
        //Create Contact 2
        Contact con2 = new Contact();
        
        con2.FirstName = 'Luke';
        con2.LastName = 'Sky' ;
        con2.Email ='Luke@Vader.com' ;
        con2.Office_Phone__c = '4561328889';
        con2.MailingStreet = '13 DeathStar rd';
        con2.MailingCity = 'Mason';
        con2.MailingState = 'Ohio';
        con2.MailingPostalCode = '45040';
        con2.AccountId = acc.Id;
        
        insert con2;
        
       
        
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
        
        //Create an Event2
        Event__c evt2 = new Event__c();
        evt2.Name = 'Test Event name';
        evt2.Event_Type__c = 'Training Event';
        evt2.Course_Name__c='Other'; 
        evt2.Venue__c = ven.id;
        evt2.Event_Start_Date__c = System.today() + 55;
        evt2.Event_End_Date__c  = System.today() + 56;
        evt2.Event_Description__c = 'test';
        evt2.Email_Invite_Body__c = 'test';
        evt2.Email_Registered_Body__c = 'test';
        evt2.Email_Cancelled_Body__c = 'test';
        evt2.Maximum_Registration__c = 100;
        
        insert evt2;
        
        //Insert new event Registraion
        Event_Registration__c evr = new Event_Registration__c();
        evr.Event__c = evt2.Id;
        evr.Attendee_Type__c = 'Other';
        evr.Contact__c = con2.id;
        evr.Status__c = 'Registered';
        
         insert evr;

      
        Test.startTest();
        mm_AmericanDreamCancelledThrowAway.sendEventCancelledEmail(evt2.Id, '0');
        Test.stopTest();      
    }
    
    
    
    

}