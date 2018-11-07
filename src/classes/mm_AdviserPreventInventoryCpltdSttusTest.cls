@isTest public with sharing class mm_AdviserPreventInventoryCpltdSttusTest {
    
    static testMethod void testAdviserPreventInventoryCpltdSttus() {
        // Test data setup
        
        //Create User
            Profile testProfile = [SELECT Id 
                           FROM profile
                           WHERE Name = 'Sales' 
                           LIMIT 1];

    User testUser = new User(LastName = 'test user 1', 
                             Username = 'test.user.1@example.com', 
                             Email = 'test.1@example.com', 
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id, 
                             LanguageLocaleKey = 'en_US');  
        
        // Create a contact, adviser and event and then insert
        
        RecordType RT = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser' and SobjectType='Adviser__c'];
        RecordType RT2 = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        
         //Create account not needed in dev6 but needed in QA
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
        //con.AccountId = acc.Id;
        
        insert con;
        
        // Create an Advisor 
        
        Adviser__c adv = new Adviser__c();
        adv.Company__c = 'Test comp';
        adv.RecordTypeId = RT2.Id;
        adv.Primary_Contact__c = con.Id;
        adv.Status__c = 'Active Prospect';
        adv.Inventory_Date__c = system.today();
        adv.Adviser_Coach__c = '00536000001OWzVAAW';
        adv.Firm_ID__c = '11111111' ;
        adv.Sales_Status__c = 'New';
        
        insert adv;
        
        Contact con2 = new Contact();
        
        con2.FirstName = 'Darth2';
        con2.LastName = 'Vader2' ;
        con2.Email ='Vader2@Vader.com' ;
        con2.Office_Phone__c = '4561328882';
        con2.MailingStreet = '2 DeathStar rd';
        con2.MailingCity = 'Mason';
        con2.MailingState = 'Ohio';
        con2.MailingPostalCode = '45040';
        //con.AccountId = acc.Id;
        
        insert con2;
        
        // Create an Advisor 
        
        Adviser__c adv2 = new Adviser__c();
        adv2.Company__c = 'Test comp2';
        adv2.RecordTypeId = RT2.Id;
        adv2.Primary_Contact__c = con2.Id;
        adv2.Status__c = 'Active Prospect';
        adv2.Adviser_Coach__c = '00536000001OWzVAAW';
        adv2.Firm_ID__c = '22222222' ;
        adv2.Sales_Status__c = 'New';
        
        insert adv2;
        
        Contact con3 = new Contact();
        
        con3.FirstName = 'Darth3';
        con3.LastName = 'Vader3' ;
        con3.Email ='Vader3@Vader.com' ;
        con3.Office_Phone__c = '4561328882';
        con3.MailingStreet = '3 DeathStar rd';
        con3.MailingCity = 'Mason';
        con3.MailingState = 'Ohio';
        con3.MailingPostalCode = '45040';
        //con.AccountId = acc.Id;
        
        insert con3;
        
        // Create an Advisor 
        
        Adviser__c adv3 = new Adviser__c();
        adv3.Company__c = 'Test comp3';
        adv3.RecordTypeId = RT2.Id;
        adv3.Primary_Contact__c = con3.Id;
        adv3.Status__c = 'Active Prospect';
        adv3.Adviser_Coach__c = '00536000001OWzVAAW';
        adv3.Firm_ID__c = '33333333' ;
        adv3.Sales_Status__c = 'New';
        
        insert adv3;
        Contact con4 = new Contact();
        
        con4.FirstName = 'Darth4';
        con4.LastName = 'Vader4' ;
        con4.Email ='Vader4@Vader.com' ;
        con4.Office_Phone__c = '4561428882';
        con4.MailingStreet = '4 DeathStar rd';
        con4.MailingCity = 'Mason';
        con4.MailingState = 'Ohio';
        con4.MailingPostalCode = '45040';
        //con.AccountId = acc.Id;
        
        insert con4;
        
        // Create an Advisor 
        
        Adviser__c adv4 = new Adviser__c();
        adv4.Company__c = 'Test comp4';
        adv4.RecordTypeId = RT2.Id;
        adv4.Primary_Contact__c = con4.Id;
        adv4.Status__c = 'Active Prospect';
        adv4.Adviser_Coach__c = '00536000001OWzVAAW';
        adv4.Firm_ID__c = '44444444' ;
        adv4.Sales_Status__c = 'New';
        
        insert adv4;
        
        Adviser__c ADVI = [SELECT Id, DuplicateCheckADVCONHidden__c, Sales_Status__c FROM Adviser__c WHERE id =: adv.id]; 
        Adviser__c ADVI2 = [SELECT Id, DuplicateCheckADVCONHidden__c, Sales_Status__c FROM Adviser__c WHERE id =: adv2.id]; 
        Adviser__c ADVI3 = [SELECT Id, DuplicateCheckADVCONHidden__c, Sales_Status__c FROM Adviser__c WHERE id =: adv3.id];
        Adviser__c ADVI4 = [SELECT Id, DuplicateCheckADVCONHidden__c, Sales_Status__c FROM Adviser__c WHERE id =: adv4.id];
        
        // Perform test
        Test.startTest();
        System.runas(testUser){
        try
        {
            ADVI.Sales_Status__c = 'Inventory Completed'; 
            update ADVI;
            //throw new MyException('An exception should have been thrown by the trigger but was not.'); 
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Please fill out BOTH the "3 Biggest Money Problems" and "Pain Money Total" fields before progressing to Inventory Completed. These fields are located below in the "Key Fields" and in the "Inventory Information" sections of the Adviser Prospect Record.');
           // System.AssertEquals(expectedExceptionThrown, true);
            
        } 
        try
        {
            ADVI.X3_Biggest_Money_Problems__c = 'test1';
            ADVI.Pain_Money_Total__c = 24;
            ADVI.Sales_Status__c = 'Inventory Completed'; 
            update ADVI;
            //throw new MyException('An exception should have been thrown by the trigger but was not.'); 
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrownA =  e.getMessage().contains('Regression within or skipping steps in the the Sales Status Path is not allowed, Please Contact a System Administrator for this edit or Proceed to the Next step in the Path.');
           // System.AssertEquals(expectedExceptionThrownA, true);
            
        }
        try
        {
            ADVI2.Sales_Status__c = 'Registered for EFT Session 1'; 
            update ADVI2;
            //throw new MyException('An exception should have been thrown by the trigger but was not.'); 
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown2 =  e.getMessage().contains('Please fill out BOTH the "3 Biggest Money Problems" and "Pain Money Total" fields before before progressing this Adviser to EFT Session 1. These fields are located in the "Key Fields" and in the "Inventory Information" sections of the Adviser Prospect Record.');
           // System.AssertEquals(expectedExceptionThrown2, true);
            
        }
        try
        {
            ADVI2.X3_Biggest_Money_Problems__c = 'test1';
            ADVI2.Pain_Money_Total__c = 24;
            ADVI2.Sales_Status__c = 'Registered for EFT Session 1'; 
            update ADVI2;
            //throw new MyException('An exception should have been thrown by the trigger but was not.'); 
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown2A =  e.getMessage().contains('Regression within or skipping steps in the the Sales Status Path is not allowed, Please Contact a System Administrator for this edit or Proceed to the Next step in the Path.');
            //System.AssertEquals(expectedExceptionThrown2A, true);
            
        }
        try
        {
            ADVI3.Sales_Status__c = 'EFT Session 1 Attended'; 
            update ADVI3;
            //throw new MyException('An exception should have been thrown by the trigger but was not.'); 
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown3 =  e.getMessage().contains('Please fill out BOTH the "3 Biggest Money Problems" and "Pain Money Total" fields before progressing this Adviser to EFT Session 1 Attended. These fields are located in the "Key Fields" and in the "Inventory Information" sections of the Adviser Prospect Record.');
            System.AssertEquals(expectedExceptionThrown3, true);
            
        }
        try
        {
            ADVI3.X3_Biggest_Money_Problems__c = 'test1';
            ADVI3.Pain_Money_Total__c = 24;
            ADVI3.Sales_Status__c = 'EFT Session 1 Attended'; 
            update ADVI3;
            //throw new MyException('An exception should have been thrown by the trigger but was not.'); 
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown3B =  e.getMessage().contains('Regression within or skipping steps in the the Sales Status Path is not allowed, Please Contact a System Administrator for this edit or Proceed to the Next step in the Path.');
            //System.AssertEquals(expectedExceptionThrown3B, true);
            
        }
        
        try
        {
            ADVI4.Sales_Status__c = 'Contracts Signed'; 
            update ADVI4;
            //throw new MyException('An exception should have been thrown by the trigger but was not.'); 
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown4 =  e.getMessage().contains('Please fill out BOTH the "3 Biggest Money Problems" and "Pain Money Total" fields before progressing this Adviser to Contracts Signed. These fields are located in the "Key Fields" and in the "Inventory Information" sections of the Adviser Prospect Record.');
           // System.AssertEquals(expectedExceptionThrown4, true);
            
        }
        try
        {   ADVI4.X3_Biggest_Money_Problems__c = 'test1';
            ADVI4.Pain_Money_Total__c = 24;
            ADVI4.Sales_Status__c = 'Contracts Signed'; 
            update ADVI4;
            //throw new MyException('An exception should have been thrown by the trigger but was not.'); 
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown4B =  e.getMessage().contains('Regression within or skipping steps in the the Sales Status Path is not allowed, Please Contact a System Administrator for this edit or Proceed to the Next step in the Path.');
           // System.AssertEquals(expectedExceptionThrown4B, true);
            
        }
        try
        {   ADVI4.X3_Biggest_Money_Problems__c = 'test1';
            ADVI4.Pain_Money_Total__c = 24;
            ADVI.Inventory_Date__c = DateTime.now()+ 5;
            ADVI4.Sales_Status__c = 'Inventory Scheduled'; 
            update ADVI4;
         
          ADVI4.Sales_Status__c = 'New'; 
            update ADVI4;
         
         
            //throw new MyException('An exception should have been thrown by the trigger but was not.'); 
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown5B =  e.getMessage().contains('Regression within the the Sales Status Path is not allowed, Please Contact a System Administrator for this edit or Proceed to the Next step in the Path.');
           // System.AssertEquals(expectedExceptionThrown5B, true);
            
        }
        try
        {   ADVI4.X3_Biggest_Money_Problems__c = 'test1';
            ADVI4.Pain_Money_Total__c = 24;
            ADVI.Inventory_Date__c = DateTime.now()+ 5;
            ADVI4.Sales_Status__c = 'Inventory Completed'; 
            update ADVI4;
         
          ADVI4.Sales_Status__c = 'Inventory Scheduled'; 
            update ADVI4;
         
         
            //throw new MyException('An exception should have been thrown by the trigger but was not.'); 
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown6B =  e.getMessage().contains('Regression within the the Sales Status Path is not allowed, Please Contact a System Administrator for this edit or Proceed to the Next step in the Path.');
            //System.AssertEquals(expectedExceptionThrown6B, true);
            
        }
       }
        Test.stopTest();
        
    }
}