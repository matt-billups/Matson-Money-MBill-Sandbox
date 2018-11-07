@IsTest
private class CleanseDataWorkerTests {

    static testMethod void givenCleanseWhenNoIdsExpectNoRecordsCleansed() {

        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_SobjectUnitOfWork mockUow = (fflib_SobjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        Integer expectedNumberOfCleanseDataCalls = 0;
        Integer expectedNumberOfUowCommits = 0;
        String advisersSelectAllQuery = 'SELECT Id FROM Adviser__c';
        Advisers mockAdvisers = (Advisers)mocks.mock(Advisers.class);
        CleanseDataWorker sut = new CleanseDataWorker();
        
        Application.Domain.setMock(mockAdvisers);
        Application.UnitOfWork.setMock(mockUow);

        // When
        Test.startTest();
        sut.cleanse(advisersSelectAllQuery, '');
        Test.stopTest();

        // Then
        ((Advisers)mocks.verify(mockAdvisers, expectedNumberOfCleanseDataCalls)).cleanseData();
        ((fflib_ISObjectUnitOfWork)mocks.verify(mockUow, expectedNumberOfUowCommits)).commitWork();
    }

    static testMethod void givenCleanseExpectRecordsToBeCleansed() {

        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_SobjectUnitOfWork mockUow = (fflib_SobjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        Integer expectedNumberOfCleanseDataCalls = 1;
        Integer expectedNumberOfUowCommits = 0;
        String advisersSelectAllQuery = 'SELECT Id FROM Adviser__c';
        IAdvisersSelector mockAdvisersSelector = (IAdvisersSelector)mocks.mock(AdvisersSelector.class);
        Advisers mockAdvisers = (Advisers)mocks.mock(Advisers.class);
        CleanseDataWorker sut = new CleanseDataWorker();
        
        Contact contact = createContact();
        Adviser__c adviser = createAdviser(contact);

        mocks.startStubbing();
        mocks.when(mockAdvisers.sObjectType()).thenReturn(Adviser__c.SObjectType);
        mocks.when(mockAdvisersSelector.sObjectType()).thenReturn(Adviser__c.SObjectType);
        mocks.when(mockAdvisersSelector.selectSObjectsById(FakeSetOfAdviserIds())).thenReturn(FakeAdvisers());
        mocks.stopStubbing();

        Application.Domain.setMock(mockAdvisers);
        Application.Selector.setMock(mockAdvisersSelector);
        Application.UnitOfWork.setMock(mockUow);

        // When
        Test.startTest();
        sut.cleanse(advisersSelectAllQuery, '');
        Test.stopTest();

        // Then
        ((Advisers)mocks.verify(mockAdvisers, expectedNumberOfCleanseDataCalls)).cleanseData();
        ((fflib_ISObjectUnitOfWork)mocks.verify(mockUow, expectedNumberOfUowCommits)).commitWork();
    }
    
    static testMethod void givenCleanseWithDependentCleanExpectRecordsToBeCleansedTwice() {

        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_SobjectUnitOfWork mockUow = (fflib_SobjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        Integer expectedNumberOfCleanseDataCalls = 1;
        Integer expectedNumberOfUowCommits = 0;
        String contactsSelectAllQuery = 'SELECT Id FROM Contact';
        String advisersSelectAllQuery = 'SELECT Id FROM Adviser__c';
        IContactsSelector mockContactsSelector = (IContactsSelector)mocks.mock(ContactsSelector.class);
        IAdvisersSelector mockAdvisersSelector = (IAdvisersSelector)mocks.mock(AdvisersSelector.class);
        Contacts mockContacts = (Contacts)mocks.mock(Contacts.class);
        Advisers mockAdvisers = (Advisers)mocks.mock(Advisers.class);
        CleanseDataWorker sut = new CleanseDataWorker();
        
        Contact contactObj = createContact();
        Adviser__c adviser = createAdviser(contactObj);

        mocks.startStubbing();
        mocks.when(mockContacts.sObjectType()).thenReturn(Contact.SObjectType);
        mocks.when(mockContactsSelector.sObjectType()).thenReturn(Contact.SObjectType);
        mocks.when(mockContactsSelector.selectSObjectsById(FakeSetOfContactIds())).thenReturn(FakeContacts());
        mocks.when(mockAdvisers.sObjectType()).thenReturn(Adviser__c.SObjectType);
        mocks.when(mockAdvisersSelector.sObjectType()).thenReturn(Adviser__c.SObjectType);
        mocks.when(mockAdvisersSelector.selectSObjectsById(FakeSetOfAdviserIds())).thenReturn(FakeAdvisers());
        mocks.stopStubbing();

        Application.Domain.setMock(mockContacts);
        Application.Selector.setMock(mockContactsSelector);
        Application.Domain.setMock(mockAdvisers);
        Application.Selector.setMock(mockAdvisersSelector);
        Application.UnitOfWork.setMock(mockUow);

        // When
        Test.startTest();
        sut.cleanse(contactsSelectAllQuery, advisersSelectAllQuery);
        Test.stopTest();

        // Then
        ((Contacts)mocks.verify(mockContacts, expectedNumberOfCleanseDataCalls)).cleanseData();
        ((Advisers)mocks.verify(mockAdvisers, expectedNumberOfCleanseDataCalls)).cleanseData();
        ((fflib_ISObjectUnitOfWork)mocks.verify(mockUow, expectedNumberOfUowCommits)).commitWork();
    }

    static Set<Id> FakeSetOfAdviserIds() {
        return new Set<Id> {
                fflib_IDGenerator.generate(Adviser__c.SObjectType),
                fflib_IDGenerator.generate(Adviser__c.SObjectType)
        };
    }
    
    static Set<Id> FakeSetOfContactIds() {
        return new Set<Id> {
                fflib_IDGenerator.generate(Contact.SObjectType),
                fflib_IDGenerator.generate(Contact.SObjectType)
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