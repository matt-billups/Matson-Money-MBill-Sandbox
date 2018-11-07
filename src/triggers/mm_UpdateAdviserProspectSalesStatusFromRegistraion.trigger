trigger mm_UpdateAdviserProspectSalesStatusFromRegistraion on Event_Registration__c (after update, after insert) {   
    
    List<Id> regAdviserIdList = new List<Id>();
    for(Event_Registration__c reg : Trigger.New){
        regAdviserIdList.add(reg.Reg_Adviser__c);
    }
     Map<Id, Adviser__c> myMap = new Map<Id, Adviser__c>([SELECT Id, 
                                                         Primary_Contact__c, 
                                                         Sales_Status__c, 
                                                         Inventory_Date__c, 
                                                         X3_Biggest_Money_Problems__c, 
                                                         Pain_Money_Total__c, 
                                                         Primary_Contact__r.MailingStreet, 
                                                         Primary_Contact__r.MailingCity, 
                                                         Primary_Contact__r.MailingState, 
                                                         Primary_Contact__r.MailingPostalCode,
                                                         RecordType.Name
                                                         FROM Adviser__c WHERE Id IN : regAdviserIdList]);
    List<Id> adviserIdList = new List<Id>();
    
    for(Event_Registration__c ER : Trigger.new){
        
        if(isStatusChangedOrRecordNew(ER) && ER.Event_Course_Name__c == 'Entrepreneur Foundation Training Session 1' && ER.Attendee_Type__c == 'Adviser' && ER.Reg_Adviser__c != NULL){
            
            Adviser__c adv = myMap.get(ER.Reg_Adviser__c);
            system.debug(ER.Attendee_First_Name__c + ' isStatusChangedOrRecordNew ' + isStatusChangedOrRecordNew(ER) +' Status is ' + ER.Status__c);
            
            if(isRecordTypeNameAdviserProspect(adv) && ER.Status__c =='Registered' && isAdviserReadyForEFTSession1(adv)){
                
                adv.Sales_Status__c = 'Registered for EFT Session 1';
                update adv;
            }
            else if (isRecordTypeNameAdviserProspect(adv) && ER.Status__c =='Registered' && !isAdviserReadyForEFTSession1(adv)){
                
                ER.addError('Please verify that you have filled out the Inventory Date, 3 Biggest Money Problems, and Pain Money Total fields on the Adviser record and the Mailing Address on the Contact record before registering the adviser for this event.');
            }                  
            else if(isRecordTypeNameAdviserProspect(adv) && ER.Status__c =='Attended' && !isAdviserReadyForEFTSession1(adv)){
                
                ER.addError('Please verify that you have filled out the Inventory Date, 3 Biggest Money Problems, and Pain Money Total fields on the Adviser record and the Mailing Address on the Contact record before registering the adviser for this event.');
            }
            else if(isRecordTypeNameAdviserProspect(adv) && ER.Status__c =='Attended' && isAdviserReadyForEFTSession1(adv) && isSalesStatusSetToRegistered(adv) && isTriggerOldStatusRegistered(ER) ){
                adv.Sales_Status__c = 'EFT Session 1 Attended';
                update adv;
            }
            else if(isRecordTypeNameAdviserProspect(adv) && isRecordTypeNameAdviserProspect(adv) && ER.Status__c =='Attended' && isAdviserReadyForEFTSession1(adv) && !isTriggerOldStatusRegistered(ER)){
                ER.addError('The Status must be set to Registered for an Entrepreneur Foundation Training Session 1 event before moving to the Status of Attended.');
            }
        }
    }
    update myMap.values();
    
    public boolean isAdviserReadyForEFTSession1(Adviser__c adviser)
    {
        if(adviser.Inventory_Date__c == NULL || adviser.X3_Biggest_Money_Problems__c == NULL 
           || adviser.Pain_Money_Total__c == NULL || adviser.Primary_Contact__r.MailingStreet == NULL 
           || adviser.Primary_Contact__r.MailingCity == NULL || adviser.Primary_Contact__r.MailingState == NULL ||
           adviser.Primary_Contact__r.MailingPostalCode == NULL){
               return false;
           }
        else{
            return true;
        }
    }
    
    public boolean isSalesStatusSetToRegistered(Adviser__c adviser){
        
        return adviser.Sales_Status__c == 'Registered for EFT Session 1';
    }  
    
    public boolean isTriggerOldStatusRegistered(Event_Registration__c registration){
        
        return Trigger.oldMap != null && Trigger.oldMap.get(registration.Id).Status__c== 'Registered';
    }
    
    public boolean isStatusChangedOrRecordNew(Event_Registration__c registration){
        
        return Trigger.oldMap == null ||Trigger.oldMap.get(registration.Id).Status__c != Trigger.newMap.get(registration.Id).Status__c;
    }
    
    public boolean isRecordTypeNameAdviserProspect(Adviser__c adviser){
        
        return adviser.RecordType.Name == 'Adviser Prospect';
    }
}