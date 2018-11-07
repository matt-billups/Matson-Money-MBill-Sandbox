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
 * @description Test class for mm_RegisteredInterfacesHelper.
 *
 *
 **/
@isTest 
public class mm_RegisteredInterfacesHelperTest {

	static final String  INTERFACE_NAME = 'IAPIHelper';

	static testmethod void given_getRegisteredInterface_expect_Registered_Interface_mdt() {
		Registered_Interface__mdt registeredInterface = null;

		List<Registered_Interface__mdt> registeredInterfaces = [select DeveloperName, Class_Name__c from Registered_Interface__mdt WHERE DeveloperName  =: INTERFACE_NAME limit 1];

		if (registeredInterfaces.size() > 0) registeredInterface = registeredInterfaces.get(0);		

		Registered_Interface__mdt result = mm_RegisteredInterfacesHelper.getRegisteredInterface(INTERFACE_NAME);

		System.assertEquals(registeredInterface, result);
	}

	static testmethod void given_getRegisteredInterface_when_interface_name_is_null_then_expect_null() {
		Registered_Interface__mdt result = mm_RegisteredInterfacesHelper.getRegisteredInterface(null);

		System.assertEquals(null, result);
	}

	static testmethod void given_getTypeName_expect_name_of_type() {
		String typeName = 'mm_APIHelper';
		String result = mm_RegisteredInterfacesHelper.getTypeName(INTERFACE_NAME);

		System.assertEquals(typeName, result);
	}

	static testmethod void given_getTypeName_when_interface_name_is_null_then_expect_null() {
		String result = mm_RegisteredInterfacesHelper.getTypeName(null);

		System.assertEquals(null, result);
	}

}