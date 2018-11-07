@isTest
public class mm_SSN_Validation_Test {
    
    
    
    @isTest static void testmm_SSN_Validation_Test() {
        Contact fakeContact = fakeContactwithSSN();
        
        RecordType RT = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
        List<User> coaches = [SELECT Id, Name, isActive FROM User WHERE User.Profile.Name = 'Sales' AND isActive = true];
        
        
    }
    
    
    @isTest static Contact fakeContactwithoutSSN(){
        
        // create account
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        insert acc;
        
        // contact for registered status
        Contact con = new Contact();
        con.FirstName = 'ChesterOk';
        con.LastName = 'TesterOk';
        con.Email = 'example@adviser.com';
        con.Office_Phone__c = '9376290231';
        con.MailingStreet = '1234 Test Ave';
        con.MailingCity = 'Cincinnati';
        con.MailingStateCode = 'OH';
        con.MailingPostalCode = '45219';
        con.AccountId = acc.Id;
        
        
        insert con;
        return con;
    }
    @isTest static Contact fakeContactwithSSN(){
        
        // create account
        Account acc = new Account();
        acc.Name = 'Matson Money Default';
        insert acc;
        
        // contact for registered status
        Contact con = new Contact();
        con.FirstName = 'ChesterGood';
        con.LastName = 'TesterGood';
        con.Email = 'example@adviser.com';
        con.Office_Phone__c = '9376290231';
        con.MailingStreet = '1234 Test Ave';
        con.MailingCity = 'Cincinnati';
        con.MailingStateCode = 'OH';
        con.MailingPostalCode = '45219';
        con.AccountId = acc.Id;
        con.Social_Security_Number__c ='123456789';   
        
        
        insert con;
        return con;
    }
    
    @isTest static void testInsertfakeContactwithSSN(){
        
        
        
        test.startTest();
        try{
            Contact fakeContactwithSSN = fakeContactwithSSN();  
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown2A =  e.getMessage().contains('Please enter the 9-digit SSN with no dashes.');
            
        }
        test.stopTest();
        
    }
    
    @isTest static void testInsertfakeContactwithoutSSN(){
        
        
        
        test.startTest();
        try{
            Contact fakeContactwithoutSSN = fakeContactwithoutSSN();  
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown2A =  e.getMessage().contains('Please enter the 9-digit SSN with no dashes.');
            
        }
        test.stopTest();
        
    }
    @isTest static void testInsertfakeContactwithBadSSN(){
        
        
        
        test.startTest();
        try{
            // create account
            Account acc = new Account();
            acc.Name = 'Matson Money Default';
            insert acc;
            
            // contact for registered status
            Contact con = new Contact();
            con.FirstName = 'ChesterBadSSN';
            con.LastName = 'TesterBadSSN';
            con.Email = 'example@adviser.com';
            con.Office_Phone__c = '9376290231';
            con.MailingStreet = '1234 Test Ave';
            con.MailingCity = 'Cincinnati';
            con.MailingStateCode = 'OH';
            con.MailingPostalCode = '45219';
            con.AccountId = acc.Id;
            con.Social_Security_Number__c ='qwertyuio';   
            
            
            insert con;
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown2A =  e.getMessage().contains('Please enter the 9-digit SSN with no dashes.');
            
        }
        test.stopTest();
        
    }
    
}