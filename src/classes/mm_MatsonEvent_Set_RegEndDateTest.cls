@IsTest
public class mm_MatsonEvent_Set_RegEndDateTest {
static testMethod void Testmm_MatsonEvent_Set_RegEndDateTest()
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
    
    
    
    Test.startTest();
    Event__c EVTU = [SELECT Id, RegistrationEndDate__c, Event_End_Date__c FROM Event__c WHERE id =: evt.id limit 1];
    
    System.assert( EVTU.RegistrationEndDate__c == EVTU.Event_End_Date__c );
    
    Test.stopTest();
}

}