/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class mm_FulfillmentRequestControllerExtTest {

    static List<Fulfillment_Request__c> requestList;
    
    static private void setupTestRun() {

        requestList = new List<Fulfillment_Request__c>();

        // Address constants
        String addr = '123 Main St';
        String city = 'Sometown';
        String zip = '12345';
        String state = 'OH';

        // Create Lead
        //Lead lead = new Lead();
        
        //lead.LastName = 'Jones';
        //lead.Company = 'N/A';
        
        //insert lead;

        // Create Product
        Product2 product = new Product2();
        product.Name = 'My product';

        insert product;
        
        // Create non-shipped Fulfillment Request
        Fulfillment_Request__c notShippedRequest = new Fulfillment_Request__c();
        
        notShippedRequest.Ship_To_Name__c = 'Not Shipped';
        notShippedRequest.Shipped_On__c  = null;
        //notShippedRequest.Lead__c = lead.Id;
        notShippedRequest.Product__c = product.Id;
        notShippedRequest.Street_Address__c = addr;
        notShippedRequest.City__c = city;
        notShippedRequest.State__c = state;
        notShippedRequest.Zip_Code__c = zip;
        
        insert notShippedRequest;
        
        // Create shipped Fulfillment Request
        Fulfillment_Request__c shippedRequest = new Fulfillment_Request__c();
        
        shippedRequest.Ship_To_Name__c = 'Shipped Request';
        shippedRequest.Shipped_On__c = Date.today();
        //shippedRequest.Lead__c = lead.Id;
        shippedRequest.Product__c = product.Id;
        shippedRequest.Street_Address__c = addr;
        shippedRequest.City__c = city;
        shippedRequest.State__c = state;
        shippedRequest.Zip_Code__c = zip;
        
        insert shippedRequest;
        
    }

    static testMethod void given_RequestsNotShipped_then_expect_results() {
        
        setupTestRun();
        
        //Start Test Context, It will reset all Governor limits
        Test.startTest();
        
        //Inform Test Class to set current page as your Page where Extension is used
        Test.setCurrentPage(Page.mm_LeadsCustomTab);
        
        //Instantiate object of "ApexPages.StandardSetController"by passing array of records
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(requestList);
        
        //Now, create Object of your Controller extension by passing object of standardSetController
        mm_FulfillmentRequestControllerExtension ext = new mm_FulfillmentRequestControllerExtension(stdSetController);
        
        //Here you can test all public methods defined on Extension "ext"
        List<Fulfillment_Request__c> requests = ext.getRequestsNotShipped();
        
        System.assertEquals(1, requests.size());    
        
        //Finish Test
        Test.stopTest();
        
    }
    
}