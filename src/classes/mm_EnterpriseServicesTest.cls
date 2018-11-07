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
 
 * @author Brian K. Broughton (brian.broughton@pinnsg.com)
 * @version 1.0.0
 * @description Test class for mm_EnterpriseServices.
 *
 *
 **/
@isTest 
public class mm_EnterpriseServicesTest { 

	static StaticResourceCalloutMock mock;
	static List<mm_Advisor> results = new List<mm_Advisor>();

	@testSetup
	static void testSetup() {		
		mock = new StaticResourceCalloutMock();
		mock.setStaticResource('mm_EnterpriseServicesTest_Advisors_JSON');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');		
	}
	
	static testmethod void given_getAllAdvisors_then_expect_list_of_advisors() {
		
		mm_APIHelperMock apiHelper = new mm_APIHelperMock();

		apiHelper.setResponseBody('[{"FirstName":"Bob","LastName":"Smith"},{"FirstName":"John","LastName":"Doe"}]');

		mm_ServiceHelper.setAPIHelper(apiHelper);

		results = mm_EnterpriseServices.getAllAdvisors();

		System.assertEquals(2, results.size());
	}

	static testmethod void given_getLocalAdvisors_then_expect_list_of_advisors() {
		
		mm_APIHelperMock apiHelper = new mm_APIHelperMock();

		apiHelper.setResponseBody('[{"FirstName":"Bob","LastName":"Smith"},{"FirstName":"John","LastName":"Doe"}]');

		mm_ServiceHelper.setAPIHelper(apiHelper);

		results = mm_EnterpriseServices.getLocalAdvisors('12345', 25);

		System.assertEquals(2, results.size()); 
	}
}