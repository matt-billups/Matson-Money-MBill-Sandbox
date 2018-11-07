@IsTest
public class mm_ManageEventEmailSubscriptionTests {

    static testmethod void ManageEventEmailSubscription_WhenContactDoesNotExist_ReturnsContactNotFound() {
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_ManageEventEmailSubscription';
        req.addParameter('CONID', 'InvalidContactId');
        req.addParameter('SUBSCRIBE', 'true');
        req.addParameter('EMAIL', 'doesntexist@example.com');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        mm_ManageEventEmailSubscription.ManageSubscription();
        
        System.assert(RestContext.response.responseBody != null);
        
        SubscriptionManagementResponse theResponse = (SubscriptionManagementResponse)JSON.deserialize(RestContext.response.responseBody.ToString(), SubscriptionManagementResponse.class);
        
        System.assert(theResponse.Success == 'false');
        System.assert(theResponse.Message == 'Contact not found.');   
        
        Test.stopTest();
    }
    
    static testmethod void ManageEventEmailSubscription_WhenContactExistsAndIsSubscribed_AndRequestIsToUnsubscribe_ThenUnsubscribesTheContact_AndReturnsSuccess() {
        // Create a contact
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.Email ='test@example.com';
        con.Office_Phone__c = '1234567890';
        con.MailingStreet = '123 Public Way';
        con.MailingCity = 'Mason';
        con.MailingState = 'Ohio';
        con.MailingPostalCode = '45040';
        
        insert con;
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_ManageEventEmailSubscription';
        req.addParameter('CONID', con.Id);
        req.addParameter('SUBSCRIBE', 'false');
        req.addParameter('EMAIL', con.Email);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        mm_ManageEventEmailSubscription.ManageSubscription();
        
        System.assert(RestContext.response.responseBody != null);
        
        SubscriptionManagementResponse theResponse = (SubscriptionManagementResponse)JSON.deserialize(RestContext.response.responseBody.ToString(), SubscriptionManagementResponse.class);
        
        System.assert(theResponse.Success == 'true');
        
        Contact savedContact = GetContact(con.Id);
        
        System.assert(savedContact.Matson_Event_Marketing_Email_Opt_Out__c == true);
        
        Test.stopTest();
    }
    
    static testmethod void ManageEventEmailSubscription_WhenContactExistsAndIsNotSubscribed_AndRequestIsToUnsubscribe_ThenDoesNothing_AndReturnsSuccess() {
        // Create a contact
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.Email ='test@example.com';
        con.Office_Phone__c = '1234567890';
        con.MailingStreet = '123 Public Way';
        con.MailingCity = 'Mason';
        con.MailingState = 'Ohio';
        con.MailingPostalCode = '45040';
        con.Matson_Event_Marketing_Email_Opt_Out__c = true;
        
        insert con;
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_ManageEventEmailSubscription';
        req.addParameter('CONID', con.Id);
        req.addParameter('SUBSCRIBE', 'false');
        req.addParameter('EMAIL', con.Email);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        mm_ManageEventEmailSubscription.ManageSubscription();
        
        System.assert(RestContext.response.responseBody != null);
        
        SubscriptionManagementResponse theResponse = (SubscriptionManagementResponse)JSON.deserialize(RestContext.response.responseBody.ToString(), SubscriptionManagementResponse.class);
        
        System.assert(theResponse.Success == 'true');
        
        Contact savedContact = GetContact(con.Id);
        
        System.assert(savedContact.Matson_Event_Marketing_Email_Opt_Out__c == true);
        
        Test.stopTest();
    }
    
    static testmethod void ManageEventEmailSubscription_WhenContactExistsAndIsSubscribed_AndRequestIsToSubscribe_ThenDoesNothing_AndReturnsSuccess() {
        // Create a contact
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.Email ='test@example.com';
        con.Office_Phone__c = '1234567890';
        con.MailingStreet = '123 Public Way';
        con.MailingCity = 'Mason';
        con.MailingState = 'Ohio';
        con.MailingPostalCode = '45040';
        
        insert con;
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_ManageEventEmailSubscription';
        req.addParameter('CONID', con.Id);
        req.addParameter('SUBSCRIBE', 'true');
        req.addParameter('EMAIL', con.Email);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        mm_ManageEventEmailSubscription.ManageSubscription();
        
        System.assert(RestContext.response.responseBody != null);
        
        SubscriptionManagementResponse theResponse = (SubscriptionManagementResponse)JSON.deserialize(RestContext.response.responseBody.ToString(), SubscriptionManagementResponse.class);
        
        System.assert(theResponse.Success == 'true');
        
        Contact savedContact = GetContact(con.Id);
        
        System.assert(savedContact.Matson_Event_Marketing_Email_Opt_Out__c == false);
        
        Test.stopTest();
    }
    
    static testmethod void ManageEventEmailSubscription_WhenContactExistsAndIsNotSubscribed_AndRequestIsToSubscribe_ThenSubscribesTheContact_AndReturnsSuccess() {
        // Create a contact
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.Email ='test@example.com';
        con.Office_Phone__c = '1234567890';
        con.MailingStreet = '123 Public Way';
        con.MailingCity = 'Mason';
        con.MailingState = 'Ohio';
        con.MailingPostalCode = '45040';
        con.Matson_Event_Marketing_Email_Opt_Out__c = true;
        
        insert con;
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_ManageEventEmailSubscription';
        req.addParameter('CONID', con.Id);
        req.addParameter('SUBSCRIBE', 'true');
        req.addParameter('EMAIL', con.Email);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        mm_ManageEventEmailSubscription.ManageSubscription();
        
        System.assert(RestContext.response.responseBody != null);
        
        SubscriptionManagementResponse theResponse = (SubscriptionManagementResponse)JSON.deserialize(RestContext.response.responseBody.ToString(), SubscriptionManagementResponse.class);
        System.assert(theResponse.Success == 'true');
        
        Contact savedContact = GetContact(con.Id);
        
        System.assert(savedContact.Matson_Event_Marketing_Email_Opt_Out__c == false);
        
        Test.stopTest();
    }
    
    static testmethod void ManageEventEmailSubscription_WhenContactExistsAndEmailParameterIsMissing_ThenReturnsNonSuccess() {
        // Create a contact
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.Email ='test@example.com';
        con.Office_Phone__c = '1234567890';
        con.MailingStreet = '123 Public Way';
        con.MailingCity = 'Mason';
        con.MailingState = 'Ohio';
        con.MailingPostalCode = '45040';
        con.Matson_Event_Marketing_Email_Opt_Out__c = true;
        
        insert con;
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_ManageEventEmailSubscription';
        req.addParameter('CONID', con.Id);
        req.addParameter('SUBSCRIBE', 'true');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        mm_ManageEventEmailSubscription.ManageSubscription();
        
        System.assert(RestContext.response.responseBody != null);
        
        SubscriptionManagementResponse theResponse = (SubscriptionManagementResponse)JSON.deserialize(RestContext.response.responseBody.ToString(), SubscriptionManagementResponse.class);
        System.assert(theResponse.Success == 'false');
        System.assert(theResponse.Message == 'Email address was not provided.');
        
        Test.stopTest();
    }
    
    static testmethod void ManageEventEmailSubscription_WhenContactExistsAndEmailParameterDoesNotMatch_ThenReturnsNonSuccess() {
        // Create a contact
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.Email ='test@example.com';
        con.Office_Phone__c = '1234567890';
        con.MailingStreet = '123 Public Way';
        con.MailingCity = 'Mason';
        con.MailingState = 'Ohio';
        con.MailingPostalCode = '45040';
        con.Matson_Event_Marketing_Email_Opt_Out__c = true;
        
        insert con;
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/mm_ManageEventEmailSubscription';
        req.addParameter('CONID', con.Id);
        req.addParameter('SUBSCRIBE', 'true');
        req.addParameter('EMAIL', 'nomatch@example.com');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        mm_ManageEventEmailSubscription.ManageSubscription();
        
        System.assert(RestContext.response.responseBody != null);
        
        SubscriptionManagementResponse theResponse = (SubscriptionManagementResponse)JSON.deserialize(RestContext.response.responseBody.ToString(), SubscriptionManagementResponse.class);
        System.assert(theResponse.Success == 'false');
        System.assert(theResponse.Message == 'Email address does not match Contact record.');
        
        Test.stopTest();
    }
    
    public class SubscriptionManagementResponse {
        public string Success;
        public string Message;
    }
    
    private static Contact GetContact(string contactId) {
        try {
            return [SELECT Id, Matson_Event_Marketing_Email_Opt_Out__c FROM Contact WHERE Id = :contactId LIMIT 1];
        }
        catch(QueryException ex) {
            return null; // Contact doesn't exist so return null
        }
    } 
   
}