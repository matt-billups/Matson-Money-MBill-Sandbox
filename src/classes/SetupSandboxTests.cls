@isTest
public class SetupSandboxTests {

    private static testMethod void givenRunApexClassExpectSetupTasks() {

        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        SetupSandbox sut = new SetupSandbox();

        IDataCleansingService mockDataCleansingService = (IDataCleansingService)mocks.mock(IDataCleansingService.class);
        IAdvisersSelector mockedAdvisersSelector = (IAdvisersSelector)mocks.mock(AdvisersSelector.class);
        IContactsSelector mockedContactsSelector = (IContactsSelector)mocks.mock(ContactsSelector.class);
        IMatsonEventRegistrationsSelector mockedEventRegistrationsSelector = (IMatsonEventRegistrationsSelector)mocks.mock(MatsonEventRegistrationsSelector.class);
        IMatsonEventsSelector mockedEventsSelector = (IMatsonEventsSelector)mocks.mock(MatsonEventsSelector.class);
        fflib_SobjectUnitOfWork mockUow = (fflib_SobjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        ISettingsHelperService mockedSettingsHelperService = (ISettingsHelperService)mocks.mock(ISettingsHelperService.class);

        mocks.startStubbing();
        mocks.when(mockedAdvisersSelector.sObjectType()).thenReturn(Adviser__c.SObjectType);
        mocks.when(mockedAdvisersSelector.selectSObjectsById(FakeSetOfAdviserIds())).thenReturn(FakeAdvisers());
        mocks.when(mockedAdvisersSelector.getSelectAllQuery()).thenReturn(FakeAdviserSelectAllQuery());
        mocks.when(mockedContactsSelector.sObjectType()).thenReturn(Contact.SObjectType);
        mocks.when(mockedContactsSelector.selectSObjectsById(FakeSetOfContactIds())).thenReturn(FakeContacts());
        mocks.when(mockedContactsSelector.getSelectAllQuery()).thenReturn(FakeContactSelectAllQuery());
        mocks.when(mockedContactsSelector.selectByName('House', 'Account')).thenReturn(new List<Contact>());
        mocks.when(mockedEventRegistrationsSelector.sObjectType()).thenReturn(Event_Registration__c.SObjectType);
        mocks.when(mockedEventRegistrationsSelector.selectSObjectsById(FakeSetOfEventRegistrationIds())).thenReturn(FakeEventRegistrations());
        mocks.when(mockedEventRegistrationsSelector.getSelectAllQuery()).thenReturn(FakeEventRegistrationSelectAllQuery());
        mocks.when(mockedEventsSelector.sObjectType()).thenReturn(Event__c.SObjectType);
        mocks.when(mockedEventsSelector.selectSObjectsById(FakeSetOfEventIds())).thenReturn(FakeEvents());
        mocks.when(mockedEventsSelector.selectFutureEvents()).thenReturn(FakeEvents());
        mocks.when(mockedSettingsHelperService.HouseAccountContactId()).thenReturn(fflib_IDGenerator.generate(Contact.SObjectType));
        mocks.when(mockedSettingsHelperService.CreateEventToken(fflib_Match.anyString())).thenReturn('token');
        mocks.stopStubbing();

        Application.Selector.setMock(mockedAdvisersSelector);
        PhoenixCore.Selector.setMock(mockedContactsSelector);
        Application.Selector.setMock(mockedEventRegistrationsSelector);
        Application.Selector.setMock(mockedEventsSelector);
        Application.Service.setMock(IDataCleansingService.class, mockDataCleansingService);
        Application.Service.setMock(ISettingsHelperService.class, mockedSettingsHelperService);
        Application.UnitOfWork.setMock(mockUow);

        // When
        Test.startTest();

        Test.testSandboxPostCopyScript(sut, UserInfo.getOrganizationId(),
                UserInfo.getOrganizationId(), UserInfo.getOrganizationName());

        Test.stopTest();

        // Then
        ((IDataCleansingService)mocks.verify(mockDataCleansingService, 1)).cleanse(FakeAdviserSelectAllQuery(), '');
        ((IDataCleansingService)mocks.verify(mockDataCleansingService, 1)).cleanse(FakeContactSelectAllQuery(), FakeEventRegistrationSelectAllQuery());
        ((ISettingsHelperService)mocks.verify(mockedSettingsHelperService, 1)).UpdateHouseAccountContactId(null);
        ((fflib_SobjectUnitOfWork)mocks.verify(mockUow, 3)).commitWork();
    }
    
    private static testMethod void givenRunApexClassAndExistingHouseAccountContactExpectSetupTasks() {

        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        SetupSandbox sut = new SetupSandbox();

        IDataCleansingService mockDataCleansingService = (IDataCleansingService)mocks.mock(IDataCleansingService.class);
        IAdvisersSelector mockedAdvisersSelector = (IAdvisersSelector)mocks.mock(AdvisersSelector.class);
        IContactsSelector mockedContactsSelector = (IContactsSelector)mocks.mock(ContactsSelector.class);
        IMatsonEventRegistrationsSelector mockedEventRegistrationsSelector = (IMatsonEventRegistrationsSelector)mocks.mock(MatsonEventRegistrationsSelector.class);
        IMatsonEventsSelector mockedEventsSelector = (IMatsonEventsSelector)mocks.mock(MatsonEventsSelector.class);
        fflib_SobjectUnitOfWork mockUow = (fflib_SobjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        ISettingsHelperService mockedSettingsHelperService = (ISettingsHelperService)mocks.mock(ISettingsHelperService.class);

        mocks.startStubbing();
        mocks.when(mockedAdvisersSelector.sObjectType()).thenReturn(Adviser__c.SObjectType);
        mocks.when(mockedAdvisersSelector.selectSObjectsById(FakeSetOfAdviserIds())).thenReturn(FakeAdvisers());
        mocks.when(mockedAdvisersSelector.getSelectAllQuery()).thenReturn(FakeAdviserSelectAllQuery());
        mocks.when(mockedContactsSelector.sObjectType()).thenReturn(Contact.SObjectType);
        mocks.when(mockedContactsSelector.selectSObjectsById(FakeSetOfContactIds())).thenReturn(FakeContacts());
        mocks.when(mockedContactsSelector.getSelectAllQuery()).thenReturn(FakeContactSelectAllQuery());
        mocks.when(mockedContactsSelector.selectByName('House', 'Account')).thenReturn(new List<Contact> { getFakeHouseAccountContact() });
        mocks.when(mockedEventRegistrationsSelector.sObjectType()).thenReturn(Event_Registration__c.SObjectType);
        mocks.when(mockedEventRegistrationsSelector.selectSObjectsById(FakeSetOfEventRegistrationIds())).thenReturn(FakeEventRegistrations());
        mocks.when(mockedEventRegistrationsSelector.getSelectAllQuery()).thenReturn(FakeEventRegistrationSelectAllQuery());
        mocks.when(mockedEventsSelector.sObjectType()).thenReturn(Event__c.SObjectType);
        mocks.when(mockedEventsSelector.selectSObjectsById(FakeSetOfEventIds())).thenReturn(FakeEvents());
        mocks.when(mockedEventsSelector.selectFutureEvents()).thenReturn(FakeEvents());
        mocks.when(mockedSettingsHelperService.HouseAccountContactId()).thenReturn(fflib_IDGenerator.generate(Contact.SObjectType));
        mocks.when(mockedSettingsHelperService.CreateEventToken(fflib_Match.anyString())).thenReturn('token');
        mocks.stopStubbing();

        Application.Selector.setMock(mockedAdvisersSelector);
        PhoenixCore.Selector.setMock(mockedContactsSelector);
        Application.Selector.setMock(mockedEventRegistrationsSelector);
        Application.Selector.setMock(mockedEventsSelector);
        Application.Service.setMock(IDataCleansingService.class, mockDataCleansingService);
        Application.Service.setMock(ISettingsHelperService.class, mockedSettingsHelperService);
        Application.UnitOfWork.setMock(mockUow);

        // When
        Test.startTest();

        Test.testSandboxPostCopyScript(sut, UserInfo.getOrganizationId(),
                UserInfo.getOrganizationId(), UserInfo.getOrganizationName());

        Test.stopTest();

        // Then
        ((IDataCleansingService)mocks.verify(mockDataCleansingService, 1)).cleanse(FakeAdviserSelectAllQuery(), '');
        ((IDataCleansingService)mocks.verify(mockDataCleansingService, 1)).cleanse(FakeContactSelectAllQuery(), FakeEventRegistrationSelectAllQuery());
        ((ISettingsHelperService)mocks.verify(mockedSettingsHelperService, 1)).UpdateHouseAccountContactId(fflib_Match.anyId());
        ((fflib_SobjectUnitOfWork)mocks.verify(mockUow, 1)).commitWork();
    }
    
    private static testMethod void givenRunSetupAndExistingHouseAccountContactExpectSetupTasks() {

        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        SetupSandbox sut = new SetupSandbox();

        IDataCleansingService mockDataCleansingService = (IDataCleansingService)mocks.mock(IDataCleansingService.class);
        IAdvisersSelector mockedAdvisersSelector = (IAdvisersSelector)mocks.mock(AdvisersSelector.class);
        IContactsSelector mockedContactsSelector = (IContactsSelector)mocks.mock(ContactsSelector.class);
        IMatsonEventRegistrationsSelector mockedEventRegistrationsSelector = (IMatsonEventRegistrationsSelector)mocks.mock(MatsonEventRegistrationsSelector.class);
        IMatsonEventsSelector mockedEventsSelector = (IMatsonEventsSelector)mocks.mock(MatsonEventsSelector.class);
        fflib_SobjectUnitOfWork mockUow = (fflib_SobjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        ISettingsHelperService mockedSettingsHelperService = (ISettingsHelperService)mocks.mock(ISettingsHelperService.class);

        mocks.startStubbing();
        mocks.when(mockedAdvisersSelector.sObjectType()).thenReturn(Adviser__c.SObjectType);
        mocks.when(mockedAdvisersSelector.selectSObjectsById(FakeSetOfAdviserIds())).thenReturn(FakeAdvisers());
        mocks.when(mockedAdvisersSelector.getSelectAllQuery()).thenReturn(FakeAdviserSelectAllQuery());
        mocks.when(mockedContactsSelector.sObjectType()).thenReturn(Contact.SObjectType);
        mocks.when(mockedContactsSelector.selectSObjectsById(FakeSetOfContactIds())).thenReturn(FakeContacts());
        mocks.when(mockedContactsSelector.getSelectAllQuery()).thenReturn(FakeContactSelectAllQuery());
        mocks.when(mockedContactsSelector.selectByName('House', 'Account')).thenReturn(new List<Contact> { getFakeHouseAccountContact() });
        mocks.when(mockedEventRegistrationsSelector.sObjectType()).thenReturn(Event_Registration__c.SObjectType);
        mocks.when(mockedEventRegistrationsSelector.selectSObjectsById(FakeSetOfEventRegistrationIds())).thenReturn(FakeEventRegistrations());
        mocks.when(mockedEventRegistrationsSelector.getSelectAllQuery()).thenReturn(FakeEventRegistrationSelectAllQuery());
        mocks.when(mockedEventsSelector.sObjectType()).thenReturn(Event__c.SObjectType);
        mocks.when(mockedEventsSelector.selectSObjectsById(FakeSetOfEventIds())).thenReturn(FakeEvents());
        mocks.when(mockedEventsSelector.selectFutureEvents()).thenReturn(FakeEvents());
        mocks.when(mockedSettingsHelperService.HouseAccountContactId()).thenReturn(fflib_IDGenerator.generate(Contact.SObjectType));
        mocks.when(mockedSettingsHelperService.CreateEventToken(fflib_Match.anyString())).thenReturn('token');
        mocks.stopStubbing();

        Application.Selector.setMock(mockedAdvisersSelector);
        PhoenixCore.Selector.setMock(mockedContactsSelector);
        Application.Selector.setMock(mockedEventRegistrationsSelector);
        Application.Selector.setMock(mockedEventsSelector);
        Application.Service.setMock(IDataCleansingService.class, mockDataCleansingService);
        Application.Service.setMock(ISettingsHelperService.class, mockedSettingsHelperService);
        Application.UnitOfWork.setMock(mockUow);

        // When
        Test.startTest();
        sut.runSetup(true);
        Test.stopTest();

        // Then
        ((IDataCleansingService)mocks.verify(mockDataCleansingService, 1)).cleanse(FakeAdviserSelectAllQuery(), '');
        ((IDataCleansingService)mocks.verify(mockDataCleansingService, 1)).cleanse(FakeContactSelectAllQuery(), FakeEventRegistrationSelectAllQuery());
        ((ISettingsHelperService)mocks.verify(mockedSettingsHelperService, 1)).UpdateHouseAccountContactId(fflib_Match.anyId());
        ((fflib_SobjectUnitOfWork)mocks.verify(mockUow, 1)).commitWork();
    }

    private static Set<Id> FakeSetOfAdviserIds() {
        return new Set<Id> {
                fflib_IDGenerator.generate(Adviser__c.SObjectType),
                fflib_IDGenerator.generate(Adviser__c.SObjectType)
        };
    }

    private static List<Adviser__c> FakeAdvisers() {
        return new List<Adviser__c> {
                getFakeAdviser(),
                getFakeAdviser()
        };
    }

    private static Adviser__c getFakeAdviser() {
        return (Adviser__c)new sfab_FabricatedSObject(Adviser__c.class)
                .setField(Adviser__c.Id, fflib_IDGenerator.generate(Adviser__c.SObjectType)).toSObject();
    }
    
    private static Set<Id> FakeSetOfContactIds() {
        return new Set<Id> {
                fflib_IDGenerator.generate(Contact.SObjectType),
                fflib_IDGenerator.generate(Contact.SObjectType)
        };
    }

    private static List<Contact> FakeContacts() {
        return new List<Contact> {
                getFakeContact(),
                getFakeContact()
        };
    }

    private static Contact getFakeContact() {
        return (Contact)new sfab_FabricatedSObject(Contact.class)
                .setField(Contact.Id, fflib_IDGenerator.generate(Contact.SObjectType)).toSObject();
    }
    
    private static Set<Id> FakeSetOfEventRegistrationIds() {
        return new Set<Id> {
                fflib_IDGenerator.generate(Event_Registration__c.SObjectType),
                fflib_IDGenerator.generate(Event_Registration__c.SObjectType)
        };
    }

    private static List<Event_Registration__c> FakeEventRegistrations() {
        return new List<Event_Registration__c> {
                getFakeEventRegistration(),
                getFakeEventRegistration()
        };
    }

    private static Event_Registration__c getFakeEventRegistration() {
        return (Event_Registration__c)new sfab_FabricatedSObject(Event_Registration__c.class)
                .setField(Event_Registration__c.Id, fflib_IDGenerator.generate(Event_Registration__c.SObjectType)).toSObject();
    }
    
    private static Set<Id> FakeSetOfEventIds() {
        return new Set<Id> {
                fflib_IDGenerator.generate(Event__c.SObjectType),
                fflib_IDGenerator.generate(Event__c.SObjectType)
        };
    }

    private static List<Event__c> FakeEvents() {
        return new List<Event__c> {
                getFakeEvent(),
                getFakeEvent()
        };
    }

    private static Event__c getFakeEvent() {
        return (Event__c)new sfab_FabricatedSObject(Event__c.class)
                .setField(Event__c.Id, fflib_IDGenerator.generate(Event__c.SObjectType)).toSObject();
    }
    
    private static String FakeAdviserSelectAllQuery() {
        return 'SELECT Id FROM Adviser__c';
    }
    
    private static String FakeContactSelectAllQuery() {
        return 'SELECT Id FROM Contact';
    }
    
    private static String FakeEventRegistrationSelectAllQuery() {
        return 'SELECT Id FROM Event_Registration__c';
    }
    
    private static Contact getFakeHouseAccountContact() {
        return (Contact)new sfab_FabricatedSObject(Contact.class)
                .setField(Contact.Id, fflib_IDGenerator.generate(Contact.SObjectType))
            	.setField(Contact.FirstName, 'House')
            	.setField(Contact.LastName, 'Account').toSObject();
    }
}