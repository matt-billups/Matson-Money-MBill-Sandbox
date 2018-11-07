({
    doInit: function(component, event, helper) {  
        helper.checkCancelledCompleted(component);
        helper.getEventName(component); 
        
    },
    searchKeyChange: function(component, event, element) {
        var myEvent = $A.get("e.c:MassAdviserSearchKeyChange");
 		myEvent.setParams({"searchKey": event.target.value});
        myEvent.fire();  
        
        /*console.log("here154");
         var searchKey = event.getParam("searchKey");
        
        var input, filter, table, tr, td, i;
        input = document.getElementById("searchTextBox");
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
        
    },
    
    massAdviserSearchKeyChange: function(component, event, helper) {
        var searchKey = event.getParam("searchKey");
        helper.getAdviserResults(component, searchKey);
        
    },
    
    includeAdviserProspects: function(component, event, helper) {  
        var cancelledEvent = component.get("v.cancelledEvent");	
        var completedEvent = component.get("v.completedEvent");
        var elements = document.getElementsByName("prospectsCheckbox");
        var ischecked = elements.item(0).checked;
        
        component.set("v.isIncludeAdviserProspects", elements.item(0).checked);  
        
        var advisers = component.get('v.advisers');
        var checkedAdvisers = advisers.filter(function(obj){ return obj.checked; });
       
        if(cancelledEvent == false && completedEvent == false){
            helper.getAdviserList(component, checkedAdvisers);
        }
    }, 
    
    cancel: function(component, event, helper)
    { 
        var sObectEvent = $A.get("e.force:navigateToSObject");
        sObectEvent.setParams({
            "recordId": component.get("v.recordId") 
        });
        sObectEvent.fire(); 
        
    },
    
    inviteAdvisersButton: function(component, event, helper) {      
        var advisers = component.get('v.advisers');
        var checkedAdvisers = advisers.filter(function(obj){ return obj.checked; });
        if(checkedAdvisers.length >0 ){
            helper.getCheckedAdvisers(component, checkedAdvisers);   
        }
        else{
            console.log("You have not selected Advisers to invite");
        }  
    },
    handleValueChange: function(component, event, helper) {
        var selectAll = component.get("v.selectAll");
    },
    
    handleCheckboxChange: function(component, event, helper) {
        
        var element = component.find("selectAll");
        var checked = element.get("v.value");
        var advisers = component.get('v.advisers');
        advisers.forEach(function(element){ element.checked = checked; });
        component.set('v.advisers', advisers);
        /*
        var myBool = component.get("v.myBool");
        console.warn("handleCheckboxChange - myBool: ", myBool);
        var element = event.getSource ? event.getSource().getElement() : event.target;       
        console.warn("element: ", element.checked);
        var checked = element.checked;
        var advisers = component.get('v.advisers')
        advisers.forEach(function(element){ element.checked = checked; });     
        component.set('v.advisers', advisers);
        */
    },
    
    handleInputCheckboxChange: function(component, event, helper) {
        // don't think this is used
        var element = event.getSource ? event.getSource().getElement() : event.target;
        console.warn("hanldeInputCheckboxChange - element checked: ", element.checked);
        component.set("v.selectAll", element.checked);        
    },
    
    toggleMyBool: function(component, event, helper) {
        // don't think this is used
        var selectAll = component.get("v.selectAll");
        component.set("v.selectAll", !selectAll);   
    },
    
    toggleInputCheckbox: function(component, event, helper) {
        // don't think this is used
        var elements = document.getElementsByName("checkbox");
        for (var i = 0; i < elements.length; i++) {
            elements.item(i).checked = elements.item(i).checked ? "" : "checked";
        }
    }
})