global class mm_Schedulable2WeekEmailReminder implements Schedulable
{
    global void execute(SchedulableContext SC) 
    {        
        date todaysDate;
        List <Test_Mode__c> test = [Select Name, System_Test_Date__c ,isTestMode__c From Test_Mode__c limit 1];
        
        if(!test.isEmpty() && test[0].isTestMode__c == True )
        {
            todaysDate = test[0].System_Test_Date__c;
        }
        else
        {
            todaysDate = system.today();
        }          
        date eventDay2Weeks = todaysDate.addDays(14);  
        
        List<Event_Registration__c> regEvent = [Select Id,Contact__c ,Event_Name__c,
                                                Primary_Contact_Id__c,Adviser_Coach_Email__c, 
                                                Event__c , 
                                                Event__r.Email_Reminder_2_Week_Template__c, 
                                                Event__r.Email_Reminder_2_Week_Body__c 
                                                From Event_Registration__c 
                                                where Status__c = 'Registered' 
                                                and Event__r.Event_Start_Date__c = :eventDay2Weeks 
                                                AND Event__r.Event_Status__c <> 'Cancelled'
                                                and Event__r.Course_Name__c <> 'Entrepreneur Foundation Training Session 1'
                                                and Email_Exempt__c <> true];
        
        for(Event_Registration__c R : regEvent)
        {
            List<Send_Email__e> Send1WeekEmails = new List<Send_Email__e>();
            Send1WeekEmails.add(new Send_Email__e(Contact_Id__c = R.Contact__c,
                                                  EmailTemplateName__c = R.Event__r.Email_Reminder_2_Week_Template__c, 
                                                  WhatId__c = R.Id));
            
            List<Database.SaveResult> results = EventBus.publish(Send1WeekEmails);
        }
        
    }
}