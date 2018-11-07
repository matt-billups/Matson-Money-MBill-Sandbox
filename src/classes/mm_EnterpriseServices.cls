/**
 * @author Brian K. Broughton (brian.broughton@pinnsg.com)
 * @version 1.0.0
 * @description Wrapper for Matson Money Enterprise Services
 *
 *
 **/ 
public class mm_EnterpriseServices implements mm_IEnterpriseServices {

	// Private Variables
	private static final String API_SETTINGS_NAME = 'Enterprise_Services';
	private static final String GET_ALL_ADVISORS_OP_NAME = 'Get_All_Advisors';
	private static final String GET_LOCAL_ADVISORS_OP_NAME = 'Get_Local_Advisors';
	private static final mm_IAPIHelper apiHelper =  mm_ServiceHelper.getAPIHelper();
	// End - Private Variables

	// Public Methods

	/**
	 * @description Get all Advisors - no filtering.
	 * @param None
	 * @return List<Advisor> List of all Advisors returned from the service call.
	 **/ 
	public static List<mm_Advisor> getAllAdvisors() {
		
		List<mm_Advisor> advisors = new List<mm_Advisor>();

		string response = apiHelper.getResponseBody(API_SETTINGS_NAME, GET_ALL_ADVISORS_OP_NAME, 0, '');

		if (String.isNotBlank(response)) {
			advisors = (List<mm_Advisor>) JSON.deserialize(response, List<mm_Advisor>.class);
		}
			
		return advisors;
	}

	/**
	 * @description Get all Advisors - no filtering.
	 * @param None
	 * @return List<Advisor> List of all Advisors returned from the service call.
	 **/ 
	public static List<mm_Advisor> getLocalAdvisors(String zipCode, Integer radiusInMiles) {
		
		List<mm_Advisor> advisors = new List<mm_Advisor>();
		String queryString = 'zipcode=' + zipCode;

		string response = apiHelper.getResponseBody(API_SETTINGS_NAME, GET_LOCAL_ADVISORS_OP_NAME, 0, queryString);

		if (String.isNotBlank(response)) {
			advisors = (List<mm_Advisor>) JSON.deserialize(response, List<mm_Advisor>.class);
		}
			
		return advisors;
	}

	// End - Public Methods
 }