@isTest
public class mm_GetEventTest {
    static testMethod void mm_GetEvent()
    {
               
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
        
        // Create an airport
        Airport__c ap = new Airport__c();
        ap.Airport_Name__c = 'Airport';
        ap.Airport_City__c = 'Madrid';
        ap.Airport_Geolocation__Latitude__s = 30;
        ap.Airport_Geolocation__Longitude__s = 30;
        ap.Airport_Postal_Code_Zip__c = '12345';
        ap.Airport_State__c = 'OH';
        ap.Airport_Street_Address__c = '123 Public Way';
        insert ap;
        
        VenueAirport__c apv = new VenueAirport__c();
        apv.Venue__c = ven.Id;
        apv.Airport__c = ap.Id;
        insert apv;
        
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
        evt.Event_Overview__c = 'This is gonna be grrrrrreeeeeeat!';
        evt.Additional_Agenda_Information__c = 'Just a few more important things you should know! Bla bla bla.';
        
        insert evt;
        
        // Create an event day
        Event_Days__c eventDay = new Event_Days__c();
        eventDay.Event_Day_Start_Time__c = '12:00 PM';
        eventDay.Event_Day_End_Time__c = '1:00 PM';
        DateTime eventStartDate = DateTime.Now() + 50;
        eventDay.Event_Day_Start_Date__c = Date.newInstance(eventStartDate.year(), eventStartDate.month(), eventStartDate.day());
        eventDay.Name = 'Gobbledeygook';
        eventDay.Matson_Event__c = evt.Id;
        
        insert eventDay;
        
        // Create Event hotel -event junc obj
        Event_Hotel__c evhot = new Event_Hotel__c();
        evhot.Matson_Event__c =  evt.Id;
        evhot.Hotel__c = hot.id;
        evhot.Discount_Code__c = 'testcode';
        evhot.Special_Rate_URL__c = 'discount url';
        evhot.Featured__c = true;
        evhot.Featured_Hotel_Description__c = 'Featured Hotel Description';
        evhot.Featured_Hotel_Rate_Description__c = 'Featured Hotel Rate Description';
        
        insert evhot;
        
        //Create Restaurant record 
        Restaurant__c rest = new Restaurant__c();
        rest.Name = 'test Restaurant';
        rest.Phone__c = '5555555555'; 
        rest.Street_Address__c = '7887 E Princess Blvd';
        rest.City__c = 'Scottsdale';  
        rest.State__c = 'AZ';
        rest.Postal_Code_Zip__c = '85255';
        rest.Venue__c = ven.Id;
        
        insert rest;
        
        //Create Event Question
        EventQuestion__c question = new EventQuestion__c();
        question.Answer_Type__c = 'PickList';
        question.Question_Text__c = 'Question?';
        
        insert question;
        
        // Create Event Event Question
        EventEventQuestion__c eeq = new EventEventQuestion__c();
        eeq.Question_Type__c = 'Registration';
        eeq.Event_Question__c = question.Id;
        eeq.Is_Required__c = true;
        eeq.IsActive__c = true;
        eeq.Matson_Event__c = evt.Id;
        eeq.Sort_Order__c = 1;
        
        insert eeq;

		// Create Event Question Option        
        EventQuestionOption__c option = new EventQuestionOption__c();
        option.Event_Question__c = question.Id;
        option.Option__c = 'Option';
        option.Sort_Order__c = 1;
        
        insert option;

        // Create Custom Tab        
        Custom_Tab__c customTab = new Custom_Tab__c();
        customTab.Content__c = '<p>Test Custom Tab</p>';
        customTab.Matson_Event__c = evt.Id;
        customTab.Sort_Order_Display_Before__c = 'Agenda Tab';
        customTab.Name = 'Test Custom Tab Name';
        customTab.Visible__c = true;
        
        insert customTab;

        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        
        insert acc;
        
        // Create a contact
        Contact con = new Contact();
        con.FirstName = 'Darth';
        con.LastName = 'Vader' ;
        con.Email ='Vader@Vader.com';
        con.Office_Phone__c = '4561328888';
        con.MailingStreet = '1 DeathStar rd';
        con.MailingCity = 'Mason';
        con.MailingState = 'Ohio';
        con.MailingPostalCode = '45040';
        con.AccountId = acc.Id;
        
        insert con;
        
        // Create Speaker       
        Matson_Event_Speaker__c speaker = new Matson_Event_Speaker__c();
		speaker.Matson_Event__c = evt.id;
		speaker.Biography__c = 'He has done well!';
		speaker.Sort_Order__c = 1;
		speaker.Speaker_Contact__c = con.Id;
        
        insert speaker;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_GetEvent/?EVID=';  
        req.addParameter('EVID', evt.id);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        RestRequest request = new RestRequest();
        
        mm_GetEvent.GetEvent();
        
        System.assert(RestContext.response.responseBody != null);
    }
}