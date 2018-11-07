@RestResource(urlMapping='/mm_CancelEventRegistration/*')
global with sharing class mm_CancelEventRegistration {
    @HttpGet	
    global static void CancelEventRegistration() {
        Map<String, String> params = RestContext.request.params;
        
        String eventId = params.get('EVID');
        String contactId = params.get('CONID');
        String authToken = params.get('TOKEN');
        
        // Get the event. If null, return because there's nothing to get
        Event__c theEvent = GetEvent(eventId);
        if(theEvent == null) 
        {
            RestContext.response.responseBody = blob.valueOf(JSON.serialize(new Map<string, object> {
                'Success' => false,
                    'Message' => 'This Event could not be found'
                    }));
            return;
        }
        
        //  Make sure the contact is not null either
        Contact theContact = GetContact(contactId);
        if(theContact == null) 
        {
            RestContext.response.responseBody = blob.valueOf(JSON.serialize(new Map<string, object> {
                'Success' => false,
                    'Message' => 'This Contact could not be found'
                    }));
            return;
        }
        
        // Get the primary event registration
        Event_Registration__c parentER = GetPrimaryEventRegistration(eventId, contactId);
        if(parentER == null) 
        {
            RestContext.response.responseBody = blob.valueOf(JSON.serialize(new Map<string, object> {
                'Success' => false,
                    'Message' => 'This Event Registration could not be found'
                    }));
            return;
        }
        
        if (parentER.Status__c == 'Cancelled')
        {
            RestContext.response.responseBody = blob.valueOf(JSON.serialize(new Map<string, object> {
                'Success' => false,
                    'Message' => 'This Event Registration is already cancelled'
                    }));
            return;
        }
        
        Boolean isTokenValid = mm_SettingsHelper.VerifyEventToken(eventId, contactId, authToken);
        
        if(!isTokenValid) 
        {
            RestContext.response.responseBody = blob.valueOf(JSON.serialize(new Map<string, object> {
                'Success' => false,
                    'Message' => 'Token Authorization failed'
                    }));
            return;
        }
        
        // Get the guest event registrations
        List<Event_Registration__c> guestERs = GetGuestEventRegistrations(parentER.Id);
        List<Event_Registration__c> guestsAlreadyCancelled = new List<Event_Registration__c>(); 
        List<Event_Registration__c> registrationsToUpdate = new List<Event_Registration__c>();
        
        parentER.Status__c = 'Cancelled';
        registrationsToUpdate.add(parentER);
        
        for(Event_Registration__c guestER: guestERs) {
            guestER.Status__c = 'Cancelled';
            registrationsToUpdate.add(guestER);
        }
        
        update registrationsToUpdate;
        
        RestContext.response.responseBody = blob.valueOf(JSON.serialize(new Map<string, object> {
            'Success' => true
                }));
    }
    
    private static Event__c GetEvent(string eventId) {
        try {
            return [SELECT Id, PublicRegistration__c FROM Event__c WHERE Id = :eventId LIMIT 1];
        }
        catch(QueryException ex) {
            return null; // Event doesn't exist so return null
        }        
    }
    
    private static Contact GetContact(string contactId) {
        try {
            return [SELECT Id FROM Contact WHERE Id = :contactId LIMIT 1];
        }
        catch(QueryException ex) {
            return null; // Contact doesn't exist so return null
        }
    }
    
    private static Event_Registration__c GetPrimaryEventRegistration(string eventId, string contactId) {
        try {
            return [SELECT Id,
                    Event__c,
                    T_Shirt_Size__c,
                    Contact__r.Id,
                    Contact__r.FirstName,
                    Contact__r.LastName,
                    Contact__r.Email,
                    Status__c,
                    Attendee_Type__c,
                    Parent_Registration__c
                    FROM Event_Registration__c
                    WHERE Contact__c =:contactId
                    AND Event__c = :eventId
                    LIMIT 1];
        }
        catch(QueryException ex) {
            return null; // Event Registration doesn't exist so return null
        }
    }
    
    private static List<Event_Registration__c> GetGuestEventRegistrations(string parentEventRegistrationId) {
        try {
            return [SELECT Id,
                    T_Shirt_Size__c,
                    Contact__r.Id,
                    Contact__r.FirstName,
                    Contact__r.LastName,
                    Contact__r.Email,
                    Status__c
                    FROM Event_Registration__c
                    WHERE Parent_Registration__c = :parentEventRegistrationId];
        }
        catch(QueryException ex) {
            return null;
        }
    }
}