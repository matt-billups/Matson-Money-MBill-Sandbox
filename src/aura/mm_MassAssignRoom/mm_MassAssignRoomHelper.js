({
    showPopupHelper :function(component, componentId, className){ 
        var modal = component.find(componentId);
        
        $A.util.removeClass(modal, className+'hide'); 
        $A.util.addClass(modal, className+'show');
    },
    
    hidePopupHelper :function(component, componentId, className){ 
        var modal = component.find(componentId);
        
        $A.util.removeClass(modal, className+'show'); 
        $A.util.addClass(modal, className+'hide');
    },
    
    getFutureEvents : function(component)
    {
        var action = component.get("c.FindAllFutureEvents");
        
        action.setParams({
        });
        action.setCallback(this, function(a) {
            var returnList = a.getReturnValue();
            component.set("v.searchEventName", a.getReturnValue());
        });
        
        $A.enqueueAction(action);
    },
    
    getVenueRoomsFromEvent : function(component)
    {
        var eventId = component.get("v.eventId");
        var action = component.get("c.FindVenueRoomsByEvent");
        
        action.setParams({
            "eventId": eventId
        });
        action.setCallback(this, function(a) {
            component.set("v.searchRoom", a.getReturnValue());
        });
        
        $A.enqueueAction(action);
    },
    
    getRegistrationsFromEvent : function(component){
        var eventText = component.get("v.eventValueName");
        var eventId = component.get("v.eventId");
        var action = component.get("c.FindRegistrationsByEvent");
        
        action.setParams({
            "eventId": eventId
        });
        action.setCallback(this, function(a) {
            component.set('v.eventRegistrations', a.getReturnValue());
            var eventRegistrations = component.get('v.eventRegistrations');
            eventRegistrations.forEach(function(element)
                                       {
                                           element.checked = false;
                                           
                                           if (element.Attendee_Type__c == 'Adviser')
                                           {
                                               element.showCheckbox = '';
                                               element.showArrow = 'slds-hide';
                                           }
                                           else
                                           {
                                               var parentReg = eventRegistrations.find(function(obj){ return obj.Id == element.Parent_Registration__c; });
                                               
                                               if (parentReg != undefined)
                                               {
                                                   element.showCheckbox = 'slds-hide';
                                                   element.showArrow = '';
                                               }
                                               else
                                               {
                                                   element.showCheckbox = '';
                                                   element.showArrow = 'slds-hide';
                                               }
                                           }
                                       });
        });
        
        $A.enqueueAction(action);        
    },
    
    getCheckedEventRegistrations: function(component, checkedEventRegistrations) {
        var checkedEventRegId = checkedEventRegistrations.map(function(obj) {return obj.Id});
        var action = component.get('c.AssignRoom'); 
        
        action.setParams({
            roomId: component.get("v.roomId"),
            eventRegistrationIds: checkedEventRegId 
        });
        action.setCallback(this, function(actionResult) {
            var spotsAssigned = actionResult.getReturnValue();
            component.set("v.spotsAssigned", spotsAssigned);
            this.hidePopupHelper(component, 'stepTwo' , 'slds-');
            this.showPopupHelper(component, 'success', 'slds-');
        });
        
        $A.enqueueAction(action);
    },
    
    getVenueRoomRegistrationCount: function(component)
    {
        var action = component.get("c.VenueRoomRegistrationCount");
        
        action.setParams({
            eventId: component.get("v.eventId"),
            roomId: component.get("v.roomId")
        })
        action.setCallback(this, function(a){
            var capacity = component.get("v.roomCapacity");
            var count = a.getReturnValue();
            var open = capacity - count;
            component.set("v.roomRegCount", count);
            component.set("v.roomOpenSeats", open);
        })
        
        $A.enqueueAction(action);
    },
    
    checkRelatedEventRegistrations: function(component, eventRegId) {
        var eventRegistrations = component.get('v.eventRegistrations');
        var regsToUpdate = [];
        var eventReg = eventRegistrations.find(function(obj){ return obj.Id == eventRegId });
        var parentRegId = eventReg.Parent_Registration__c;
        
        if (parentRegId != undefined)
        {
            regsToUpdate.push(parentRegId);
            var siblingRegs = eventRegistrations.filter(function(obj){ return obj.Parent_Registration__c == parentRegId && obj.Id != eventRegId });
            siblingRegs.forEach(function(obj){ regsToUpdate.push(obj.Id); });
        }
        
        var childrenRegs = eventRegistrations.filter(function(obj){ return obj.Parent_Registration__c == eventRegId });
        childrenRegs.forEach(function(obj){ regsToUpdate.push(obj.Id); });
        
        return regsToUpdate;
    },
    
    reset: function(component)
    {
        this.hidePopupHelper(component, 'stepTwo' , 'slds-');
        this.hidePopupHelper(component, 'success' , 'slds-');
        this.showPopupHelper(component, 'stepOne', 'slds-');
        this.hidePopupHelper(component,'dropdownSelectionTo','slds-');
        this.hidePopupHelper(component,'dropdownSelectionTo2','slds-');
        
        document.getElementById("eventNameText").value =  "";
        document.getElementById("roomText").value =  "";
        document.getElementById('errorsEvent').innerHTML="";
        document.getElementById('errorsRoom').innerHTML="";
        document.getElementById('errorsRegs').innerHTML="";
        
        component.set("v.eventId" , undefined);
        component.set("v.eventValueName" , "");
        component.set("v.roomId" , undefined);
        component.set("v.roomValueName" , "");
        component.set("v.myBool" , false);
        component.set("v.roomOpenSeats", "");
        component.set("v.spotsAssigned", "");
        
        var eventRegistrations = component.get('v.eventRegistrations');
        eventRegistrations.forEach(function(element){ element.checked = false; });
        component.set('v.eventRegistrations', eventRegistrations);
    },
    
    minimize: function(component)
    {
        var utilityAPI = component.find("utilityBar");
        utilityAPI.minimizeUtility();
    }
})