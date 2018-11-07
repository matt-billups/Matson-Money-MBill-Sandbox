public class MatsonEventRegistrationsSelector extends fflib_SObjectSelector implements IMatsonEventRegistrationsSelector {
    
    public static IMatsonEventRegistrationsSelector newInstance() {
        return (IMatsonEventRegistrationsSelector) Application.Selector.newInstance(Event_Registration__c.SObjectType);
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            	Event_Registration__c.Id,
                Event_Registration__c.Adviser_Number_Hidden__c,
                Event_Registration__c.Adviser_Email__c,
                Event_Registration__c.Attendee_First_Name__c,
                Event_Registration__c.Attendee_Email__c,
                Event_Registration__c.Attendee_Last_Name__c,
                Event_Registration__c.Attendee_Name__c,
                Event_Registration__c.Attendee_Nickname__c,
                Event_Registration__c.Contact__c,
                Event_Registration__c.Event__c,
                Event_Registration__c.Event_Email_Opt_Out_URL__c,
				Event_Registration__c.Reg_Adviser__c,
                Event_Registration__c.Registration_Site_URL__c,
                Event_Registration__c.Status__c,
                Event_Registration__c.Venue_Name__c
                };
                    }
    
    public override String getOrderBy() {
        return 'Attendee_Name__c';
    }
    
    public Schema.SObjectType getSObjectType() {
        return Event_Registration__c.sObjectType;
    }
    
    public List<Event_Registration__c> selectById(Set<ID> idSet) {
        return (List<Event_Registration__c>) selectSObjectsById(idSet);
    }
    
    public Event_Registration__c selectRegistrationWithEventFieldsById(Id recordId) {
        fflib_QueryFactory query = newQueryFactory();
        
        fflib_SObjectSelector matsonEventsSelector = new MatsonEventsSelector();
        matsonEventsSelector.configureQueryFactoryFields(query, 'Event__r');
        query.setCondition('Id = :recordId');
        return (Event_Registration__c)  Database.query( query.toSOQL() );
    }
    
    public List<Event_Registration__c> selectActiveEFT1RegistationByEventStartDate(Date eventStartDate) {
        fflib_QueryFactory query = newQueryFactory();
        fflib_SObjectSelector matsonEventsSelector = new MatsonEventsSelector();
        matsonEventsSelector.configureQueryFactoryFields(query, 'Event__r');
        fflib_SObjectSelector contactSelector = new ContactsSelector();
        contactSelector.configureQueryFactoryFields(query, 'Contact__r');
        string condition = 'Status__c = \'Registered\'and Event__r.Event_Start_Date__c = :eventStartDate and Event__r.Event_Status__c <> \'Cancelled\' and Event__r.Course_Name__c <> \'Entrepreneur Foundation Training Session 1\' and Contact__r.IsEmailBounced <> true and Email_Exempt__c <> true and Event__r.Email_Reminder_1_Week_Template__c <> null';
        query.setCondition(condition);
        return (List<Event_Registration__c>)  Database.query( query.toSOQL() );
    }
         
    public List<Event_Registration__c> selectEventRegistrationsByEventId(Id newEventId) {
        fflib_QueryFactory query = newQueryFactory();
        string condition = 'Event__c =: newEventId';
        query.setCondition(condition);
        return (List<Event_Registration__c>)  Database.query( query.toSOQL() );  
    }
    
    public List<Event_Registration__c> selectAdviserEventRegistrationsByEventId(Id newEventId) {
        fflib_QueryFactory query = newQueryFactory();
        string condition = 'Event__c =: newEventId AND Attendee_Type__c = \'Adviser\'';
        query.setCondition(condition);
        return (List<Event_Registration__c>)  Database.query( query.toSOQL() );
    }
    
 	public List<Event_Registration__c> selectRegistrationByIdAndAdviserId(Set<Id> adviserIds, Id eventId) {        
     	fflib_QueryFactory query = newQueryFactory();
        string condition = 'Event__c =: eventId AND Status__c = \'Attended\' AND Attendee_Type__c = \'Adviser\' AND Reg_Adviser__c NOT in: existingAdvisers';
        query.setCondition(condition);
        return (List<Event_Registration__c>)  Database.query( query.toSOQL() );
    }
    
    public List<Event_Registration__c> selectAllCheckedEventRegistrations(Id eventId, String[] checkedRegistrations){
        fflib_QueryFactory query = newQueryFactory();
        string condition = 'Id in: checkedRegistrations';
        query.setCondition(condition);
        return (List<Event_Registration__c>)  Database.query( query.toSOQL() );
    }
    
    public List<Event_Registration__c> selectEventRegistrationsByAdviserIdsAndEventIds(List<Id> eligibleAdviserIds, Id eventId) {
        fflib_QueryFactory query = newQueryFactory();
        string condition = 'Event__c =: eventId AND Reg_Adviser__c in: eligibleAdviserIds';
        query.setCondition(condition);
        return (List<Event_Registration__c>)  Database.query( query.toSOQL() );

    }
    
        
    public String getSelectAllQuery() {
        return newQueryFactory().toSOQL();
    }
    
    public List<Event_Registration__c> selectFutureRegistrationsWithEventFields()
    {
        fflib_QueryFactory query = newQueryFactory();
        fflib_SObjectSelector matsonEventsSelector = new MatsonEventsSelector();
        matsonEventsSelector.configureQueryFactoryFields(query, 'Event__r');
        
        query.setCondition('Event_Start_Date__c >= TODAY');
        query.getOrderings().clear();
        query.addOrdering('Event_Start_Date__c', fflib_QueryFactory.SortOrder.ASCENDING, true);
        
        return (List<Event_Registration__c>)Database.query(query.toSOQL());
    }
    
    public List<Event_Registration__c> filterEventRegistrationListByAdviserName(String name, List<Event_Registration__c> myList){
        fflib_QueryFactory query = newQueryFactory();
        string condition = ('Id IN: myList AND Adviser_Name__c LIKE: name');
        query.setCondition(condition);
        return (List<Event_Registration__c>)  Database.query( query.toSOQL() );
    }
}