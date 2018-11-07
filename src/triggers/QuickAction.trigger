trigger QuickAction on Adviser__c (before update) {


    for (Adviser__c a : Trigger.new) 
    {
        If(a.Sales_Status__c =='Inventory Scheduled'&& a.Inventory_Date__c == null)
        {
            
      	 
        }
    } 
    
}