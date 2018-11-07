@RestResource(urlMapping='/mm_RetriveEventDayforEventRestPull/*')
global with sharing class mm_RetriveEventDayforEventRestPull {
    
    @HttpGet    
    global static List<Event_Days__c> GetEventDays() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //accepts param(s) of:
        // EVID
        //URL example: /services/apexrest/mm_RetriveEventDayforEventRestPull/?EVID=a0ec0000004bCPbAAM
        
        //string EVID = 'a0ec0000004bCPbAAM';
        
        //get param from URL
        Map<String, String> params = RestContext.request.params;
        
        String EVID = params.get('EVID');
        //Retrive Event from URL param
        List<Event__c> EVNTALLFUT = [Select ID, Track__c from Event__c where ID = :EVID Limit 1];
        
        List<Event_Days__c> EvDayforEVENT = [Select ID, Name, Event_Day_Start_Date__c, Event_Day_Start_Time__c, Event_Day_End_Time__c, Adviser_Only__c from Event_Days__c where Matson_Event__c =:EVNTALLFUT[0].id order by Start_Time__c ASC ];
        
        
        return EvDayforEVENT ;
        
    }
}