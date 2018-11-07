@isTest public class mm_ContactExistsRestPullTest {
    
    
      static testMethod void mm_Test_mm_ContactExistsRestPull()
    {
        
        //create test custom setting:
        //privateKey
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');
        
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        // Create account
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Walt';
        con.LastName = 'Disney' ;
        con.Nickname__c = 'Mickey';
        con.Email ='braden.fraley@matsonmoney.com' ;
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
        adv.Legacy_RepNo__c = 123456;
        
        insert adv;
        
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
        evt.Course_Name__c='Other'; 
        evt.Venue__c = ven.Id;
        evt.Track__c = tra.Id;
        evt.Event_Start_Date__c = System.today() + 55;
        evt.Event_End_Date__c  = System.today() + 56;
        evt.Event_Description__c = 'test';
        evt.Email_Invite_Body__c = 'test';
        evt.Email_Registered_Body__c = 'test';
        evt.Email_Cancelled_Body__c = 'test';
        
        insert evt; 
        // END TEST DATA CREATION
        
        
       // RestRequest req = new RestRequest(); 
       // RestResponse res = new RestResponse();
       // req.requestURI = '/services/apexrest/mm_ContactExistsRestPull/';
        
        //system.debug('***uri***' +  req.requestURI);
        //req.addParameter('CONID', con.id);
        //req.addParameter('EVID', evt.id);
        //req.addParameter('FN', con.FirstName);
        //req.addParameter('LN', con.LastName);
        //req.addParameter('EM', con.Email);
        //req.addParameter('NN', con.Nickname__c);
        
       // req.httpMethod = 'GET';
       // RestContext.request = req;
       // RestContext.response = res;
        
       // Test.startTest();
       // mm_ContactExistsRestPull.GetContacts();
       // Test.stopTest();
        String ValueToHash = '';
        String Encrypted = '';

        ValueToHash =   String.valueOf(con.id)+String.valueOf(evt.id);
            
        Encrypted = mm_SettingsHelper.CreateEventToken(ValueToHash);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/mm_ContactExistsRestPull/';
        
        
        req.addParameter('TOKEN', Encrypted);       
        req.addParameter('CONID', con.id);
        req.addParameter('EVID', evt.id);
        req.addParameter('FN', con.FirstName);
        req.addParameter('LN', con.LastName);
        req.addParameter('EM', con.Email);
        req.addParameter('NN', con.Nickname__c);
        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        String TestContacts = mm_ContactExistsRestPull.GetContacts();
        System.assertEquals('Authorized', TestContacts);
        Test.stopTest();
        
        
    }
    static testMethod void mm_Test_mm_ContactExistsRestPullWithAuthToken()
    {
        
        //create test custom setting:
        //privateKey
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');
        
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        // Create account
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Walt';
        con.LastName = 'Disney' ;
        con.Nickname__c = 'Mickey';
        con.Email ='braden.fraley@matsonmoney.com' ;
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
        adv.Legacy_RepNo__c = 123456;
        
        insert adv;
        
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
        evt.Course_Name__c='Other'; 
        evt.Venue__c = ven.Id;
        evt.Track__c = tra.Id;
        evt.Event_Start_Date__c = System.today() + 55;
        evt.Event_End_Date__c  = System.today() + 56;
        evt.Event_Description__c = 'test';
        evt.Email_Invite_Body__c = 'test';
        evt.Email_Registered_Body__c = 'test';
        evt.Email_Cancelled_Body__c = 'test';
        
        insert evt; 
        
        String ValueToHash = '';
        String Encrypted = '';

        ValueToHash =   String.valueOf(con.id)+String.valueOf(evt.id);
            
        Encrypted = mm_SettingsHelper.CreateEventToken(ValueToHash);
        
        // END TEST DATA CREATION
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/mm_ContactExistsRestPull/';
        
        
        req.addParameter('TOKEN', Encrypted);       
        req.addParameter('CONID', con.id);
        req.addParameter('EVID', evt.id);
        req.addParameter('FN', con.FirstName);
        req.addParameter('LN', con.LastName);
        req.addParameter('EM', con.Email);
        req.addParameter('NN', con.Nickname__c);
        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        String TestContacts = mm_ContactExistsRestPull.GetContacts();
        System.assertEquals('Authorized', TestContacts);
        Test.stopTest();
        
        
    }


    static testMethod void mm_Test_mm_ContactExistsRestPullWithAuthTokenNoAdviser()
    {
        
        //create test custom setting:
        //privateKey
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');
        
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        // Create account
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        
        insert acc;
        
        //Contact with no adviser
        Contact con = new Contact();
        con.FirstName = 'Walt';
        con.LastName = 'Disney' ;
        con.Nickname__c = 'Mickey';
        con.Email ='braden.fraley@matsonmoney.com' ;
        con.Office_Phone__c = '4561328888';
        con.MailingStreet = '1 DeathStar rd';
        con.MailingCity = 'Mason';
        con.MailingState = 'Ohio';
        con.MailingPostalCode = '45040';
        con.AccountId = acc.Id;
        
        insert con;

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
        evt.Course_Name__c='Other'; 
        evt.Venue__c = ven.Id;
        evt.Track__c = tra.Id;
        evt.Event_Start_Date__c = System.today() + 55;
        evt.Event_End_Date__c  = System.today() + 56;
        evt.PublicRegistration__c = True;
        evt.Event_Description__c = 'test';
        evt.Email_Invite_Body__c = 'test';
        evt.Email_Registered_Body__c = 'test';
        evt.Email_Cancelled_Body__c = 'test';
        
        insert evt; 
        
        String ValueToHash = '';
        String Encrypted = '';

        ValueToHash =   String.valueOf(con.id)+String.valueOf(evt.id);
            
        Encrypted = mm_SettingsHelper.CreateEventToken(ValueToHash);

        // END TEST DATA CREATION
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/mm_ContactExistsRestPull/';
        
        
        req.addParameter('TOKEN', Encrypted);       
        req.addParameter('CONID', con.id);
        req.addParameter('EVID', evt.id);
        req.addParameter('FN', con.FirstName);
        req.addParameter('LN', con.LastName);
        req.addParameter('EM', con.Email);
        req.addParameter('NN', con.Nickname__c);
        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        String TestContacts = mm_ContactExistsRestPull.GetContacts();
        System.assertEquals('Authorized', TestContacts);
        Test.stopTest();
        
        
    }
    static testMethod void mm_Test_mm_ContactExistsRestPullWithAuthTokenNoRegistration()
    {
        
        //create test custom setting:
        //privateKey
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');
        
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        // Create account
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Walt';
        con.LastName = 'Disney' ;
        con.Nickname__c = 'Mickey';
        con.Email ='braden.fraley@matsonmoney.com' ;
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
        adv.Legacy_RepNo__c = 123456;
        
        insert adv;
        
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
        //evt.mm_TestRestResourceEndpoints = 'www.yahoo.com';
        evt.Course_Name__c='Other'; 
        evt.Venue__c = ven.Id;
        evt.Track__c = tra.Id;
        evt.Event_Start_Date__c = System.today() + 55;
        evt.Event_End_Date__c  = System.today() + 56;
        evt.Event_Description__c = 'test';
        evt.Email_Invite_Body__c = 'test';
        evt.Email_Registered_Body__c = 'test';
        evt.Email_Cancelled_Body__c = 'test';
        
        insert evt; 

        //registration for invited status
        Event_Registration__c reg = new Event_Registration__c();
        reg.Event__c = evt.Id;
        reg.Status__c = 'Invited';
        reg.Attendee_Type__c = 'Adviser';
        reg.Reg_Adviser__c = adv.Id;
        insert reg;
        
        String ValueToHash = '';
        String Encrypted = '';

        ValueToHash =   String.valueOf(con.id)+String.valueOf(evt.id);
            
        Encrypted = mm_SettingsHelper.CreateEventToken(ValueToHash);

        // END TEST DATA CREATION
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/mm_ContactExistsRestPull/';
        
        
        req.addParameter('TOKEN', Encrypted);       
        req.addParameter('CONID', con.id);
        req.addParameter('EVID', evt.id);
        req.addParameter('FN', con.FirstName);
        req.addParameter('LN', con.LastName);
        req.addParameter('EM', con.Email);
        req.addParameter('NN', con.Nickname__c);
        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        String TestContacts = mm_ContactExistsRestPull.GetContacts();
        System.assertEquals('Authorized', TestContacts);
        Test.stopTest();
        
        
    }
    static testMethod void mm_Test_mm_ContactExistsRestPullWithAuthTokenNotMatching()
    {
        
        //create test custom setting:
        //privateKey
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');
        
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        // Create account
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Walt';
        con.LastName = 'Disney' ;
        con.Nickname__c = 'Mickey';
        con.Email ='braden.fraley@matsonmoney.com' ;
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
        adv.Legacy_RepNo__c = 123456;
        
        insert adv;
        
        //create Track
        Track__c tra = new Track__c();
        tra.Name = 'testtrack';
        
        insert tra;
         
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
        evt.Name = 'American Dream Experience Test Event name';
        evt.Event_Type__c = 'Training Event';
        evt.Maximum_Registration__c = 50;
        evt.Event_Start_Date__c = System.today() + 5;
        evt.Course_Name__c='Other'; 
        evt.Venue__c = ven.Id;
        evt.Track__c = tra.Id;
        evt.Event_Start_Date__c = System.today() + 55;
        evt.Event_End_Date__c  = System.today() + 56;
        evt.Event_Description__c = 'test';
        evt.Email_Invite_Body__c = 'test';
        evt.Email_Registered_Body__c = 'test';
        evt.Email_Cancelled_Body__c = 'test';
        
        insert evt; 



        //registration for invited status
        Event_Registration__c reg = new Event_Registration__c();
        reg.Event__c = evt.Id;
        reg.Status__c = 'Invited';
        reg.Attendee_Type__c = 'Adviser';
        reg.Reg_Adviser__c = adv.Id;
        insert reg;
        
        String ValueToHash = '';
        String Encrypted = '';
        
        ///passing in Adviser Id instead of Contact Id for a no match Auth token
        ValueToHash =   String.valueOf(adv.id)+String.valueOf(evt.id);
            
        Encrypted = mm_SettingsHelper.CreateEventToken(ValueToHash);

        // END TEST DATA CREATION
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/mm_ContactExistsRestPull/';
        
        
        req.addParameter('TOKEN', Encrypted);       
        req.addParameter('CONID', con.id);
        req.addParameter('EVID', evt.id);
        req.addParameter('FN', con.FirstName);
        req.addParameter('LN', con.LastName);
        req.addParameter('EM', con.Email);
        req.addParameter('NN', con.Nickname__c);
        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        String TestContacts = mm_ContactExistsRestPull.GetContacts();
        System.assertEquals('Not Authorized', TestContacts);
        Test.stopTest();
        
        
    }
    static testMethod void mm_Test_mm_ContactExistsRestPull_ContactDoesNotExist()
    {

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/mm_ContactExistsRestPull/';
        

        req.addParameter('FN', 'DoesnotExist');
        req.addParameter('LN', 'DoesnotExist');
        req.addParameter('EM', 'DoesnotExist@DoesnotExist.com');
        req.addParameter('NN', 'DoesnotExist');
        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        String TestContacts = mm_ContactExistsRestPull.GetContacts();
        System.assertEquals('False', TestContacts);
        Test.stopTest();
        
        
    }
    static testMethod void mm_Test_mm_ContactExistsRestPull_NOAuthTokenConExists()
    {
          //create test custom setting:
        //privateKey
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');
        
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        // Create account
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Walt';
        con.LastName = 'Disney' ;
        con.Nickname__c = 'Mickey';
        con.Email ='braden.fraley@matsonmoney.com' ;
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
        adv.Legacy_RepNo__c = 123456;
        
        insert adv;
        
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
        evt.Course_Name__c='Other'; 
        evt.Venue__c = ven.Id;
        evt.Track__c = tra.Id;
        evt.Event_Start_Date__c = System.today() + 55;
        evt.Event_End_Date__c  = System.today() + 56;
        evt.Event_Description__c = 'test';
        evt.Email_Invite_Body__c = 'test';
        evt.Email_Registered_Body__c = 'test';
        evt.Email_Cancelled_Body__c = 'test';
        
        insert evt; 
        
        String ValueToHash = '';
        String Encrypted = '';

        ValueToHash =   String.valueOf(con.id)+String.valueOf(evt.id);
            
        Encrypted = mm_SettingsHelper.CreateEventToken(ValueToHash);
        
        // END TEST DATA CREATION
        
        
       // RestRequest req = new RestRequest(); 
       // RestResponse res = new RestResponse();
       // req.requestURI = '/services/apexrest/mm_ContactExistsRestPull/';
        
        
      //  req.addParameter('TOKEN', Encrypted);       
      //  req.addParameter('CONID', con.id);
      //  req.addParameter('EVID', evt.id);
      //  req.addParameter('FN', con.FirstName);
      //  req.addParameter('LN', con.LastName);
      //  req.addParameter('EM', con.Email);
      //  req.addParameter('NN', con.Nickname__c);
        
        //req.httpMethod = 'GET';
       // RestContext.request = req;
        //RestContext.response = res;
        
        //Test.startTest();
        //String TestContacts = mm_ContactExistsRestPull.GetContacts();
        //System.assertEquals('Authorized', TestContacts);
       // Test.stopTest();
        
        
        
        
        
/////////////////////////
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/mm_ContactExistsRestPull/';
        

        req.addParameter('CONID', con.id);
        req.addParameter('EVID', evt.id);
        req.addParameter('FN', con.FirstName);
        req.addParameter('LN', con.LastName);
        req.addParameter('EM', con.Email);
        req.addParameter('NN', con.Nickname__c);
        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        String TestContacts = mm_ContactExistsRestPull.GetContacts();
        System.assertEquals('True', TestContacts);
        Test.stopTest();
        
        
    }


}