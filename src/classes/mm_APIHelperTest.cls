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
 * @description Test class for mm_APIHelper.
 *
 *
 **/
@isTest 
public class mm_APIHelperTest {

	static final string API_SETTINGS_NAME = 'Enterprise_Services';
	static final string API_OPERATION_NAME = 'Get_All_Advisors';
    
	@testSetup
	static void testSetup() {
	}

	@isTest static void given_getResponseBody_then_expect_valid_result() {
        Boolean IsThisaSand = mm_SettingsHelper.IsSandboxOrg();
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();

		// Use StaticResourceCalloutMock built-in class to
		// specify fake response and include response body 
		// in a static resource.
		mock.setStaticResource('mm_EnterpriseServicesTest_Advisors_JSON');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');
        
		// Set the mock callout mode
		Test.setMock(HttpCalloutMock.class, mock);		

		String res = mm_APIHelper.getResponseBody(API_SETTINGS_NAME, API_OPERATION_NAME, 0, '');
         Boolean IsSand = mm_SettingsHelper.IsSandboxOrg(); 
        system.debug('***sandbox '+IsSand);
		// Verify response received contains values returned by
		// the mock response.
		// This is the content of the static resource.
		System.assertEquals('[{"FirstName":"Bob","LastName":"Smith"},{"FirstName":"John","LastName":"Doe"}]', res);
        System.assertEquals(IsThisaSand, IsSand);
	}

	@isTest static void given_getResponseBody_when_id_passed_then_expect_valid_result() {
        Boolean IsThisaSand = mm_SettingsHelper.IsSandboxOrg();
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();

		// Use StaticResourceCalloutMock built-in class to
		// specify fake response and include response body 
		// in a static resource.
		mock.setStaticResource('mm_EnterpriseServicesTest_Advisors_JSON');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');
        
		// Set the mock callout mode
		Test.setMock(HttpCalloutMock.class, mock);		
        
		String res = mm_APIHelper.getResponseBody(API_SETTINGS_NAME, API_OPERATION_NAME, 1, '');
         Boolean IsSand = mm_SettingsHelper.IsSandboxOrg(); 
        system.debug('***sandbox '+IsSand);
		// Verify response received contains values returned by
		// the mock response.
		// This is the content of the static resource.
		System.assertEquals('[{"FirstName":"Bob","LastName":"Smith"},{"FirstName":"John","LastName":"Doe"}]', res);
        System.assertEquals(IsThisaSand, IsSand);
	}

	@isTest static void given_getResponseBody_when_query_passed_then_expect_valid_result() {
        Boolean IsThisaSand = mm_SettingsHelper.IsSandboxOrg();
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();

		// Use StaticResourceCalloutMock built-in class to
		// specify fake response and include response body 
		// in a static resource.
		mock.setStaticResource('mm_EnterpriseServicesTest_Advisors_JSON');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');
        
		// Set the mock callout mode
		Test.setMock(HttpCalloutMock.class, mock);		

		String res = mm_APIHelper.getResponseBody(API_SETTINGS_NAME, API_OPERATION_NAME, 0, 'zipcode=12345');
        Boolean IsSand = mm_SettingsHelper.IsSandboxOrg(); 
        
		// Verify response received contains values returned by
		// the mock response.
		// This is the content of the static resource.
		System.assertEquals('[{"FirstName":"Bob","LastName":"Smith"},{"FirstName":"John","LastName":"Doe"}]', res);
        System.assertEquals(IsThisaSand, IsSand);
	}

	@isTest static void given_getResponseBody_when_invalid_respone_then_expect_empty_string() {

		StaticResourceCalloutMock mock2 = new StaticResourceCalloutMock();
        mock2.setStaticResource('mm_EnterpriseServicesTest_Advisors_JSON');
		mock2.setHeader('Content-Type', 'application/json');
		mock2.setStatusCode(500);

		// Set the mock callout mode
		Test.setMock(HttpCalloutMock.class, mock2);		

		String res = mm_APIHelper.getResponseBody(API_SETTINGS_NAME, API_OPERATION_NAME, 0, 'zipcode=12345');
        
		// Verify response received contains values returned by
		// the mock response.
		// This is the content of the static resource.
		System.assert(String.isEmpty(res));
	}

}