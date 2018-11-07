({    
    getContactRecord : function(component) {
        var recordID = component.get("v.recordId");
        var action = component.get("c.getContactFromId");
        action.setParam("id", recordID);
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.record", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})