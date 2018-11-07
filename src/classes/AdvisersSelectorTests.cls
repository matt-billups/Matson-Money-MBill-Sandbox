/**
 * Created by Brian.Broughton on 2/26/2018.
 */

@IsTest
private class AdvisersSelectorTests {

    private static testMethod void givenNewInstanceExpectCorrectSelector() {

        // When
        Object selector = AdvisersSelector.newInstance();

        // Then
        System.assert(selector instanceof IAdvisersSelector);
    }

    private static testMethod void givenGetSObjectTypeExpectAdviserc() {

        // Given
        AdvisersSelector sut = new AdvisersSelector();
        SObjectType expectedType = Adviser__c.SObjectType;

        // When
        SObjectType actualType = sut.getSObjectType();

        // Then
        System.assertEquals(expectedType, actualType);
    }

    private static testMethod void givenGetSObjectFieldListExpectCorrectFields() {

        // Given
        AdvisersSelector sut = new AdvisersSelector();
        List<Schema.SObjectField> expectedFields = new List<Schema.SObjectField> {
                Adviser__c.Id,
                Adviser__c.Name_on_Credit_Card__c,
                Adviser__c.Credit_Card_Number__c,
                Adviser__c.Credit_Card_Expiration__c,
                Adviser__c.Assistant_Email__c,
                Adviser__c.Transfer_Email__c,
                Adviser__c.Status__c
        };

        // When
        List<Schema.SObjectField> actualFields = sut.getSObjectFieldList();

        // Then
        System.assertEquals(expectedFields, actualFields);
    }
    
    private static testMethod void givenSelectByIdExpectAdvisers() {
        // Given
        Contact contact = createContact();
        Adviser__c adviser = createAdviser(contact);
        AdvisersSelector sut = new AdvisersSelector();
        
        // When
        List<Adviser__c> returnedAdvisers = sut.selectById(new Set<Id> { adviser.Id });
        
        // Then
        System.assertEquals(1, returnedAdvisers.size());
        System.assertEquals(adviser.Name_on_Credit_Card__c, returnedAdvisers[0].Name_on_Credit_Card__c);
    }
    
    private static testMethod void givenGetSelectAllQueryExpectNonBlankQuery() {
        // Given
        AdvisersSelector sut = new AdvisersSelector();
        
        // When
        String actualQuery = sut.getSelectAllQuery();
        
        // Then
        System.assert(actualQuery.contains('FROM Adviser__c'));
    }
    
    private static Contact createContact() {
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'McTest';
        con.Email = 'test.mctest@example.com';
        con.MailingStreet = '5955 Deerfield Blvd';
        con.MailingCity = 'Mason';
        con.MailingState = 'Ohio';
        con.MailingPostalCode = '45040';
        
        insert con;
        return con;
    }
    
    private static Adviser__c createAdviser(Contact contact) {
        Adviser__c adv = new Adviser__c();
        adv.Primary_Contact__c = contact.Id;
        adv.Name_on_Credit_Card__c = 'Test McTest';
        adv.Credit_Card_Number__c = '1234567891234567';
        adv.Credit_Card_Expiration__c = '01/2030';
        adv.Assistant_Email__c = 'assistant@example.com';
        adv.Transfer_Email__c = 'transfer@example.com';
        adv.Status__c = 'Active Adviser';
        adv.Designation__c = 'RIA';
        adv.Firm_ID__c = '1234';
        adv.Service_Team__c = '1';
        
        insert adv;
        return adv;
    }
}