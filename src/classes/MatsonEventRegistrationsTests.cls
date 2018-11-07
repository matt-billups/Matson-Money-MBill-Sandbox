@isTest
public class MatsonEventRegistrationsTests {
    static testMethod void givenCleanseDataExpectCorrectFieldsToBeCleansed() {

        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_SobjectUnitOfWork mockUow =
                (fflib_SobjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        List<Event_Registration__c> listOfFakeEventRegistrations = FakeEventRegistrations();
        MatsonEventRegistrations sut = (MatsonEventRegistrations)MatsonEventRegistrations.newInstance(listOfFakeEventRegistrations);

        Application.UnitOfWork.setMock(mockUow);

        // When
        sut.cleanseData();

        // Then
        ((fflib_SobjectUnitOfWork)mocks.verify(mockUow, listOfFakeEventRegistrations.size())).registerDirty(fflib_Match.sObjectOfType(Event_Registration__c.SObjectType));

        for(Event_Registration__c evtReg : (List<Event_Registration__c>)sut.Records) {
            System.assertEquals('scrubbedadviseremail@example.com', evtReg.Adviser_Email__c);
            System.assertEquals('scrubbedattendeeemail@example.com', evtReg.Attendee_Email__c);
        }
    }

    static List<Event_Registration__c> FakeEventRegistrations() {
        return new List<Event_Registration__c> {
            getFakeEventRegistration(),
            getFakeEventRegistration()
        };
    }

    static Event_Registration__c getFakeEventRegistration() {
        return (Event_Registration__c)new sfab_FabricatedSObject(Event_Registration__c.class)
                .setField(Event_Registration__c.Id, fflib_IDGenerator.generate(Event_Registration__c.SObjectType))
            	.setField(Event_Registration__c.Event__c, fflib_IDGenerator.generate(Event__c.SObjectType))
            	.setField(Event_Registration__c.Contact__c, fflib_IDGenerator.generate(Contact.SObjectType))
            	.setField(Event_Registration__c.Adviser_Email__c, 'test@example.com')
            	.setField(Event_Registration__c.Attendee_Email__c, 'test@example.com')
                .setField(Event_Registration__c.Registration_Site_Token__c, '').toSObject();
    }
}