/*
 * Author: Matt Billups
 * Purpose: Helper class for getting the org wide email addresses
 * Date: 10/30/18
 *
 */
public without sharing class mm_OrgWideEmailHelper {
	public mm_OrgWideEmailHelper() {
		
	}

	public List<OrgWideEmailAddress> getAllOrgWideEmailAddresses(){
		return [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress];
	}

	public String getOrgWideEmailAddress(String address){
		OrgWideEmailAddress email = [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress WHERE Address =: address LIMIT 1];
		return email.Id;
	}
}