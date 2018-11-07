@RestResource(urlMapping='/mm_SingleEventHotelRestPull/*')
global with sharing class mm_SingleEventHotelRestPull {
    
    @HttpGet	
    global static List<Event_Hotel__c> GetEventHotels() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //accepts param(s) of:
        // EVID
        //URL example: /services/apexrest/mm_SingleEventHotelRestPull/?EVID=a0ec0000004b1dSAAQ
        //will set ER record to registered with T-Shirt size of XL
        //string EVID = 'a0ec0000004b1dSAAQ';
        
        //get param from URL
        Map<String, String> params = RestContext.request.params;
        
        String EVID = params.get('EVID');
        
        
        //Retrive All Event Hotel data for Event ID pased in URL parameter - 
        
        List<Event_Hotel__c> EVHTL = [Select Id,
                                      Name, 
                                      Matson_Event__c, 
                                      Hotel__c,
                                      Hotel__r.Name,
                                      Hotel__r.Address__c,
                                      Hotel__r.City__c,
                                      Hotel__r.Description__c,
                                      Hotel__r.Hotel_Phone_Number__c,
                                      Hotel__r.Postal_Code_Zip__c,
                                      Hotel__r.State__c,
                                      Hotel__r.Web_Address__c,
                                      Hotel__r.Hotel_Geolocation__Latitude__s,
                                      Hotel__r.Hotel_Geolocation__Longitude__s,
                                      Discount_Code__c
                                      
                                      
                                      from Event_Hotel__c where Matson_Event__c = :EVID];
   
        
        
        ////return Hotel specific fields for specified event
        return EVHTL;
        
    }
}