@isTest
public class UpcomingEventsGraphControllerTests {
    static List<String> internalEventNames = new List<String> {'Test Internal 1', 'Test Internal 2', 'Test Internal 3'};

    static testMethod void givenGetChartDataExpectChartData() {
        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IMatsonEventRegistrationsSelector mockedMatsonEventRegistrationsSelector = (IMatsonEventRegistrationsSelector)mocks.mock(MatsonEventRegistrationsSelector.class);
        IMatsonEventsSelector mockedMatsonEventsSelector = (IMatsonEventsSelector)mocks.mock(MatsonEventsSelector.class);

        Set<Id> fakeSetOfEventRegistrationIds = FakeSetOfEventRegistrationIds();
        Set<Id> fakeSetOfEventIds = FakeSetOfEventIds();
        List<Event_Registration__c> listOfFakeEventRegistrations = FakeEventRegistrations(new List<Id>(fakeSetOfEventRegistrationIds), new List<Id>(fakeSetOfEventIds));

        mocks.startStubbing();
        mocks.when(mockedMatsonEventRegistrationsSelector.sObjectType()).thenReturn(Event_Registration__c.SObjectType);
        mocks.when(mockedMatsonEventRegistrationsSelector.selectSObjectsById(fakeSetOfEventRegistrationIds)).thenReturn(listOfFakeEventRegistrations);
        mocks.when(mockedMatsonEventRegistrationsSelector.selectFutureRegistrationsWithEventFields()).thenReturn(listOfFakeEventRegistrations);
        mocks.when(mockedMatsonEventsSelector.sObjectType()).thenReturn(Event__c.SObjectType);
        mocks.when(mockedMatsonEventsSelector.selectSObjectsById(fakeSetOfEventIds)).thenReturn(FakeEvents(new List<Id>(fakeSetOfEventIds), internalEventNames));
        mocks.stopStubbing();

        Application.Selector.setMock(mockedMatsonEventRegistrationsSelector);
        Application.Selector.setMock(mockedMatsonEventsSelector);

        // When
        Test.startTest();
        UpcomingEventsGraphController.chartData data = UpcomingEventsGraphController.getChartData();
        Test.stopTest();

        // Then
        System.assertEquals(3, data.eventNames.size());
        System.assertEquals(3, data.statuses.size());
    }

    private static Set<Id> FakeSetOfEventRegistrationIds() {
        return new Set<Id> {
                fflib_IDGenerator.generate(Event_Registration__c.SObjectType),
                fflib_IDGenerator.generate(Event_Registration__c.SObjectType),
                fflib_IDGenerator.generate(Event_Registration__c.SObjectType),
                fflib_IDGenerator.generate(Event_Registration__c.SObjectType)
        };
    }

    private static List<Event_Registration__c> FakeEventRegistrations(List<Id> idList, List<Id> eventIdList) {
        return new List<Event_Registration__c> {
                getFakeEventRegistration(idList[0], 'Invited', eventIdList[0], internalEventNames[0]),
                getFakeEventRegistration(idList[1], 'Registered', eventIdList[0], internalEventNames[0]),
                getFakeEventRegistration(idList[2], 'Registered', eventIdList[1], internalEventNames[1]),
                getFakeEventRegistration(idList[3], 'Cancelled', eventIdList[2], internalEventNames[2])
        };
    }

    private static Event_Registration__c getFakeEventRegistration(Id regId, String status, Id evtId, String eventName) {
        return (Event_Registration__c)new sfab_FabricatedSObject(Event_Registration__c.class)
                .setField(Event_Registration__c.Id, regId)
                .setField(Event_Registration__c.Status__c, status)
                .setParent('Event__r', getFakeEvent(evtId, eventName)).toSObject();
    }

    private static Set<Id> FakeSetOfEventIds() {
        return new Set<Id> {
                fflib_IDGenerator.generate(Event__c.SObjectType),
                fflib_IDGenerator.generate(Event__c.SObjectType),
                fflib_IDGenerator.generate(Event__c.SObjectType)
        };
    }

    private static List<Event__c> FakeEvents(List<Id> idList, List<String> eventNames) {
        return new List<Event__c> {
                (Event__c)getFakeEvent(idList[0], eventNames[0]).toSObject(),
                (Event__c)getFakeEvent(idList[1], eventNames[1]).toSObject(),
                (Event__c)getFakeEvent(idList[2], eventNames[2]).toSObject()
        };
    }

    private static sfab_FabricatedSObject getFakeEvent(Id evtId, String internalEventName) {
        return new sfab_FabricatedSObject(Event__c.class)
                .setField(Event__c.Id, evtId)
                .setField(Event__c.Internal_Event_Name__c, internalEventName);
    }
}