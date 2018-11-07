@isTest(SeeAllData=true) private class addAccountOnCreateContactTest {
    
    @isTest static void testSetAccount() {
        
        Contact c = new Contact(FirstName = 'Test', LastName = 'Contact', MobilePhone = '5135550123', Email = 'test.contact@example.com');
        insert c;
        
        Account acct = [SELECT Id, Name FROM Account WHERE Name = 'Matson Money Default'];
        c = [SELECT AccountId FROM Contact WHERE Id =: c.Id];
        System.assertEquals(acct.Id, c.AccountId);
    }

}