global class mm_ScheduledEmailEFT1 
{
    List<Event_Registration__c> listOfRegistrations = new List<Event_Registration__c>();
    List<Trigger_EFT_Session_1_Activities_Event__e> listOfEFTTriggerEvents = new List<Trigger_EFT_Session_1_Activities_Event__e>();
    
    //Methods that can excute this code    
    public void eft1EmailsmorningSechudled()
    {  
        date todaysDate = getTodaysDate();    
        listOfRegistrations = getEventRegistrations(todaysDate);
        
        for(Event_Registration__c registration : listOfRegistrations)
        {
            addEFTTriggerEventToPublishList(registration, todaysDate);
        }  
        
        if(listOfEFTTriggerEvents.size() > 0)
        {
           List<Database.SaveResult> results = EventBus.publish(listOfEFTTriggerEvents);
        }
    }   
    
    public date getTodaysDate()
    {
        date todaysDate;
        list <Test_Mode__c> test = [Select Name, System_Test_Date__c ,isTestMode__c From Test_Mode__c limit 1]; 
        
        if(!test.isEmpty() && test[0].isTestMode__c == True )
        {
            todaysDate = test[0].System_Test_Date__c;
        }
        else
        {
            todaysDate = system.today();
        }
        return todaysDate;
    } 
    
    public List<Event_Registration__c> getEventRegistrations(date todaysDate)
    {
        string eft1 = 'Entrepreneur Foundation Training Session 1';
        List<Event_Registration__c> regEvent =[Select Id, Event_Start_Date__c From Event_Registration__c 
                                               where Status__c ='Registered'and Event__c in (
                                                   Select Id From Event__c where Course_Name__c= :eft1 
                                                   and Event_Start_Date__c > :todaysDate and Event_Status__c != 'Cancelled'
                                               )] ;    
        return regEvent;      
    }
       
    public void addEFTTriggerEventToPublishList(Event_Registration__c registration, date todaysDate)
    {        
        if(isEvent49DaysAway(todaysDate, registration.Event_Start_Date__c))
        {
           listOfEFTTriggerEvents.add(new Trigger_EFT_Session_1_Activities_Event__e(Event_Registration_ID__c = registration.Id));    
        }        
    }  
    private boolean isEvent49DaysAway(Date todaysDate , Date eventStartDate){
      
        integer daysUntillEvent = todaysDate.daysBetween(eventStartDate);
        return daysUntillEvent <= 49;
    }
}