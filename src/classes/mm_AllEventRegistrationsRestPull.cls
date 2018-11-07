@RestResource(urlMapping='/mm_AllEventRegistrationsRestPull/*')
global with sharing class mm_AllEventRegistrationsRestPull {
    @HttpGet	
    global static List<Event_Registration__c> GetEventRegistrations() {
        
        //test param
        //string LRNTEST = '1234';
        //get param from URL
        Map<String, String> params = RestContext.request.params;
        String LRN = params.get('LRN');
        Double doubLRN = Double.valueOf(LRN);
        
        
        List<Adviser__c> ADV2 = [Select Id from Adviser__c where Id =:LRN];
        
        //incomplete string for adviser not found
        List<String> notfound = New List<String>();
        String notfoundmess = 'No Adviser found for this RepNo';
        notfound.add(notfoundmess);
        List<String> NF = new string[]{'No Adviser found for this RepNo'};
        
         //get date
        String dateString =  date.today().format();
        
        //get adviser matched to Repno
        List <Adviser__c> ADV = [Select Id, Legacy_RepNo__c from Adviser__c where Legacy_RepNo__c=:doubLRN];
        if (ADV == null || ADV.size() < 1)
        {
            //No Adviser found in Salesforce with that legacy REPNO
            ////Need to Handle
            return Null;
        }
        else
        {
            
            //get all Event Registrations for that adviser matching RepNo 
            List<Event_Registration__c> ER = [Select 
                                            
                                              Adviser_Name__c,
                                              Adviser_Status__c,
                                              //Adviser__c,
                                              Reg_Adviser__c,
                                              Attendee_Type__c,
                                              Confirmation_Number__c,
                                              Contact__c,
                                              Event__r.Name,
                                              Id,
                                              Name,
                                              Name_on_Badge__c,
                                              Primary_Contact__c,
                                              Registration_Type__c,
                                              Status__c,
                                              Title_on_Badge__c,
                                              T_Shirt_Size__c
                                              
                                              from Event_Registration__c where Reg_Adviser__c  =:ADV[0].Id AND Event_Start_Date__c >= :date.today() ];
            
   
            //return Event specific fields now in EVIDS 
            return ER;
            

        }
        
        
        
    }
    
}