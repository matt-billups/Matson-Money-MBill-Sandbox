@RestResource(urlMapping='/mm_ManageEventEmailSubscription/*')
global with sharing class mm_ManageEventEmailSubscription {
	@HttpGet
    global static void ManageSubscription() {
        Map<String, String> params = RestContext.request.params;

        String contactId = params.get('CONID');
        String subscribe = params.get('SUBSCRIBE');
        String emailAddress = params.get('EMAIL');

        Contact theContact = GetContact(contactId);
        if(theContact == null) {
            RestContext.response.responseBody = blob.valueOf(JSON.serialize(new Map<string, object> {
                'Success' => false,
                'Message' => 'Contact not found.'
        	}));
            return;
        }

        if(theContact.Email != emailAddress) {
            string message = (emailAddress == '' || emailAddress == null) ? 'Email address was not provided.' : 'Email address does not match Contact record.';
            RestContext.response.responseBody = blob.valueOf(JSON.serialize(new Map<string, object> {
                'Success' => false,
                'Message' => message
        	}));
            return;
        }

        if(ExplicitlyTrue(subscribe)) { // Subscribe the contact only when specifically requested
            theContact.Matson_Event_Marketing_Email_Opt_Out__c = false;
        } else { // Otherwise unsubscribe the contact
            theContact.Matson_Event_Marketing_Email_Opt_Out__c = true;
        }

        update theContact;

        RestContext.response.responseBody = blob.valueOf(JSON.serialize(new Map<string, object> {
            'Success' => true
        }));
    }

    private static Contact GetContact(string contactId) {
        try {
            return [SELECT Id, Email FROM Contact WHERE Id = :contactId LIMIT 1];
        }
        catch(QueryException ex) {
            return null; // Contact doesn't exist so return null
        }
    }

    private static boolean ExplicitlyTrue (string value) {
        if(value.toLowerCase() == 'true') {
            return true;
        }
        return false;
    }
}