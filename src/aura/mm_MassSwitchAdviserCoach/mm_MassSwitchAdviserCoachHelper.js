({
    showPopupHelper :function(component, componentId, className) { 
        
        var modal = component.find(componentId); 
        $A.util.removeClass(modal, className+'hide'); 
        $A.util.addClass(modal, className+'show');
        
    },
    
    hidePopupHelper :function(component, componentId, className) { 
        
        var modal = component.find(componentId); 
        $A.util.removeClass(modal, className+'show'); 
        $A.util.addClass(modal, className+'hide');
        
    },
    
    getAdviserCoach : function(component,searchKey,helper) {
        var action = component.get("c.selectAdviserCoachByName");
        action.setParams({
            "searchKey": searchKey,
        });
        action.setCallback(this, function(a) {
            var returnList = a.getReturnValue();
            component.set("v.switchFromSearchResults", a.getReturnValue());
        });
        $A.enqueueAction(action);
        
    },

    
    getNewAdviserCoaches : function(component, searchKey, helper) {
        
        var action = component.get("c.selectAdviserCoachByName");
        action.setParams({
            "searchKey": searchKey,
        });
        action.setCallback(this, function(a) {
            var returnList = a.getReturnValue();
            component.set("v.switchToSearchResults", a.getReturnValue());
        });
        $A.enqueueAction(action);
        
    },
    
    getEvent : function(component,searchKey) {
        
        var action = component.get("c.findByEvent");
        action.setParams({
            "searchKey": searchKey,
        });
        action.setCallback(this, function(a) {
            component.set("v.switchFromSearchResults", a.getReturnValue());
        });
        $A.enqueueAction(action);
        
    },
    
    getAdvisersByAdviserCoach : function(component){
        
        var fromWhatText = component.get("v.switchFromRecordName");
        var switchFromRecordId = component.get("v.switchFromRecordId");
        var action = component.get("c.findAdviserByAdviserCoach");
        action.setParams({
            "adviserCoachId": switchFromRecordId
        });
        action.setCallback(this, function(a) {
            component.set('v.advisers', a.getReturnValue());
              var advisers = component.get('v.advisers');
            advisers.forEach(function(element){ element.checked = false; });
        });
        $A.enqueueAction(action);
        
    },
    
    getAdvisersFromEvent : function(component){
        
        var fromWhatText = component.get("v.switchFromRecordName");
        var switchFromRecordId = component.get("v.switchFromRecordId");
        var action = component.get("c.findAdviserByEvent");
        action.setParams({
            "eventId": switchFromRecordId
        });
        action.setCallback(this, function(a) {
            component.set('v.advisers', a.getReturnValue());
              var advisers = component.get('v.advisers');
            advisers.forEach(function(element){ element.checked = false; });
        });
        $A.enqueueAction(action); 
        
    },
    
    getAllAdvisers : function(component) {
        
        var fromWhatText = component.get("v.switchFromRecordName");
        var action = component.get("c.findAllAdviser");
        action.setParams({
        });
        action.setCallback(this, function(a) {
            component.set('v.advisers', a.getReturnValue());
              var advisers = component.get('v.advisers');
            advisers.forEach(function(element){ element.checked = false; });
        });
        $A.enqueueAction(action); 
        
    },
    
    getCheckedAdvisers: function(component, checkedAdvisers) {
        
        var checkedAdviserId = checkedAdvisers.map(function(obj) {return obj.Id});
        var action = component.get('c.switchAdvisers'); 
        action.setParams({
            adviserCoachId: component.get("v.newAdviserCoachId"),
            adviserIds: checkedAdviserId 
        });
       action.setCallback(this, function(actionResult) {         
       });
        $A.enqueueAction(action); 
         $A.get("e.force:closeQuickAction").fire() 
        window.location.reload();
        
    },  
    
    filterAdviserList: function(component, searchKey, helper) {
        var action = component.get("c.FilterAdvisersList");
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
    }
    
})