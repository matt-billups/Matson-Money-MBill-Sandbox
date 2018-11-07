@RestResource(urlMapping='/mm_GetEventsAndRegistrationsByContact/*')
global with sharing class mm_GetEventsAndRegistrationsByContact {
    
    @HttpGet
    global static void GetEventsAndRegistrations() {
        Map<string, string> params = RestContext.request.params;
        
        string listedContacts = params.get('ContactIds');
        List<string> contactIds = listedContacts.replace(' ', '').split(',');
                
        // Distinct the ContactIDs in case the same one came over twice+
        Set<string> contactIdSet = new Set<string>();
        contactIdSet.addAll(contactIds);
        contactIds.clear();
        contactIds.addAll(contactIdSet);
                
        DateTime now = DateTime.Now();
        Date nowDate = Date.newInstance(now.year(), now.month(), now.day());
                
        // Get the Events
        List<Event__c> events;
        
        try {
            events = [SELECT Id,
                             Name,
                             Event_End_Date__c,
                             Event_Start_Date__c,
                             RegistrationEndDate__c,
                             RegistrationEndTime__c
                        FROM Event__c
                       WHERE ShowOnWebsite__c = TRUE
                         AND Event_Start_Date__c >= :nowDate
                         AND RegistrationEndDate__c >= :nowDate
                       ORDER BY Event_Start_Date__c];
        }
        catch(QueryException ex) {
            // No events available
            return;
        }
        
        // Get the Contacts
        List<Contact> contacts;
        try {
            contacts = [SELECT Id,
                               FirstName,
                               LastName,
                               NickName__c,
                               Email
                          FROM Contact
                         WHERE Id IN :contactIds];
        } catch(QueryException ex) {
         	// No contacts found
        }
        
        List<string> invalidContactIds = new List<string>();
        
        if(contacts == null || contacts.size() == 0) {
            for(string id : contactIds) {
                invalidContactIds.add(id);
            }
        } else {
            for(string id : contactIds) {
                boolean idMatchesContact = false;
                for(Contact c : contacts) {
                    try {
                        if(c.Id == id) {
                            idMatchesContact = true;
                        }
                    }
                    catch (StringException ex) {
                        // Move on, doesn't match
                    }
                }
                if(!idMatchesContact) {
                    invalidContactIds.add(id);
                }
            }
        }
        
        // Get the Event Registrations
        List<Event_Registration__c> eventRegistrations;
        
        try {
            eventRegistrations = [SELECT Id,
                                         Status__c,
                                         T_Shirt_Size__c,
                                         Contact__c,
                                         Event__c
                                    FROM Event_Registration__c
                                   WHERE Contact__c IN :contactIds];
        }
        catch(QueryException ex) {
            // swallow because it doesn't matter if they have no current registrations
        }
        
        // Only want to proceed with valid contact IDs
        List<string> validContactIds = new List<string>();
        for(string id : contactIds) {
            boolean isValid = true;
            for(string invalidId : invalidContactIds) {
                if(id == invalidId) {
                    isValid = false;
                }
            }
            if(isValid) {
                validContactIds.add(id);
            }
        }
                
        List<Map<string, object>> EventsAndRegistrations = new List<Map<string, object>>();
        
        for(Event__c event: events) {
            for(string listedContactId: validContactIds) {
                Event_Registration__c matchingEventRegistration = null;
                for(Event_Registration__c eventRegistration: eventRegistrations) {
                    if(eventRegistration.Event__c == event.Id && eventRegistration.Contact__c == listedContactId) {
                        matchingEventRegistration = eventRegistration;
                    }
                }
                Contact currentContact = null;
                for(Contact contactIterator: contacts) {
                    if(contactIterator.Id == listedContactId) {
                        currentContact = contactIterator;
                    }
                }
                Map<string, object> eventAndRegistration = new Map<string, object> {
                    'EventId' => event.Id,
                    'Title' => event.Name,
                    'StartDate' => event.Event_Start_Date__c,
                    'EndDate' => event.Event_End_Date__c,
                    'RegistrationEndDate' => event.RegistrationEndDate__c,
                    'RegistrationEndTime' => event.RegistrationEndTime__c,
                    'ContactId' => listedContactId
                };
                    
                if(currentContact != null) {

                    eventAndRegistration.put('EmailAddress', currentContact.Email);
                    eventAndRegistration.put('FirstName', currentContact.FirstName);
                    eventAndRegistration.put('LastName', currentContact.LastName);
                    eventAndRegistration.put('NickName', currentContact.NickName__c);
                }
                
                if(matchingEventRegistration != null) {
                    eventAndRegistration.put('Status', matchingEventRegistration.Status__c);
                }
                 
                EventsAndRegistrations.add(eventAndRegistration);
            }
        }
                
        RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(new Map<string, object>{
            'Summaries' => EventsAndRegistrations,
            'InvalidContactIds' => invalidContactIds
        }));
    }   
}