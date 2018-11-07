@IsTest
public class mm_RegisterForEventCreatePublicTest {
    static testMethod void mm_RegisterForEvent_CreatePublicRegistration() {
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
        evt.PublicRegistration__c = true;
        evt.Event_Description__c = 'test';
        evt.Email_Invite_Body__c = 'test';
        evt.Email_Registered_Body__c = 'test';
        evt.Email_Cancelled_Body__c = 'test'; 
        
        insert evt;
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_RegisterForEvent/';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        RestRequest request = new RestRequest();
        
        List<mm_RegisterForEvent.Guest> guests = new List<mm_RegisterForEvent.Guest>();
        
        mm_RegisterForEvent.Registration registration = new mm_RegisterForEvent.Registration();
        registration.EventId = evt.Id;
        registration.AttendeeType = 'Guest';
        registration.ContactType = 'Guest';
        registration.EmailAddress = 'Text@Example.com';
        registration.FirstName = 'Test';
        registration.LastName = 'Example';
        registration.ShirtSize = 'XL';
        
        RestContext.request.requestBody = Blob.valueof(JSON.serialize(registration));
        
        mm_RegisterForEvent.Register();
        
        System.assert(RestContext.response.responseBody != null);
        
        Test.stopTest();
    }
}