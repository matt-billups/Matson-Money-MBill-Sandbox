@isTest
public with sharing class EventsTests {
    
    static testMethod void givenOnBeforeDeleteExpectAssociatedEventEventQuestionsDeleted(){

        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_SobjectUnitOfWork mockUow =
                (fflib_SobjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        IEventEventQuestionsSelector selectorMock = (IEventEventQuestionsSelector)mocks.mock(IEventEventQuestionsSelector.class);
        EventQuestion__c fakeEventQuestion = CreateFakeEventQuestion();
        List<Event__c> listOfFakeEvents = CreateListOfFakeEvents();
        EventEventQuestion__c fakeEventEventQuestion = CreateFakeEventEventQuestion(fakeEventQuestion.Id, listOfFakeEvents[0].Id);
        Events sut = new Events(listOfFakeEvents);
        
        mocks.startStubbing();
        mocks.when(selectorMock.sObjectType()).thenReturn(EventEventQuestion__c.SObjectType);
        mocks.when(selectorMock.selectEEQByEventId(listOfFakeEvents[0].Id)).thenReturn(new List<EventEventQuestion__c> { fakeEventEventQuestion });
        mocks.stopStubbing();
        Application.UnitOfWork.setMock(mockUow);
        Application.Selector.setMock(selectorMock);
        
        // When
        sut.deleteAssociatedEventEventQuestions(mockUow);
        
        // Then
		((fflib_SobjectUnitOfWork)mocks.verify(mockUow, listOfFakeEvents.size())).registerDeleted((List<EventEventQuestion__c>)fflib_Match.anyList());

    }
    
    static Id CreateFakeEventQuestionId() {
        return fflib_IDGenerator.generate(EventQuestion__c.SObjectType);
    }
    
    static Id CreateFakeEventId() {
        return fflib_IDGenerator.generate(Event__c.SObjectType);    
    }
    
    static EventEventQuestion__c CreateFakeEventEventQuestion(Id eventQuestionId, Id eventId) {
        return (EventEventQuestion__c)new sfab_FabricatedSObject(EventEventQuestion__c.class)
                .setField(EventEventQuestion__c.Id, fflib_IDGenerator.generate(EventEventQuestion__c.SObjectType))
                .setField(EventEventQuestion__c.Matson_Event__c, eventId)
                .setField(EventEventQuestion__c.Event_Question__c, eventQuestionId).toSObject();
    }
    
    static Event__c CreateFakeEvent() {
		return (Event__c)new sfab_FabricatedSObject(Event__c.class)
            .setField(Event__c.Id, fflib_IDGenerator.generate(Event__c.SObjectType))
            .setField(Event__c.Venue__c, fflib_IDGenerator.generate(Venue__c.SObjectType))
            .setField(Event__c.Course_Name__c, 'Other')
            .setField(Event__c.Name, 'Test Event')
            .setField(Event__c.Event_Description__c, 'This is a fake event.')
            .setField(Event__c.Maximum_Registration__c, '100').toSObject();
    }
    
    static List<Event__c> CreateListOfFakeEvents() {
        return new List<Event__c> {
            CreateFakeEvent()
        };
    }
    
    static EventQuestion__c CreateFakeEventQuestion() {
        Id newRecordTypeId = Schema.SObjectType.EventQuestion__c.getRecordTypeInfosByName().get('New').getRecordTypeId();
        return (EventQuestion__c) new sfab_FabricatedSObject(EventQuestion__c.class)
            .setField(EventQuestion__c.RecordTypeId, newRecordTypeId)
            .setField(EventQuestion__c.Answer_Type__c, 'Text' )
            .setField(EventQuestion__c.Question_Text__c, 'Test question').toSObject();
    }

}