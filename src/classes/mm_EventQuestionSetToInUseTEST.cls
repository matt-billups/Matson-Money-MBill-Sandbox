@isTest public with sharing class mm_EventQuestionSetToInUseTEST {
    static testMethod void testmm_EventQuestionSetToInUseTEST() {
        //Create Test Data
        
        RecordType RTNew =[select ID From RecordType where name = 'New'and SobjectType='EventQuestion__c'];
        RecordType RTInUse =[select ID From RecordType where name = 'In Use'and SobjectType='EventQuestion__c'];
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
        
        //Create EventQuestion
        EventQuestion__c eq =  new EventQuestion__c ();
        eq.Answer_Type__c = 'Text';
        eq.RecordTypeId = RTNew.Id ;
        eq.Question_Text__c = 'This is a question';
        
        insert eq;

        //Create EventEventQuestion
        EventEventQuestion__c eeq =  new EventEventQuestion__c ();
        eeq.Event_Question__c = eq.Id;
        eeq.Matson_Event__c = evt.Id;
        eeq.Sort_Order__c =1;
        eeq.IsActive__c = True;
        eeq.Question_Type__c = 'Registration';
        
        insert eeq;
        
        
    }
    
    
    
    
    
}