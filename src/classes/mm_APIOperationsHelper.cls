/**
 * @author Brian K. Broughton (brian.broughton@pinnsg.com)
 * @version 1.0.0
 * @description Helper class for the API Operations custom metadata type.
 *
 *
 **/ 
public class mm_APIOperationsHelper { 

	/**
	 * @description Uses SOQL to retrieve API Operations using API Operations Name
	 * @apiSettingName String API Settings Name as found in API Settings custom metadata type. 
	 * @operationName  String API Operations Name as found in API Operations custom metadata type.
	 * @return API_Operations__mdt 
	 **/ 
	public static API_Operations__mdt getAPIOperation(string apiSettingName, string operationName) {

		API_Operations__mdt operation = null;

		List<API_Operations__mdt> operations = [SELECT API_Settings_Name__c, DeveloperName, HTTP_Method__c, URI__c, Query__c 
												FROM API_Operations__mdt 
												WHERE API_Settings_Name__c =: apiSettingName AND DeveloperName =: operationName limit 1];

		if (operations.size() > 0) operation = operations.get(0);

		return operation;
	}
}