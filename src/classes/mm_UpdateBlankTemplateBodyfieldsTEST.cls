@isTest public with sharing class mm_UpdateBlankTemplateBodyfieldsTEST {
    static testMethod void testmm_UpdateBlankTemplateBodyfieldsTEST() {
        
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
        evt.Maximum_Registration__c = 100;
        evt.Event_Description__c = 'test';
        evt.Maximum_Registration__c = 100;

        
        insert evt;

    }   
    
}