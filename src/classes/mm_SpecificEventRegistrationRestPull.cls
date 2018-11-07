@RestResource(urlMapping='/mm_SpecificEventRegistrationRestPull/*')
global with sharing class mm_SpecificEventRegistrationRestPull {
    @HttpGet	
    global static List<Event_Registration__c> GetEventRegistrations() {
        
        
        // Example URL: /services/apexrest/mm_SpecificEventRegistrationRestPull/?CONID=003c000000paVD3AAM&EVID=a0ec0000004bCPbAAM
        // Accepts PARAMS:
        // CONID = STRING SF CONTACT ID
        // EVID = STRING SF EVENT__c ID
        //get param from URL
        Map<String, String> params = RestContext.request.params;
        
        String EVNTID = params.get('EVID');
        String CONID = params.get('CONID');
        
        List<Event__c> EVNT = [Select Id from Event__c where Id =:EVNTID];
        
        //incomplete string for contact not found
        List<String> notfoundcon = New List<String>();
        String notfoundmesscon = 'No Contact found for this Id';
        notfoundcon.add(notfoundmesscon);
        List<String> NFC = new string[]{'No Contact found for this ContactID'};
            
            //get contact matched to Id
            List <Contact> CON = [Select Id from Contact where Id=:CONID];
        if (CON == null || CON.size() < 1)
        {
            //No Contact found in Salesforce with that ID
            return Null;
        }
        else
        {
            
            //get all Event Registrations for that contact/event 
            List<Event_Registration__c> ER = [Select 
                                              
                                              Adviser_Name__c,
                                              Adviser_Status__c,
                                              //Adviser__c,
                                              Reg_Adviser__c, 
                                              Parent_Registration__c,
                                              Attendee_Type__c,
                                              Contact__c,
                                              Contact__r.Firstname,
                                              Contact__r.Lastname,
                                              Contact__r.Email,                                             
                                              Event__r.Name,
                                              Id,
                                              Name,
                                              Name_on_Badge__c,
                                              Primary_Contact__c,
                                              Registration_Type__c,
                                              Status__c,
                                              Title_on_Badge__c,
                                              T_Shirt_Size__c,
                                              Dietary_Needs__c
                                              
                                              from Event_Registration__c where Contact__c =:CON[0].Id AND Event__c =:EVNT[0].id];
            
            if( ER.isEmpty())
            {
                //No Event Registraions Found for this Event/Contact
                Return Null;
                
            }
            else
            {
                //get all Event Registrations where  Parent Registration is that of the above registraion
                List<Event_Registration__c> GuestER = [Select 
                                                       
                                                       Adviser_Name__c,
                                                       Adviser_Status__c,
                                                       //Adviser__c,
                                                       Reg_Adviser__c, 
                                                       Parent_Registration__c,
                                                       Attendee_Type__c,
                                                       Contact__c,
                                                       Contact__r.Firstname,
                                                       Contact__r.Lastname,
                                                       Contact__r.Email,
                                                       Event__r.Name,
                                                       Id,
                                                       Name,
                                                       Name_on_Badge__c,
                                                       Primary_Contact__c,
                                                       Registration_Type__c,
                                                       Status__c,
                                                       Title_on_Badge__c,
                                                       T_Shirt_Size__c,
                                                       Dietary_Needs__c
                                                       
                                                       from Event_Registration__c where Parent_Registration__c =:ER[0].Id];
                
                
                if (!GuestER.isEmpty())
                {
                    ER.addAll(GuestER);
                }
                
                //return Event specific fields now in EVIDS 
                return ER;
                
            }
            
        }
        
    }
    
}