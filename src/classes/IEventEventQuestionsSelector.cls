public interface IEventEventQuestionsSelector extends fflib_ISObjectSelector {

	List<EventEventQuestion__c> selectEEQByQuestionIdAndEventId(Id eventQuestionId, Id eventId);
    
    List<EventEventQuestion__c> selectEEQByEventId(Id eventId);
}