({
    doneRendering : function(component, event, helper)
    { 
        if(!component.get("v.isDoneRendering") && component.get("v.adviserRecord.Primary_Contact__c ")!= null){
            component.set("v.isDoneRendering", true);
            helper.getProspectKitSentIfAny (component, helper); 
        } 
        else if(!component.get("v.isDoneRendering")){
            component.set("v.isDoneRendering", true);
            const wait = time => new Promise((resolve) => setTimeout(resolve, time));       
            wait(3000).then(() => helper.getProspectKitSentIfAny (component, helper)); 
        }
    },
    onSendButtonCLick : function(component, event, helper){
        
        helper.toggleSpinner(component, event);
        component.find("recordEdit").reloadRecord(true);
        const wait = time => new Promise((resolve) => setTimeout(resolve, time));       
        wait(1000).then(() => helper.createFulfillmentRequest(component, event, helper));
        
    },  
})