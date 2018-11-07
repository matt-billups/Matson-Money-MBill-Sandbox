@RestResource(urlMapping='/mm_AllFutureEventRestPull/*')
global with sharing class mm_AllFutureEventRestPull {
    
    @HttpGet    
    global static List<Event__c> GetEvents() {
        
        
        //Retrive All Future Event specific fields - whether Adviser has a registration for the event or not
        List<Event__c> EVNTALLFUT = [Select 
                                     Capacity_Full__c,
                                     Course_Name__c,
                                     Event_Description__c,
                                     Event_End_Date__c,
                                     Event_Evaluation__c,
                                     Event_Manager__c,
                                     Event_Start_Date__c,
                                     Event_Type__c,
                                     Event_Vendor_Account__c,
                                     Event_Vision__c,

                                     Id,
                                     Invited_Attendees__c,
                                     Map_to_Venue__c,
                                     Maximum_Registration__c,
                                     Name,
                                     Event_Banner__c,
                                     Registered_Attendees__c,
                                     T_Shirt_Included__c,
                                     Track__r.Name,
                                     Track__r.Key_Takeaways__c,
                                     Track__r.Publish_to_Web__c,
                                     Track__r.Track_Category__c,
                                     Track__r.Track_Description__c,
                                     Track__r.Track_Status__c,
                                     Track__r.Track_Website__c,
                                     
                                     Venue_City__c,
                                     Venue_Country__c,
                                     Venue_Postal_Code__c,
                                     Venue_State__c,
                                     Venue_Status__c,
                                     Venue_Street_Address_1__c,
                                     Venue_Street_Address_2__c,
                                     Venue__r.Name,
                                     Venue__r.Street_Address_1__c, 
                                     Venue__r.Street_Address_2__c,
                                     Venue__r.City__c,
                                     Venue__r.Concierge__c,
                                     Venue__r.Venue_State__c,
                                     Venue__r.Postal_Code_Zip__c,
                                     
                                     Venue__r.Airport_Name__c,
                                     Venue__r.Airport_Street_Address__c,
                                     Venue__r.Airport_City__c,
                                     Venue__r.Airport_State__c,
                                     Venue__r.Airport_Postal_Code_Zip__c,
                                     Venue__r.Airport_Website__c,
                                     Venue__r.Airport_Geolocation__c,
                                     Venue__r.Airport_Abbreviation__c
                                     
                                     
                                     from Event__c where Event_Start_Date__c >= :System.Today()];
        
        ////return Event specific fields for all future events 
        return EVNTALLFUT;
        
    }
}