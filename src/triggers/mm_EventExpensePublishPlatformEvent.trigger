/*
 * Author: Matt Billups
 * Date: 10/16/18
 * Purpose: Calls a method from a class to publish a platform event for Matson Events 
 *          when a related child (Event Expense) is udpated or deleted
 */
 
trigger mm_EventExpensePublishPlatformEvent on Event_Expense__c (after update, after delete) {
	List<Id> eventIds = new List<Id>();

	//Check if this is a delete DML
	if(Trigger.isDelete){
        List<Event_Expense__c> deletedExpenses = Trigger.oldMap.values();
        for(Event_Expense__c deletedExpense : deletedExpenses){
        	//Add the Id of the parent Matson Event to the list
			if(deletedExpense.Event__c != NULL) eventIds.add(deletedExpense.Event__c);
        }
	}

	if(Trigger.isUpdate){
		//Loop through all records in the trigger that are deleted or updated
	 	for(Event_Expense__c expense : Trigger.new){
	 		//Add the Id of the parent Matson Event to the list
	 		if(expense.Event__c != NULL) eventIds.add(expense.Event__c);
	 	}
 	}

 	//Call the method to run the publishing of events
 	if(!eventIds.isEmpty()){
 		mm_PublishMatsonEventPlatformEvents.publishEvents(eventIds);
 	}
}