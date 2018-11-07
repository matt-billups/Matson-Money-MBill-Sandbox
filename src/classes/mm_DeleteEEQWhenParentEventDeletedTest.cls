@isTest public class mm_DeleteEEQWhenParentEventDeletedTest {
    static testMethod void Testmm_DeleteEEQWhenParentEventDeletedTest()
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
        evt.Course_Name__c = 'Other'; 
        evt.Venue__c = ven.Id;
        evt.Track__c = tra.Id;
        evt.Event_Start_Date__c = System.today() + 1;
        evt.Event_End_Date__c  = System.today() + 2;
        evt.ShowOnWebsite__c = true;
        evt.Event_Description__c  = 'description';       
        
        insert evt;
        
        //Event Question
        EventQuestion__c eq =  new EventQuestion__c();
        eq.Question_Text__c = 'yada yada yada yada yada yada yada yada';
        eq.Answer_Type__c = 'Text';
        insert eq;
        
        //EventEventQuestion - Question for event
        EventEventQuestion__c eeq = new EventEventQuestion__c();
        eeq.Matson_Event__c = evt.Id;
        eeq.Event_Question__c = eq.Id;
        eeq.Sort_Order__c = 1;
        eeq.Question_Type__c = 'Registration';
        eeq.IsActive__c = True;
        insert eeq;
        
        Test.startTest();
        
        Event__c EVTU = [SELECT Id FROM Event__c WHERE id =: evt.id limit 1];
        delete EVTU;
        Test.stopTest();
    }
}