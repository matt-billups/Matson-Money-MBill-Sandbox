@isTest public with sharing class  mm_publicEmailOptOutTest {



  static testMethod void Testmm_publicEmailOptOutTest()
    {
 //create test custom setting:
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234'); 

        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        // Create account
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        
        insert acc;

        
      
    
        
      
        // Start of testing  Event registation page 
        //Insert a second contact - Duplicate Rule failed test class - braden fix in QA
        Contact con2 = new Contact();
        con2.FirstName = 'Kim';
        con2.LastName = 'Posible' ;
        con2.Email ='KimPosible@example.com' ;
        con2.Office_Phone__c = '2561328888';
        con2.MailingStreet = '2 Posible rd';
        con2.MailingCity = 'Mason';
        con2.MailingState = 'Ohio';
        con2.MailingPostalCode = '45040';
        con2.AccountId = acc.Id;   
        insert con2;
        
        //created Adviser
        
        Adviser__c adv2 = new Adviser__c();
        adv2.Company__c = 'Test comp';
        adv2.RecordTypeId = RT2.Id;
        adv2.Primary_Contact__c = con2.Id;
        adv2.Status__c= 'Active Adviser';
        adv2.Inventory_Date__c = system.now().addDays(5);
        adv2.Sales_Status__c = 'Inventory Scheduled';
        adv2.Service_Team__c = '2' ;
        adv2.Designation__c  ='BD' ; 
        adv2.Adviser_Coach__c = '00536000001OWzVAAW';
        adv2.Firm_ID__c = '22222222' ;
        insert adv2;   

         
     
        
        
    

    
        Test.startTest()  ;
    
               //Test Email Opt Out 
        mm_publicEmailOptOut.emailOptOut('KimPosible@example.com');
        //test with a non existing email
        mm_publicEmailOptOut.emailOptOut('apitinAmerica@example.co');
    
        Test.stopTest();
    }
}