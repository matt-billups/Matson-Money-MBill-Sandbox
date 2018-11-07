@isTest
public class mm_UpdateAdviserProspectSlsSttsFmRegTest {
    
    @isTest static void setUpTestData() {
        
        //create test custom setting:
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234'); 
        HttpRequest request = new HttpRequest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mm_geocodeVenueAddressTest_JSON');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        mock.respond(request);
        Test.setMock(HttpCalloutMock.class, mock); 
        Profile salesProfile = [SELECT Id FROM Profile WHERE Name = 'Sales'];
        List<User> adviserCoachList = [SELECT Id FROM User WHERE ProfileId =: salesProfile.Id AND isActive = True];
        User adviserCoachUser = adviserCoachList[0];
        RecordType prospectRecordType = [SELECT Id FROM RecordType WHERE Name = 'Adviser Prospect' AND SobjectType = 'Adviser__c'];
        
        // create account record
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        insert acc;   
        
        // create contact record with mailing address
        Contact con = new Contact();
        con.FirstName = 'Jess';
        con.LastName = 'Day';
        con.Email =  'adviser@example.com';
        con.MailingStreet = '24716 Long Valley Rd';
        con.MailingCity = 'Calabasas';
        con.MailingState = 'California';
        con.MailingPostalCode = '91302';
        insert con;
        
        // create adviser prospect record with all info needed to register for EFT1 and sales status new
        Adviser__c adv = new Adviser__c();
        adv.RecordTypeId = prospectRecordType.Id;
        adv.Primary_Contact__c = con.Id;
        adv.Adviser_Coach__c = adviserCoachUser.Id;
        adv.Status__c = 'Active Adviser';
        adv.Inventory_Date__c = system.today() - 2;
        adv.X3_Biggest_Money_Problems__c = 'living with 3 guys';
        adv.Pain_Money_Total__c = 1.00;
        adv.Designation__c = 'BD';
        adv.Firm_ID__c = '123';
        adv.Service_Team__c = 'MAA';
        insert adv;
        
        // create venue record
        Venue__c ven = new Venue__c();
        ven.Name = 'The Loft';
        ven.Concierge__c = 'Mason';
        ven.Street_Address_1__c = '1080 Park Blvd';
        ven.Street_Address_2__c = '#206';
        ven.City__c = 'San Diego';
        ven.Venue_State__c = 'CA';
        ven.Postal_Code_Zip__c = '92101';
        insert ven;
        
        // create EFT Session 1 event record
        Event__c futureEvt = new Event__c();
        futureEvt.Course_Name__c = 'Entrepreneur Foundation Training Session 1';
        futureEvt.Name = 'Future Event';
        futureEvt.Event_Start_Date__c = system.today() + 10;
        futureEvt.Event_End_Date__c = system.today() + 12;
        futureEvt.Maximum_Registration__c = 100.00;
        futureEvt.Event_Description__c = 'A future event.';
        futureEvt.Venue__c = ven.Id;
        insert futureEvt;      
        
        // create EFT Session 1 event record
        Event__c pastEvt = new Event__c();
        pastEvt.Course_Name__c = 'Entrepreneur Foundation Training Session 1';
        pastEvt.Name = 'Past Event';
        pastEvt.Event_Start_Date__c = system.today() - 10;
        pastEvt.Event_End_Date__c = system.today() - 8;
        pastEvt.Maximum_Registration__c = 100.00;
        pastEvt.Event_Description__c = 'A past event.';
        pastEvt.Venue__c = ven.Id;
        insert pastEvt; 
        
    }
    
    @isTest static void testInsertRegAllInfoStatusNew() {
        // verifies sales status updates when registration is manually inserted with status registered, sales status is new, and all required fields are filled out
        
        setUpTestData();
        
        Adviser__c adv = [SELECT Id, Sales_Status__c FROM Adviser__c LIMIT 1];
        Event__c evt = [SELECT Id FROM Event__c WHERE Name = 'Future Event' LIMIT 1];
        
        Event_Registration__c reg = new Event_Registration__c();
        reg.Attendee_Type__c = 'Adviser';
        reg.Event__c = evt.Id;
        reg.Reg_Adviser__c = adv.Id;
        reg.Status__c = 'Registered';
        insert reg;     
        
        test.startTest();
        Adviser__c registeredAdviser = [SELECT Id, Sales_Status__c FROM Adviser__c WHERE Id =: adv.Id];
        system.assertEquals('Registered for EFT Session 1', registeredAdviser.Sales_Status__c);
        test.stopTest();
        
    }
    
    @isTest static void testUpdateRegAllInfoStatusNew() {
        // verifies sales status updates when registration is manually updated to status registered, sales status is new, and all required fields are filled out
        
        setUpTestData();
        
        Adviser__c adv = [SELECT Id, Sales_Status__c FROM Adviser__c LIMIT 1];
        Event__c evt = [SELECT Id FROM Event__c WHERE Name = 'Future Event' LIMIT 1];
        
        Event_Registration__c reg = new Event_Registration__c();
        reg.Attendee_Type__c = 'Adviser';
        reg.Event__c = evt.Id;
        reg.Reg_Adviser__c = adv.Id;
        reg.Status__c = 'Invited';
        insert reg;     
        
        test.startTest();
        reg.Status__c = 'Registered';
        update reg;
        Adviser__c registeredAdviser = [SELECT Id, Sales_Status__c FROM Adviser__c WHERE Id =: adv.Id];
        system.assertEquals('Registered for EFT Session 1', registeredAdviser.Sales_Status__c);
        test.stopTest();        
    }
    
    @isTest static void testInsertRegFieldMissingStatusNew() {
        // verifies sales status does not update when registration is manually inserted with status registered, sales status is new, and a required field is missing
        
        setUpTestData();
        
        Adviser__c adv = [SELECT Id FROM Adviser__c LIMIT 1];
        Event__c evt = [SELECT Id FROM Event__c WHERE Name = 'Future Event' LIMIT 1];  
        
        adv.X3_Biggest_Money_Problems__c = '';
        update adv;
        
        Event_Registration__c reg = new Event_Registration__c();
        reg.Attendee_Type__c = 'Adviser';
        reg.Event__c = evt.Id;
        reg.Reg_Adviser__c = adv.Id;
        reg.Status__c = 'Registered';  
        
        test.startTest();
        try{
            insert reg;
        }   
        catch(Exception e)
        {
            Boolean expectedExceptionThrown = e.getMessage().Contains('Please verify that you have filled out the Inventory Date, 3 Biggest Money Problems, and Pain Money Total fields on the Adviser record and the Mailing Address on the Contact record before registering the adviser for this event');
            system.assertEquals(expectedExceptionThrown, true);
        }
        
        test.stopTest();        
    }
    
    @isTest static void testUpdateRegAllInfoInvScheduled() {
        // verifies sales status updates when registration is manually inserted with status registered, sales status is inventory scheduled, and all required fields are filled out
        
        setUpTestData();
        
        Adviser__c adv = [SELECT Id, Sales_Status__c FROM Adviser__c LIMIT 1];
        Event__c evt = [SELECT Id FROM Event__c WHERE Name = 'Future Event' LIMIT 1];  
        
        adv.Sales_Status__c = 'Inventory Scheduled';
        update adv;      
        
        Event_Registration__c reg = new Event_Registration__c();
        reg.Attendee_Type__c = 'Adviser';
        reg.Event__c = evt.Id;
        reg.Reg_Adviser__c = adv.Id;
        reg.Status__c = 'Invited';
        insert reg;     
        
        test.startTest();
        reg.Status__c = 'Registered';
        update reg;
        Adviser__c registeredAdviser = [SELECT Id, Sales_Status__c FROM Adviser__c WHERE Id =: adv.Id];
        system.assertEquals('Registered for EFT Session 1', registeredAdviser.Sales_Status__c);
        test.stopTest();  
    }
    
    
    @isTest static void testInsertRegFieldMissingStatusInvScheduled() {
        // verifies sales status does not update when registration is manually inserted with status registered, sales status is inventory scheduled, and a required field is missing
        
        setUpTestData();
        
        Adviser__c adv = [SELECT Id FROM Adviser__c LIMIT 1];
        Event__c evt = [SELECT Id FROM Event__c WHERE Name = 'Future Event' LIMIT 1];  
        
        adv.X3_Biggest_Money_Problems__c = '';
        adv.Sales_Status__c = 'Inventory Scheduled';
        update adv;
        
        Event_Registration__c reg = new Event_Registration__c();
        reg.Attendee_Type__c = 'Adviser';
        reg.Event__c = evt.Id;
        reg.Reg_Adviser__c = adv.Id;
        reg.Status__c = 'Registered';  
        
        test.startTest();
        try{
            insert reg;
        }   
        catch(Exception e)
        {
            Boolean expectedExceptionThrown = e.getMessage().Contains('Please verify that you have filled out the Inventory Date, 3 Biggest Money Problems, and Pain Money Total fields on the Adviser record and the Mailing Address on the Contact record before registering the adviser for this event');
            system.assertEquals(expectedExceptionThrown, true);
        }
        
        test.stopTest();        
    }
    
    
    @isTest static void testInsertRegAllInfoInvCompleted() {
        // verifies sales status updates when registration is manually inserted with status registered, sales status is inventory scheduled, and all required fields are filled out
        
        setUpTestData();
        
        Adviser__c adv = [SELECT Id, Sales_Status__c FROM Adviser__c LIMIT 1];
        Event__c evt = [SELECT Id FROM Event__c WHERE Name = 'Future Event' LIMIT 1];  
        
        adv.Sales_Status__c = 'Inventory Completed';
        update adv;      
        
        Event_Registration__c reg = new Event_Registration__c();
        reg.Attendee_Type__c = 'Adviser';
        reg.Event__c = evt.Id;
        reg.Reg_Adviser__c = adv.Id;
        reg.Status__c = 'Registered';
        insert reg;     
        
        test.startTest();
        Adviser__c registeredAdviser = [SELECT Id, Sales_Status__c FROM Adviser__c WHERE Id =: adv.Id];
        system.assertEquals('Registered for EFT Session 1', registeredAdviser.Sales_Status__c);
        test.stopTest();  
    }
    
    @isTest static void testUpdateRegAllInfoInvCompleted() {
        // verifies sales status updates when registration is manually inserted with status registered, sales status is inventory scheduled, and all required fields are filled out
        
        setUpTestData();
        
        Adviser__c adv = [SELECT Id, Sales_Status__c FROM Adviser__c LIMIT 1];
        Event__c evt = [SELECT Id FROM Event__c WHERE Name = 'Future Event' LIMIT 1];  
        
        adv.Sales_Status__c = 'Inventory Completed';
        update adv;      
        
        Event_Registration__c reg = new Event_Registration__c();
        reg.Attendee_Type__c = 'Adviser';
        reg.Event__c = evt.Id;
        reg.Reg_Adviser__c = adv.Id;
        reg.Status__c = 'Invited';
        insert reg;     
        
        test.startTest();
        reg.Status__c = 'Registered';
        update reg;
        Adviser__c registeredAdviser = [SELECT Id, Sales_Status__c FROM Adviser__c WHERE Id =: adv.Id];
        system.assertEquals('Registered for EFT Session 1', registeredAdviser.Sales_Status__c);
        test.stopTest();  
    }
    
    @isTest static void testInsertAllInfoCreatedWithAttended() {
        // verifies sales status updates when registration is manually inserted with status registered, sales status is new, and all required fields are filled out
        
        setUpTestData();
        
        Adviser__c adv = [SELECT Id, Sales_Status__c FROM Adviser__c LIMIT 1];
        Event__c evt = [SELECT Id FROM Event__c WHERE Name = 'Past Event' LIMIT 1];
        
        Event_Registration__c reg = new Event_Registration__c();
        reg.Attendee_Type__c = 'Adviser';
        reg.Event__c = evt.Id;
        reg.Reg_Adviser__c = adv.Id;
        reg.Status__c = 'Attended';
        
        test.startTest();
        try{
            insert reg;
        }   
        catch(Exception e)
        {
            Boolean expectedExceptionThrown = e.getMessage().Contains('The Status must be set to Registered for an Entrepreneur Foundation Training Session 1 event before moving to the Status of Attended.');
            system.assertEquals(expectedExceptionThrown, true);
        }
        
        test.stopTest();    
    }
    @isTest static void testInsertAllInfoChangedToAttended(){
        setUpTestData();
        
        Adviser__c adv = [SELECT Id, Sales_Status__c FROM Adviser__c LIMIT 1];
        Event__c evt = [SELECT Id FROM Event__c WHERE Name = 'Past Event' LIMIT 1];
        
        Event_Registration__c reg = new Event_Registration__c();
        reg.Attendee_Type__c = 'Adviser';
        reg.Event__c = evt.Id;
        reg.Reg_Adviser__c = adv.Id;
        reg.Status__c = 'Registered';
        insert reg;
        
        test.startTest();
        
        reg.Status__c = 'Attended';
        reg.Waiver_Status__c ='Not Signed';
        update reg;
        test.stopTest(); 
 
    }
    @isTest static void testUpdateFieldMissingAttended() {
        // verifies sales status does not update when registration is manually updated to status registered, sales status is new, and a required field is missing
        
        setUpTestData();
        
        Adviser__c adv = [SELECT Id FROM Adviser__c LIMIT 1];
        Event__c evt = [SELECT Id FROM Event__c WHERE Name = 'Past Event' LIMIT 1];  
        
        adv.X3_Biggest_Money_Problems__c = '';
        update adv;   
        
        Event_Registration__c reg = new Event_Registration__c();
        reg.Attendee_Type__c = 'Adviser';
        reg.Event__c = evt.Id;
        reg.Reg_Adviser__c = adv.Id;
        reg.Status__c = 'Invited';
        insert reg;
        reg.Status__c = 'Attended';
        
        test.startTest();
        try{
            update reg;
        }   
        catch(Exception e)
        {
            Boolean expectedExceptionThrown = e.getMessage().Contains('Please verify that you have filled out the Inventory Date, 3 Biggest Money Problems, and Pain Money Total fields on the Adviser record and the Mailing Address on the Contact record before registering the adviser for this event');
            system.assertEquals(expectedExceptionThrown, true);
        }
        
        test.stopTest();         
    }
    
}