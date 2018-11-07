/**
 * @author Brian K. Broughton (brian.broughton@pinnsg.com)
 * @version 1.0.0
 * @description Interface class for API helper.
 *
 *
 **/ 
public interface mm_IAPIHelper {
	string getResponseBody(string apiSettingName, string apiOperationName, Integer id, String query);
}