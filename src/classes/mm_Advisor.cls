/**
 * @author Brian K. Broughton (brian.broughton@pinnsg.com)
 * @version 1.0.0
 * @description Class to represent an Advisor. This will be used when
 * making a call to Enterprise Services to retreive advisors.
 *
 **/ 
public class mm_Advisor {

	public mm_Advisor() {
	}

	public string firstName { get; set; }
	public string lastName { get; set; }
	public string company { get; set; }
	public string address1 { get; set; }
	public string address2 { get; set; }
	public string city { get; set; }
	public string state { get; set; }
	public string zipcode { get; set; }
	public string phone { get; set; }
	public string email { get; set; }
	public string repNo { get; set; }
	public String distance { get; set; }
}