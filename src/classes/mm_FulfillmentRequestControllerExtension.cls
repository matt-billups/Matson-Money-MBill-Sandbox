public with sharing  class mm_FulfillmentRequestControllerExtension {
    
	private ApexPages.StandardSetController fulfillmentRequestController;
    
    public mm_FulfillmentRequestControllerExtension(ApexPages.StandardSetController setController) {
        fulfillmentRequestController = setController;
    }
    
	public ApexPages.StandardSetController NotShippedCon {
    	get {
    		if(NotShippedCon == null) {                
    			NotShippedCon = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Ship_To_Name__c, Ship_By__c, Shipped_On__c 
																								FROM Fulfillment_Request__c 
																								WHERE Shipped_On__c = null And (Status__c = 'Active' OR Status__c = '')
																								ORDER BY Ship_By__c DESC]));
                NotShippedCon.setPageSize(10);
    		}
    		return NotShippedCon;
    	}
    	
    	set;
    }
    
    public List<Fulfillment_Request__c> getRequestsNotShipped() {
    	return (List<Fulfillment_Request__c>)NotShippedCon.getRecords();
    }        
}