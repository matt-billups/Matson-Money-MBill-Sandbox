/**
 * @author Brian K. Broughton (brian.broughton@pinnsg.com)
 * @version 1.0.0
 * @description Helper class that serves as a Service Factory. The custom metadata type Registered_Interface acts as the 
 * IOC container.
 *
 **/ 
public class mm_ServiceHelper {
	private static mm_IAPIHelper apiHelper;
	private static mm_IEnterpriseServices enterpriseServices;

	static final String IAPIHelperKey = 'IAPIHelper';
	static final String IEnterpriseServicesKey = 'IEnterpriseServices';
    
    @TestVisible
    private static void setAPIHelper(mm_IAPIHelper helper) {
   		apiHelper = helper;
    }

	 @TestVisible
    private static void setEnterpriseServices(mm_IEnterpriseServices entService) {
   		enterpriseServices = entService;
    }
    
	/**
	 * @description Gets new instance of mm_IAPIHelper
	 * @param None
	 * @return mm_IAPIHelper Returns new instance of mm_IAPIHelper
	 **/ 
    public static mm_IAPIHelper getAPIHelper() {
        return apiHelper != null ? apiHelper : (mm_IAPIHelper)Type.forName(mm_RegisteredInterfacesHelper.getTypeName(IAPIHelperKey)).newInstance();
    }

	/**
	 * @description Gets new instance of mm_IEnterpriseServices
	 * @param None
	 * @return mm_IEnterpriseServices Returns new instance of mm_IEnterpriseServices
	 **/ 
    public static mm_IEnterpriseServices getEnterpriseServices() {
        return enterpriseServices != null ? enterpriseServices : (mm_IEnterpriseServices)Type.forName(mm_RegisteredInterfacesHelper.getTypeName(IEnterpriseServicesKey)).newInstance();
    }
}