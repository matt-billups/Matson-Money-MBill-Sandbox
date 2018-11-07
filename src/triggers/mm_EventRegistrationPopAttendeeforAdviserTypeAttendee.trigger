trigger mm_EventRegistrationPopAttendeeforAdviserTypeAttendee on Event_Registration__c(before insert, before update) {

    List<String> EVREGNames = new List<String>{};
 
   //Loop through all records in the Trigger.new collection
   for(Event_Registration__c ER: Trigger.new){
     if(ER.Attendee_Type__c == 'Adviser' && (ER.Contact__c != null && ER.Contact__c != ER.Primary_Contact_Id__c) )
    {
        ER.addError('Attendee Contacts cannot be added to records with an Attendee Type of Adviser. Please change the Attendee Type or remove the Attendee and create another Registration for this person if desired.');
        
    }
     else {
       ER.Contact__c = ER.Primary_Contact_Id__c;    
     }
   }
   


}