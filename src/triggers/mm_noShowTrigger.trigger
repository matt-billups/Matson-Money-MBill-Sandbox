trigger mm_noShowTrigger on Event_Registration__c (After Update) 
{   List<Task> taskList = new List<Task>();
 for(Event_Registration__c ER : Trigger.new)
     if(ER.Status__c =='No Show' && ER.Attendee_Type__c == 'Adviser')
 {
     Task T = New Task();
     T.Priority = 'Normal';
     T.Subject =ER.Attendee_Name__c +' did not show up to ' + ER.Event_Name__c;
     T.Status = 'Open';
     T.WhatId = ER.Reg_Adviser__c;
     T.WhoId = ER.Contact__c;
     T.OwnerID = Er.Adviser_Coach_Id__c;
     T.Description = 'Missed Event - Follow up/Reschedule';
     if(ER.Event_End_Date__c == NULL)
     {
         T.ActivityDate = System.Today().addDays(5);
     }
     else
     {
         T.ActivityDate = ER.Event_End_Date__c.addDays(5);
     }
     T.IsReminderSet = True;
     T.ReminderDateTime = System.now().addDays(3);
     
     taskList.add(T);
     
 }
 insert taskList;
}