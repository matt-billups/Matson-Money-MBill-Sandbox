@isTest
public class mm_Test_Client_Primary_Contact {
            
        @isTest static void TestIsPrimaryNoExisting(){
        
            // set up test data
            
            Account acc = new Account();
            acc.Name = 'Matson Money Default';
            insert acc;
            
            Contact con = new Contact();
            con.FirstName = 'Elvis';
            con.LastName = 'Presley';
            con.Email = 'adviser@example.com';
            con.Office_Phone__c = '5132048000';
            con.AccountId = acc.id;
            insert con;
            
            Client__c cli = new Client__c();
            cli.Client_Name__c = 'Blue Hawaii Inc.';
            insert cli;
            
            Investor__c inv = new Investor__c();
            inv.ClientId__c = cli.Id;
            inv.ContactId__c = con.Id;
            inv.Is_Primary_Contact__c = True;
            insert inv;
            
            Test.startTest();
            
            Client__c myClient = [SELECT Id, Name, Primary_Investor_Contact__c FROM Client__c WHERE Client_Name__c = 'Blue Hawaii Inc.' limit 1];
            Investor__c myInvestor = [SELECT Id, ClientId__c FROM Investor__c WHERE ClientId__c =: myClient.Id limit 1];
			
            Test.stopTest();
            
            System.assertEquals(myClient.Primary_Investor_Contact__c, myInvestor.id);
            

        }
    
        @isTest static void TestIsPrimaryRemoved(){
        
            // set up test data
            
            Account acc1 = new Account();
            acc1.Name = 'Matson Money Default';
            insert acc1;
            
            Contact con1 = new Contact();
            con1.FirstName = 'Frank';
            con1.LastName = 'Sinatra';
            con1.Email = 'adviser@example.com';
            con1.Office_Phone__c = '5132048000';
            con1.AccountId = acc1.Id;
            insert con1;
            
            Client__c cli1 = new Client__c();
            cli1.Client_Name__c = 'Strangers in the Night Inc.';
            insert cli1;
            
            Investor__c inv1 = new Investor__c();
            inv1.ClientId__c = cli1.Id;
            inv1.ContactId__c = con1.Id;
            inv1.Is_Primary_Contact__c = True;
            insert inv1;
            
            cli1.Primary_Investor_Contact__c = inv1.Id;
            update cli1;
            
            inv1.Is_Primary_Contact__c = False;
            update inv1;
            
            Test.startTest();
            
            Client__c myClient1 = [SELECT Id, Name, Primary_Investor_Contact__c FROM Client__c WHERE Client_Name__c = 'Strangers in the Night Inc.' limit 1];
            
            Test.stopTest();
            
            System.assertEquals(null, myClient1.Primary_Investor_Contact__c);
            
        }
    


}