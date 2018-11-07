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
private class mm_LeadControllerExtensionTest {
	
	@testSetup
	static private void setupTestRun() {
		
		// Create queue group
		Group qGroup = new Group(Name='test group', Type='Queue');
		qGroup.Name = 'Investor Outreach Sales Lead Queue';
		
		insert qGroup;		
        
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue = new QueueSObject(QueueID = qGroup.id, SObjectType = 'Lead');
            insert testQueue;
        }
        
		
		// Create non-queued Lead
		Lead lead = new Lead();
		
		lead.LastName = 'Lead 1';
		lead.Company = 'N/A';
		
		insert lead;
		
		// Create queued Lead
		Lead qLead = new Lead();
		
		qLead.LastName = 'Lead 2';
		qLead.Company = 'N/A';
		qLead.OwnerId = qGroup.Id;
		
		insert qLead;
		
	}

    static testMethod void given_LeadInSalesQueue_then_expect_results() {
    	
		//Start Test Context, It will reset all Governor limits
		Test.startTest();
		
		//Inform Test Class to set current page as your Page where Extension is used
		Test.setCurrentPage(Page.mm_LeadsCustomTab);
		
		//Instantiate object of "ApexPages.StandardSetController"by passing array of records
		ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(new List<Lead>());
		
		//Now, create Object of your Controller extension by passing object of standardSetController
		mm_LeadControllerExtension ext = new mm_LeadControllerExtension(stdSetController);
		
		//Here you can test all public methods defined on Extension "ext"
		List<Lead> queueLeads = ext.getLeadsInSalesQueue();
        
        System.assertEquals(1, queueLeads.size());	
		
		//Finish Test
		Test.stopTest();
        
    }

	static testMethod void given_LocalAdvisors_then_expect_results() {
    	
		mm_EnterpriseServicesMock esMock = new mm_EnterpriseServicesMock();

		esMock.setAdvisors(new List<mm_Advisor> { new mm_Advisor(), new mm_Advisor() });

		mm_ServiceHelper.setEnterpriseServices(esMock);
    	
		//Start Test Context, It will reset all Governor limits
		Test.startTest();
		
		//Inform Test Class to set current page as your Page where Extension is used
		Test.setCurrentPage(Page.mm_LocalAdvisors);
		
		//Instantiate object of "ApexPages.StandardSetController"by passing array of records
		ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(new List<Lead>());
		
		//Now, create Object of your Controller extension by passing object of standardSetController
		mm_LeadControllerExtension ext = new mm_LeadControllerExtension(stdSetController);
		
		//Here you can test all public methods defined on Extension "ext"
		List<mm_Advisor> adviors = ext.getLocalAdvisors();
        
        System.assertEquals(2, adviors.size());	
		
		//Finish Test
		Test.stopTest();
        
    }
}