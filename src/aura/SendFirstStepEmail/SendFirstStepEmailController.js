({
	sendFirstStepEmail : function(component, event, helper) {
          console.log('here ' +  component.get("v.recordId"))
                var action = component.get("c.SendCongratFirstStepsEmail");
        action.setParams({
            parentId: component.get("v.recordId"),
           
        });
        action.setCallback(this, function(a) {
			component.set('v.Email', a.getReturnValue());
            if(a.getReturnValue().length > 0)
            {
               component.find("sendFirstStepEmailButton").set("v.disabled", true);
            }
        });
        $A.enqueueAction(action); 
		
	},
    doInit : function(component, event, helper)
    {
            var action = component.get("c.GetCongratFirstStepsEmail");
        action.setParams({
            parentId: component.get("v.recordId"),
           
        });
        action.setCallback(this, function(a) {
			component.set('v.Email', a.getReturnValue());
            if(a.getReturnValue().length > 0)
            {
               component.find("sendFirstStepEmailButton").set("v.disabled", true);
            }
        });
        $A.enqueueAction(action); 
    }
})