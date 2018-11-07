@RestResource(urlMapping='/mm_SpecificEventRestPull/*')
global with sharing class mm_SpecificEventRestPull {
    
    @HttpGet    
    global static List<Event__c> GetEvents() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        //accepts param(s) of:
        // EVID
        //URL example: /services/apexrest/mm_SpecificEventRestPull/?EVID=a0ec0000004bCPbAAM
        
        //string EVID = 'a0ec0000004bCPbAAM';
        
        //get param from URL
        Map<String, String> params = RestContext.request.params;
        
        String EVID = params.get('EVID'); 
        
        //Retrive Specific Event specific fields 
        List<Event__c> EVNT = [Select 
                                     
                                     
                                     Event_Banner__c,
                                     Event_Description__c,
                                     Event_End_Date__c,
                                     Event_Start_Date__c,
                                     Event_Type__c,
                                     Event_Vendor_Account__c,
                                     Event_Vision__c,
                                     Event_Website__c,
                
                                     Id,
                                     Map_to_Venue__c,
                                     Maximum_Registration__c,
                                     Name,
                                     PublicRegistration__c, 
                                     Registered_Attendees__c,
                                     RegistrationEndDate__c,
                                     RegistrationEndTime__c,
                                     T_Shirt_Included__c,
                                     Track__c,
                                     Venue__r.Arrival_Instructions__c,
                                     Venue__r.Name,
                                     Venue__r.Street_Address_1__c, 
                                     Venue__r.Street_Address_2__c,
                                     Venue__r.City__c,
                                     Venue__r.Concierge__c,
                                     Venue__r.Venue_State__c,
                                     Venue__r.Postal_Code_Zip__c,
                                     Venue__r.Venue_Geolocation__Latitude__s,
                                     Venue__r.Venue_Geolocation__Longitude__s,
                                     Venue__r.Venue_Time_Zone__c,
                                     Venue__r.Airport_Name__c,
                                     Venue__r.Airport_Street_Address__c,
                                     Venue__r.Airport_City__c,
                                     Venue__r.Airport_State__c,
                                     Venue__r.Airport_Postal_Code_Zip__c,
                                     Venue__r.Airport_Website__c,
                                     Venue__r.Airport_Geolocation__c,
                                     Venue__r.Airport_Abbreviation__c

                                     from Event__c where Id= :EVID Limit 1];
        
        ////return Event specific fields for all future events 
        return EVNT;
        
    }
}