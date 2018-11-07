public with sharing class EventEventQuestions extends ApplicationDomain {

    public EventEventQuestions(List<EventEventQuestion__c> eventEventQuestions) {
        super(eventEventQuestions);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {

        public fflib_SObjectDomain construct(List<SObject>sObjectList) {
            return new EventEventQuestions(sObjectList);
        }

    }

    public override void onBeforeInsert(){
        for(EventEventQuestion__c eventEventQuestion : (List<EventEventQuestion__c>) Records){
            List<EventEventQuestion__c> eventEventQuestionList = EventEventQuestionsSelector.newInstance().selectEEQByQuestionIdAndEventId(eventEventQuestion.Event_Question__c, eventEventQuestion.Matson_Event__c);
            if (eventEventQuestionList != null && eventEventQuestionList.size() > 0){
                eventEventQuestion.addError('This question has already been used on this event, please select one of the existing Event Questions or create a new Event Question to add to this event.');
            }
        }

    }

}