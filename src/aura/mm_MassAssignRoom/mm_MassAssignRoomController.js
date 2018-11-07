({
    doInit : function(component, event, helper)
    {
        helper.getFutureEvents(component);
    },
    
    cancelAssign:function(component, event, helper)
    {
        helper.minimize(component);
        helper.reset(component);
    },
    
    clickNext:function(component, event, helper)
    {
        var selectedEvent =  component.get("v.eventId");
        var selectedEventName = component.get("v.eventValueName");
        var selectedRoom =  component.get("v.roomId");
        
        if(selectedEvent === undefined)
        {
            document.getElementById('errorsEvent').innerHTML="*Please select an event";
            document.getElementById("eventNameText").disabled =  false;
            
            if(selectedRoom === undefined)
            {
                document.getElementById('errorsRoom').innerHTML="*Please select a room";
                document.getElementById("roomText").disabled =  false;
            }
        }
        else if(selectedRoom === undefined)
        {
            document.getElementById('errorsRoom').innerHTML="*Please select a room";
            document.getElementById("roomText").disabled =  false;
        }
            else
            {
                helper.hidePopupHelper(component, 'stepOne' , 'slds-');
                helper.showPopupHelper(component, 'stepTwo', 'slds-');
                helper.getRegistrationsFromEvent(component);
            }
    },
    
    showEventSuggestions: function(component, event, helper)
    {
        var input = document.getElementById("eventNameText");
        var filter = input.value.toUpperCase();
        var ul = document.getElementById("eventNameList");
        var li = ul.getElementsByTagName("li");
        
        if (filter == "")
        {
            for (var i = 0; i < li.length; i++)
            {
                if (i < 3)
                {
                    li[i].style.display = "";
                }
                else
                {
                    li[i].style.display = "none";
                }
            }
        }
        else
        {
            for (i = 0; i < li.length; i++)
            {
                if (li[i].innerText.toUpperCase().indexOf(filter) > -1)
                {
                    li[i].style.display = "";
                }
                else
                {
                    li[i].style.display = "none";
                }
            }
        }
        
        helper.showPopupHelper(component,'dropdownSelectionTo','slds-');
    },
    
    searchingEventName : function(component, event, helper)
    {
        helper.showPopupHelper(component,'dropdownSelectionTo','slds-');
        
        var input, filter, ul, li, a, i;
        input = document.getElementById("eventNameText");
        filter = input.value.toUpperCase();
        ul = document.getElementById("eventNameList");
        li = ul.getElementsByTagName("li");
        
        for (i = 0; i < li.length; i++)
        {
            if (li[i].innerText.toUpperCase().indexOf(filter) > -1)
            {
                li[i].style.display = "";
            }
            else
            {
                li[i].style.display = "none";
            }
        }
    },
    
    selectedEventName :  function(component, event, helper)
    {
        helper.hidePopupHelper(component,'dropdownSelectionTo','slds-');
        
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset.record; 
        var selectedName = selectedItem.dataset.data;
        
        document.getElementById("eventNameText").value =  selectedName;
        component.set("v.eventId", recId);
        component.set("v.eventValueName", selectedName);
        helper.getVenueRoomsFromEvent(component);
    },
    
    showRoomSuggestions: function(component, event, helper)
    {
        var input = document.getElementById("roomText");
        var filter = input.value.toUpperCase();
        var ul = document.getElementById("roomList");
        var li = ul.getElementsByTagName("li");
        
        if (filter == "")
        {
            for (var i = 0; i < li.length; i++)
            {
                if (i < 3)
                {
                    li[i].style.display = "";
                }
                else
                {
                    li[i].style.display = "none";
                }
            }
        }
        else
        {
            for (i = 0; i < li.length; i++)
            {
                if (li[i].innerText.toUpperCase().indexOf(filter) > -1)
                {
                    li[i].style.display = "";
                }
                else
                {
                    li[i].style.display = "none";
                }
            }
        }
        
        helper.showPopupHelper(component,'dropdownSelectionTo2','slds-');
    },
    
    searchingRoom : function(component, event, helper)
    {
        helper.showPopupHelper(component,'dropdownSelectionTo2','slds-');
        
        var input, filter, ul, li, a, i;
        input = document.getElementById("roomText");
        filter = input.value.toUpperCase();
        ul = document.getElementById("roomList");
        li = ul.getElementsByTagName("li");
        
        for (i = 0; i < li.length; i++)
        {
            if (li[i].innerText.toUpperCase().indexOf(filter) > -1)
            {
                li[i].style.display = "";
            }
            else
            {
                li[i].style.display = "none";
            }
        }
    },
    
    selectedRoom :  function(component, event, helper)
    {
        helper.hidePopupHelper(component,'dropdownSelectionTo2','slds-');
        
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset.record; 
        var selectedName = selectedItem.dataset.data;
        var capacity = selectedItem.dataset.capacity;
        
        document.getElementById("roomText").value =  selectedName;
        component.set("v.roomId", recId);
        component.set("v.roomValueName", selectedName);
        component.set("v.roomCapacity", capacity);
        helper.getVenueRoomRegistrationCount(component);
    },
    
    restart : function(component, event, helper)
    {
        helper.reset(component);
    },
    
    searchBoxChange : function(component, event, helper)
    {
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
                }
                else
                {
                    tr[i].style.display = "none";
                }
            }       
        }
    },
    
    handleCheckboxChange: function(component, event, helper) {
        var myBool = component.get("v.myBool");
        var element = component.find("selectAll");
        var checked = element.get("v.value");
        var eventRegistrations = component.get('v.eventRegistrations');
        
        eventRegistrations.forEach(function(element){ element.checked = checked; });     
        component.set('v.eventRegistrations', eventRegistrations);
    },
    
    assignButton: function(component, event, helper) {
        var eventRegistrations = component.get('v.eventRegistrations');
        var checkedEventRegistrations = eventRegistrations.filter(function(obj){ return obj.checked; });
        var spotsToFill = component.get("v.roomOpenSeats");
        
        if(checkedEventRegistrations.length > 0 )
        {
            if (checkedEventRegistrations.length > spotsToFill)
            {
                document.getElementById('errorsRegs').innerHTML="The number of registrations you are trying to assign would put the room over capacity.";
            }
            else
            {
                helper.getCheckedEventRegistrations(component, checkedEventRegistrations);
            }
        }
        else
        {
            document.getElementById('errorsRegs').innerHTML= "Choose at least 1 person to assign to this room.";
        }
    },
    
    fillRoom: function(component, event, helper) {
        var spotsToFill = component.get("v.roomOpenSeats");
        var eventRegistrations = component.get('v.eventRegistrations');
        var checkedEventRegistrations = eventRegistrations.filter(function(obj){ return obj.checked; });
        var spotsFilled = checkedEventRegistrations.length;
        var increment = 0;
        
        while (spotsFilled < spotsToFill && increment < eventRegistrations.length)
        {
            var eventReg = eventRegistrations[increment];
            
            if (!eventReg.checked && eventReg.Venue_Room_Name__c == null)
            {
                var regsToUpdate = helper.checkRelatedEventRegistrations(component, eventReg.Id);
                
                if (spotsFilled + 1 + regsToUpdate.length <= spotsToFill)
                {
                    eventReg.checked = true;
                    eventRegistrations.forEach(function(obj){
                        if (regsToUpdate.indexOf(obj.Id) >= 0)
                        {
                            obj.checked = true;
                        }});
                }
                
                checkedEventRegistrations = eventRegistrations.filter(function(obj){ return obj.checked; });
                spotsFilled = checkedEventRegistrations.length;
            }
            
            increment = increment + 1;
        }
        
        component.set('v.eventRegistrations', eventRegistrations);
    },
    
    handleRelatedEventRegistrations: function(component, event, helper) {
        var eventSource = event.getSource();
        var eventRegId = eventSource.get("v.name");
        var checked = eventSource.get("v.value");
        var eventRegistrations = component.get('v.eventRegistrations');
        var regsToUpdate = helper.checkRelatedEventRegistrations(component, eventRegId);
        
        eventRegistrations.forEach(function(obj){
            if (regsToUpdate.indexOf(obj.Id) >= 0)
            {
                obj.checked = checked;
            }});
        
        component.set('v.eventRegistrations', eventRegistrations);
    },
    
    showSpinner: function(component)
    {
        component.set("v.Spinner", true);
    },
    
    hideSpinner: function(component)
    {
        component.set("v.Spinner", false);
    }
})