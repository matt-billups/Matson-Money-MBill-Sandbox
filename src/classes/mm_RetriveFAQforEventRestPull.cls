@RestResource(urlMapping='/mm_RetriveFAQforEventRestPull/*')
global with sharing class mm_RetriveFAQforEventRestPull {
    
    @HttpGet    
    global static List<FAQ__c> GetFAQs() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //accepts param(s) of:
        // EVID
        //URL example: /services/apexrest/mm_RetriveFAQforEventRestPull/?EVID=a0ec0000004bCPbAAM

        //get param from URL
        Map<String, String> params = RestContext.request.params;
        
        String EVID = params.get('EVID');
        
        //Retrive Event from URL param
        Event__c EVNT = [Select ID, name,Track__c from Event__c where Id= :EVID Limit 1];
        system.debug('***EVNTALLFUT***'+ EVNT.Name);
        Track__c TrackforEvent = [Select ID, Name from Track__c where ID = :EVNT.Track__c limit 1];     
        system.debug('***TrackforEvent***' +TrackforEvent.Name);
        List<FAQ__c> FAQsforEVENT = [Select ID, Track__c, Name, Order__c, Question__c, Answer__c from FAQ__c where Track__c =:TrackforEvent.id order by Order__c ASC ];
        system.debug('***FAQsforEVENT***'+ FAQsforEVENT[0].Name);
        ////return FAQ specific fields for event 
        
        
        return FAQsforEVENT ;
        
    }
}