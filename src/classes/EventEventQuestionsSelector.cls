public class EventEventQuestionsSelector extends fflib_SObjectSelector implements IEventEventQuestionsSelector {

    public static IEventEventQuestionsSelector newInstance(){
		return (IEventEventQuestionsSelector) Application.Selector.newInstance(EventEventQuestion__c.SObjectType);
	}
    
    public Schema.SObjectType getSObjectType() {
        return EventEventQuestion__c.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            EventEventQuestion__c.Id
        };
    }
    
    public List<EventEventQuestion__c> selectEEQByQuestionIdAndEventId(Id eventQuestionId, Id eventId) {
        return (List<EventEventQuestion__c>)
            Database.query(
            	newQueryFactory().
            		setCondition('Event_Question__c = :eventQuestionId AND Matson_Event__c =:eventId').
            		toSOQL());
    }
    
    public List<EventEventQuestion__c> selectEEQByEventId(Id eventId) {
       
        return (List<EventEventQuestion__c>)
            Database.query(
            	newQueryFactory().
            		setCondition('Matson_Event__c =:eventId').
            		toSOQL());
        
    }

}