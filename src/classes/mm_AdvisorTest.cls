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
 * @description Test class for mm_Advisor. mm_Advisor does not have any logic in it.
 * I'm just adding a test case to improve code coverage %.
 *
 **/
@isTest 
public class mm_AdvisorTest { 
	
	static testmethod void given_mm_Advisor_expect_mm_Advisor() {
		mm_Advisor advisor = new mm_Advisor();

		advisor.firstName = 'Bob';
		advisor.lastName = 'Smith';
		advisor.company = 'ABC Company';
		advisor.address1 = '123 Any Street';
		advisor.address2 = '';
		advisor.city = 'Any City';
		advisor.state = 'OH';
		advisor.zipcode = '12345';
		advisor.phone = '555-555-5555';
		advisor.email = 'bob_at_gmail.com';
		advisor.repNo = '123';
		advisor.distance = '10';
	}
}