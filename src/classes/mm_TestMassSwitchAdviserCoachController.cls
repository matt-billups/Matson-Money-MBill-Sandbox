@isTest
public class mm_TestMassSwitchAdviserCoachController {
    
   @isTest static void testSetup(){
        
        // Test data setup
        
        Account acc = new Account();
        acc.Name = 'Matson MOney Default';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Luke';
        con.LastName = 'Skywalker';
        con.Email = 'Luke@Rebel.com';
        con.Office_Phone__c = '5550123456';
        con.MailingStreet = '12 Tatooine Ave';
        con.MailingCity = 'Centerville';
        con.MailingState = 'Ohio';
        con.MailingPostalCode = '45459';
        con.AccountId = acc.Id;
        insert con;
        
        RecordType rec = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser' and SobjectType='Adviser__c'];
		Profile salesProfile = [SELECT Id FROM Profile WHERE Name = 'Sales'];
        User advCoachUser = [SELECT Id FROM User WHERE isActive = True AND ProfileId =: salesProfile.Id LIMIT 1];
        
        // Create an Adviser & insert
        Adviser__c adv = new Adviser__c();
        adv.Company__c = 'Rebel Alliance Inc.';
        adv.RecordTypeId = rec.Id;
        adv.Primary_Contact__c = con.Id;
        adv.Status__c = 'Active Adviser';
        adv.Service_Team__c = '3';
        adv.Designation__c = 'BD';
        adv.Adviser_Coach__c = advCoachUser.Id;
        adv.Firm_ID__c = '1234';
        insert adv;
        
        // Create another Contact & insert
        Contact con1 = new Contact();
        con1.FirstName = 'Leia';
        con1.LastName = 'Skywalker';
        con1.Email = 'Leia@Rebel.com';
        con1.Office_Phone__c = '5556543210';
        con1.MailingStreet = '12 Tatooine Ave';
        con1.MailingCity = 'Centerville';
        con1.MailingState = 'Ohio';
        con1.MailingPostalCode = '45459';
        con1.AccountId = acc.Id;
        insert con1;
        
        Adviser__c adv1 = new Adviser__c();
        adv1.Company__c = 'Rebel Alliance Inc.';
        adv1.RecordTypeId = rec.Id;
        adv1.Primary_Contact__c = con1.Id;
        adv1.Status__c = 'Active Adviser';
        adv1.Service_Team__c = '2';
        adv1.Designation__c = 'BD';
        adv1.Adviser_Coach__c = advCoachUser.Id;
        adv1.Firm_ID__c = '4321';
        insert adv1;
        
        Venue__c ven = new Venue__c();
        ven.Name = 'Test Venue';
        ven.Street_Address_1__c = '5955 Deerfield Blvd';
        ven.City__c = 'Mason';
        ven.Venue_State__c = 'OH';
        ven.Postal_Code_Zip__c = '45040';
        ven.Concierge__c = 'Mason';
        insert ven;
        
        Event__c evn = new Event__c();
        evn.Name = 'Destruction of the Death Star';
        evn.Event_Type__c = 'Training Event';
        evn.Course_Name__c = 'Other';
        evn.Event_Start_Date__c = system.today() + 12;
        evn.Event_End_Date__c = system.today() + 15;
        evn.Maximum_Registration__c = 100;
        evn.RegistrationEndDate__c = system.today() + 10;
        evn.Venue__c = ven.Id;
        
        insert evn;  
        
        Event_Registration__c reg = new Event_Registration__c();
        reg.Reg_Adviser__c = adv.Id;
        reg.Event__c = evn.Id;
        reg.Status__c = 'Registered';
        reg.Attendee_Type__c = 'Adviser';
        insert reg;
        
        Event_Registration__c reg1 = new Event_Registration__c();
        reg1.Reg_Adviser__c = adv1.Id;
        reg1.Event__c = evn.Id;
        reg1.Status__c = 'Registered';
        reg1.Attendee_Type__c = 'Adviser';
        insert reg1;   
        
    }
    
    @isTest static void testFindAllAdviser(){

        test.startTest();

		testSetUp();
        

        List<Adviser__c> adviserList = [SELECT Id, Name, Primary_Contact_Name__c, Adviser_Number__c, Contact_Email__c FROM Adviser__c ORDER BY Primary_Contact_Name__c];
        List<Adviser__c> findAllAdviserList = mm_MassSwitchAdviserCoachController.findAllAdviser();
        test.stopTest();
        
        system.assertEquals(adviserList, findAllAdviserList);

    }
    
    @isTest static void testFindByAdviserCoach(){

        test.startTest();

        testSetUp();
        
        Profile salesProfile = [SELECT Id FROM Profile WHERE Name = 'Sales'];
        User advCoachUser = [SELECT Id, Name FROM User WHERE isActive = True AND ProfileId =: salesProfile.Id LIMIT 1];
        String searchString = advCoachUser.Name.substring(0,4);
        List<User> findAdviserCoachUser = mm_MassSwitchAdviserCoachController.selectAdviserCoachByName(searchString);
        test.stopTest();
        
        system.assertEquals(True, findAdviserCoachUser.contains(advCoachUser));

    }
    
    @isTest static void testFindByEvent(){

        test.startTest();

        testSetUp();

        Event__c evt = [SELECT Id, Name, Event_Start_Date__c  FROM Event__c LIMIT 1];
        String searchString = evt.Name.substring(0,4);
        List<Event__c> findEvent = mm_MassSwitchAdviserCoachController.findByEvent(searchString);
        test.stopTest();
        
        system.assertEquals(True, findEvent.contains(evt));                

    }
    
    @isTest static void testFindAdviserByEvent(){

        test.startTest();

        testSetup();
        
        Event__c evt = [SELECT Id, Name, Event_Start_Date__c  FROM Event__c LIMIT 1];
        List<Adviser__c> advList = [SELECT Id, Name, Primary_Contact_Name__c, Adviser_Number__c, Contact_Email__c FROM Adviser__c ORDER BY Primary_Contact_Name__c];
        List<Adviser__c> findAdvByEvtList = mm_MassSwitchAdviserCoachController.findAdviserByEvent(evt.id);
        test.stopTest();
        
        system.assertEquals(advList, findAdvByEvtList);

    }
    
    @isTest static void testFindAdviserByAdviserCoach(){

        test.startTest();

        testSetUp();
        
        Profile salesProfile = [SELECT Id FROM Profile WHERE Name = 'Sales'];
        User advCoachUser = [SELECT Id FROM User WHERE isActive = True AND ProfileId =: salesProfile.Id LIMIT 1];  
        List<Adviser__c> adviserList = [SELECT Id FROM Adviser__c ORDER BY Primary_Contact__r.Name];
        List<Id> adviserIds = new List<Id>();
        for (Adviser__c a : adviserList)
            adviserIds.add(a.Id);
        List<Id> adviserIds1 = new List<Id>();
        List<Adviser__c> findAdvByCoachList = mm_MassSwitchAdviserCoachController.findAdviserByAdviserCoach(advCoachUser.Id);
        for (Adviser__c a : findAdvByCoachList)
            adviserIds1.add(a.Id);
        test.stopTest();
            
        system.assertEquals(adviserIds, adviserIds1);
    }
    
    @isTest static void testFindAdviserCoach(){

        test.startTest();

        testSetUp();
        
        Profile salesProfile = [SELECT Id FROM Profile WHERE Name = 'Sales'];
        List<User> advCoachUser = [SELECT Id, Name FROM User WHERE isActive = True AND ProfileId =: salesProfile.Id LIMIT 1];  
        List<User> findAdvCoachList = mm_MassSwitchAdviserCoachController.selectAllAdviserCoaches();
        system.debug('findAdvCoachList: ' + findAdvCoachList);
        system.debug('advCoachUser: ' + advCoachUser[0]);
        test.stopTest();
        system.assertEquals(True, findAdvCoachList.contains(advCoachUser[0]));
        
    }

    @isTest static void testSwitchAdvisers(){

        test.startTest();

        testSetUp();
        
        Adviser__c adv = [SELECT Id, Adviser_Coach__c FROM Adviser__c WHERE Primary_Contact__r.FirstName = 'Luke' LIMIT 1];
        Adviser__c adv1 = [SELECT Id, Adviser_Coach__c FROM Adviser__c WHERE Primary_Contact__r.FirstName = 'Leia'];
        Profile salesProfile = [SELECT Id FROM Profile WHERE Name = 'Sales'];
        User advCoachUser = [SELECT Id FROM User WHERE Id =: adv.Adviser_Coach__c];  
 		User newAdvCoachUser = [SELECT Id FROM User WHERE isActive = True AND ProfileId =: salesProfile.Id AND Id !=: advCoachUser.Id LIMIT 1]; 
        List<String> adviserIds = new   string[]{adv.id, adv1.id};          
        mm_MassSwitchAdviserCoachController.switchAdvisers(newAdvCoachUser.Id, adviserIds);
        Adviser__c advUpdated = [SELECT Id, Adviser_Coach__c FROM Adviser__c WHERE Primary_Contact__r.FirstName = 'Leia'];
        Adviser__c adv1Updated = [SELECT Id, Adviser_Coach__c FROM Adviser__c WHERE Primary_Contact__r.FirstName = 'Luke' LIMIT 1];
        test.stopTest();
        
        system.assertEquals(newAdvCoachUser.Id, advUpdated.Adviser_Coach__c);
        system.assertEquals(newAdvCoachUser.Id, adv1Updated.Adviser_Coach__c);
      
    }
    
    
    @isTest static void testFilterAdviserList(){
                // set up test data
        
        RecordType RT = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser' and SobjectType='Adviser__c'];
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        
        Profile salesProfile = [SELECT Id FROM Profile WHERE Name = 'Sales'];
        User adviserCoachUser = [SELECT Id FROM User WHERE isActive = True AND ProfileId =: salesProfile.Id LIMIT 1];
        
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Darth';
        con.LastName = 'Vader' ;
        con.Email ='Vader@Vader.com' ;
        con.Office_Phone__c = '4561328888';
        con.MailingStreet = '1 DeathStar rd';
        con.MailingCity = 'Mason';
        con.MailingState = 'Ohio';
        con.MailingPostalCode = '45040';
        con.AccountId = acc.Id;
        
        insert con;
        
        Adviser__c adv = new Adviser__c();
        adv.Company__c = 'Test comp';
        adv.RecordTypeId = RT2.Id;
        adv.Primary_Contact__c = con.Id;
        adv.Status__c = 'Active Adviser';
        adv.Service_Team__c = '2' ;
        adv.Designation__c  = 'BD'; 
        adv.Adviser_Coach__c = adviserCoachUser.Id;
        adv.Firm_ID__c = '22222222' ;
        
        insert adv;
        
        Contact con1 = new Contact();
        con1.FirstName = 'Test';
        con1.LastName = 'Contact';
        con1.Email = 'Test@Test.com';
        con1.Office_Phone__c = '1233455678';
        con1.MailingStreet = '1234 Testing Ln';
        con1.MailingCity = 'Test';
        con1.MailingState = 'Ohio';
        con1.MailingPostalCode = '29911';
        con1.AccountId = acc.Id;
        
        insert con1;
        
        Adviser__c adv1 = new Adviser__c();
        adv1.Company__c = 'A company';
        adv1.RecordTypeId = RT2.Id;
        adv1.Primary_Contact__c = con1.Id;
        adv1.Status__c = 'Active Adviser';
        adv1.Service_Team__c = '1';
        adv1.Designation__c  = 'BD'; 
        adv1.Adviser_Coach__c = adviserCoachUser.Id;
        adv1.Firm_ID__c = '123';
        
        insert adv1;
        
        test.startTest();
        String searchKey = 'test'; 	// a search key similar to con1's name
        List<Adviser__c> adviserList = [SELECT Id FROM Adviser__c];
        List<Adviser__c> results = MassAdviserInviteController.filterAdviserResults(searchKey, adviserList);
        System.assertEquals(1, results.size());		// only the adviser with the primary contact name of Test should be returned
        test.stopTest();
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}