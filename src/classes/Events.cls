public with sharing class Events extends ApplicationDomain {

    public Events(List<Event__c> events) {
        super(events);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject>sObjectList) {
            return new Events(sObjectList);
        }
    } 
    
    public override void onBeforeDelete(){
        deleteAssociatedEventEventQuestions(Application.UnitOfWork.newInstance());
    }
    
    public void deleteAssociatedEventEventQuestions(fflib_ISObjectUnitOfWork uow) {
        List<EventEventQuestion__c> listOfEventEventQuestions = new List<EventEventQuestion__c>();
        for(Event__c event : (List<Event__c>) Records){
			listOfEventEventQuestions.addAll(EventEventQuestionsSelector.newInstance().selectEEQByEventId(event.Id));        }
        uow.registerDeleted(listOfEventEventQuestions);
        uow.commitWork();
    }
    
}