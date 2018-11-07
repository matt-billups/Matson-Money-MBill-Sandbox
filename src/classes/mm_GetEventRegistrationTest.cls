@IsTest
public class mm_GetEventRegistrationTest {
    
    static testMethod void mm_GetEventRegistration() {
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
        
        insert evt;
        
        LIst<EventQuestionOption__c> eventQuestionOptions = new List<EventQuestionOption__c>();
        
        // Create EventQuestions
        EventQuestion__c pQ = new EventQuestion__c();
        pQ.Answer_Type__c = 'Picklist';
        pQ.Question_Text__c = 'How many dogs do you have?';
        
        insert pQ;
        
        EventQuestionOption__c pQO1 = new EventQuestionOption__c();
        pQO1.Event_Question__c = pQ.Id;
        pQO1.Option__c = 'Exactly One Doggie';
        pQO1.Sort_Order__c = 1;
        
        eventQuestionOptions.add(pQO1);
        
        EventQuestionOption__c pQO2 = new EventQuestionOption__c();
        pQO2.Event_Question__c = pQ.Id;
        pQO2.Option__c = 'Two Doggers';
        pQO2.Sort_Order__c = 1;
        
        eventQuestionOptions.add(pQO2);
        
        EventQuestionOption__c pQO3 = new EventQuestionOption__c();
        pQO3.Event_Question__c = pQ.Id;
        pQO3.Option__c = 'Three Or More Dogglemutts';
        pQO3.Sort_Order__c = 1;
        
        eventQuestionOptions.add(pQO3);
        
        EventQuestion__c mQ = new EventQuestion__c();
        mQ.Answer_Type__c = 'MultiSelect';
        mQ.Question_Text__c = 'What kind of animals do you have?';
        
        insert mQ;
        
        EventQuestionOption__c mQO1 = new EventQuestionOption__c();
        mQO1.Event_Question__c = mQ.Id;
        mQO1.Option__c = 'Cats';
        mQO1.Sort_Order__c = 1;
        
        eventQuestionOptions.add(mQO1);
        
        EventQuestionOption__c mQO2 = new EventQuestionOption__c();
        mQO2.Event_Question__c = mQ.Id;
        mQO2.Option__c = 'Dogs';
        mQO2.Sort_Order__c = 1;
        
        eventQuestionOptions.add(mQO2);
        
        EventQuestionOption__c mQO3 = new EventQuestionOption__c();
        mQO3.Event_Question__c = mQ.Id;
        mQO3.Option__c = 'Children';
        mQO3.Sort_Order__c = 1;
        
        eventQuestionOptions.add(mQO3);
        
        EventQuestion__c tQ = new EventQuestion__c();
        tQ.Answer_Type__c = 'Text';
        tQ.Question_Text__c = 'What are the names of your animals?';
        
		insert tQ;
        
        EventQuestion__c cQ = new EventQuestion__c();
        cQ.Answer_Type__c = 'Checkbox';
        cQ.Question_Text__c = 'Check if you love puppies';
        
        insert cQ;
        
        insert eventQuestionOptions;
        
        List<EventEventQuestion__c> eventEventQuestions = new List<EventEventQuestion__c>();
        
        // Create EventEventQuestions
        EventEventQuestion__c pEQ = new EventEventQuestion__c();
        pEQ.Event_Question__c = pQ.Id;
        pEQ.Is_Required__c = true;
        pEQ.IsActive__c = true;
        pEQ.Matson_Event__c = evt.Id;
        pEQ.Question_Type__c = 'Registration';
        pEQ.Sort_Order__c = 1;
        
        eventEventQuestions.add(pEQ);
        
        EventEventQuestion__c mEQ = new EventEventQuestion__c();
        mEQ.Event_Question__c = mQ.Id;
        mEQ.Is_Required__c = true;
        mEQ.IsActive__c = true;
        mEQ.Matson_Event__c = evt.Id;
        mEQ.Question_Type__c = 'Registration';
        mEQ.Sort_Order__c = 2;
        
        eventEventQuestions.add(mEQ);
        
        EventEventQuestion__c tEQ = new EventEventQuestion__c();
        tEQ.Event_Question__c = tQ.Id;
        tEQ.Is_Required__c = false;
        tEQ.IsActive__c = false;
        tEQ.Matson_Event__c = evt.Id;
        tEQ.Question_Type__c = 'Registration';
        tEQ.Sort_Order__c = 3;
        
        eventEventQuestions.add(tEQ);
        
        EventEventQuestion__c cEQ = new EventEventQuestion__c();
        cEQ.Event_Question__c = cQ.Id;
        cEQ.Is_Required__c = false;
        cEQ.IsActive__c = false;
        cEQ.Matson_Event__c = evt.Id;
        cEQ.Question_Type__c = 'Registration';
        cEQ.Sort_Order__c = 4;
        
        eventEventQuestions.add(cEQ);
        
        insert eventEventQuestions;
        
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
        
        // Create a guest contact
        Contact guest = new Contact();
        guest.FirstName = 'Luke';
        guest.LastName = 'Skywalker';
        guest.Email = 'luke@skywalker.com';
        
        insert guest;
        
        // Create another guest contact
        Contact guest2 = new Contact();
        guest2.FirstName = 'Jar Jar';
        guest2.LastName = 'Binks';
        guest2.Email = 'jarjar@binks.com';
        
        insert guest2;
        
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
        Test.startTest();
        
        // Create an Event Registration
        Event_Registration__c eventRegistration = new Event_Registration__c();
        eventRegistration.Event__c = evt.Id;
        eventRegistration.Status__c = 'Registered';
        eventRegistration.T_Shirt_Size__c = 'XL';
        eventRegistration.Reg_Adviser__c = adv.Id;
        eventRegistration.Attendee_Type__c = 'Adviser';
        eventRegistration.Waiver_Status__c = 'Electronically Signed';
        
        insert eventRegistration;
        
        // Create an event registration to delete
        Event_Registration__c erdel = new Event_Registration__c();
        erdel.Event__c = evt.Id;
        erdel.Status__c = 'Registered';
        erdel.T_Shirt_Size__c = 'XL';
        erdel.Contact__c = guest.Id;
        erdel.Parent_Registration__c = eventRegistration.id;
        erdel.Attendee_Type__c = 'Guest';
        erdel.Waiver_Status__c = 'Electronically Signed';
        
        insert erdel;
    
        // Create an event registration to update
        Event_Registration__c erupd = new Event_Registration__c();
        erupd.Event__c = evt.Id;
        erupd.Status__c = 'Registered';
        erupd.T_Shirt_Size__c = 'XL';
        erupd.Contact__c = guest2.Id;
        erupd.Parent_Registration__c = eventRegistration.id;
        erupd.Attendee_Type__c = 'Guest';
        erupd.Waiver_Status__c = 'Electronically Signed';
        
        insert erupd;
        
        List<Event_Registration_Answer_Selection__c> answerSelections = new List<Event_Registration_Answer_Selection__c>();
        
        // Create Event Question Answers and selected options for the primary registrant (test already existing answers)
        Event_Registration_Answer__c pA = new Event_Registration_Answer__c();
        pA.Event_Event_Question__c = pEQ.Id;
        pA.Event_Registration__c = eventRegistration.Id;
        
        insert pA;
        
        // Running the test should delete this answer and add an answer selection of pQO2 instead
        Event_Registration_Answer_Selection__c pAC1 = new Event_Registration_Answer_Selection__c();
        pAC1.Event_Registration_Answer__c = pA.Id;
        pAC1.Event_Question_Option__c = pQO1.Id;
        
        answerSelections.add(pAC1);
        
        Event_Registration_Answer__c mA = new Event_Registration_Answer__c();
        mA.Event_Event_Question__c = mEQ.Id;
        mA.Event_Registration__c = eventRegistration.Id;
        
        insert mA;
        
        // Running the test should delete these answers and add an answer selection of pQO2 instead
        Event_Registration_Answer_Selection__c mAC1 = new Event_Registration_Answer_Selection__c();
        mAC1.Event_Registration_Answer__c = mA.Id;
        mAC1.Event_Question_Option__c = mQO1.Id;
        
        answerSelections.add(mAC1);
        
        Event_Registration_Answer_Selection__c mAC2 = new Event_Registration_Answer_Selection__c();
        mAC2.Event_Registration_Answer__c = mA.Id;
        mAC2.Event_Question_Option__c = mQO2.Id;
        
        answerSelections.add(mAC2);
        
        insert answerSelections;
        
        Event_Registration_Answer__c tA = new Event_Registration_Answer__c();
        tA.Event_Event_Question__c = tEQ.Id;
        tA.Event_Registration__c = eventRegistration.Id;
        tA.Text_Answer__c = 'Wrong answer!';
        
        insert tA;
                
        Event_Registration_Answer__c cA = new Event_Registration_Answer__c();
        cA.Event_Event_Question__c = cEQ.Id;
        cA.Event_Registration__c = eventRegistration.Id;
        cA.Checkbox_Answer__c = true;
        
        insert cA;
        
        Event__c testEvt = [SELECT Id,Name FROM Event__c WHERE Name = 'American Dream Experience Test Event name' and Event_Type__c = 'Training Event' and ShowOnWebsite__c = true];
        Contact testCon = [SELECT Id,Name FROM Contact WHERE FirstName = 'Darth' and LastName = 'Vader' and Email = 'Vader@Vader.com'];
        Adviser__c testAdv = [SELECT Id FROM Adviser__c WHERE Primary_Contact__c = :testCon.Id and Adviser_Coach__c = '00536000001OWzVAAW'];
        Event_Registration__c testEvtReg = [SELECT Id,Name,Contact__c,Event__c, Registration_Site_Token__c FROM Event_Registration__c WHERE Event__c = :testEvt.Id and Reg_Adviser__c = :testAdv.Id and Attendee_Type__c = 'Adviser'];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.addParameter('EVID', testEvtReg.Event__c);
        req.addParameter('CONID', testEvtReg.Contact__c);
        req.addParameter('TOKEN', testEvtReg.Registration_Site_Token__c);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
                
        mm_GetEventRegistration.GetEventRegistration();
        
        System.assert(RestContext.response.responseBody != null);
        
        Test.stopTest();
    }
    
    static testMethod void mm_GetEventRegistration_EventDoesntExist() {
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.addParameter('EVID', 'InvalidEventId');
        req.addParameter('CONID', 'InvalidContactId');
        req.addParameter('TOKEN', 'NOT A VALID TOKEN8901234567890123456789012345');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;        
        
        mm_GetEventRegistration.GetEventRegistration();
        
        System.assert(RestContext.response.responseBody == null);
        
        Test.stopTest();
    }
    
    static testMethod void mm_GetEventRegistration_ContactDoesntExist() {
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
        
        insert evt;
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.addParameter('EVID', evt.Id);
        req.addParameter('CONID', 'InvalidContactId');
        req.addParameter('TOKEN', 'NOT A VALID TOKEN8901234567890123456789012345');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        mm_GetEventRegistration.GetEventRegistration();
        
        System.assert(RestContext.response.responseBody == null);
        
        Test.stopTest();
    }
    
    static testMethod void mm_GetEventRegistration_EventRegistrationDoesntExist() {
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
        
        insert evt;
        
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
        
        // Create a guest contact
        Contact guest = new Contact();
        guest.FirstName = 'Luke';
        guest.LastName = 'Skywalker';
        guest.Email = 'luke@skywalker.com';
        
        insert guest;
        
        // Create another guest contact
        Contact guest2 = new Contact();
        guest2.FirstName = 'Jar Jar';
        guest2.LastName = 'Binks';
        guest2.Email = 'jarjar@binks.com';
        
        insert guest2;
        
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
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.addParameter('EVID', evt.Id);
        req.addParameter('CONID', con.Id);
        req.addParameter('TOKEN', 'NOT A VALID TOKEN8901234567890123456789012345');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
                
        mm_GetEventRegistration.GetEventRegistration();
        
        System.assert(RestContext.response.responseBody == null);
        
        Test.stopTest();
    }
    
    static testMethod void mm_GetEventRegistration_NoGuests() {
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
        
        insert evt;
        
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
        
        insert eventRegistration;
        
        Test.startTest();
        
        Event__c testEvt = [SELECT Id,Name FROM Event__c WHERE Name = 'American Dream Experience Test Event name' and Event_Type__c = 'Training Event' and ShowOnWebsite__c = true];
        Contact testCon = [SELECT Id,Name FROM Contact WHERE FirstName = 'Darth' and LastName = 'Vader' and Email = 'Vader@Vader.com'];
        Adviser__c testAdv = [SELECT Id FROM Adviser__c WHERE Primary_Contact__c = :testCon.Id and Adviser_Coach__c = '00536000001OWzVAAW'];
        Event_Registration__c testEvtReg = [SELECT Id,Name,Contact__c,Event__c, Registration_Site_Token__c FROM Event_Registration__c WHERE Event__c = :testEvt.Id and Reg_Adviser__c = :testAdv.Id and Attendee_Type__c = 'Adviser'];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.addParameter('EVID', testEvtReg.Event__c);
        req.addParameter('CONID', testEvtReg.Contact__c);
        req.addParameter('TOKEN', testEvtReg.Registration_Site_Token__c);
        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
                
        mm_GetEventRegistration.GetEventRegistration();
        
        System.assert(RestContext.response.responseBody != null);
        
        Test.stopTest();
    }
}