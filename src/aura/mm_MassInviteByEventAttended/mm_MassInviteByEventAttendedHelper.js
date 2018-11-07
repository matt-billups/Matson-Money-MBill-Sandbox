({
    showPopupHelper: function(component, componentId, className) {
        var modal = component.find(componentId);
        
        $A.util.removeClass(modal, className + 'hide');
        $A.util.addClass(modal, className + 'show');
    },
    
    hidePopupHelper: function(component, componentId, className) {
        var modal = component.find(componentId);
        
        $A.util.removeClass(modal, className + 'show');
        $A.util.addClass(modal, className + 'hide');
    },
    

    
    getFutureEvents: function(component, searchKey, helper) {
        var action = component.get("c.SearchFutureEvents");
        action.setParams({
            "searchKey": searchKey,
        });
        action.setCallback(this, function(a) {
            var returnList = a.getReturnValue();
            component.set("v.filteredUpcomingEventsList", a.getReturnValue());
            var stuff= component.get("v.filteredUpcomingEventsList");
        });
        $A.enqueueAction(action);
    },
    

    
    getPastEvents: function(component, searchKey, helper) {
        var action = component.get("c.SearchPastEvents");
        action.setParams({
            "searchKey": searchKey,
        });
        action.setCallback(this, function(a) {
            var returnList = a.getReturnValue();
            component.set("v.filteredPastEventsList", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    getEventResults: function(component, searchKey, helper) {
        var action = component.get("c.FilterEventRegistrationsList");
        var registrationList = component.get("v.pastMatsonEventRegistrations");
        action.setParams({
            "searchKey": searchKey,
            "registrationList": registrationList
        });
        action.setCallback(this, function(a) {
            var returnList = a.getReturnValue();
            component.set("v.pastMatsonEventRegistrations", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    getRegistrationsFromEvent: function(component) {
        var eventId = component.get("v.pastEventId");
        var newEventId = component.get("v.upcomingEventId");
        var action = component.get("c.FindRegistrationsByEvent");
        action.setParams({
            "eventId": eventId,
            "newEventId": newEventId
        });
        action.setCallback(this, function(a) {
            component.set('v.pastMatsonEventRegistrations', a.getReturnValue());
            var pastMatsonEventRegistrations = component.get('v.pastMatsonEventRegistrations');
            
            if (pastMatsonEventRegistrations.length < 1) {
                document.getElementById('errors4').innerHTML="There are no advisers available to invite.";
            }
            
            pastMatsonEventRegistrations.forEach(function(element) {
                element.checked = false;
                element.showArrow = 'slds-hide';
           });
        });
        
        $A.enqueueAction(action);
    },
    
    getAdvisersFromRegistration: function(component, eventId, checkedRegistrations) {
        var checkedEventRegId = checkedRegistrations.map(function(obj) { return obj.Id; });
        var action = component.get('c.GetAdvisersFromRegistrations');
        action.setParams({
			eventId: eventId,
            checkedRegistrations: checkedEventRegId
        });
        action.setCallback(this, function(a) {
            this.inviteAdvisers(component, a.getReturnValue(), eventId);
        });
        
        $A.enqueueAction(action);
    },
    
    inviteAdvisers: function(component, checkedAdvisers, newEvent) {
        var action = component.get('c.InviteAdvisers');
        var registrationStatus = component.get("v.selectedRegistrationStatus");
        action.setParams({
            eventId: newEvent,
            adviserIds: checkedAdvisers,
            registrationStatus: registrationStatus
        });
        action.setCallback(this, function(actionResult) {
            this.hidePopupHelper(component, 'stepTwo' , 'slds-');
            this.showPopupHelper(component, 'success', 'slds-');
        });
        
        $A.enqueueAction(action);
    },
    
    reset: function(component) {
        this.hidePopupHelper(component, 'stepTwo' , 'slds-');
        this.hidePopupHelper(component, 'success' , 'slds-');
        this.showPopupHelper(component, 'stepOne', 'slds-');
        this.hidePopupHelper(component,'dropdownSelectionToLeft','slds-');
        this.hidePopupHelper(component,'dropdownSelectionToRight','slds-');
        
        document.getElementById("pastEventSearchText").value =  "";
        document.getElementById("upcomingEventSearchText").value =  "";
        document.getElementById('errors').innerHTML="";
        document.getElementById('errors2').innerHTML="";
        document.getElementById('errors3').innerHTML="";
        document.getElementById('errors4').innerHTML="";
        
        component.set("v.selectAllChecked" , false);
        component.set("v.pastEventId" , undefined);
        component.set("v.pastEventName" , "");
        component.set("v.upcomingEventName", "");
        component.set("v.upcomingEventId" , undefined);
        component.set("v.selectedRegistrationStatus", 'Queued');
        component.set("v.pastMatsonEventRegistrations" , undefined);
        component.set("v.filteredPastEventsList", "v.allPastEventsList");
        component.set("v.filteredUpcomingEventsList", "v.allUpcomingEventsList");
    },
    
    minimize: function(component) {
        var utilityAPI = component.find("utilityBar");
        utilityAPI.minimizeUtility();
    },

    
    handleEventSearch: function(component, inputName, listControlName, allEventsName, filteredEventsName, dropdownName) {
        
    }
})