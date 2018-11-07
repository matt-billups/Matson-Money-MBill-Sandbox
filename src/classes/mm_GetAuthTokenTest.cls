@isTest
public class mm_GetAuthTokenTest {
 static testMethod void Test_mm_GetAuthToken()
    {
        //create test custom setting:
        //privateKey
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = ' /services/apexrest/mm_GetAuthToken/';
        

        req.addParameter('CONID', 'doesnotmatter');
        req.addParameter('EVID', 'doesnotmatter');

        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        mm_GetAuthToken.GetAuthToken();
        Test.stopTest();
        
        
    }
 static testMethod void Test_mm_GetAuthTokenNone()
    {
        //create test custom setting:
        //privateKey
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = ' /services/apexrest/mm_GetAuthToken/';
        

        req.addParameter('CONID', '');
        req.addParameter('EVID', '');

        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        mm_GetAuthToken.GetAuthToken();
        Test.stopTest();
        
        
    }

}