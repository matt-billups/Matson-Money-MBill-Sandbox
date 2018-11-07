public with sharing class mm_LeadControllerExtension {
	
	private ApexPages.StandardSetController leadController;
	
    public mm_LeadControllerExtension(ApexPages.StandardSetController stdController) {
    	leadController = stdController;	
    }
    
	public ApexPages.StandardSetController LeadQueueCon {
    	get {
    		if(LeadQueueCon == null) {                
    			LeadQueueCon = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Name, Email, State, Phone, LastModifiedDate FROM Lead 
																							 WHERE Owner.Name = 'Investor Outreach Sales Lead Queue' AND (Status != 'Adviser - Current' AND Status != 'Unqualified')
																							 ORDER BY LastModifiedDate DESC]));
                LeadQueueCon.setPageSize(10);
    		}
    		return LeadQueueCon;
    	}
    	
    	set;
    }
    
    public List<Lead> getLeadsInSalesQueue() {
    	return (List<Lead>)LeadQueueCon.getRecords();
    }    

	public List<mm_Advisor> getLocalAdvisors() {
		List<mm_Advisor> advisors = new List<mm_Advisor>();

		Lead lead = (Lead)leadController.getRecord();    

		advisors = mm_ServiceHelper.getEnterpriseServices().getLocalAdvisors(lead.PostalCode, 25);

		return advisors;
	}
}