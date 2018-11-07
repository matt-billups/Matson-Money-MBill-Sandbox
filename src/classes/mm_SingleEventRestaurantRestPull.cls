@RestResource(urlMapping='/mm_SingleEventRestaurantRestPull/*')
global with sharing class mm_SingleEventRestaurantRestPull {
    @HttpGet	
    global static List<Restaurant__c> GetEventRestaurants() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //accepts param(s) of:
        // EVID
        //URL example: /services/apexrest/mm_SingleEventRestaurantRestPull/?EVID=a0ec0000004b1dSAAQ
        
        //get param from URL
        Map<String, String> params = RestContext.request.params;
        
        String EVID = params.get('EVID');
        
        
        //Retrive All Event Hotel data for Event ID pased in URL parameter - 
        List<Event__c> EVNTALLFUT = [Select ID, Venue__c from Event__c where ID = :EVID Limit 1];
        List<Restaurant__c> EVREST = [Select 
                                      Id,
                                      Name,
                                      Street_Address__c,
                                      City__c,
                                      State__c,
                                      Postal_Code_Zip__c,
                                      Restaurant_Geolocation__Latitude__s,
                                      Restaurant_Geolocation__Longitude__s 
                                      
                                      from Restaurant__c where Venue__c = :EVNTALLFUT[0].Venue__c];
        
        ////return Restaurant specific fields for specified event
        return EVREST;
        
    }
}