public class MatsonEventsSelector extends fflib_SObjectSelector implements IMatsonEventsSelector {

    public static IMatsonEventsSelector newInstance()
	{
		return (IMatsonEventsSelector) Application.Selector.newInstance(Event__c.SObjectType);
	}

	public List<Schema.SObjectField> getSObjectFieldList()
	{
		return new List<Schema.SObjectField> {
			Event__c.Id,
            Event__c.Name,
            Event__c.Email_Cancelled_Body__c,
            Event__c.Email_Cancelled_Template__c,
            Event__c.Course_Name__c,
            Event__c.Email_Invite_Body__c,
            Event__c.Email_Invite_Template__c,
			Event__c.Email_Registered_Body__c,
            Event__c.Email_Registered_Template__c,
			Event__c.Email_Reminder_1_Week_Body__c,
			Event__c.Email_Reminder_1_Week_Template__c,
			Event__c.Email_Reminder_2_Week_Body__c,
            Event__c.Email_Reminder_2_Week_Template__c,
            Event__c.Event_End_Date__c,
            Event__c.Event_Status__c,
            Event__c.Event_Start_Date__c,
            Event__c.Formatted_End_Date__c,                
            Event__c.Formatted_Start_Date__c,
			Event__c.Venue_City__c,
            Event__c.Venue_Postal_Code__c,
            Event__c.Venue_State__c,
			Event__c.Venue_Street_Address_1__c,
            Event__c.Internal_Event_Name__c
		};
	}

	public Schema.SObjectType getSObjectType()
	{
		return Event__c.sObjectType;
	}

	public List<Event__c> selectById(Set<ID> idSet)
	{
		return (List<Event__c>) selectSObjectsById(idSet);
	}
    
    public List<Event__c> findAllNoncancelledFutureEventsBySearchKey(String searchKey) {
        fflib_QueryFactory query = newQueryFactory();
        Date todaysDate = system.today();
        string condition = 'Event_End_Date__c >=: todaysDate AND Event_Status__c <> \'Cancelled\' AND Name LIKE :searchKey';
        query.setCondition(condition);
        return (List<Event__c>)  Database.query( query.toSOQL() );
    }
    
    public List<Event__c> findAllPastEventsBySearchKey(String searchKey) {
        fflib_QueryFactory query = newQueryFactory();
        Date todaysDate = system.today();
        string condition = 'Event_Start_Date__c <=: todaysDate AND Name LIKE :searchKey';
        query.setCondition(condition);
        return (List<Event__c>)  Database.query( query.toSOQL() );
    }
    
    public List<Event__c> selectFutureEvents() {
        fflib_QueryFactory query = newQueryFactory();
        query.setCondition('Event_Start_Date__c >= TODAY');
        return (List<Event__c>)Database.query(query.toSOQL());
    }
    
}