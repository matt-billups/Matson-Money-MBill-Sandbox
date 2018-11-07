@isTest
public with sharing class mm_EventClearCacheMicrositeTest {
    
    
    static testMethod void testmm_EventClearCacheMicrositeTest() {
        // Test data setup
        
        //create test custom setting:
        insert new EventTokenHashKey__c(Crypto__c = '623456789123456789112234');   
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
        evt.Event_Start_Date__c = System.today() + 15;
        evt.Event_End_Date__c =  System.today() + 16;
        evt.Event_Description__c = 'test';
        evt.Email_Invite_Body__c = 'test';
        evt.Email_Registered_Body__c = 'test';
        evt.Email_Cancelled_Body__c = 'test';
        evt.Maximum_Registration__c = 100;
        insert evt;
        
        List<String> id = new list<String> {evt.Id};

        Test.startTest();
        
        string status;
        HttpRequest request = new HttpRequest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        mock.setStaticResource('mm_geocodeVenueAddressTest_JSON');
        
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        mock.respond(request);
        HttpResponse response = new HttpResponse();
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        
        // Call the method that performs the callout
        
        mm_EventClearCacheMicrosite.doEventCallout(id);
        
        
        Test.stopTest();   
    }
}