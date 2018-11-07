@RestResource(urlMapping='/mm_UpdateEventRegistrationRest/*')
global with sharing class mm_UpdateEventRegistrationRest {
    
    @HttpGet	
    global static List<Event_Registration__c> GetEventRegistrations() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //accepts params of ERID and TS
        //URL example: /services/apexrest/mm_UpdateEventRegistrationRest/?ERID=a0dc000000DN61zAAD&TS=XL
        //will set ER record to registered with T-Shirt size of XL
        //string ERID = 'a0dc000000DN61zAAD';
        //get param from URL
        Map<String, String> params = RestContext.request.params;
        
        String ERID = params.get('ERID');
        String TS = params.get('TS');

        Event_Registration__c EvReg = null;
        List<Event_Registration__c> EvRegs = [SELECT Id, Status__c, T_Shirt_Size__c  from Event_Registration__c where Id =:ERID Limit 1 ];
        //check returned EventRegistration record, if Status is not already registered, set to registered.
        //system.debug('wwwwwww'+ EvRegs[0].Status__c);
        if(!EvRegs.isEmpty())
        {
            EvReg = EvRegs[0];
            If (EvReg.Status__c != 'Registered')
            {
                EvReg.Status__c =  'Registered';
  
            }
            If(EvReg.T_Shirt_Size__c != TS && TS != NULL)
            {
                EvReg.T_Shirt_Size__c = TS;   
            }
            
            try
            {
                Update EvReg;
            }
            
            catch(DmlException e) 
            {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
                
            }
            
        }
        List<Event_Registration__c> UpdatedEvReg = [SELECT Id, Status__c, T_Shirt_Size__c from Event_Registration__c where Id =:ERID Limit 1 ];
        ///system.debug('wvvvvv'+ UpdatedEvReg[0].Status__c);
        return UpdatedEvReg;  
    }
    
    
}