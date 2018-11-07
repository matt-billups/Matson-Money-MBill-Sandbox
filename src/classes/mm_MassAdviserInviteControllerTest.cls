@isTest public with sharing class mm_MassAdviserInviteControllerTest {
    
    //create test data
    
    static testMethod void testMassAdviserInviteController() {
        // Test data setup
        //create test custom setting:
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');
        
        // Create a contact, adviser and event and then insert
        
        RecordType RT = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser' and SobjectType='Adviser__c'];
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        
        Profile salesProfile = [SELECT Id FROM Profile WHERE Name = 'Sales'];
        User adviserCoachUser = [SELECT Id FROM User WHERE isActive = True AND ProfileId =: salesProfile.Id LIMIT 1];
        
        // Create account not needed in dev6 but needed in QA
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
        adv.RecordTypeId = RT.Id;
        adv.Primary_Contact__c = con.Id;
        adv.Status__c = 'Active Adviser';
        adv.Service_Team__c = '2' ;
        adv.Designation__c  = 'BD' ; 
        adv.Adviser_Coach__c = adviserCoachUser.Id;
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
        evt.Event_Start_Date__c = System.today() + 60;
        evt.Event_End_Date__c =  System.today() + 65;
        evt.Event_Description__c = 'test';
        evt.Email_Invite_Body__c = 'test';
        evt.Email_Registered_Body__c = 'test';
        evt.Email_Cancelled_Body__c = 'test';
        evt.Maximum_Registration__c = 100;
        insert evt;
        
        List<Adviser__c> reqs =  MassAdviserInviteController.getAdvisers(evt.Id, true); 
        List<Adviser__c> reqs2 =  MassAdviserInviteController.getAdvisers(evt.Id, false); 
        List<string> lsstr= new List<string> ();
        
        for(Adviser__c a: reqs){
            lsstr.add(String.valueOf(a.Id));
        }
        
        // Perform test
        Test.startTest();
        
        system.assertNotEquals(null, MassAdviserInviteController.getAdvisers(evt.Id, true));
        MassAdviserInviteController.inviteAdvisersToEvent(evt.Id, lsstr);
        
        Test.stopTest();
        
        String query = 'SELECT COUNT() FROM Event_Registration__c WHERE Reg_Adviser__c = \'' + adv.Id + '\' AND Event__c = \'' + evt.Id + '\'';
        System.assertEquals(1, Database.countQuery(query));
    }
    
 	static testMethod void testMassAdviserInviteController2() {
        // Test data setup
        //create test custom setting:
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');
        
        // Create a contact, adviser and event and then insert
        
        RecordType RT = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser' and SobjectType='Adviser__c'];
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        
        Profile salesProfile = [SELECT Id FROM Profile WHERE Name = 'Sales'];
        User adviserCoachUser = [SELECT Id FROM User WHERE isActive = True AND ProfileId =: salesProfile.Id LIMIT 1];
        
        // Create account not needed in dev6 but needed in QA
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
        adv.Status__c = 'Active Prospect';
        adv.Service_Team__c = '2' ;
        adv.Designation__c  = 'BD' ; 
        adv.Adviser_Coach__c = adviserCoachUser.Id;
        adv.Firm_ID__c = '22222222' ;
        adv.Pain_Money_Total__c = 12;
        adv.X3_Biggest_Money_Problems__c ='anything';
        adv.Inventory_Date__c= System.now() -2;
        
        
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
        evt.Course_Name__c='Entrepreneur Foundation Training Session 1'; 
        evt.Venue__c = ven.id;
        evt.Event_Start_Date__c = System.today() + 60;
        evt.Event_End_Date__c =  System.today() + 65;
        evt.Event_Description__c = 'test';
        evt.Email_Invite_Body__c = 'test';
        evt.Email_Registered_Body__c = 'test';
        evt.Email_Cancelled_Body__c = 'test';
        evt.Maximum_Registration__c = 100;
        insert evt;
        
        List<Adviser__c> reqs =  MassAdviserInviteController.getAdvisers(evt.Id, true); 
        List<string> lsstr= new List<string> ();
        
        for(Adviser__c a: reqs){
            lsstr.add(String.valueOf(a.Id));
        }
        
        // Perform test
        Test.startTest();
        
        system.assertNotEquals(null, MassAdviserInviteController.getAdvisers(evt.Id, true));
        MassAdviserInviteController.inviteAdvisersToEvent(evt.Id, lsstr);
        
        Test.stopTest();
        
        String query = 'SELECT COUNT() FROM Event_Registration__c WHERE Reg_Adviser__c = \'' + adv.Id + '\' AND Event__c = \'' + evt.Id + '\'';
        System.assertEquals(1, Database.countQuery(query));
    }
    
     @isTest static void TestGetEventName(){
         
        //  set up test data
         
        // create a Venue
        Venue__c ven = new Venue__c();
        ven.Name = 'Porters Crate';
        ven.Street_Address_1__c = '1234 Cincinnati Street';
        ven.City__c ='Dayton';
        ven.Venue_State__c = 'OH';
        ven.Postal_Code_Zip__c = '45219';
        ven.Country__c = 'United States';
        ven.Concierge__c = 'Mason';
        insert ven;
         
         // create a Matson Evnt
         Event__c evt = new Event__c();
         evt.Course_Name__c = 'Other';
         evt.Name = 'Porter Party';
         evt.Event_Start_Date__c = system.today() + 4;
         evt.Event_End_Date__c = system.today() + 5;
         evt.Event_Description__c = 'descriiiiiption';
         evt.Venue__c = ven.Id;
         evt.Event_Status__c = 'Active';
         evt.Maximum_Registration__c = 100;
         insert evt;
         
         test.startTest();
         Event__c myEvent = [SELECT Id FROM Event__c WHERE Name = 'Porter Party'];
         String eventName = MassAdviserInviteController.GetEventName(myEvent.Id);
         System.assertEquals('Porter Party', eventName);
         Test.stopTest();
         
     }
    
    @isTest static void TestEventCancelled(){
         
        //  set up test data
         
        // create a Venue
        Venue__c ven = new Venue__c();
        ven.Name = 'Porters Crate';
        ven.Street_Address_1__c = '1234 Cincinnati Street';
        ven.City__c ='Dayton';
        ven.Venue_State__c = 'OH';
        ven.Postal_Code_Zip__c = '45219';
        ven.Country__c = 'United States';
        ven.Concierge__c = 'Mason';
        insert ven;
         
         // create a Matson Evnt
         Event__c evt = new Event__c();
         evt.Course_Name__c = 'Other';
         evt.Name = 'Porter Party';
         evt.Event_Start_Date__c = system.today() + 4;
         evt.Event_End_Date__c = system.today() + 5;
         evt.Event_Description__c = 'descriiiiiption';
         evt.Venue__c = ven.Id;
         evt.Event_Status__c = 'Cancelled';
         evt.Maximum_Registration__c = 100;
         insert evt;
         
         test.startTest();
         Event__c myEvent = [SELECT Id FROM Event__c WHERE Name = 'Porter Party'];
         Boolean cancelled = MassAdviserInviteController.EventCancelled(myEvent.Id);
         System.assertEquals(true, cancelled);
         test.stopTest();
         
     }
    
        
    @isTest static void TestEventCompleted(){
         
        //  set up test data
         
        // create a Venue
        Venue__c ven = new Venue__c();
        ven.Name = 'Porters Crate';
        ven.Street_Address_1__c = '1234 Cincinnati Street';
        ven.City__c ='Dayton';
        ven.Venue_State__c = 'OH';
        ven.Postal_Code_Zip__c = '45219';
        ven.Country__c = 'United States';
        ven.Concierge__c = 'Mason';
        insert ven;
         
         // create a Matson Evnt
         Event__c evt = new Event__c();
         evt.Course_Name__c = 'Other';
         evt.Name = 'Porter Party';
         evt.Event_Start_Date__c = system.today() - 4;
         evt.Event_End_Date__c = system.today() - 3;
         evt.Event_Description__c = 'descriiiiiption';
         evt.Venue__c = ven.Id;
         evt.Event_Status__c = 'Cancelled';
         evt.Maximum_Registration__c = 100;
         insert evt;
         
         test.startTest();
         Event__c myEvent = [SELECT Id FROM Event__c WHERE Name = 'Porter Party'];
         Boolean completed = MassAdviserInviteController.EventCompleted(myEvent.Id);
         System.assertEquals(true, completed);
         test.stopTest();
         
     }
    
    
    /*public static List<Adviser__c> filterAdviserResults(String searchKey, List<Adviser__c> adviserList) {
        
        String name = '%' + searchKey + '%';
        List<Adviser__c> filteredAdviserList = [SELECT Id, Primary_Contact_Name__c, Adviser_Number__c, Contact_Email__c FROM Adviser__c WHERE Id IN: adviserList AND Primary_Contact__r.Name LIKE: name];
        return filteredAdviserList;*/
    
    @isTest static void TestFilterAdviserResults() {
        
        // set up test data
        
        RecordType RT = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser' and SobjectType='Adviser__c'];
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        
        Profile salesProfile = [SELECT Id FROM Profile WHERE Name = 'Sales'];
        User adviserCoachUser = [SELECT Id FROM User WHERE isActive = True AND ProfileId =: salesProfile.Id LIMIT 1];
        
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
        
        Adviser__c adv = new Adviser__c();
        adv.Company__c = 'Test comp';
        adv.RecordTypeId = RT2.Id;
        adv.Primary_Contact__c = con.Id;
        adv.Status__c = 'Active Adviser';
        adv.Service_Team__c = '2' ;
        adv.Designation__c  = 'BD'; 
        adv.Adviser_Coach__c = adviserCoachUser.Id;
        adv.Firm_ID__c = '22222222' ;
        
        insert adv;
        
        Contact con1 = new Contact();
        con1.FirstName = 'Test';
        con1.LastName = 'Contact';
        con1.Email = 'Test@Test.com';
        con1.Office_Phone__c = '1233455678';
        con1.MailingStreet = '1234 Testing Ln';
        con1.MailingCity = 'Test';
        con1.MailingState = 'Ohio';
        con1.MailingPostalCode = '29911';
        con1.AccountId = acc.Id;
        
        insert con1;
        
        Adviser__c adv1 = new Adviser__c();
        adv1.Company__c = 'A company';
        adv1.RecordTypeId = RT2.Id;
        adv1.Primary_Contact__c = con1.Id;
        adv1.Status__c = 'Active Adviser';
        adv1.Service_Team__c = '1';
        adv1.Designation__c  = 'BD'; 
        adv1.Adviser_Coach__c = adviserCoachUser.Id;
        adv1.Firm_ID__c = '123';
        
        insert adv1;
        
        test.startTest();
        String searchKey = 'test'; 	// a search key similar to con1's name
        List<Adviser__c> adviserList = [SELECT Id FROM Adviser__c];
        List<Adviser__c> results = MassAdviserInviteController.filterAdviserResults(searchKey, adviserList);
        System.assertEquals(1, results.size());		// only the adviser with the primary contact name of Test should be returned
        test.stopTest();
        
    }



    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    }