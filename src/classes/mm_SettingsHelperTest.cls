@isTest
public class mm_SettingsHelperTest {

    @isTest public static void testGetAPISetting(){
        
        API_Settings__mdt setting = [SELECT DeveloperName FROM API_Settings__mdt LIMIT 1];
        String settingName = setting.DeveloperName;
        API_Settings__mdt functionReturn = mm_SettingsHelper.getAPISetting(settingName);
        API_Settings__mdt returnedSetting = [SELECT Id, DeveloperName FROM API_Settings__mdt WHERE Id =: functionReturn.Id];
        
        system.assertEquals(settingName, returnedSetting.DeveloperName);
    }
       
    @isTest public static void testIsSandboxOrg(){
        
        Organization currentOrg = [SELECT IsSandbox FROM Organization LIMIT 1];
        Boolean sandbox = currentOrg.IsSandbox;
        Boolean testSandbox = mm_SettingsHelper.IsSandboxOrg();
        
        system.assertEquals(sandbox, testSandbox);
    }
    
    @isTest static void testEventRegistrationSiteUrl(){
        
        String returnedURL = mm_SettingsHelper.EventRegistrationSiteUrl();
        
        Boolean isNull = returnedURL == '';
        
        system.assertEquals(False, isNull);
    }
    
    @isTest static void testCreateEventToken(){
        
        String returnedToken = mm_SettingsHelper.CreateEventToken('word');
        Boolean isNull = returnedToken == null;
        
        system.assertEquals(True, isNull);
    }
    
    @isTest static void testVerifyEventTokenPass(){
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
        eventRegistration.Waiver_Status__c = 'Electronically Signed';
        
        insert eventRegistration;
        
        Event__c testEvent = [SELECT Id FROM Event__c WHERE Event__c.Name = 'American Dream Experience Test Event name' and Event__c.Venue__c = :ven.Id];
        Contact testContact = [SELECT Id FROM Contact WHERE Contact.FirstName = 'Darth' and Contact.LastName = 'Vader' and Contact.Email ='Vader@Vader.com'];
        Adviser__c testAdviser = [SELECT Id FROM Adviser__c WHERE Adviser__c.Primary_Contact__c = :testContact.Id and Adviser__c.RecordTypeId = :RT2.Id and Adviser__c.Company__c = 'Test comp'];
        Event_Registration__c testEventRegistration = [SELECT Registration_Site_Token__c FROM Event_Registration__c WHERE Event__c = :testEvent.Id and Reg_Adviser__c = :testAdviser.Id];
        
        Boolean success = mm_SettingsHelper.VerifyEventToken(testEvent.Id, testContact.Id, testEventRegistration.Registration_Site_Token__c);
        
        system.assertEquals(True, success);
    }
    
    @isTest static void testVerifyEventTokenFail(){
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
        eventRegistration.Waiver_Status__c = 'Electronically Signed';
        
        insert eventRegistration;
        
        Event__c testEvent = [SELECT Id FROM Event__c WHERE Event__c.Name = 'American Dream Experience Test Event name' and Event__c.Venue__c = :ven.Id];
        Contact testContact = [SELECT Id FROM Contact WHERE Contact.FirstName = 'Darth' and Contact.LastName = 'Vader' and Contact.Email ='Vader@Vader.com'];
        
        Boolean success = mm_SettingsHelper.VerifyEventToken(testEvent.Id, testContact.Id, 'NOT A VALID TOKEN8901234567890123456789012345');
        
        system.assertEquals(False, success);
    }
    
    static testMethod void givenHouseAccountContactIdExpectUpdateAndGetCorrect() {
        String testId = fflib_IDGenerator.generate(Contact.SObjectType);
        mm_SettingsHelper.UpdateHouseAccountContactId(testId);
        String houseAccountContactId = mm_SettingsHelper.HouseAccountContactId();
        System.assertEquals(testId, houseAccountContactId);
    }
    
}