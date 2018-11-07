trigger mm_AdviserPreventSalespathRegresion on Adviser__c (before update) {
    Map<Id,Adviser__c> adviserOldValue = new Map<Id,Adviser__c>();
    Id profileId=userinfo.getProfileId();
    String profileName=[Select Id,Name from Profile where Id=:profileId].Name;    
    adviserOldValue = trigger.oldMap;
    for(Adviser__c adviser: trigger.new)
    {
        if(adviser.Sales_Status__c == 'Inventory Completed' &&
           (adviserOldValue.get(adviser.id).Sales_Status__c != 'Inventory Scheduled' && adviserOldValue.get(adviser.id).Sales_Status__c != 'Inventory Completed') 
           && profileName != 'System Administrator' )
        {
            adviser.addError('Regression within or skipping steps in the the Sales Status Path is not allowed, Please Contact a System Administrator for this edit or Proceed to the Next step in the Path.');
        }
        else if(adviser.Sales_Status__c == 'EFT Session 1 Attended' 
                && (adviserOldValue.get(adviser.id).Sales_Status__c != 'Registered for EFT Session 1' 
                    && adviserOldValue.get(adviser.id).Sales_Status__c != 'EFT Session 1 Attended' )&& profileName != 'System Administrator')
        {

            adviser.addError('Regression within or skipping steps in the the Sales Status Path is not allowed, Please Contact a System Administrator for this edit or Proceed to the Next step in the Path.');
        }
        else if(adviser.Sales_Status__c == 'Contracts Signed' && 
                (adviserOldValue.get(adviser.id).Sales_Status__c != 'EFT Session 1 Attended' 
                 && adviserOldValue.get(adviser.id).Sales_Status__c != 'Contracts Signed') && profileName != 'System Administrator' )
        {
            adviser.addError('Regression within or skipping steps in the the Sales Status Path is not allowed, Please Contact a System Administrator for this edit or Proceed to the Next step in the Path.');
        }
        else if(adviser.Sales_Status__c == 'New' &&
                (adviserOldValue.get(adviser.id).Sales_Status__c == 'Inventory Scheduled' 
                 || adviserOldValue.get(adviser.id).Sales_Status__c == 'Inventory Completed'
                 || adviserOldValue.get(adviser.id).Sales_Status__c == 'Registered for EFT Session 1'
                 || adviserOldValue.get(adviser.id).Sales_Status__c == 'EFT Session 1 Attended'  
                 || adviserOldValue.get(adviser.id).Sales_Status__c == 'Contracts Signed') && profileName != 'System Administrator' )
        {
            adviser.addError('Regression within the the Sales Status Path is not allowed, Please Contact a System Administrator for this edit or Proceed to the Next step in the Path.');
        }
        else if(adviser.Sales_Status__c == 'Inventory Scheduled' && (adviserOldValue.get(adviser.id).Sales_Status__c == 'Inventory Completed' 
                                                                     || adviserOldValue.get(adviser.id).Sales_Status__c == 'Registered for EFT Session 1' 
                                                                     || adviserOldValue.get(adviser.id).Sales_Status__c == 'EFT Session 1 Attended' 
                                                                     || adviserOldValue.get(adviser.id).Sales_Status__c == 'Contracts Signed' ) && profileName != 'System Administrator')
        {
            adviser.addError('Regression within the the Sales Status Path is not allowed, Please Contact a System Administrator for this edit or Proceed to the Next step in the Path.');
        }
   
    }
}