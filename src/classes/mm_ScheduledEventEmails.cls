global class mm_ScheduledEventEmails implements Schedulable {
    global void execute(SchedulableContext SC) {
           	mm_Schedulable2WeekEmailReminder weeksBefore =new mm_Schedulable2WeekEmailReminder();
			weeksBefore.execute(null) ; 
        
            mm_Schedulable1WeekEmailReminder daysbefore = new mm_Schedulable1WeekEmailReminder();
			daysbefore.execute(null) ;     
        
       		mm_ScheduledEmailEFT1 eft1Emails = new mm_ScheduledEmailEFT1();
			eft1Emails.EFT1EmailsmorningSechudled();    
        
    } 
}