trigger mm_AdviserPreventInventoryCompletedStatus on Adviser__c (before insert, before update) {
    List<String> ADVRS = new List<String>{};
        
        //Look for all Contacts with Null address fields
        string qry = 'Select Id From Contact Where MailingStreet = NULL OR MailingCity = NULL OR MailingState = NULL OR MailingPostalCode = NULL';
    //create list and get results
    List<SObject> results = Database.query(qry);
    //Map Sobject results in list from query to Ids
    Set<Id> resultIds = (new Map<Id,SObject>(results)).keySet();
    
    
    
    RecordType adviserProspectRecordType = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser Prospect' and SobjectType='Adviser__c'];
    //Loop through all records in the Trigger.new collection
    for(Adviser__c adviser: Trigger.new){
        
        
        
        if(  isSalesStatus('Inventory Scheduled', adviser) && !isInventoryDateNull(adviser) && isAdviserProspectAndSalesStatusChangedOrNew(adviser) && isAdviserMailingAddressPresent(adviser))
        {     
            adviser.addError('Please enter a Mailing Address in the Primary Contact Details area.'); 
        } 
        
        else if(isSalesStatus('Inventory Scheduled', adviser) && isInventoryDateNull(adviser) && isAdviserProspectAndSalesStatusChangedOrNew(adviser))
        {
            adviser.addError('Please enter an Inventory Date');
        }
        
        else if(isSalesStatus('Inventory Completed', adviser) && isAdviserProspectAndSalesStatusChangedOrNew(adviser) && isInventoryNotCompleted(adviser))
        {     
            inventoryNotCompletedErrorMessage('Inventory Completed',  adviser);  
        }
        
        else if(isSalesStatus('Registered for EFT Session 1', adviser) && isAdviserProspectAndSalesStatusChangedOrNew(adviser) && isInventoryNotCompleted(adviser))
        {
            inventoryNotCompletedErrorMessage('Registered for EFT Session 1',  adviser);
        }
        
        else if(isSalesStatus( 'EFT Session 1 Attended', adviser) && isAdviserProspectAndSalesStatusChangedOrNew(adviser) && isInventoryNotCompleted(adviser) )
        {
             inventoryNotCompletedErrorMessage('EFT Session 1 Attended',  adviser);
        }
        
        else if(isSalesStatus('Contracts Signed', adviser) && isAdviserProspectAndSalesStatusChangedOrNew(adviser) && isInventoryNotCompleted(adviser))
        {
          inventoryNotCompletedErrorMessage('Contracts Signed',  adviser);
        }
        
    } 
    
    public boolean isAdviserProspectAndSalesStatusChangedOrNew(Adviser__c adviser){
        
        return  adviser.RecordTypeId == adviserProspectRecordType.Id && (Trigger.oldMap == null || Trigger.oldMap.get(adviser.Id).Sales_Status__c != Trigger.newMap.get(adviser.Id).Sales_Status__c);
    }    
    
    public boolean isInventoryNotCompleted(Adviser__c adviser){
        
        return String.isBlank(adviser.X3_Biggest_Money_Problems__c) || adviser.X3_Biggest_Money_Problems__c == NUll || adviser.Pain_Money_Total__c == NULL ;        
    }
    
    public boolean isInventoryDateNull(Adviser__c adviser){
        
        return adviser.Inventory_Date__c == NULL;        
    }
    public boolean isAdviserMailingAddressPresent(Adviser__c adviser){
        
        return resultIds.contains(adviser.Primary_Contact__c);
    }
    
    public boolean isSalesStatus(string salesStatus , Adviser__c adviser){
        
        return adviser.Sales_Status__c == salesStatus;
    }
    public void inventoryNotCompletedErrorMessage(string salesStatus, Adviser__c adviser){
        
        string errorMessage= 'Please fill out BOTH the "3 Biggest Money Problems" and "Pain Money Total" fields before progressing this Adviser to ';
        string endingErrorMessage = '. These fields are located in the "Key Fields" and in the "Inventory Information" sections of the Adviser Prospect Record.' ;  
        adviser.addError(errorMessage + salesStatus + endingErrorMessage);
        
    }
    
}