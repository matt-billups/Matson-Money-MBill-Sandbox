({
    doInit: function(component, event, helper) {

    },
    
    cancel: function(component, event, helper) {
        helper.minimize(component);
        helper.reset(component);
    },
    
    clickNext: function(component, event, helper) {
        var selectedPastEvent = component.get("v.pastEventId");
        var selectedUpcomingEvent = component.get("v.upcomingEventId");
        
        if(selectedPastEvent === undefined)
        {
            document.getElementById('errors').innerHTML = "*Please select an event";
            
            if(selectedUpcomingEvent === undefined)
            {
                document.getElementById('errors2').innerHTML = "*Please select an event";
            }
        }
        else if(selectedUpcomingEvent === undefined)
        {
            document.getElementById('errors2').innerHTML = "*Please select an event";
        }
        else
        {
            helper.hidePopupHelper(component, 'stepOne' , 'slds-');
            helper.showPopupHelper(component, 'stepTwo', 'slds-');
            helper.getRegistrationsFromEvent(component);
        }
    },
    
    showPastEventSuggestions: function(component, event, helper) {
        helper.handleEventSearch(component, "pastEventSearchText", "pastEventNameList", "v.allPastEventsList", "v.filteredPastEventsList", 'dropdownSelectionToLeft');
    },
    
    showUpcomingEventSuggestions: function(component, event, helper) {
        helper.handleEventSearch(component, "upcomingEventSearchText", "upcomingEventNameList", "v.allUpcomingEventsList", "v.filteredUpcomingEventsList", 'dropdownSelectionToRight');
    },
    
    
    searchingUpcomingEvents: function(component, event, helper) {
        var myEvent = $A.get("e.c:FutureEventSearchKeyChange");
        myEvent.setParams({"searchKey": event.target.value});
        myEvent.fire();
    },
    
    futureEventSearchKeyChange: function(component, event, helper) {
        helper.showPopupHelper(component,'dropdownSelectionToRight','slds-'); 
        var searchKey = event.getParam("searchKey");
        helper.getFutureEvents(component, searchKey);
        
    },
    
    searchingPastEvents: function(component, event, helper) {
        
        var myEvent = $A.get("e.c:PastEventSearchKeyChange");
        myEvent.setParams({"searchKey": event.target.value});
        myEvent.fire();

    },
    
    pastEventSearchKeyChange: function(component, event, helper) {
        helper.showPopupHelper(component,'dropdownSelectionToLeft','slds-'); 
        var searchKey = event.getParam("searchKey");
        helper.getPastEvents(component, searchKey);
        
    },
    
    selectedPastEventName: function(component, event, helper) {
        helper.hidePopupHelper(component, 'dropdownSelectionToLeft', 'slds-');
        
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset.record;
        var selectedName = selectedItem.dataset.data;
        
        document.getElementById("pastEventSearchText").value = selectedName;
        component.set("v.pastEventId", recId);
        component.set("v.pastEventName", selectedName);
    },
    
    selectedUpcomingEventName: function(component, event, helper) {
        helper.hidePopupHelper(component, 'dropdownSelectionToRight', 'slds-');
        
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset.record;
        var selectedName = selectedItem.dataset.data;
        
        document.getElementById("upcomingEventSearchText").value = selectedName;
        component.set("v.upcomingEventId", recId);
        component.set("v.upcomingEventName", selectedName);
    },
    
    restart: function(component, event, helper) {
        helper.reset(component);
    },
    
    searchBoxChange: function(component, event, helper) {
        
        var myEvent = $A.get("e.c:MassAddSearchKeyChange");
        myEvent.setParams({"resultsSearchKey": event.target.value});
        myEvent.fire();
        
        /*
        console.log('searchBoxChange');
        var searchBoxKey = event.target.value;
        var input, filter, table, tr, td, i;
        input = document.getElementById("filterTextBox");
        filter = input.value.toUpperCase();
        table = document.getElementById("myTable");
        tr = table.getElementsByTagName("tr");
        
        for (i = 0; i < tr.length; i++)
        {
            td = tr[i].getElementsByTagName("td")[1];
            
            if (td)
            {
                if (td.innerHTML.toUpperCase().indexOf(filter) > -1)
                {
                    tr[i].style.display = "";
                    console.log('tr[i] ' + tr[i].name());
                }
                else
                {
                    tr[i].style.display = "none";
                }
            }
        }*/
        
    },
    
    eventResultsSearchKeyChange: function(component, event, helper) {
        var searchKey = event.getParam("resultsSearchKey");
        helper.getEventResults(component, searchKey);
        
    },
    
    handleCheckboxChange: function(component, event, helper) {
        var element = component.find("selectAll");
        var checked = element.get("v.value");
        var pastMatsonEventRegistrations = component.get('v.pastMatsonEventRegistrations');
        pastMatsonEventRegistrations.forEach(function(element){ element.checked = checked; });
        component.set('v.pastMatsonEventRegistrations', pastMatsonEventRegistrations);
    },
    
    submit: function(component, event, helper) {
        var pastMatsonEventRegistrations = component.get('v.pastMatsonEventRegistrations');
        var newEvent = component.get('v.upcomingEventId');
        var checkedRegistrations = pastMatsonEventRegistrations.filter(function(obj){ return obj.checked; });
        if(checkedRegistrations.length < 1)
        {
            document.getElementById('errors3').innerHTML= "You have not selected any Advisers to invite.";
        }
        else
        {
            helper.getAdvisersFromRegistration(component, newEvent, checkedRegistrations);
        }
    },
    
    showSpinner: function(component) {
        component.set("v.Spinner", true);
    },
    
    hideSpinner: function(component) {
        component.set("v.Spinner", false);
    }
})