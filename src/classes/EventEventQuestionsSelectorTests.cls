@isTest
public with sharing class EventEventQuestionsSelectorTests {

    private static testMethod void givenGetSObjectTypeExpectEventEventQuestions() {

        // Given
        EventEventQuestionsSelector sut = new EventEventQuestionsSelector();
        SObjectType expectedType = EventEventQuestion__c.SObjectType;

        // When
        SObjectType actualType = sut.getSObjectType();

        // Then
        System.assertEquals(expectedType, actualType);
        
    }

    private static testMethod void givenGetSObjectFieldListExpectCorrectFields() {

        // Given
        EventEventQuestionsSelector sut = new EventEventQuestionsSelector();
        List<Schema.SObjectField> expectedFields = new List<Schema.SObjectField> {
                EventEventQuestion__c.Id
        };

        // When
        List<Schema.SObjectField> actualFields = sut.getSObjectFieldList();

        // Then
        System.assertEquals(expectedFields, actualFields);
        
    }

}