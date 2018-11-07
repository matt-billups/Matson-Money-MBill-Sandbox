@IsTest
public class OneFeaturedHotelPerEventTrigger_Test {
    
    static testMethod void FeaturedCheckNoOtherFeatureHotel()
    {
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
        evt.Event_Start_Date__c = System.today() + 55;
        evt.Event_End_Date__c  = System.today() + 56;
        evt.ShowOnWebsite__c = true;
        evt.Event_Description__c = 'test';
        evt.Email_Invite_Body__c = 'test';
        evt.Email_Registered_Body__c = 'test';
        evt.Email_Cancelled_Body__c = 'test';
        
        insert evt;
        
        Hotel__c hotel = new Hotel__c();
        hotel.Name = 'Hotel California';
        hotel.Address__c ='6902 E Greenway Pkwy'; 
        hotel.City__c = 'Scottsdale';
        hotel.State__c = 'AZ';
        hotel.Postal_Code_Zip__c = '85254';
        
        insert hotel;
   
        Event_Hotel__c  EventHotel = new Event_Hotel__c();
        EventHotel.Matson_Event__c = evt.Id;
        EventHotel.Hotel__c= hotel.Id;
        EventHotel.Featured__c= true;
        
        insert EventHotel;
        
             
    }
    static testMethod void FeaturedCheckwithOtherFeatureHotel()
    {
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
        evt.Event_Start_Date__c = System.today() + 55;
        evt.Event_End_Date__c  = System.today() + 56;
        evt.ShowOnWebsite__c = true;
        evt.Event_Description__c = 'test';
        evt.Email_Invite_Body__c = 'test';
        evt.Email_Registered_Body__c = 'test';
        evt.Email_Cancelled_Body__c = 'test';
        
        insert evt;
        
        Hotel__c hotel = new Hotel__c();
        hotel.Name = 'Hotel California';
        hotel.Address__c ='6902 E Greenway Pkwy'; 
        hotel.City__c = 'Scottsdale';
        hotel.State__c = 'AZ';
        hotel.Postal_Code_Zip__c = '85254';
        
        insert hotel;
        
        Event_Hotel__c  EventHotel = new Event_Hotel__c();
        EventHotel.Matson_Event__c = evt.Id;
        EventHotel.Hotel__c= hotel.Id;
        EventHotel.Featured__c= true;
        insert EventHotel;
        
        Hotel__c hotel2 = new Hotel__c();
        hotel2.Name = 'The Hotel California';
        hotel2.Address__c ='6901 E Greenway Pkwy'; 
        hotel2.City__c = 'Scottsdale';
        hotel2.State__c = 'AZ';
        hotel2.Postal_Code_Zip__c = '85254';
        insert hotel2;
               
        Event_Hotel__c  EventHotel2 = new Event_Hotel__c();
        EventHotel2.Matson_Event__c = evt.Id;
        EventHotel2.Hotel__c= hotel2.Id;
        EventHotel2.Featured__c= true;
         
        try
        {
            insert EventHotel2;
        }   
        catch(Exception e)
        {
            Boolean expectedExceptionThrown = e.getMessage().Contains('Only one featured hotel can be selected per event.');
            system.assertEquals(expectedExceptionThrown, true);
        }
        
    }
}