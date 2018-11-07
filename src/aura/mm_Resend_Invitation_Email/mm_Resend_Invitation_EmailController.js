({
    doInit : function(component, event, helper) {
        var sendEmail = component.get("c.sendEmail");
        
        sendEmail.setParams({
            "recordId" : component.get("v.recordId") 
        });
        
        sendEmail.setCallback(this, function(a){
            var state = sendEmail.getState();
            if(component.isValid() && state == "SUCCESS"){
                $A.get("e.force:closeQuickAction").fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The Invitation Email has been resent."
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
            } 
            else if (state == "ERROR") {
                console.log('There was a problem and the state is: '+ action.getState());
            }
            
        });
        $A.enqueueAction(sendEmail);
        
    }
})