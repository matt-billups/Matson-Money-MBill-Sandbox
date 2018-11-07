/**
 * @author Brian K. Broughton (brian.broughton@pinnsg.com)
 * @version 1.0.0
 * @description Helper class for API Settings Custom Metadata Type
 *
 *
 **/ 
public class mm_APISettingsHelper {
	
	/**
	 * @description Uses SOQL to retrieve API Settings using DeveloperName
	 * @settingName String DeveloperName of API_Settings. 
	 * @return API_Settings__mdt 
	 **/ 
	public static API_Settings__mdt getAPISetting(String settingName) {

		API_Settings__mdt setting = null;

		List<API_Settings__mdt> settings = [select Username__c, Password__c, ApiKey__c, Endpoint_Base__c, Auth_Header_Field_Pattern__c from API_Settings__mdt WHERE DeveloperName  =: settingName limit 1];

		if (settings.size() > 0) setting = settings.get(0);

		return setting;
	}
}