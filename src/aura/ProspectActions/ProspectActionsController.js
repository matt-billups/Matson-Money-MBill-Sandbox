({
    onProspectKitTabPress:function(component, event, helper)
    {
        console.log('Hello');
        helper.showHelper(component,'tab-scoped-1', 'slds-')
        helper.hideHelper(component,'tab-scoped-2', 'slds-')
        helper.makeActiveHelper(component,'ProspectKit')
        helper.makeUnactiveHelper(component,'SendFirstStepEmail')
       
    },
        onSendFirstStepEmailTabPress:function(component, event, helper)
    {
        console.log('Hello2');
        helper.showHelper(component,'tab-scoped-2', 'slds-')
       	helper.hideHelper(component,'tab-scoped-1', 'slds-')
        helper.makeActiveHelper(component,'SendFirstStepEmail')
		helper.makeUnactiveHelper(component,'ProspectKit')
    },
    
})