@IsTest
private class AdvisersTests {

    static testMethod void givenCleanseDataExpectCorrectFieldsToBeCleansed() {

        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_SobjectUnitOfWork mockUow =
                (fflib_SobjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        List<Adviser__c> listOfFakeAdvisers = FakeAdvisers();
        Advisers sut = (Advisers)Application.Domain.newInstance(listOfFakeAdvisers);
        
        Application.UnitOfWork.setMock(mockUow);

        // When
        sut.cleanseData();
        
        // Then
        ((fflib_SobjectUnitOfWork)mocks.verify(mockUow, listOfFakeAdvisers.size())).registerDirty(fflib_Match.sObjectOfType(Adviser__c.SObjectType));
        
        for(Adviser__c adviser : (List<Adviser__c>)sut.Records) {
            System.assert(String.isBlank(adviser.Credit_Card_Number__c));
            System.assert(String.isBlank(adviser.Credit_Card_Expiration__c));
            System.assert(String.isBlank(adviser.Name_on_Credit_Card__c));
            System.assertEquals('scrubbedassistantemail@example.com', adviser.Assistant_Email__c);
            System.assertEquals('scrubbedtransferemail@example.com', adviser.Transfer_Email__c);
        }
    }

    static List<Adviser__c> FakeAdvisers() {
        return new List<Adviser__c> {
                getFakeAdviser(),
                getFakeAdviser()
        };
    }

    static Adviser__c getFakeAdviser() {
        return (Adviser__c)new sfab_FabricatedSObject(Adviser__c.class)
                .setField(Adviser__c.Id, fflib_IDGenerator.generate(Adviser__c.SObjectType))
                .setField(Adviser__c.Name_on_Credit_Card__c, 'Frank Jones')
                .setField(Adviser__c.Credit_Card_Number__c, '123456566')
                .setField(Adviser__c.Credit_Card_Expiration__c, '11/2019')
            	.setField(Adviser__c.Assistant_Email__c, 'assistant@example.com')
            	.setField(Adviser__c.Transfer_Email__c, 'transfer@example.com').toSObject();
    }
}