/**
 * @author Brian K. Broughton (brian.broughton@pinnsg.com)
 * @version 1.0.0
 * @description Interface for the Matson Money Enterprise Services
 *
 *
 **/ 
public interface mm_IEnterpriseServices {
	List<mm_Advisor> getAllAdvisors();
	List<mm_Advisor> getLocalAdvisors(String zipCode, Integer radiusInMiles);
}