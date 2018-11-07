public class mm_EventClearCacheMicrosite {
    @InvocableMethod(label='Event Callout')
    //@Invocable tag used when calling apex from a Process builder verison, must be list type
    public static List<String> doEventCallout(List<ID> ids) {
        List<String> MatsonEventIds = new List<String>();
        List<Event__c> events = [SELECT Id FROM Event__c WHERE Id in :ids];
        for (Event__c MatsonEvent : events) {
            MatsonEventIds.add(MatsonEvent.Id);
        }
        getEventNames(MatsonEventIds);
        return null;
    }
    @future(callout=true) public static void getEventNames(List<ID> ids) {
        
        
        List<String> MatsonEventIds = new List<String>();
        List<Event__c> events = [SELECT Id FROM Event__c WHERE Id in :ids];
        for (Event__c MatsonEvent : events) {
            MatsonEventIds.add(MatsonEvent.Id);
        }
        for(Id EventId :MatsonEventIds)
        {
            String BaseClearCacheURL = '';
            BaseClearCacheURL = mm_EventClearCacheMicrositeHelper.GetEventRegistrationSiteClearCacheBaseUrl();
            Http mm_http = new Http();
            HttpRequest req = new HttpRequest();
            //req.setEndpoint (BaseClearCacheURL+'/'+EventId );
            //req.setEndpoint (BaseClearCacheURL+'/'+ MatsonEventIds[0]
            req.setEndpoint (BaseClearCacheURL+EventId );
            req.setMethod ('GET');
            
            httpResponse response = mm_http.send(req);
            //@InvocableMethod can only return a list but we do not care about the list just that the req went out.
            
            
        }
        
        
    }
    
    
    
    
}