({
    
    selectShowAdvisersBy : function(component, event, helper) {
        
        var showAdvisersBy = component.get("v.showAdvisersBy");
        
        if(showAdvisersBy=="Adviser Coach") {
            document.getElementById("fromWhatText").value =  "";
            document.getElementById("fromWhatText").disabled =  false;
            component.set("v.switchFromRecordName" , "");
            component.set("v.switchFromRecordId", undefined);
            helper.showPopupHelper(component,'searchByWhoWhat','slds-');
            component.set("v.showByEventSelected", false);
            component.set("v.switchFromSearchTitle" , "Adviser Coach");
            component.set("v.switchFromHelpText" , "I.E. John Doe");            
        }
        else if(showAdvisersBy=="Event") {
            document.getElementById("fromWhatText").value =  "";
            document.getElementById("fromWhatText").disabled =  false;
            component.set("v.switchFromRecordName" , "");
            component.set("v.switchFromRecordId", undefined);
            helper.showPopupHelper(component,'searchByWhoWhat','slds-');
            component.set("v.showByEventSelected", false);
            component.set("v.switchFromSearchTitle" , "Event Name");
            component.set("v.switchFromHelpText" , "I.E. ACC 2017");
        }
        else if (showAdvisersBy=="All") {
            helper.hidePopupHelper(component, 'searchByWhoWhat', 'slds-');
        }
        else {
        	return;
        }
        
    },
    
    searchSwitchFromRecords :function(component, event, helper) {
        

        var myEvent = $A.get("e.c:SearchKeyChange");
        myEvent.setParams({"searchKey": event.target.value});
        myEvent.fire();
        
    },
    
    searchKeyChange: function(component, event, helper)  {
        
        helper.showPopupHelper(component,'fromwhat','slds-'); 
        var showAdvisersBy = component.get("v.showAdvisersBy");
        var searchKey = event.getParam("searchKey");
        if(showAdvisersBy=="Adviser Coach") {
            helper.getAdviserCoach(component,searchKey); 
        }
        else if(showAdvisersBy=="Event") {
            helper.getEvent(component,searchKey); 
        }
        else {
       		return;  
        }
        
    },
    
    selectedName : function(component, event, helper) {
        
        helper.hidePopupHelper(component,'fromwhat','slds-'); 
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset.record; 
        var selectedName = selectedItem.dataset.data;
        document.getElementById("fromWhatText").value =  selectedName;
        document.getElementById("fromWhatText").disabled =  true;
        component.set("v.switchFromRecordName" , selectedName);
        component.set("v.switchFromRecordId", recId);
        
    },
    
    searchSwitchToRecords :function(component, event, helper) {
        
        var myEvent = $A.get("e.c:SwitchToSearchKeyChange");
        myEvent.setParams({"newSearchKey": event.target.value});
        myEvent.fire();
        
    },
    
    switchToSearchKeyChange: function(component, event, helper)  {
        
        helper.showPopupHelper(component,'dropdownSelectionTo','slds-'); 
        var searchKey = event.getParam("newSearchKey");
        helper.getNewAdviserCoaches(component,searchKey); 

    },

    
    newCoachSelected :  function(component, event, helper) {
        
        helper.hidePopupHelper(component,'dropdownSelectionTo','slds-'); 
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset.record; 
        var selectedName = selectedItem.dataset.data;
        document.getElementById("toWhoText").value =  selectedName;
        document.getElementById("toWhoText").disabled =  true;
        component.set("v.newAdviserCoachId", recId);
        component.set("v.newAdviserCoachName", selectedName);
        
    },
    
    clickNext:function(component, event, helper) {
        
        var showAdvisersBy = component.get("v.showAdvisersBy");
        var newCoachId =  component.get("v.newAdviserCoachId");
        var switchFromRecordId = component.get("v.switchFromRecordId");
        var toWhoName = component.get("v.newAdviserCoachName");
        
        if(newCoachId=== undefined || (showAdvisersBy == "Adviser Coach" && switchFromRecordId=== undefined) || (showAdvisersBy == "Event" && switchFromRecordId=== undefined)) {
            if (newCoachId=== undefined) {
                document.getElementById('errors').innerHTML="*Please select an Adviser Coach*";
            }
            else {
                document.getElementById('errors').innerHTML="";   
            }
            if (showAdvisersBy == "Event" && switchFromRecordId=== undefined) {
                document.getElementById('errors1').innerHTML="*Please select an Event*";
            }
            else if(showAdvisersBy == "Adviser Coach" && switchFromRecordId=== undefined) {
                document.getElementById('errors1').innerHTML="*Please select an Adviser Coach*";
            }
            else {
                document.getElementById('errors1').innerHTML="";   
            }
            document.getElementById("fromWhatText").disabled =  false;
            document.getElementById("toWhoText").disabled =  false;
        }

        // switch from an adviser to the same adviser
        else if(newCoachId == switchFromRecordId){
            document.getElementById('errors').innerHTML="*The two Adviser Coaches must be different*"; 
            document.getElementById('errors1').innerHTML="*The two Adviser Coaches must be different*"; 
            document.getElementById("fromWhatText").disabled =  false;
            document.getElementById("toWhoText").disabled =  false;
        }
        
        else{
            helper.hidePopupHelper(component, 'stepOne' , 'slds-');
            helper.showPopupHelper(component, 'stepTwo', 'slds-');
            if(showAdvisersBy=="Adviser Coach") {
                helper.getAdvisersByAdviserCoach(component); 
            }
            else if(showAdvisersBy=="Event") {
                helper.getAdvisersFromEvent(component); 
            }
            else {
                showAdvisersBy="All";
                component.set("v.switchFromRecordName" , showAdvisersBy);
                helper.getAllAdvisers(component); 
            }
        }
        
    },
    
    searchBoxChange : function(component, event, helper) {

        /*var searchBoxKey = event.target.value;
        var input, filter, table, tr, td, i;
        input = document.getElementById("filterTextBox");
        filter = input.value.toUpperCase();
        table = document.getElementById("myTable");
        tr = table.getElementsByTagName("tr");
        for (i = 0; i < tr.length; i++) {
            td = tr[i].getElementsByTagName("td")[1];
            if (td) {
                if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }       
        }*/
        
        var myEvent = $A.get("e.c:MassSwitchSearchKeyChange");
        myEvent.setParams({"searchKey": event.target.value});
        myEvent.fire();
    },
    
    massSwitchSearchKeyChange: function(component, event, helper) {
        var searchKey = event.getParam("searchKey");
        helper.filterAdviserList(component, searchKey);
        
    },
    
    handleCheckboxChange : function(component, event, helper) {
        
        var adviserSelected = component.get("v.adviserSelected");
        console.warn("handleCheckboxChange - adviserSelected: ", adviserSelected);
        var element = event.getSource ? event.getSource().getElement() : event.target;       
        console.warn("element: ", element.checked);
        var checked = element.checked;
        var advisers = component.get('v.advisers')
        advisers.forEach(function(element){ element.checked = checked; });     
        component.set('v.advisers', advisers);
        
    },
    
    switchAdvisersButton: function(component, event, helper) {  
        
        var advisers = component.get('v.advisers');
        var checkedAdvisers = advisers.filter(function(obj){ return obj.checked; });
        var newCoach = component.get
        if(checkedAdvisers.length >0 ){
            helper.getCheckedAdvisers(component, checkedAdvisers);   
        }
        else{
            document.getElementById('errorsTop').innerHTML="*Please select at least one Adviser.*";
        } 
        
    },
    
    cancelSwitch:function(component, event, helper) {

        $A.get("e.force:closeQuickAction").fire() 
        window.location.reload();
        
    },

    restart : function(component, event, helper) {
        
        helper.hidePopupHelper(component, 'stepTwo' , 'slds-');
        helper.showPopupHelper(component, 'stepOne', 'slds-');
        document.getElementById("fromWhatText").value =  "";
        document.getElementById("fromWhatText").disabled =  false;
        component.set("v.switchFromRecordName" , "");
        component.set("v.switchFromRecordId", undefined);
        helper.hidePopupHelper(component,'searchByWhoWhat','slds-');
        component.set("v.switchFromSearchTitle" , "");
        component.set("v.newAdviserCoachId" , undefined);
        component.set("v.newAdviserCoachName" , "");
        component.set("v.switchFromHelpText" , "");
        component.set("v.showByEventSelected" , false);
        component.set("v.showAdvisersBy", "All");
        document.getElementById("toWhoText").value =  "";
        document.getElementById("toWhoText").disabled =  false;
        document.getElementById('errors').innerHTML="";
        
    },
    
})