/**
 * @author Brian K. Broughton (brian.broughton@pinnsg.com)
 * @version 1.0.0
 * @description Mock of mm_APIHelper class.
 *
 *
 **/ 
public class mm_APIHelperMock implements mm_IAPIHelper { 

	String responseBodyText;

	public String getResponseBody(string apiSettingName, string apiOperationName, Integer id, String query) {
		return responseBodyText;
	}

	public void setResponseBody(String responseBody) {
		responseBodyText = responseBody;

		System.debug(responseBodyText);
	}
}