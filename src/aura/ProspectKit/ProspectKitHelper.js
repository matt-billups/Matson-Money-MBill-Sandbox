({
    getProspectKitSentIfAny : function(component, helper)
    {     
        var action = component.get("c.GetProspectKitFulfillment");
        action.setParams({
            contactId: component.get("v.adviserRecord.Primary_Contact__c "),
        });
        action.setCallback(this, function(a) {             
            component.set('v.Fulfillments', a.getReturnValue());
            helper.toggleSpinner(component, event);
            if(a.getReturnValue()!= null && a.getReturnValue().length > 0)
            {
                component.find("sendProspectKitButton").set("v.disabled", true);
            }
        });
        $A.enqueueAction(action); 
    },
    createProspectKit : function(component, helper, street, city, state, zipCode)
    {
        var action = component.get("c.CreateProspectKitFulfillment");
        action.setParams({
            contactId: component.get("v.adviserRecord.Primary_Contact__c"),
            name: component.get("v.adviserRecord.Primary_Contact__r.Name"),
            street: street,
            city: city,
            state: state,
            zipCode : zipCode
            
        });
        action.setCallback(this, function(a) {     
            if(a.getState() === "SUCCESS") 
            {
                helper.getProspectKitSentIfAny(component, helper);
            }
            
        });
        $A.enqueueAction(action); 
    },
    
    toggleSpinner: function (component, event) {
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    },
    createFulfillmentRequest : function(component, event, helper)
    {
        
        
        var street = component.get("v.adviserRecord.Primary_Contact__r.MailingStreet");
        var city = component.get("v.adviserRecord.Primary_Contact__r.MailingCity");
        var state = component.get("v.adviserRecord.Primary_Contact__r.MailingState");
        var zipCode = component.get("v.adviserRecord.Primary_Contact__r.MailingPostalCode");
        var missingMialingMessage;
        
        if(street !== null && city !== null  && state !== null && zipCode !== null){
            helper.createProspectKit(component, helper, street, city, state, zipCode);
        }
        else{
            component.set("v.isInError", true);
            var missingMialingMessageHeader = 'Adviser Prospect\'s Contact is missing Mailing ';
            missingMialingMessage = ((street == null) ? 'Street' : '');
            missingMialingMessage = ((city == null) ? ((missingMialingMessage == null || missingMialingMessage == '')? 'City': missingMialingMessage +', City') : missingMialingMessage + '');
            missingMialingMessage = ((state == null) ? ((missingMialingMessage == null || missingMialingMessage == '')? 'State': missingMialingMessage +', State') : missingMialingMessage + '');
            missingMialingMessage = ((zipCode == null) ? ((missingMialingMessage == null || missingMialingMessage == '')? 'Zip Code': missingMialingMessage +', Zip Code') : missingMialingMessage + '');
            missingMialingMessage = missingMialingMessageHeader + missingMialingMessage + '. Please add item(s) and try again.';
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error Prospect Kit Not Sent",
                "message":  missingMialingMessage,                   
                "type" : "error",
                "mode" : "sticky"
            });
            
            toastEvent.fire();  
            helper.toggleSpinner(component, event);            
        }
        
    },
    
})