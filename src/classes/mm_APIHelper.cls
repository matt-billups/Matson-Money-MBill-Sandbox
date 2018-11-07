/**
 * @author Brian K. Broughton (brian.broughton@pinnsg.com)
 * @version 1.0.0
 * @description Helper class for making external API calls.
 *
 *
 **/ 
public class mm_APIHelper implements mm_IAPIHelper {

	// Private Variables
	private static final Http http = new Http();
	private static final HttpRequest request = new HttpRequest();
	private static API_Settings__mdt apiSetting;
	// End - Private Variables

	// Public Methods
	public static string getResponseBody(string apiSettingName, string apiOperationName, Integer id, string query) {

		apiSetting = mm_SettingsHelper.getAPISetting(apiSettingName);

		setRequest(apiSettingName, apiOperationName, id, query);

		return getResponseBody();

	}
	// End - Public Methods

	// Private Methods
	private static void setRequest(string apiSettingName, string operationName, Integer id, string query) {

		setRequestHeader();

		API_Operations__mdt opSettings = mm_APIOperationsHelper.getAPIOperation(apiSettingName, operationName);

		request.setMethod(opSettings.HTTP_Method__c);

		String endpoint = apiSetting.Endpoint_Base__c + opSettings.URI__c;

		if (id > 0) {
			endpoint = endpoint + '/' + id.format();
		}

		if (String.isNotEmpty(query)) {
			endpoint = endpoint + '?' + query;
		}

		request.setEndpoint(endpoint);
	}

	private static void setRequestHeader() {
		request.setHeader('Content-Type', 'application/json;charset=UTF-8');
		request.setHeader('Authorization', getAuthFieldValue());
	}

	
	private static String getAuthFieldValue() {
		String value = '';

		if (apiSetting != null) {

			String authField = apiSetting.Auth_Header_Field_Pattern__c;
			authField = authField.replace('{Username__c}', apiSetting.Username__c);
			authField = authField.replace('{Password__c}', apiSetting.Password__c);
			authField = authField.replace('{ApiKey__c}', apiSetting.ApiKey__c);

			value = authField;
		}
		
		return value;
	}

	private static Boolean isValidResponse(HttpResponse response) {
		Boolean isValid = true;

		if (response.getStatusCode() != 200) {
			System.debug('The status code returned was not expected: ' +
				response.getStatusCode() + ' ' + response.getStatus());

			isValid = false;
		} else {
			System.debug(response.getBody());
		}
		
		return isValid;	
	}

	private static String getResponseBody() {
		string body = '';

		HttpResponse response = http.send(request);

		if (isValidResponse(response)) {
			body = response.getBody();
		}

		return body;
	}
	// End - Private Methods
}