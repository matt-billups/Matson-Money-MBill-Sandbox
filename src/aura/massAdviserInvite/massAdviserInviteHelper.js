({
    // Fetch the Adviser from the Apex controller
    getAdviserList: function(component, checkedAdvisers) {     
        var action = component.get('c.getAdvisers');
        action.setParams({
            eventId: component.get("v.recordId"),
            isgetBothAdviserAndProspest: component.get("v.isIncludeAdviserProspects")
        });  
        
        
        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set('v.advisers', actionResult.getReturnValue());
            var advisers = component.get('v.advisers');
            
            if(checkedAdvisers != null && checkedAdvisers.length >0)
            {
                 for(var adviser in advisers){

                     for(var checkedAdviser in checkedAdvisers){
                         var advisersID = advisers[adviser].Id;
                         var heckedAdviserId = checkedAdvisers[checkedAdviser].Id;
                         if (advisers[adviser].Id == checkedAdvisers[checkedAdviser].Id){
                            advisers[adviser].checked = true;                             
                        }
                    }
                }
            }
            else
            {             
                advisers.forEach(function(element){ element.checked = false; });
            }            
        });
        $A.enqueueAction(action);   
    },
    getEventName : function(component) {
        
        var getValue = component.get("c.getEventName");
        getValue.setParams({
            eventId: component.get("v.recordId")
        });
        getValue.setCallback(this, function(a) {
            component.set("v.eventName", a.getReturnValue());                    
        });
        $A.enqueueAction(getValue);
    },
    
    checkCancelledCompleted : function(component) {
        var cancelled = false;
        var cancelledAction = component.get("c.eventCancelled");
        cancelledAction.setParams({
            eventId: component.get("v.recordId")
        });
        cancelledAction.setCallback(this, function(a) {
            component.set("v.cancelledEvent", a.getReturnValue());    
            if (a.getReturnValue() == true){
                cancelled = true;
                document.getElementById('cancelledErrorBottom').innerHTML= "This event has been cancelled. Try inviting advisers to another event.";
                document.getElementById('cancelledErrorBottom').style.visibility = "show";
                document.getElementById('myTable').style.visibility = "hidden";
                document.getElementById('searchTextBox').style.visibility = "hidden";
                document.getElementById('icon').style.visibility = "hidden";
                document.getElementById('inviteButton').disabled = true;
            }
            else{
                document.getElementById('cancelledErrorBottom').style.visibility = "hidden";
            }
            this.checkCompleted(component, cancelled);
        });
        $A.enqueueAction(cancelledAction);
        
    },
    
    getAdviserResults: function(component, searchKey, helper) {
        var action = component.get("c.filterAdviserResults");
        var adviserList = component.get("v.advisers");
        action.setParams({
            "searchKey": searchKey,
            "adviserList": adviserList
        });
        action.setCallback(this, function(a) {
            var returnList = a.getReturnValue();
            component.set("v.advisers", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    
    checkCompleted : function(component, cancelled) {
        var completed = false;
        var completedAction = component.get("c.eventCompleted");
        completedAction.setParams({
            eventId: component.get("v.recordId")
        });
        completedAction.setCallback(this, function(b) {
            component.set("v.completedEvent", b.getReturnValue());    
            if (b.getReturnValue() == true){
                completed = true;
                document.getElementById('completedErrorBottom').innerHTML= "This event has ended. Try inviting advisers to a future event.";
                document.getElementById('completedErrorBottom').style.visibility = "show";
                document.getElementById('myTable').style.visibility = "hidden";
                document.getElementById('searchTextBox').style.visibility = "hidden";
                document.getElementById('icon').style.visibility = "hidden";
                document.getElementById('inviteButton').disabled = true;
            }
            else{
                document.getElementById('completedErrorBottom').style.visibility = "hidden";
            }
            this.showTable(component, cancelled, completed);
        });  
        $A.enqueueAction(completedAction); 
    },
    
    showTable : function(component, cancelled, completed){
        if(cancelled == false && completed == false){
            this.getAdviserList(component, null);
        }
    },
    
    
    getCheckedAdvisers: function(component, checkedAdvisers) {
        var checkedAdviserId = checkedAdvisers.map(function(obj) {return obj.Id});
        var JScheckedAdviserId = JSON.stringify(checkedAdviserId);
        var action = component.get('c.inviteAdvisersToEvent'); 
        action.setParams({
            eventId: component.get("v.recordId"),
            adviserIds: checkedAdviserId 
        });
        action.setCallback(this, function(actionResult) {});
        $A.enqueueAction(action);
        
        var sObectEvent = $A.get("e.force:navigateToSObject");
        sObectEvent .setParams({
            "recordId": component.get("v.recordId") 
        });
        sObectEvent.fire();
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Job Requested",
            "message": "Successfully requested to invite " + checkedAdviserId.length + " adviser(s).  An email will be sent when the job is completed.",
            "duration": 10000
        });
        toastEvent.fire();
    }
})