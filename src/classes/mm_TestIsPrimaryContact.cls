@isTest
public class mm_TestIsPrimaryContact {

    @isTest static void TestIsPrimaryContactWithThreeContacts(){
        
        // Test data setup
        
        // Create a client to link to all investors
        Client__c testClient = new Client__c(Client_Name__c = '000001');
        insert testClient;
         
        // Create an account
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        insert acc;
        
        // Create three contacts 
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
        
        Contact con1 = new Contact();
        con1.FirstName = 'Darth';
        con1.LastName = 'Vader1' ;
        con1.Email ='Vader@Vader.com' ;
        con1.Office_Phone__c = '4561328888';
        con1.MailingStreet = '1 DeathStar rd';
        con1.MailingCity = 'Mason';
        con1.MailingState = 'Ohio';
        con1.MailingPostalCode = '45040';
        con1.AccountId = acc.Id;
        insert con1;
        
        Contact con2 = new Contact();
        con2.FirstName = 'Darth';
        con2.LastName = 'Vader2' ;
        con2.Email ='Vader@Vader.com' ;
        con2.Office_Phone__c = '4561328888';
        con2.MailingStreet = '1 DeathStar rd';
        con2.MailingCity = 'Mason';
        con2.MailingState = 'Ohio';
        con2.MailingPostalCode = '45040';
        con2.AccountId = acc.Id;
        insert con2; 
             
        // Create an investor using con that is not a primary contact
        Investor__c nonPrim = new Investor__c(ContactId__c = con.id, ClientId__c = testClient.id, Is_Primary_Contact__c = false);
        insert nonPrim;
    
        // Create an investor using con1 that is a primary contact
        Investor__c firstPrim = new Investor__c(ContactId__c = con1.id, ClientId__c = testClient.id, Is_Primary_Contact__c = true);
        insert firstPrim;
        
        // Create an investor using con2 that is also a primary contact
        try{
        	Investor__c secondPrim = new Investor__c(ContactId__c = con2.id, ClientId__c = testClient.id, Is_Primary_Contact__c = true);
            insert secondPrim;
        }
        catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('My Error Message') ? false : true;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
    }
}