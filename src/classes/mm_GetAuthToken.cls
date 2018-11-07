@RestResource(urlMapping='/mm_GetAuthToken/*')
global with sharing class mm_GetAuthToken {
    @HttpGet	
    global static String GetAuthToken() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //accepts param(s) of:
        //EVID - Event__c Salesforce ID
        //CONID - Contact Salesforce ID
        
        //URL example: /services/apexrest/mm_GetAuthToken/?EVID=a0ec0000004bCPbAAM&CONID=003c000000paku4AAA
        
        //get param(s) from URL
        Map<String, String> params = RestContext.request.params;
        String EVID = params.get('EVID');
        String CONID = params.get('CONID');

        String TOKEN = '';
        String NOTOKENAVAILABLE = 'NO TOKEN IS AVAILABLE, EITHER THE CONTACT OR EVENT ID IS INVALID.';
        String ValueToHash = '';
        String Encrypted = '';
        if(!string.isBlank(CONID) &&!string.isBlank(EVID) )
        {
            ValueToHash =   String.valueOf(CONID)+String.valueOf(EVID);
            Encrypted = mm_SettingsHelper.CreateEventToken(ValueToHash);
            
            TOKEN = Encrypted;
            
            return TOKEN;
            
        }
        else
        {
            return NOTOKENAVAILABLE;
        }
    }
    
}