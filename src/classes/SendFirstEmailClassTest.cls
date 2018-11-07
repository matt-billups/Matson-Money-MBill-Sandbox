@isTest public class SendFirstEmailClassTest {


   static testMethod void  SendFirstEmailTest()
   {
       List<User> coaches = [SELECT Id, Name, isActive FROM User WHERE User.Profile.Name = 'Sales' AND isActive = true];
         RecordType RT = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];

        
        //create test custom setting:
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234'); 
        
        // create account
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        insert acc;
        
                   // contact for registered status
        Contact con1 = new Contact();
        con1.FirstName = 'Chester1';
        con1.LastName = 'Tester1';
        con1.Email = 'Kelly.Carroll@matsonmoney.com';
        con1.Office_Phone__c = '8376290231';
        con1.MailingStreet = '1284 Test Ave';
        con1.MailingCity = 'Cincinnati';
        con1.MailingStateCode = 'OH';
        con1.MailingPostalCode = '45219';
        con1.AccountId = acc.Id;
        insert con1;
        
        // adviser for registered status
        Adviser__c adv1 = new Adviser__c();
        adv1.RecordTypeId = RT.Id;
        adv1.Primary_Contact__c = con1.Id;
        adv1.Status__c = 'Active Prospect';
        adv1.Adviser_Coach__c = coaches[1].Id;
        adv1.Inventory_Date__c = system.today();
        adv1.X3_Biggest_Money_Problems__c = 'stufff';
        adv1.Pain_Money_Total__c = 10.00;
        insert adv1;
       
      SendFirstEmailClass.SendCongratFirstStepsEmail(adv1.Id);
       SendFirstEmailClass.GetCongratFirstStepsEmail(adv1.Id);
   }
}