public class mm_EventClearCacheMicrositeHelper {
  
    // should return  as url https://mmeventregistration-stage.azurewebsites.net/MatsonEvent/ClearCache/ in staging
    // and
    // url https://event.matsonmoney.com/MatsonEvent/ClearCache/ in prod
    public static String GetEventRegistrationSiteClearCacheBaseUrl() {
        
        String url = '';
        External_Endpoints__c externalEndPoints = External_Endpoints__c.getInstance();
        
        if(externalEndPoints != null){ 
            url = externalEndPoints.Event_Clear_Cache__c;
        }
      
        return url;        
    }
     
}