trigger mm_UpdateBlankTemplateBodyfields on Event__c  (before insert, before update) {
    for (Event__c obj: trigger.new){
        // Used to populate the Email template body fields on an event with default values
        if (obj.Email_Invite_Body__c == null )
        {
            obj.Email_Invite_Body__c = 'This will show in the body of the Invited Email if merge field is present.' ;
        }
        if (obj.Email_Registered_Body__c == null){
            
            obj.Email_Registered_Body__c = 'This will show in the body of the Registered Email if merge field is present.' ;
        }  
        if (obj.Email_Cancelled_Body__c == null){
            
            obj.Email_Cancelled_Body__c  = 'This will show in the body of the Cancelled Email if merge field is present.' ;
        }
        if (obj.Email_Reminder_1_Week_Body__c == null){
            
            obj.Email_Reminder_1_Week_Body__c  = 'This will show in the body of the 1 week Reminder Email if merge field is present.' ;
        }  
        if (obj.Email_Reminder_2_Week_Body__c == null){
            
            obj.Email_Reminder_2_Week_Body__c  = 'This will show in the body of the 2 week Reminder Email if merge field is present.' ;
        }  
        
    }
    
}