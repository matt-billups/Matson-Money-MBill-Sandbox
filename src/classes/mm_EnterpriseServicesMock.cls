/**
 * @author Brian K. Broughton (brian.broughton@pinnsg.com)
 * @version 1.0.0
 * @description Mock of mm_EnterpriseServices
 *
 *
 **/ 
 @isTest
public class mm_EnterpriseServicesMock implements mm_IEnterpriseServices { 

	private List<mm_Advisor> advisors = new List<mm_Advisor>();

	public List<mm_Advisor> getAllAdvisors() {
		return advisors;
	}

	public List<mm_Advisor> getLocalAdvisors(String zipCode, Integer radiusInMiles) {
		return advisors;
	}

	public void setAdvisors(List<mm_Advisor> adv) {
		advisors = adv;
	}
}