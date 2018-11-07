({
    showHelper :function(component, componentId, className){ 
        var modal = component.find(componentId); 
        $A.util.removeClass(modal, className+'hide'); 
        $A.util.addClass(modal, className+'show');
    },
    
    hideHelper :function(component, componentId, className){ 
        var modal = component.find(componentId); 
        $A.util.removeClass(modal, className+'show'); 
        $A.util.addClass(modal, className+'hide');
    },
    
    makeActiveHelper :function(component, componentId){
        var modal = component.find(componentId); 
        $A.util.addClass(modal, 'slds-is-active');      
    },
    
    makeUnactiveHelper :function(component, componentId){
         var modal = component.find(componentId); 
       $A.util.removeClass(modal, 'slds-is-active');          
    }
})