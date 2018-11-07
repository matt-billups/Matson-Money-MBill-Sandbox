trigger mm_SalesStatusSetToReg on Adviser__c (after update) {   
    
    if (mm_CurrentUser.isServiceUser) {
        return;
    } 
    Date isToday = system.today();
    List<Event__c> listOfFutureEFT1Events = [Select Id, Course_Name__c, Event_Start_Date__c,Capacity_Full__c From Event__c 
                                             where Course_Name__c='Entrepreneur Foundation Training Session 1'and Capacity_Full__c < 100 and Event_Start_Date__c > :isToday and Event_Status__c <> 'Cancelled' ORDER BY Event_Start_Date__c NULLS LAST];   
    
    Set<Id> AdviserID = new Set<Id>();
    
    Set<Id> AdviserAttendedID = new Set<Id>();
    
    
    List<Adviser__c> AdviserIds =  new List<Adviser__c>();
    for(Adviser__c a : Trigger.new)
        AdviserIds.add(a);
    Adviser__c a = AdviserIds[0];

        if(isSatusChangedAndSetToRegisteredForEFTSession1(a)&& !listOfFutureEFT1Events.isEmpty())
        {       
            List<Event_Registration__c> listOfRegistrations = [Select id, Status__c, Reg_Adviser__c from Event_Registration__c where Event__c in :listOfFutureEFT1Events and Attendee_Type__c = 'Adviser' and Reg_Adviser__c = :a.Id]; 
            
            if (listOfRegistrations.isEmpty())
            {  
                Event__c E1 = listOfFutureEFT1Events[0];
                Event_Registration__c RE = new Event_Registration__c(Status__c ='Registered', Attendee_Type__c = 'Adviser', Registration_Type__c = 'Paid', Reg_Adviser__c = a.Id, Event__c= E1.Id); 
                insert RE;
                AdviserID.add(RE.Id);
            }
            else 
            {
                setRegistrationToRegisteredIfInvited(listOfRegistrations);
            }     
        }
        else if(isSatusChangedAndSetToEFTSession1Attended(a))
        { 
            
            List<Event_Registration__c> listOfEFT1Registrations = [Select Id, Status__c, Reg_Adviser__c, Event__r.Course_Name__c From Event_Registration__c where 
                                                                   Event__r.Course_Name__c ='Entrepreneur Foundation Training Session 1' and Reg_Adviser__c = :a.Id 
                                                                   and Attendee_Type__c = 'Adviser' and (Status__c ='Registered' or Status__c = 'Attended')];
            
            
            if (listOfEFT1Registrations.isEmpty())
            {  
                a.addError('There is no Entrepreneur Foundation Training Session 1 Registration for ' + a.Name +' that has a status of Registered or Attended, if you found this message in error, please manually add Adviser to event with the desired status.');
                
            }
            else
            {
                setRegistrationToAttendedIfRegistered(listOfEFT1Registrations);
            }                
        }
        else if(isSatusChangedAndSetToRegisteredForEFTSession1(a) && listOfFutureEFT1Events.isEmpty()) {
            
            a.addError('There are no Entrepreneur Foundation Training Session 1 Scheduled');
        }

    public void setRegistrationToRegisteredIfInvited(List<Event_Registration__c> listOfRegistrations){
        
        for(Event_Registration__c r : listOfRegistrations)
        {
            if(r.Reg_Adviser__c == a.id && r.Status__c =='Invited')
            {
                r.Status__c ='Registered';
                update r;
            }
        }
    }
    
    public void setRegistrationToAttendedIfRegistered(List<Event_Registration__c> listOfRegistrations){
        
        for(Event_Registration__c r : listOfRegistrations)
        {
            if(r.Reg_Adviser__c == a.id && r.Status__c =='Registered' )
            {
                r.Status__c ='Attended';
                update r;
            }
        }
    }
    
    public boolean isSatusChangedAndSetToRegisteredForEFTSession1(Adviser__c adviser){
        
        return Trigger.oldMap.get(adviser.Id).Sales_Status__c != Trigger.newMap.get(adviser.Id).Sales_Status__c && adviser.Sales_Status__c =='Registered for EFT Session 1';
    }
    
    public boolean isSatusChangedAndSetToEFTSession1Attended(Adviser__c adviser){
        return Trigger.oldMap.get(adviser.Id).Sales_Status__c != Trigger.newMap.get(adviser.Id).Sales_Status__c && adviser.Sales_Status__c =='EFT Session 1 Attended';
        
    }
    
}