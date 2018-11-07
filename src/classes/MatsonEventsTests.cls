@isTest
public class MatsonEventsTests {
    static testMethod void givenOnBeforeInsertExpectPopulateHouseAccountSiteToken() {
        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        List<Event__c> listOfFakeEvents = FakeEvents();
        ISettingsHelperService mockedSettingsHelperService = (ISettingsHelperService)mocks.mock(ISettingsHelperService.class);
        MatsonEvents sut = (MatsonEvents)MatsonEvents.newInstance(listOfFakeEvents);
        
        mocks.startStubbing();
        mocks.when(mockedSettingsHelperService.HouseAccountContactId()).thenReturn(fflib_IDGenerator.generate(Contact.SObjectType));
        mocks.when(mockedSettingsHelperService.CreateEventToken(fflib_Match.anyString())).thenReturn('token');
        mocks.stopStubbing();
        
        Application.Service.setMock(ISettingsHelperService.class, mockedSettingsHelperService);
        
        // When
        Test.startTest();
        sut.onBeforeInsert();
        Test.stopTest();
        
        // Then
        for (Event__c evt : listOfFakeEvents) {
            System.assertEquals('token', evt.House_Account_Site_Token__c);
        }
    }
    
    static testMethod void givenOnBeforeUpdateExpectPopulateHouseAccountSiteToken() {
        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        List<Event__c> listOfFakeEvents = FakeEvents();
        ISettingsHelperService mockedSettingsHelperService = (ISettingsHelperService)mocks.mock(ISettingsHelperService.class);
        MatsonEvents sut = (MatsonEvents)MatsonEvents.newInstance(listOfFakeEvents);
        
        mocks.startStubbing();
        mocks.when(mockedSettingsHelperService.HouseAccountContactId()).thenReturn(fflib_IDGenerator.generate(Contact.SObjectType));
        mocks.when(mockedSettingsHelperService.CreateEventToken(fflib_Match.anyString())).thenReturn('token');
        mocks.stopStubbing();
        
        Application.Service.setMock(ISettingsHelperService.class, mockedSettingsHelperService);
        
        // When
        Test.startTest();
        sut.onBeforeUpdate(new Map<Id, SObject>());
        Test.stopTest();
        
        // Then
        // There is no House Account Contact ID in the settings, so the token should be null
        for (Event__c evt : listOfFakeEvents) {
            System.assertEquals('token', evt.House_Account_Site_Token__c);
        }
    }
    
    static List<Event__c> FakeEvents() {
        return new List<Event__c> {
            getFakeEvent(),
            getFakeEvent()
        };
    }
    
    static Event__c getFakeEvent() {
        return (Event__c)new sfab_FabricatedSObject(Event__c.class)
                .setField(Event__c.Id, fflib_IDGenerator.generate(Event__c.SObjectType))
                .setField(Event__c.House_Account_Site_Token__c, '').toSObject();
    }
}