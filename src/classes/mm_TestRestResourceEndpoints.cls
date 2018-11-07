@isTest
public class mm_TestRestResourceEndpoints {
    static testMethod void mm_Test_SpecificEventRestPull()
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
        adv.Legacy_RepNo__c = 123456;
        
        insert adv;
        
        //create hotel
        Hotel__c hot = new Hotel__c();
        hot.Name = 'Test Hotel';
        hot.Description__c ='hotel has a real address';
        hot.Web_Address__c = 'www.test.com';
        hot.Hotel_Phone_Number__c = '5555555555';
        hot.Address__c = '7887 E Princess Blvd';
        hot.City__c = 'Scotsdale';
        hot.State__c = 'AZ';
        hot.Postal_Code_Zip__c = '85255';
        
        insert hot;
        
        //create Track
        Track__c tra = new Track__c();
        tra.Name = 'testtrack';
        
        insert tra;
        
        // Create FAQ
        FAQ__c fa = new FAQ__c();
        fa.Name = 'TestFAQ1';
        fa.Order__c = 1;
        fa.Question__c = 'how much?';
        fa.Answer__c = 'Lots';
        fa.Track__c = tra.id;
        
        insert fa;
        
        
        //Create an Event
        Event__c evt = new Event__c();
        evt.Name = 'American Dream Experience Test Event name';
        evt.Event_Type__c = 'Training Event';
        evt.Maximum_Registration__c = 50;
        evt.Event_Start_Date__c = System.today() + 5;
        evt.Course_Name__c='Other'; 
        // evt.Venue__c = ven.Id;
        evt.Track__c = tra.Id;
        evt.Event_Start_Date__c = System.today() + 55;
        evt.Event_End_Date__c  = System.today() + 56;
        evt.Event_Description__c = 'test';
        evt.Email_Invite_Body__c = 'test';
        evt.Email_Registered_Body__c = 'test';
        evt.Email_Cancelled_Body__c = 'test';
        
        insert evt; 
        
        // Create Event hotel -event junc obj
        Event_Hotel__c evhot = new Event_Hotel__c();
        evhot.Matson_Event__c =  evt.Id;
        evhot.Hotel__c = hot.id;
        
        insert evhot;
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_SpecificEventRestPull/?EVID=';  
        req.addParameter('EVID', evt.id);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        RestRequest request = new RestRequest();
        
        List<Event__c> Testevnt = mm_SpecificEventRestPull.GetEvents();
        
        
        System.assert(Testevnt.size() >=0 );
        
        RestRequest req2 = new RestRequest(); 
        RestResponse res2 = new RestResponse();
        
        req2.requestURI = '/services/apexrest/mm_AllFutureEventRestPull/?EVID=';  
        
        req2.httpMethod = 'GET';
        RestContext.request = req2;
        RestContext.response = res2;
        
        
        List<Event__c> Testevnt2 = mm_AllFutureEventRestPull.GetEvents();
        System.assert(Testevnt.size() >=0 );
    }
    
    
    static testMethod void mm_Test_SingleEventHotelRestPull()
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
        adv.Legacy_RepNo__c = 123456;
        
        insert adv;
        
        //create hotel
        Hotel__c hot = new Hotel__c();
        hot.Name = 'Test Hotel';
        hot.Description__c ='hotel has a real address';
        hot.Web_Address__c = 'www.test.com';
        hot.Hotel_Phone_Number__c = '5555555555';
        hot.Address__c = '7887 E Princess Blvd';
        hot.City__c = 'Scotsdale';
        hot.State__c = 'AZ';
        hot.Postal_Code_Zip__c = '85255';
        
        insert hot;
        
        //create Track
        Track__c tra = new Track__c();
        tra.Name = 'testtrack';
        
        insert tra;
        
        // Create FAQ
        FAQ__c fa = new FAQ__c();
        fa.Name = 'TestFAQ1';
        fa.Order__c = 1;
        fa.Question__c = 'how much?';
        fa.Answer__c = 'Lots';
        fa.Track__c = tra.id;
        
        insert fa;
        
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
        
        // Create Event hotel -event junc obj
        Event_Hotel__c evhot = new Event_Hotel__c();
        evhot.Matson_Event__c =  evt.Id;
        evhot.Hotel__c = hot.id;
        evhot.Discount_Code__c = 'testcode';
        
        insert evhot;
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_SingleEventHotelRestPull/?EVID=';  
        req.addParameter('EVID', evt.id);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        
        List<Event_Hotel__c> TestEVHot = mm_SingleEventHotelRestPull.GetEventHotels();
        
        
        System.assert(TestEVHot.size() >=0 );
        
    } 
    
    
    static testMethod void mm_Test_SpecificEventRegistrationRestPull()
    {   
        //create test custom setting:
        //privateKey
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');
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
        
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
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
        
        Contact con2 = new Contact();
        con2.FirstName = 'Ddddarth';
        con2.LastName = 'Vader' ;
        con2.Email ='Vader@Vader.com' ;
        con2.Office_Phone__c = '4561328888';
        con2.MailingStreet = '1 DeathStar rd';
        con2.MailingCity = 'Mason';
        con2.MailingState = 'Ohio';
        con2.MailingPostalCode = '45040';
        con2.AccountId = acc.Id;
        
        insert con2;
        
        
        
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
        
        //create hotel
        Hotel__c hot = new Hotel__c();
        hot.Name = 'Test Hotel';
        hot.Description__c ='hotel has a real address';
        hot.Web_Address__c = 'www.test.com';
        hot.Hotel_Phone_Number__c = '5555555555';
        hot.Address__c = '7887 E Princess Blvd';
        hot.City__c = 'Scotsdale';
        hot.State__c = 'AZ';
        hot.Postal_Code_Zip__c = '85255';
        
        insert hot;
        
        //create Track
        Track__c tra = new Track__c();
        tra.Name = 'testtrack';
        
        insert tra;
        
        // Create FAQ
        FAQ__c fa = new FAQ__c();
        fa.Name = 'TestFAQ1';
        fa.Order__c = 1;
        fa.Question__c = 'how much?';
        fa.Answer__c = 'Lots';
        fa.Track__c = tra.id;
        
        insert fa;
        
        
        //Create an Event
        Event__c evt = new Event__c();
        evt.Name = 'American Dream Experience Test Event name';
        evt.Event_Type__c = 'Training Event';
        evt.Maximum_Registration__c = 50;
        evt.Event_Start_Date__c = System.today() + 5;
        evt.Course_Name__c='Other'; 
        evt.Venue__c = ven.Id;
        evt.Track__c = tra.Id;
        evt.PublicRegistration__c = TRUE;
        evt.Event_Start_Date__c = System.today() + 55;
        evt.Event_End_Date__c  = System.today() + 56;
        evt.Event_Description__c = 'test';
        evt.Email_Invite_Body__c = 'test';
        evt.Email_Registered_Body__c = 'test';
        evt.Email_Cancelled_Body__c = 'test';
        
        insert evt; 
        
        // Create Event hotel -event junc obj
        Event_Hotel__c evhot = new Event_Hotel__c();
        evhot.Matson_Event__c =  evt.Id;
        evhot.Hotel__c = hot.id;
        evhot.Discount_Code__c = 'testcode';
        
        insert evhot;
        
        
        System.Debug('made it here');
        Event_Registration__c evr2 = new Event_Registration__c();
        //evr2.Adviser__c = adv.id;
        evr2.Reg_Adviser__c = adv.id;
        //evr2.Contact__c = con.Id;
        evr2.Event__c = evt.Id;
        evr2.Attendee_Type__c = 'Adviser';
        evr2.T_Shirt_Size__c = 'S';
        evr2.Status__c = 'Invited';
        
        insert evr2;
        
        System.Debug('made it here2');
        
        Event_Registration__c evr3 = new Event_Registration__c();
        
        evr3.Parent_Registration__c = evr2.id;
        evr3.Contact__c = con2.Id;
        evr3.Event__c = evt.Id;
        evr3.Attendee_Type__c = 'Guest';
        evr3.T_Shirt_Size__c = 'S';
        evr3.Status__c = 'Invited';
        
        insert evr3;
        System.Debug('made it here3');
        
        Test.startTest();
        
        //do request
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_SpecificEventRegistrationRestPull/?EVID=';  
        req.addParameter('EVID', evt.id);
        //req.addParameter('LRN', String.valueOf(adv.Legacy_RepNo__c));
        req.addParameter('CONID', con.id);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        List<Event_Registration__c> TestevntReg = mm_SpecificEventRegistrationRestPull.GetEventRegistrations();
        
        
        System.assert(TestevntReg.size() >=0 );  
        
        
        //do request
        RestRequest req2 = new RestRequest(); 
        RestResponse res2 = new RestResponse();
        
        req2.requestURI = '/services/apexrest/mm_AllEventRegistrationsRestPull/?LRN=';  
        req2.addParameter('LRN', String.valueOf(adv.Legacy_RepNo__c));
        req2.httpMethod = 'GET';
        RestContext.request = req2;
        RestContext.response = res2;
        
        List<Event_Registration__c> TestevntReg2 = mm_AllEventRegistrationsRestPull.GetEventRegistrations();
        
        
        System.assert(TestevntReg2.size() >=0 );  
        

        Event_Registration__c R = [SELECT Id,Name, Reg_Adviser__c, Contact__c, Event__c,DuplicateCheckHidden__c, Attendee_Type__c FROM Event_Registration__c WHERE Contact__c =: con2.id and Event__c =:evt.id];
      
        
        Test.stopTest();
        
    }   
    
    
    static testMethod void mm_Test_UpdateEventRegistrationRest()
    {   
        //create test custom setting:
        //privateKey
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');
        
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
        
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
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
        adv.Legacy_RepNo__c = 123456;
        
        insert adv;
        
        //create hotel
        Hotel__c hot = new Hotel__c();
        hot.Name = 'Test Hotel';
        hot.Description__c ='hotel has a real address';
        hot.Web_Address__c = 'www.test.com';
        hot.Hotel_Phone_Number__c = '5555555555';
        hot.Address__c = '7887 E Princess Blvd';
        hot.City__c = 'Scotsdale';
        hot.State__c = 'AZ';
        hot.Postal_Code_Zip__c = '85255';
        
        insert hot;
        
        //create Track
        Track__c tra = new Track__c();
        tra.Name = 'testtrack';
        
        insert tra;
        
        // Create FAQ
        FAQ__c fa = new FAQ__c();
        fa.Name = 'TestFAQ1';
        fa.Order__c = 1;
        fa.Question__c = 'how much?';
        fa.Answer__c = 'Lots';
        fa.Track__c = tra.id;
        
        insert fa;
        
        
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
        
        // Create Event hotel -event junc obj
        Event_Hotel__c evhot = new Event_Hotel__c();
        evhot.Matson_Event__c =  evt.Id;
        evhot.Hotel__c = hot.id;
        evhot.Discount_Code__c = 'testcode';
        
        insert evhot;
        
        Event_Registration__c evr2 = new Event_Registration__c();
        //evr2.Adviser__c = adv.id;
        evr2.Reg_Adviser__c = adv.id;
        evr2.Event__c = evt.Id;
        evr2.Attendee_Type__c = 'Adviser';
        evr2.T_Shirt_Size__c = 'S';
        evr2.Status__c = 'Invited';
        
        insert evr2;
        
        Test.startTest();
        
        //do request
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_UpdateEventRegistrationRest/?ERID=';  
        req.addParameter('ERID', evr2.id);
        req.addParameter('TS', 'XL');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        List<Event_Registration__c> TestevntReg = mm_UpdateEventRegistrationRest.GetEventRegistrations();
        
        
        System.assert(TestevntReg.size() >=0 );       
        
        Test.stopTest();
        
    }
    static testMethod void mm_Test_RetriveFAQforEventRestPull()
    {
        //create test custom setting:
        //privateKey
        insert new EventTokenHashKey__c(Crypto__c = '723456789123456789112234');
        
        //create Track
        Track__c tra = new Track__c();
        tra.Name = 'testtrack';
        
        insert tra;
        SYSTEM.DEBUG('*****TRack***'+ tra.Name);       
        // Create FAQ
        FAQ__c fa = new FAQ__c();
        fa.Name = 'TestFAQ1';
        fa.Order__c = 1;
        fa.Question__c = 'how much?';
        fa.Answer__c = 'Lots';
        fa.Track__c = tra.id;
        
        insert fa;
         
       
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
        
        Test.startTest();     
        //do request
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_RetriveFAQforEventRestPull/?EVID=';  
        req.addParameter('EVID', evt.id);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        
        List<FAQ__c> TestFAQ = mm_RetriveFAQforEventRestPull.GetFAQs();
        
        System.assert(TestFAQ.size() >=0 );
        
        Test.stopTest(); 
    } 
    
    static testMethod void mm_Test_RetriveEventDayforEventRestPull()
    {   
        //create test custom setting:
        //privateKey
        insert new EventTokenHashKey__c(Crypto__c = '823456789123456789112234');
        
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
        
        //Create Event Day record 
        Event_Days__c ed = new Event_Days__c();
        ed.Matson_Event__c = evt.id;
        ed.Name = 'EventDay description';
        
        insert ed;
        

        Test.startTest();
        
        //do request
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_RetriveEventDayforEventRestPull/?ERID=';  
        req.addParameter('EVID', evt.id);
        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        List<Event_Days__c> TestevntDays = mm_RetriveEventDayforEventRestPull.GetEventDays();
        
        
        System.assert(TestevntDays.size() >=0 );       
        
        Test.stopTest();
        
    } 
    static testMethod void mm_Test_SingleEventRestaurantRestPull()
    {   
        //create test custom setting:
        //privateKey
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');
        
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
        
        //Create Restaurant record 
        Restaurant__c rest = new Restaurant__c();
        rest.Name = 'test Restaurant';
        rest.Phone__c = '5555555555'; 
        rest.Street_Address__c = '7887 E Princess Blvd';
        rest.City__c = 'Scottsdale';  
        rest.State__c = 'AZ';
        rest.Postal_Code_Zip__c = '85255';
        
        insert rest;
        
        
        Test.startTest();
        
        //do request
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_SingleEventRestaurantRestPull/?EVID=';  
        req.addParameter('EVID', evt.id);
        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        List<Restaurant__c> TestRestaurants = mm_SingleEventRestaurantRestPull.GetEventRestaurants();
        
        
        System.assert(TestRestaurants.size() >=0 );       
        
        Test.stopTest();
        
    }   
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

}