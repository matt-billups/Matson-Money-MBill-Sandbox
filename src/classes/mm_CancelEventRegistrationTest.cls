@IsTest
public class mm_CancelEventRegistrationTest {
    static void SetupTestObjects() {
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
        evt.Name = 'CANCEL EVENT REGISTRATION TEST';
        evt.Event_Type__c = 'Training Event';
        evt.Maximum_Registration__c = 50;
        evt.Event_Start_Date__c = System.today() + 5;
        evt.Course_Name__c = 'Other'; 
        evt.Venue__c = ven.Id;
        evt.Track__c = tra.Id;
        evt.Event_Start_Date__c = System.today() + 55;
        evt.Event_End_Date__c  = System.today() + 56;
        evt.ShowOnWebsite__c = true;
        evt.Event_Description__c = 'test';
        evt.Email_Invite_Body__c = 'test';
        evt.Email_Registered_Body__c = 'test';
        evt.Email_Cancelled_Body__c = 'test';
        
        insert evt;
        
        List<Contact> contacts = new List<Contact>();
        
        // Create a contact
        Contact con = new Contact();
        con.FirstName = 'CANCEL TEST FIRST';
        con.LastName = 'CANCEL TEST LAST' ;
        con.Email ='CANCEL@TEST.com';
        con.Office_Phone__c = '4561328888';
        con.MailingStreet = '1 DeathStar rd';
        con.MailingCity = 'Mason';
        con.MailingState = 'Ohio';
        con.MailingPostalCode = '45040';
        con.AccountId = acc.Id;
        contacts.Add(con);
        
        // Create a guest contact
        Contact guest = new Contact();
        guest.FirstName = 'Luke';
        guest.LastName = 'Skywalker';
        guest.Email = 'luke@skywalker.com';
        contacts.Add(guest);
        
        // Create another guest contact
        Contact guest2 = new Contact();
        guest2.FirstName = 'Jar Jar';
        guest2.LastName = 'Binks';
        guest2.Email = 'jarjar@binks.com';
        contacts.Add(guest2);
        
        insert contacts;
        
        // Create an Advisor 
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
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

        // Create an Event Registration
        Event_Registration__c eventRegistration = new Event_Registration__c();
        eventRegistration.Event__c = evt.Id;
        eventRegistration.Status__c = 'Registered';
        eventRegistration.T_Shirt_Size__c = 'XL';
        eventRegistration.Reg_Adviser__c = adv.Id;
        eventRegistration.Attendee_Type__c = 'Adviser';
        eventRegistration.Waiver_Status__c = 'Electronically Signed';
        
        insert eventRegistration;
                
        List<Event_Registration__c> guestERs = new List<Event_Registration__c>();
        
        // Create an event registration to cancel
        Event_Registration__c erdel = new Event_Registration__c();
        erdel.Event__c = evt.Id;
        erdel.Status__c = 'Registered';
        erdel.T_Shirt_Size__c = 'XL';
        erdel.Contact__c = guest.Id;
        erdel.Parent_Registration__c = eventRegistration.id;
        erdel.Attendee_Type__c = 'Guest';
        erdel.Waiver_Status__c = 'Electronically Signed';
        
        guestERs.add(erdel);
    
        // Create an event registration to update
        Event_Registration__c erupd = new Event_Registration__c();
        erupd.Event__c = evt.Id;
        erupd.Status__c = 'Cancelled';
        erupd.T_Shirt_Size__c = 'XL';
        erupd.Contact__c = guest2.Id;
        erupd.Parent_Registration__c = eventRegistration.id;
        erupd.Attendee_Type__c = 'Guest';
        erupd.Waiver_Status__c = 'Electronically Signed';
        
        guestERs.add(erupd);
        
        insert guestERs;
    }
    
    static testmethod void mm_CancelEventRegistrationTest_RegistrationAlreadyCancelled(){
        SetupTestObjects();
        
        Event__c evt = [SELECT Id,Name FROM Event__c WHERE Name = 'CANCEL EVENT REGISTRATION TEST' and Event_Type__c = 'Training Event' and ShowOnWebsite__c = true];
        Contact con = [SELECT Id,Name FROM Contact WHERE FirstName = 'CANCEL TEST FIRST' and LastName = 'CANCEL TEST LAST' and Email = 'CANCEL@TEST.com'];
        Adviser__c adv = [SELECT Id FROM Adviser__c WHERE Primary_Contact__c = :con.Id and Adviser_Coach__c = '00536000001OWzVAAW'];
        Event_Registration__c evtReg = [SELECT Id,Name,Contact__c,Event__c, Registration_Site_Token__c FROM Event_Registration__c WHERE Event__c = :evt.Id and Reg_Adviser__c = :adv.Id and Attendee_Type__c = 'Adviser'];
        
        evtReg.Status__c = 'Cancelled';
        update evtReg;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_CancelEventRegistration/';
        req.addParameter('EVID', evtReg.Event__c);
        req.addParameter('CONID', evtReg.Contact__c);
        req.addParameter('TOKEN', evtReg.Registration_Site_Token__c);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        RestRequest request = new RestRequest();
        
        mm_CancelEventRegistration.CancelEventRegistration();
        
        System.assert(RestContext.response.responseBody != null);
        CancelEventRegistrationResponse theResponse = (CancelEventRegistrationResponse)JSON.deserialize(RestContext.response.responseBody.ToString(), CancelEventRegistrationResponse.class);
        System.assert(theResponse.Success == 'false');
        System.assert(theResponse.Message == 'This Event Registration is already cancelled');
    }
    
    static testmethod void mm_CancelEventRegistrationTest_CancelPrimaryRegistrationSuccess(){
        SetupTestObjects();
        
        Event__c evt = [SELECT Id,Name FROM Event__c WHERE Name = 'CANCEL EVENT REGISTRATION TEST' and Event_Type__c = 'Training Event' and ShowOnWebsite__c = true];
        Contact con = [SELECT Id,Name FROM Contact WHERE FirstName = 'CANCEL TEST FIRST' and LastName = 'CANCEL TEST LAST' and Email = 'CANCEL@TEST.com'];
        Adviser__c adv = [SELECT Id FROM Adviser__c WHERE Primary_Contact__c = :con.Id and Adviser_Coach__c = '00536000001OWzVAAW'];
        Event_Registration__c evtReg = [SELECT Id,Name,Contact__c,Event__c, Registration_Site_Token__c FROM Event_Registration__c WHERE Event__c = :evt.Id and Reg_Adviser__c = :adv.Id and Attendee_Type__c = 'Adviser'];
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_CancelEventRegistration/';
        req.addParameter('EVID', evtReg.Event__c);
        req.addParameter('CONID', evtReg.Contact__c);
        req.addParameter('TOKEN', evtReg.Registration_Site_Token__c);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        RestRequest request = new RestRequest();
        
        mm_CancelEventRegistration.CancelEventRegistration();
        
        System.assert(RestContext.response.responseBody != null);
        CancelEventRegistrationResponse theResponse = (CancelEventRegistrationResponse)JSON.deserialize(RestContext.response.responseBody.ToString(), CancelEventRegistrationResponse.class);
        
        System.assert(theResponse.Success == 'true');
        System.assert(theResponse.Message == null);
    }
    
    static testmethod void mm_CancelEventRegistrationTest_EventDoesNotExist(){
        SetupTestObjects();

        Event__c evt = [SELECT Id,Name FROM Event__c WHERE Name = 'CANCEL EVENT REGISTRATION TEST' and Event_Type__c = 'Training Event' and ShowOnWebsite__c = true];
        Contact con = [SELECT Id,Name FROM Contact WHERE FirstName = 'CANCEL TEST FIRST' and LastName = 'CANCEL TEST LAST' and Email = 'CANCEL@TEST.com'];
        Adviser__c adv = [SELECT Id FROM Adviser__c WHERE Primary_Contact__c = :con.Id and Adviser_Coach__c = '00536000001OWzVAAW'];
        Event_Registration__c evtReg = [SELECT Id,Name,Contact__c,Event__c, Registration_Site_Token__c FROM Event_Registration__c WHERE Event__c = :evt.Id and Reg_Adviser__c = :adv.Id and Attendee_Type__c = 'Adviser'];
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_CancelEventRegistration/';
        req.addParameter('EVID', 'invalidid');
        req.addParameter('CONID', evtReg.Contact__c);
        req.addParameter('TOKEN', evtReg.Registration_Site_Token__c);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        RestRequest request = new RestRequest();
        
        mm_CancelEventRegistration.CancelEventRegistration();
        
        System.assert(RestContext.response.responseBody != null);
        CancelEventRegistrationResponse theResponse = (CancelEventRegistrationResponse)JSON.deserialize(RestContext.response.responseBody.ToString(), CancelEventRegistrationResponse.class);
        System.assert(theResponse.Success == 'false');
        System.assert(theResponse.Message == 'This Event could not be found');
    }
    
    static testmethod void mm_CancelEventRegistrationTest_ContactDoesNotExist(){
        SetupTestObjects();
        
        Event__c evt = [SELECT Id,Name FROM Event__c WHERE Name = 'CANCEL EVENT REGISTRATION TEST' and Event_Type__c = 'Training Event' and ShowOnWebsite__c = true];
        Contact con = [SELECT Id,Name FROM Contact WHERE FirstName = 'CANCEL TEST FIRST' and LastName = 'CANCEL TEST LAST' and Email = 'CANCEL@TEST.com'];
        Adviser__c adv = [SELECT Id FROM Adviser__c WHERE Primary_Contact__c = :con.Id and Adviser_Coach__c = '00536000001OWzVAAW'];
        Event_Registration__c evtReg = [SELECT Id,Name,Contact__c,Event__c, Registration_Site_Token__c FROM Event_Registration__c WHERE Event__c = :evt.Id and Reg_Adviser__c = :adv.Id and Attendee_Type__c = 'Adviser'];
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_CancelEventRegistration/';
        req.addParameter('EVID', evtReg.Event__c);
        req.addParameter('CONID', 'invalidid');
        req.addParameter('TOKEN', evtReg.Registration_Site_Token__c);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        RestRequest request = new RestRequest();
        
        mm_CancelEventRegistration.CancelEventRegistration();
        
        System.assert(RestContext.response.responseBody != null);
        CancelEventRegistrationResponse theResponse = (CancelEventRegistrationResponse)JSON.deserialize(RestContext.response.responseBody.ToString(), CancelEventRegistrationResponse.class);
        System.assert(theResponse.Success == 'false');
        System.assert(theResponse.Message == 'This Contact could not be found');
    }
    
    static testmethod void mm_CancelEventRegistrationTest_EventRegistrationDoesNotExist(){
        SetupTestObjects();
        
        Event__c evt = [SELECT Id,Name FROM Event__c WHERE Name = 'CANCEL EVENT REGISTRATION TEST' and Event_Type__c = 'Training Event' and ShowOnWebsite__c = true];
        Contact con = [SELECT Id,Name FROM Contact WHERE FirstName = 'CANCEL TEST FIRST' and LastName = 'CANCEL TEST LAST' and Email = 'CANCEL@TEST.com'];
        Adviser__c adv = [SELECT Id FROM Adviser__c WHERE Primary_Contact__c = :con.Id and Adviser_Coach__c = '00536000001OWzVAAW'];
        Event_Registration__c evtReg = [SELECT Id,Name,Contact__c,Event__c, Registration_Site_Token__c FROM Event_Registration__c WHERE Event__c = :evt.Id and Reg_Adviser__c = :adv.Id and Attendee_Type__c = 'Adviser'];
        
        delete evtReg;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_CancelEventRegistration/';
        req.addParameter('EVID', evtReg.Event__c);
        req.addParameter('CONID', evtReg.Contact__c);
        req.addParameter('TOKEN', evtReg.Registration_Site_Token__c);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        RestRequest request = new RestRequest();
        
        mm_CancelEventRegistration.CancelEventRegistration();
        
        System.assert(RestContext.response.responseBody != null);
        CancelEventRegistrationResponse theResponse = (CancelEventRegistrationResponse)JSON.deserialize(RestContext.response.responseBody.ToString(), CancelEventRegistrationResponse.class);
        System.assert(theResponse.Success == 'false');
        System.assert(theResponse.Message == 'This Event Registration could not be found');
    }
    
    static testmethod void mm_CancelEventRegistrationTest_RegistrationGoodToken(){
        SetupTestObjects();
        
        Event__c evt = [SELECT Id,Name FROM Event__c WHERE Name = 'CANCEL EVENT REGISTRATION TEST' and Event_Type__c = 'Training Event' and ShowOnWebsite__c = true];
        Contact con = [SELECT Id,Name FROM Contact WHERE FirstName = 'CANCEL TEST FIRST' and LastName = 'CANCEL TEST LAST' and Email = 'CANCEL@TEST.com'];
        Adviser__c adv = [SELECT Id FROM Adviser__c WHERE Primary_Contact__c = :con.Id and Adviser_Coach__c = '00536000001OWzVAAW'];
        Event_Registration__c evtReg = [SELECT Id,Name,Contact__c,Event__c, Registration_Site_Token__c FROM Event_Registration__c WHERE Event__c = :evt.Id and Reg_Adviser__c = :adv.Id and Attendee_Type__c = 'Adviser'];
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_CancelEventRegistration/';
        req.addParameter('EVID', evtReg.Event__c);
        req.addParameter('CONID', evtReg.Contact__c);
        req.addParameter('TOKEN', evtReg.Registration_Site_Token__c);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        RestRequest request = new RestRequest();
        
        mm_CancelEventRegistration.CancelEventRegistration();
        
        System.assert(RestContext.response.responseBody != null);
        CancelEventRegistrationResponse theResponse = (CancelEventRegistrationResponse)JSON.deserialize(RestContext.response.responseBody.ToString(), CancelEventRegistrationResponse.class);
        System.assert(theResponse.Success == 'true');
        System.assert(theResponse.Message == null);
    }
    
    static testmethod void mm_CancelEventRegistrationTest_RegistrationBadToken(){
        SetupTestObjects();
        
        Event__c evt = [SELECT Id,Name FROM Event__c WHERE Name = 'CANCEL EVENT REGISTRATION TEST' and Event_Type__c = 'Training Event' and ShowOnWebsite__c = true];
        Contact con = [SELECT Id,Name FROM Contact WHERE FirstName = 'CANCEL TEST FIRST' and LastName = 'CANCEL TEST LAST' and Email = 'CANCEL@TEST.com'];
        Adviser__c adv = [SELECT Id FROM Adviser__c WHERE Primary_Contact__c = :con.Id and Adviser_Coach__c = '00536000001OWzVAAW'];
        Event_Registration__c evtReg = [SELECT Id,Name,Contact__c,Event__c, Registration_Site_Token__c FROM Event_Registration__c WHERE Event__c = :evt.Id and Reg_Adviser__c = :adv.Id and Attendee_Type__c = 'Adviser'];
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_CancelEventRegistration/';
        req.addParameter('EVID', evtReg.Event__c);
        req.addParameter('CONID', evtReg.Contact__c);
        req.addParameter('TOKEN', 'NOT A VALID TOKEN8901234567890123456789012345');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        RestRequest request = new RestRequest();
        
        mm_CancelEventRegistration.CancelEventRegistration();
        
        System.assert(RestContext.response.responseBody != null);
        CancelEventRegistrationResponse theResponse = (CancelEventRegistrationResponse)JSON.deserialize(RestContext.response.responseBody.ToString(), CancelEventRegistrationResponse.class);
        System.assert(theResponse.Success == 'false');
        System.assert(theResponse.Message == 'Token Authorization failed');
    }
    
    public class CancelEventRegistrationResponse {
        public string Success;
        public string Message;
    }
}