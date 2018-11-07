@isTest
public with sharing class EventEventQuestionsTests {

    static testMethod void givenOnBeforeInsertExpectCheckForDuplicates() {
        
        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        
        IEventEventQuestionsSelector mockEventEventQuestionsSelector = (IEventEventQuestionsSelector)mocks.mock(IEventEventQuestionsSelector.class);
        
        Id eventQuestionId = CreateFakeEventQuestionId();
        Id eventId = CreateFakeEventId();
        List<EventEventQuestion__c> ListOfFakeEventEventQuestions = CreateFakeEventEventQuestionList(eventQuestionId, eventId);
        EventEventQuestions sut = new EventEventQuestions(ListOfFakeEventEventQuestions);
        
        mocks.startStubbing();
        mocks.when(mockEventEventQuestionsSelector.sObjectType()).thenReturn(EventEventQuestion__c.sObjectType);
        mocks.when(mockEventEventQuestionsSelector.selectEEQByQuestionIdAndEventId(eventQuestionId, eventId)).thenReturn(ListOfFakeEventEventQuestions);
        mocks.stopStubbing();

        Application.Selector.setMock(mockEventEventQuestionsSelector);
        
        // When
        Test.startTest();
        sut.onBeforeInsert();
        Test.stopTest();

        // Then  
        ((IEventEventQuestionsSelector) mocks.verify(mockEventEventQuestionsSelector,
                                                mocks
                                                .times(1)
                                                .description('duplicates should be checked')))
        .selectEEQByQuestionIdAndEventId(eventQuestionId, eventId);

    }

    static EventEventQuestion__c CreateFakeEventEventQuestion(Id eventQuestionId, Id eventId) {
        return (EventEventQuestion__c)new sfab_FabricatedSObject(EventEventQuestion__c.class)
                .setField(EventEventQuestion__c.Id, fflib_IDGenerator.generate(EventEventQuestion__c.SObjectType))
                .setField(EventEventQuestion__c.Matson_Event__c, eventId)
                .setField(EventEventQuestion__c.Event_Question__c, eventQuestionId).toSObject();
    }
    
    static List<EventEventQuestion__c> CreateFakeEventEventQuestionList(Id eventQuestionId, Id eventId) {
        return new List<EventEventQuestion__c> {
                CreateFakeEventEventQuestion(eventQuestionId, eventId)
        };
    }
    
    static Id CreateFakeEventQuestionId() {
        return fflib_IDGenerator.generate(EventQuestion__c.SObjectType);
    }
    
    static Id CreateFakeEventId() {
        return fflib_IDGenerator.generate(Event__c.SObjectType);    
    }
}