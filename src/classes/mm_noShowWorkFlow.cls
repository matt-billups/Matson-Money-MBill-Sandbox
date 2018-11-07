global class mm_noShowWorkFlow implements Schedulable
{
    global void execute(SchedulableContext SC) 
    {
        Date yesterdaysDate = system.today().addDays(-1); 
        List<Event__c> Event =[select Id , Event_End_Date__c from Event__c where Event_End_Date__c = :yesterdaysDate or (Event_End_Date__c =NULL and Event_Start_Date__c = :yesterdaysDate)];
		if(!Event.isEmpty())
        {
            for(Event__c e : Event)
            {
                List<Event_Registration__c> eventRegistration = [Select Id, Status__c from Event_Registration__c where Status__c ='Registered' and Event__c = :e.Id];
                if(!eventRegistration.isEmpty())
                {
                    for(Event_Registration__c ER : eventRegistration )
                    {
                        ER.Status__c = 'No Show';
                        Update ER;
                    }
                }
            }
        }
    }
}