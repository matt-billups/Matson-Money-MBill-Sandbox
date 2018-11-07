@isTest
private class EventRegistrationExtControllerTests {
    
    static String templateName = 'some template name';
    static String folderName = 'some folder name';
    static String tableTentName = 'table tent';
    
    private static testMethod void givenHasSelectedRegistrationsWhenSelectedRecordsExpectTrue() {
        
        // Given
        List<Event_Registration__c> listOfFakeRegistrations = FakeRegistrations(false);
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(listOfFakeRegistrations);
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        sut.setController = setController;
        sut.setController.setSelected(listOfFakeRegistrations);
        
        // Then
        System.assertEquals(true, sut.hasSelectedRegistrations);
    }
    
    private static testMethod void givenHasSelectedRegistrationsWhenNoSelectedRecordsExpectFalse() {
        
        // Given
        List<Event_Registration__c> listOfFakeRegistrations = FakeRegistrations(false);
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(listOfFakeRegistrations);
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        sut.setController = setController;
        
        
        // Then
        System.assertEquals(false, sut.hasSelectedRegistrations);
    }
    
    private static testMethod void givenGetSelectedOrgWideEmailAddressIdExpectSelectedOrgWideEmailAddressId () {
        
        // Given
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        Id expectedId = fflib_IDGenerator.generate(OrgWideEmailAddress.SObjectType);
        
        // When
        sut.selectedOrgWideEmailAddressId = expectedId;
        
        // Then
        System.assertEquals(expectedId, sut.getSelectedOrgWideEmailAddressId());
    }
    
    private static testMethod void givenGetSelectedEmailTemplateFolderNameExpectFolderName () {
        
        // Given
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        
        
        // When
        sut.selectedEmailTemplateFolderName = folderName;
        
        
        // Then
        System.assertEquals(folderName, sut.getSelectedEmailTemplateFolderName());
    }
    
    private static testMethod void givenGetSelectedEmailTemplateExpectSelectedEmailTemplateName () {
        
        // Given
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        
        // When
        sut.selectedEmailTemplateName = templateName;
        
        // Then
        System.assertEquals(templateName, sut.getSelectedEmailTemplate());
    }
    
    private static testMethod void givenGetSelectedEmailTemplateBodyExpectSelectedEmailTemplateBody () {
        
        // Given
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        String expectedEmailBody = 'body here';
        
        // When
        sut.selectedEmailTemplateBody = expectedEmailBody;
        
        // Then
        System.assertEquals(expectedEmailBody, sut.getSelectedEmailTemplateBody());
    }
    
    private static testMethod void givenSetSelectedEmailFolder(){
        
        // Given
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        
        // When
        sut.setSelectedEmailTemplateFolderName(folderName);
        
        // Then
        System.assertEquals(folderName, sut.selectedEmailTemplateFolderName);
        
    }
    
    private static testMethod void givenIsFromAddressSelectedWhenSelectedExpectTrue () {
        
        // Given
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        
        // When
        sut.selectedOrgWideEmailAddressId = fflib_IDGenerator.generate(OrgWideEmailAddress.SObjectType);
        
        // Then
        System.assertEquals(true, sut.isFromAddressSelected);
    }
    
    private static testMethod void givenIsFromAddressSelectedWhenNotSelectedExpectFalse () {
        
        // Given
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        
        // When
        sut.selectedOrgWideEmailAddressId = null;
        
        // Then
        System.assertEquals(false, sut.isFromAddressSelected);
    }
    
    private static testMethod void givenIsTemplateSelectedWhenSelectedExpectTrue () {
        
        // Given
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        
        // When
        sut.selectedEmailTemplateName = templateName;
        
        // Then
        System.assertEquals(true, sut.isTemplateSelected);
    }
    
    private static testMethod void givenIsTemplateSelectedWhenNotSelectedExpectFalse () {
        
        // Given
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        
        // When
        sut.selectedEmailTemplateName = null;
        
        // Then
        System.assertEquals(false, sut.isTemplateSelected);
    }
    
    private static testMethod void givenIsEmailTemplateFolderSelectedTrue () {
        
        // Given
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        
        // When
        sut.selectedEmailTemplateFolderName = folderName;
        
        // Then
        System.assertEquals(true, sut.isEmailTemplateFolderSelected);
    }
    
    private static testMethod void givenIsEmailTemplateFolderSelectedFalse () {
        
        // Given
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        
        // When
        sut.selectedEmailTemplateFolderName = null;
        
        // Then
        System.assertEquals(false, sut.isEmailTemplateFolderSelected);
    }
    
    private static testMethod void givenSetSelectedEmailTemplateWhenNameIsNullExpectEmptyString() {
        
        // Given
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        
        // When
        sut.setSelectedEmailTemplate(null);
        
        // Then
        System.assertEquals('', sut.selectedEmailTemplateBody);
        
    }
    
    private static testMethod void givenGetEmailTemplateListItemsExpectListOfOptions() {
        
        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        List<SelectOption> expectedOptions = new List<SelectOption>();
        IEmailTemplatesSelector mockedTemplatesSelector = (IEmailTemplatesSelector)mocks.mock(IEmailTemplatesSelector.class);
        IEmailTemplateLookupTableSelector mockedEmailTemplateLookupTableSelector = (IEmailTemplateLookupTableSelector)mocks.mock(IEmailTemplateLookupTableSelector.class);
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        sut.selectedEmailTemplateFolderName = 'Matson Event Transactional Emails';
        
        mocks.startStubbing();
        mocks.when(mockedTemplatesSelector.sObjectType()).thenReturn(EmailTemplate.SObjectType);
        mocks.when(mockedEmailTemplateLookupTableSelector.SObjectType()).thenReturn(EmailTemplateLookupTable__c.SObjectType);
        mocks.when(mockedTemplatesSelector.selectByFolderName(sut.selectedEmailTemplateFolderName)).thenReturn(FakeTemplates());
        mocks.when(mockedEmailTemplateLookupTableSelector.selectByDeveloperName(templateName)).thenReturn(fakeEmailTemplateLookup(FakeTemplate(templateName), 'Transactional'));
        mocks.stopStubbing();
        
        Application.Selector.setMock(mockedTemplatesSelector);
        Application.Selector.setMock(mockedEmailTemplateLookupTableSelector);
        
        expectedOptions.add(new SelectOption('', '-- Please select an email template --'));
        
        for(EmailTemplate template : FakeTemplates()) {
            expectedOptions.add(new SelectOption(template.DeveloperName, template.Name));
        }
        
        // When
        List<SelectOption> options = sut.getEmailTemplateListItems();
        
        // Then
        System.assertEquals(expectedOptions, options);
    }
    
    private static testMethod void givenGetEmailTemplateFolderListItems() {
        
        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        List<SelectOption> expectedOptions = new List<SelectOption>();
        IFolderSelector mockedFolderSelector = (IFolderSelector)mocks.mock(IFolderSelector.class);
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        
        mocks.startStubbing();
        mocks.when(mockedFolderSelector.sObjectType()).thenReturn(Folder.SObjectType);
        mocks.when(mockedFolderSelector.selectByType('Email')).thenReturn(FakeFolders());
        mocks.stopStubbing();
        
        Application.Selector.setMock(mockedFolderSelector);
        
        expectedOptions.add(new SelectOption('', '-- Please select an email template folder --'));
        for(Folder emailFolder : FakeFolders()) {
            expectedOptions.add(new SelectOption(emailFolder.Name, emailFolder.Name));
        }
        
        // When
        List<SelectOption> options = sut.getEmailTemplateFolderListItems();
        
        // Then
        System.assertEquals(expectedOptions, options);
    }
    
    private static testMethod void givenGetEmailAddressListItemsExpectListOfOptions() {
        
        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        List<SelectOption> expectedOptions = new List<SelectOption>();
        List<OrgWideEmailAddress> listOfEmailAddresses = FakeOrgWideEmailAddresses();
        IOrgWideEmailAddressesSelector mockedEmailAddressSelector = (IOrgWideEmailAddressesSelector)mocks.mock(IOrgWideEmailAddressesSelector.class);
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        
        mocks.startStubbing();
        mocks.when(mockedEmailAddressSelector.sObjectType()).thenReturn(OrgWideEmailAddress.SObjectType);
        mocks.when(mockedEmailAddressSelector.selectAll()).thenReturn(listOfEmailAddresses);
        mocks.stopStubbing();
        
        Application.Selector.setMock(mockedEmailAddressSelector);
        
        expectedOptions.add(new SelectOption('', '-- Please select an email address --'));
        
        for(OrgWideEmailAddress address : listOfEmailAddresses) {
            expectedOptions.add(new SelectOption(address.Id, address.DisplayName));
        }
        
        // When
        List<SelectOption> options = sut.getEmailAddressListItems();
        
        // Then
        System.assertEquals(expectedOptions, options);
    }
    
    private static testMethod void givenSendProofToMeWhenNoRecordsExpectNoException() {
        
        // Given
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(new List<Event_Registration__c>());
        EventRegistrationExtController sut = new EventRegistrationExtController(setController);
        
        // When
        try {
            sut.sendProofToMe();
        }
        catch (Exception ex) {
            throw new fflib_Application.DeveloperException('Test failed. No exception should have been thrown.');
        }
    }
    
    private static testMethod void givenSendToSelectedWhenNoRecordsExpectNoException() {
        
        // Given
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(new List<Event_Registration__c>());
        EventRegistrationExtController sut = new EventRegistrationExtController(setController);
        
        // When
        try {
            sut.sendToSelected();
        }
        catch (Exception ex) {
            System.debug(ex);
            throw new fflib_Application.DeveloperException('Test failed. No exception should have been thrown.');
            
            
        }
    }
    
    private static testMethod void givenSendToAllWhenNoRecordsExpectNoException() {
        
        // Given
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(new List<Event_Registration__c>());
        EventRegistrationExtController sut = new EventRegistrationExtController(setController);
        
        // When
        try {
            sut.sendToAll();
        }
        catch (Exception ex) {
            throw new fflib_Application.DeveloperException('Test failed. No exception should have been thrown.');
        }
    }
    
    private static testMethod void givenSendProofToMeExpectEmailToBeSent() {
        
        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IEmailTemplatesSelector mockedTemplatesSelector = (IEmailTemplatesSelector)mocks.mock(IEmailTemplatesSelector.class);
        IEmailTemplateLookupTableSelector mockedEmailTemplateLookupTableSelector = (IEmailTemplateLookupTableSelector)mocks.mock(IEmailTemplateLookupTableSelector.class);
        
        EmailTemplate fakeTemplate = FakeTemplate(templateName);
        EmailTemplateLookupTable__c fakeEmailTemplateLookup = fakeEmailTemplateLookup(fakeTemplate, 'Transactional');
        List<Event_Registration__c> listOfFakeRegistrations = FakeRegistrations(false);
        MassEmailRequest expectedMassEmailRequest = FakeMassEmailRequest(new List<EmailRequest> { getListOfFakeEmailRequests(listOfFakeRegistrations)[0] });
        expectedMassEmailRequest.emailAddressOverride = UserInfo.getUserEmail();
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(listOfFakeRegistrations);
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        sut.setController = setController;
        
        mocks.startStubbing();
        mocks.when(mockedTemplatesSelector.sObjectType()).thenReturn(EmailTemplate.SObjectType);
        mocks.when(mockedTemplatesSelector.selectByDeveloperName(templateName)).thenReturn(fakeTemplate);
        mocks.when(mockedEmailTemplateLookupTableSelector.sObjectType()).thenReturn(EmailTemplateLookupTable__c.SObjectType);
        mocks.when(mockedEmailTemplateLookupTableSelector.selectByDeveloperName(fakeTemplate.DeveloperName)).thenReturn(fakeEmailTemplateLookup);
        mocks.stopStubbing();
        
        Application.Selector.setMock(mockedTemplatesSelector);
        Application.Selector.setMock(mockedEmailTemplateLookupTableSelector);
        
        // When
        sut.setSelectedEmailTemplate(templateName);
        sut.setSelectedOrgWideEmailAddressId(expectedMassEmailRequest.orgWideEmailAddressId);
        sut.sendProofToMe();
        
        // Then
        // System.assert(expectedMassEmailRequest.equals(sut.actualMassEmailRequestSentToTheService));
        
    }
    
    private static testMethod void givenSendToSelectedExpectEmailToBeSent() {
        
        // Given
        integer expectedNumberOfServiceCalls = 1;
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IEmailTemplatesSelector mockedTemplatesSelector = (IEmailTemplatesSelector)mocks.mock(IEmailTemplatesSelector.class);
        IEmailTemplateLookupTableSelector mockedEmailTemplateLookupTableSelector = (IEmailTemplateLookupTableSelector)mocks.mock(IEmailTemplateLookupTableSelector.class);
        
        EmailTemplate fakeTemplate = FakeTemplate(templateName);
        EmailTemplateLookupTable__c fakeEmailTemplateLookup = fakeEmailTemplateLookup(fakeTemplate, 'Transactional');
        Event__c fakeEvent = FakeEvent();
        
        List<Event_Registration__c> listOfFakeRegistrations = FakeRegistrations(false);
        MassEmailRequest expectedMassEmailRequest = FakeMassEmailRequest(getListOfFakeEmailRequests(listOfFakeRegistrations));
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(listOfFakeRegistrations);
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        sut.setController = setController;
        sut.setController.setSelected(listOfFakeRegistrations);
        sut.selectedEmailTemplateFolderName = 'Tranactional';
        
        mocks.startStubbing();
        mocks.when(mockedTemplatesSelector.sObjectType()).thenReturn(EmailTemplate.SObjectType);
        mocks.when(mockedTemplatesSelector.selectByDeveloperName(templateName)).thenReturn(fakeTemplate);
        mocks.when(mockedEmailTemplateLookupTableSelector.sObjectType()).thenReturn(EmailTemplateLookupTable__c.SObjectType);
        mocks.when(mockedEmailTemplateLookupTableSelector.selectByDeveloperName(fakeTemplate.DeveloperName)).thenReturn(fakeEmailTemplateLookup);
        mocks.stopStubbing();
        
        Application.Selector.setMock(mockedTemplatesSelector);
        Application.Selector.setMock(mockedEmailTemplateLookupTableSelector);
        
        // When
        sut.setSelectedEmailTemplate(templateName);
        sut.setSelectedOrgWideEmailAddressId(expectedMassEmailRequest.orgWideEmailAddressId);
        sut.sendToSelected();
        
        // Then
        // System.assert(expectedMassEmailRequest.equals(sut.actualMassEmailRequestSentToTheService));
        
    }
    
    private static testMethod void givenSendToSelectedWithDifferentEventsExpectEmailToBeSent() {
        
        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IEmailTemplatesSelector mockedTemplatesSelector = (IEmailTemplatesSelector)mocks.mock(IEmailTemplatesSelector.class);
        IEmailTemplateLookupTableSelector mockedEmailTemplateLookupTableSelector = (IEmailTemplateLookupTableSelector)mocks.mock(IEmailTemplateLookupTableSelector.class);
        
        EmailTemplate fakeTemplate = FakeTemplate(templateName);
        EmailTemplateLookupTable__c fakeEmailTemplateLookup = fakeEmailTemplateLookup(fakeTemplate, 'Transactional');
        Event__c fakeEvent = FakeEvent();
        
        List<Event_Registration__c> listOfFakeRegistrations = FakeRegistrations(false);
        MassEmailRequest expectedMassEmailRequest = FakeMassEmailRequest(getListOfFakeEmailRequests(listOfFakeRegistrations));
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(listOfFakeRegistrations);
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        sut.setController = setController;
        sut.setController.setSelected(listOfFakeRegistrations);
        sut.selectedEmailTemplateFolderName = 'Tranactional';
        
        mocks.startStubbing();
        mocks.when(mockedTemplatesSelector.sObjectType()).thenReturn(EmailTemplate.SObjectType);
        mocks.when(mockedTemplatesSelector.selectByDeveloperName(templateName)).thenReturn(fakeTemplate);
        mocks.when(mockedEmailTemplateLookupTableSelector.sObjectType()).thenReturn(EmailTemplateLookupTable__c.SObjectType);
        mocks.when(mockedEmailTemplateLookupTableSelector.selectByDeveloperName(fakeTemplate.DeveloperName)).thenReturn(fakeEmailTemplateLookup);
        mocks.stopStubbing();
        
        Application.Selector.setMock(mockedTemplatesSelector);
        Application.Selector.setMock(mockedEmailTemplateLookupTableSelector);
        
        // When
        sut.setSelectedEmailTemplate(templateName);
        sut.setSelectedOrgWideEmailAddressId(expectedMassEmailRequest.orgWideEmailAddressId);
        sut.sendToSelected();
        
        // Then
        for(EmailRequest expectedEmailRequest : expectedMassEmailRequest.listOfEmailRequests) {
            
            for(EmailRequest actualEmailRequest : sut.actualMassEmailRequestSentToTheService.listOfEmailRequests) {
                
                if (actualEmailRequest.contactId.equals(expectedEmailRequest.contactId)) {
                    System.assertEquals(expectedEmailRequest.relatedObjectId, actualEmailRequest.relatedObjectId);
                }
            }
        }
    }
    
    private static testMethod void givenSendToAllExpectEmailToBeSent() {
        
        // Given
        integer expectedNumberOfServiceCalls = 1;
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IEmailTemplateLookupTableSelector mockedEmailTemplateLookupTableSelector = (IEmailTemplateLookupTableSelector)mocks.mock(IEmailTemplateLookupTableSelector.class);
        IEmailTemplatesSelector mockedTemplatesSelector = (IEmailTemplatesSelector)mocks.mock(IEmailTemplatesSelector.class);
        
        Folder fakeFolder = new Folder();
        fakeFolder.Id =  fflib_IDGenerator.generate(Folder.SObjectType);
        fakeFolder.Name = 'Transactional';
        
        
        EmailTemplate fakeTemplate = FakeTemplate(templateName);
        EmailTemplateLookupTable__c fakeEmailTemplateLookup = fakeEmailTemplateLookup(fakeTemplate, 'Transactional');
        fakeTemplate.FolderId  =  fakeFolder.ID;
        
        Event__c fakeEvent = FakeEvent();
        List<Event_Registration__c> listOfFakeRegistrations = FakeRegistrations(false);
        MassEmailRequest expectedMassEmailRequest = FakeMassEmailRequest(getListOfFakeEmailRequests(listOfFakeRegistrations));
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(listOfFakeRegistrations);
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        sut.setController = setController;
        sut.selectedEmailTemplateFolderName = fakeFolder.Name;
        
        mocks.startStubbing();
        mocks.when(mockedTemplatesSelector.sObjectType()).thenReturn(EmailTemplate.SObjectType);
        mocks.when(mockedTemplatesSelector.selectByDeveloperName(templateName)).thenReturn(fakeTemplate);
        mocks.when(mockedEmailTemplateLookupTableSelector.sObjectType()).thenReturn(EmailTemplateLookupTable__c.SObjectType);
        mocks.when(mockedEmailTemplateLookupTableSelector.selectByDeveloperName(fakeTemplate.DeveloperName)).thenReturn(fakeEmailTemplateLookup);
        mocks.stopStubbing();
        
        Application.Selector.setMock(mockedTemplatesSelector);
        Application.Selector.setMock(mockedEmailTemplateLookupTableSelector);
        
        // When
        sut.setSelectedEmailTemplate(templateName);
        sut.setSelectedOrgWideEmailAddressId(expectedMassEmailRequest.orgWideEmailAddressId);
        sut.sendToAll();
        
        // Then
        // System.assert(expectedMassEmailRequest.equals(sut.actualMassEmailRequestSentToTheService));
        
    }
    
    private static testMethod void givenPrintTableTentProofWhenNoRecordsExpectNoException() {
        
        // Given
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(new List<Event_Registration__c>());
        EventRegistrationExtController sut = new EventRegistrationExtController(setController);
        
        // When
        try {
            sut.printTableTentProof();
        }
        catch (Exception ex) {
            throw new fflib_Application.DeveloperException('Test failed. No exception should have been thrown.');
        }
    }
    
    private static testMethod void givenPrintSelectedTableTentsWhenNoRecordsExpectNoException() {
        
        // Given
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(new List<Event_Registration__c>());
        EventRegistrationExtController sut = new EventRegistrationExtController(setController);
        
        // When
        try {
            sut.printSelectedTableTents();
        }
        catch (Exception ex) {
            throw new fflib_Application.DeveloperException('Test failed. No exception should have been thrown.');
        }
    }
    
    private static testMethod void givenPrintAllTableTentsWhenNoRecordsExpectNoException() {
        
        // Given
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(new List<Event_Registration__c>());
        EventRegistrationExtController sut = new EventRegistrationExtController(setController);
        
        // When
        try {
            sut.printAllTableTents();
        }
        catch (Exception ex) {
            throw new fflib_Application.DeveloperException('Test failed. No exception should have been thrown.');
        }
    }
    
    private static testMethod void givenPrintTableTentProofExpectTableTentToBePrinted() {
        
        // Given
        integer expectedNumberOfCalls = 1;
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IEmailTemplatesSelector mockedTemplatesSelector = (IEmailTemplatesSelector)mocks.mock(IEmailTemplatesSelector.class);
        IMatsonEventRegistrationsSelector mockedRegistrationsSelector = (IMatsonEventRegistrationsSelector)mocks.mock(IMatsonEventRegistrationsSelector.class);
        IPlatformEventService mockedPlatformEventService = (IPlatformEventService)mocks.mock(IPlatformEventService.class);
        
        EmailTemplate fakeTemplate = FakeTableTentTemplate();
        List<Event_Registration__c> listOfFakeRegistrations = new List<Event_Registration__c>();
        listOfFakeRegistrations.add(FakeRegistrations(false)[0]);
        Map<Id, Event_Registration__c> fakeRegistrationsMap = new Map<Id, Event_Registration__c>(listOfFakeRegistrations);
        Set<Id> fakeRegistrationIds = fakeRegistrationsMap.keySet();
        List<Print_Table_Tent__e> listOfFakePrintEvents = FakePrintTableTentEvents();
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(listOfFakeRegistrations);
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        sut.setController = setController;
        
        mocks.startStubbing();
        mocks.when(mockedTemplatesSelector.sObjectType()).thenReturn(EmailTemplate.SObjectType);
        mocks.when(mockedTemplatesSelector.selectByDeveloperName(tableTentName)).thenReturn(fakeTemplate);
        mocks.when(mockedRegistrationsSelector.sObjectType()).thenReturn(Event_Registration__c.SObjectType);
        mocks.when(mockedRegistrationsSelector.selectById(fakeRegistrationIds)).thenReturn(listOfFakeRegistrations);
        mocks.stopStubbing();    
        
        Application.Selector.setMock(mockedTemplatesSelector);
        Application.Selector.setMock(mockedRegistrationsSelector);
        Application.Service.setMock(IPlatformEventService.class, mockedPlatformEventService);
        
        // When
        sut.printTableTentProof();    
        
        // Then
        ((IPlatformEventService)mocks.verify(mockedPlatformEventService, expectedNumberOfCalls)).publish((List<Print_Table_Tent__e>)fflib_Match.anyList());
        
    }
    
    private static testMethod void givenPrintSelectedTableTentsExpectTableTentToBePrinted() {
        
        // Given
        integer expectedNumberOfCalls = 1;
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IEmailTemplatesSelector mockedTemplatesSelector = (IEmailTemplatesSelector)mocks.mock(IEmailTemplatesSelector.class);
        IMatsonEventRegistrationsSelector mockedRegistrationsSelector = (IMatsonEventRegistrationsSelector)mocks.mock(IMatsonEventRegistrationsSelector.class);
        IPlatformEventService mockedPlatformEventService = (IPlatformEventService)mocks.mock(IPlatformEventService.class);
        
        EmailTemplate fakeTemplate = FakeTableTentTemplate();
        List<Event_Registration__c> listOfFakeRegistrations = FakeRegistrations(false);
        Map<Id, Event_Registration__c> fakeRegistrationsMap = new Map<Id, Event_Registration__c>(listOfFakeRegistrations);
        Set<Id> fakeRegistrationIds = fakeRegistrationsMap.keySet();
        List<Print_Table_Tent__e> listOfFakePrintEvents = FakePrintTableTentEvents();
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(listOfFakeRegistrations);
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        sut.setController = setController;
        sut.setController.setSelected(listOfFakeRegistrations);
        
        mocks.startStubbing();
        mocks.when(mockedTemplatesSelector.sObjectType()).thenReturn(EmailTemplate.SObjectType);
        mocks.when(mockedTemplatesSelector.selectByDeveloperName(tableTentName)).thenReturn(fakeTemplate);
        mocks.when(mockedRegistrationsSelector.sObjectType()).thenReturn(Event_Registration__c.SObjectType);
        mocks.when(mockedRegistrationsSelector.selectById(fakeRegistrationIds)).thenReturn(listOfFakeRegistrations);
        mocks.stopStubbing();    
        
        Application.Selector.setMock(mockedTemplatesSelector);
        Application.Selector.setMock(mockedRegistrationsSelector);
        Application.Service.setMock(IPlatformEventService.class, mockedPlatformEventService);
        
        // When
        sut.printSelectedTableTents();
        
        // Then
        ((IPlatformEventService)mocks.verify(mockedPlatformEventService, expectedNumberOfCalls)).publish((List<Print_Table_Tent__e>)fflib_Match.anyList());
        
    }
    
    private static testMethod void givenPrintAllTableTentsExpectTableTentToBePrinted() {
        
        // Given
        integer expectedNumberOfCalls = 1;
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IEmailTemplatesSelector mockedTemplatesSelector = (IEmailTemplatesSelector)mocks.mock(IEmailTemplatesSelector.class);
        IMatsonEventRegistrationsSelector mockedRegistrationsSelector = (IMatsonEventRegistrationsSelector)mocks.mock(IMatsonEventRegistrationsSelector.class);
        IPlatformEventService mockedPlatformEventService = (IPlatformEventService)mocks.mock(IPlatformEventService.class);
        
        EmailTemplate fakeTemplate = FakeTableTentTemplate();
        List<Event_Registration__c> listOfFakeRegistrations = new List<Event_Registration__c>();
        listOfFakeRegistrations.add(FakeRegistrations(false)[0]);
        Map<Id, Event_Registration__c> fakeRegistrationsMap = new Map<Id, Event_Registration__c>(listOfFakeRegistrations);
        Set<Id> fakeRegistrationIds = fakeRegistrationsMap.keySet();
        List<Print_Table_Tent__e> listOfFakePrintEvents = FakePrintTableTentEvents();
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(listOfFakeRegistrations);
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        sut.setController = setController;
        
        mocks.startStubbing();
        mocks.when(mockedTemplatesSelector.sObjectType()).thenReturn(EmailTemplate.SObjectType);
        mocks.when(mockedTemplatesSelector.selectByDeveloperName(tableTentName)).thenReturn(fakeTemplate);
        mocks.when(mockedRegistrationsSelector.sObjectType()).thenReturn(Event_Registration__c.SObjectType);
        mocks.when(mockedRegistrationsSelector.selectById(fakeRegistrationIds)).thenReturn(listOfFakeRegistrations);
        mocks.stopStubbing();
        
        Application.Selector.setMock(mockedTemplatesSelector);
        Application.Selector.setMock(mockedRegistrationsSelector);
        Application.Service.setMock(IPlatformEventService.class, mockedPlatformEventService);
        
        // When
        sut.printAllTableTents();    
        
        // Then
        ((IPlatformEventService)mocks.verify(mockedPlatformEventService, expectedNumberOfCalls)).publish((List<Print_Table_Tent__e>)fflib_Match.anyList());
    }
    
    private static testMethod void givenGetSelectedPrinterIdExpectSelectedPrinterId () {
        
        // Given
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        Id expectedId = fflib_IDGenerator.generate(Printer__c.SObjectType);
        
        // When
        sut.selectedPrinterId = expectedId;
        
        // Then
        System.assertEquals(expectedId, sut.getSelectedPrinterId());
    }
    
    private static testMethod void givenIsPrinterSelectedWhenSelectedExpectTrue () {
        
        // Given
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        Id expectedId = fflib_IDGenerator.generate(Printer__c.SObjectType);
        
        // When
        sut.selectedPrinterId = expectedId;
        
        // Then
        System.assertEquals(true, sut.isPrinterSelected);
    }
    
    private static testMethod void givenIsPrinterSelectedWhenNotSelectedExpectFalse () {
        
        // Given
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        
        // When
        sut.selectedPrinterId = null;
        
        // Then
        System.assertEquals(false, sut.isPrinterSelected);
    }
    
    private static testMethod void givenSetSelectedPrinterIdWhenIdIsNullExpectNull() {
        
        // Given
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        
        // When
        sut.setSelectedPrinterId(null);
        
        // Then
        System.assertEquals(null, sut.selectedPrinterId);
    }
    
    private static testMethod void givenGetPrinterListItemsExpectCorrectOptions() {
        
        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        List<SelectOption> expectedOptions = new List<SelectOption>();
        IPrintersSelector mockedPrintersSelector = (IPrintersSelector)mocks.mock(IPrintersSelector.class);
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        List<Printer__c> listOfFakePrinters = FakePrinters();
        
        mocks.startStubbing();
        mocks.when(mockedPrintersSelector.sObjectType()).thenReturn(Printer__c.SObjectType);
        mocks.when(mockedPrintersSelector.selectAll()).thenReturn(listOfFakePrinters);
        mocks.stopStubbing();
        
        PhoenixCore.Selector.setMock(mockedPrintersSelector);
        
        expectedOptions.add(new SelectOption('', '-- Please select a printer --'));
        for(Printer__c printer : listOfFakePrinters) {
            expectedOptions.add(new SelectOption(printer.Id, printer.Name));
        }
        
        // When
        List<SelectOption> options = sut.getPrinterListItems();
        
        // Then
        System.assertEquals(expectedOptions, options);
    }
    
    private static List<Event_Registration__c> FakeRegistrations(Boolean matsonEventMarketingEmailOptOut) {
        
        List<Event_Registration__c> listOfRegistrations = new List<Event_Registration__c>();
        
        Event_Registration__c registration1 = new Event_Registration__c();
        registration1.Id = fflib_IDGenerator.generate(Event_Registration__c.SObjectType);
        registration1.Attendee_Email__c = 'bob@example.com';
        registration1.Contact__c = fakeContact(matsonEventMarketingEmailOptOut).Id;
        registration1.Event__c = fflib_IDGenerator.generate(Event__c.SObjectType);
        
        Event_Registration__c registration2 = new Event_Registration__c();
        registration2.Id = fflib_IDGenerator.generate(Event_Registration__c.SObjectType);
        registration2.Attendee_Email__c = 'bob@example.com';
        registration2.Contact__c = fakeContact(matsonEventMarketingEmailOptOut).Id;
        registration2.Event__c = fflib_IDGenerator.generate(Event__c.SObjectType);
        
        listOfRegistrations.add(registration1);
        listOfRegistrations.add(registration2);
        
        return listOfRegistrations;
    }
    
    private static List<EmailRequest> getListOfFakeEmailRequests(List<Event_Registration__c> listOfEventRegistrations) {
        
        List<EmailRequest> listOfEmailRequests = new List<EmailRequest>();
        
        for(Event_Registration__c eventRegistration : listOfEventRegistrations) {
            listOfEmailRequests.add(new EmailRequest(eventRegistration.Contact__c, eventRegistration.Attendee_Email__c, eventRegistration.Id, UserInfo.getUserEmail(), false));
        }
        
        return listOfEmailRequests;
    }
    
    private static Contact fakeContact(Boolean MatsonEventMarketingEmailOptOut){
        
        Contact fcontact = new Contact();
        fcontact.Matson_Event_Marketing_Email_Opt_Out__c = MatsonEventMarketingEmailOptOut;
        fcontact.Id = fflib_IDGenerator.generate(Contact.SObjectType);
        
        return fcontact;
    }
    
    private static MassEmailRequest FakeMassEmailRequest(List<EmailRequest> listOfEmailRequests) {
        
        MassEmailRequest request = new MassEmailRequest();
        request.listOfEmailRequests = listOfEmailRequests;
        request.emailTemplateDeveloperName = templateName;
        request.orgWideEmailAddressId = fflib_IDGenerator.generate(OrgWideEmailAddress.SObjectType);
        request.emailAddressOverride = null;
        request.isTransactionalEmail = true;
        
        return request;
    }
    
    private static EmailTemplate FakeTemplate(String templateDeveloperName) {
        EmailTemplate emailTemplate = new EmailTemplate();
        emailTemplate.DeveloperName = templateDeveloperName;
        emailTemplate.Name = 'Matson Event Date Change Email - Standard';
        emailTemplate.Subject = 'Your January 2018 Entrepreneur’s Foundation Training';
        emailTemplate.HtmlValue = '<html>Hello {!Event_Registration__c.Adviser_Email__c} {!Event__c.Name}</html>';
        
        return emailTemplate;
    }
    
    private static List<EmailTemplate> FakeTemplates() {
        List<EmailTemplate> templates = new List<EmailTemplate>();
        templates.add(FakeTemplate(templateName));
        return templates;
    }
    
    private static Folder FakeFolder(string name ) {
        Folder fakeFolder = new Folder();
        // fakeFolder.Id =  fflib_IDGenerator.generate(Folder.SObjectType);
        fakeFolder.Name = name;
        fakeFolder.Type = 'Email template';
        
        return fakeFolder;
    }
    
    private static List<Folder> FakeFolders() {
        List<Folder> folders = new List<Folder>();
        folders.add(FakeFolder('Matson Event Transactional Emails'));
        folders.add(FakeFolder('Matson Event Marketing Email'));
        return folders;
    }
    
    private static Event__c FakeEvent() {
        Event__c event = new Event__c();
        event.Id = fflib_IDGenerator.generate(Event__c.SObjectType);
        event.Name = 'My Awesome Event';
        
        return event;
    }
    
    private static List<OrgWideEmailAddress> FakeOrgWideEmailAddresses() {
        List<OrgWideEmailAddress> addresses = new List<OrgWideEmailAddress>();
        
        addresses.add(new OrgWideEmailAddress(Id = fflib_IDGenerator.generate(OrgWideEmailAddress.SObjectType), Address = 'bob@example.com', DisplayName = 'Bob'));
        addresses.add(new OrgWideEmailAddress(Id = fflib_IDGenerator.generate(OrgWideEmailAddress.SObjectType), Address = 'frank@example.com', DisplayName = 'Frank'));
        
        return addresses;
    }
    
    static EmailTemplateLookupTable__c fakeEmailTemplateLookup(EmailTemplate fakeEmailTemplate, string typeName){
        EmailTemplateLookupTable__c emailTemplateLookupTable = new EmailTemplateLookupTable__c();
        emailTemplateLookupTable.EmailTemplateId__c = fakeEmailTemplate.Id;
        emailTemplateLookupTable.EmailTemplateType__c = typeName;
        emailTemplateLookupTable.IsActive__c = true;
        emailTemplateLookupTable.Name = fakeEmailTemplate.Name;
        emailTemplateLookupTable.EmailTemplateDeveloperName__c = fakeEmailTemplate.DeveloperName;
        return emailTemplateLookupTable;
        
    }
    
    private static List<Print_Table_Tent__e> FakePrintTableTentEvents() {
        List<Print_Table_Tent__e> events = new List<Print_Table_Tent__e>();
        
        events.add(new Print_Table_Tent__e(Attendee_First_Name__c = 'Bob', Attendee_Last_Name__c = 'Smith', Printer_Id__c = 'abcd1234'));
        events.add(new Print_Table_Tent__e(Attendee_First_Name__c = 'Frank', Attendee_Last_Name__c = 'Smith', Printer_Id__c = 'abcd1234'));
        
        return events;
    }
    
    private static EmailTemplate FakeTableTentTemplate() {
        EmailTemplate emailTemplate = new EmailTemplate();
        emailTemplate.DeveloperName = tableTentName;
        emailTemplate.Name = 'Matson Event Table Tent';
        emailTemplate.Subject = 'Matson Event Table Tent';
        emailTemplate.HtmlValue = '<html>First<br>Last<br>Matson Money</html>';
        
        return emailTemplate;
    }
    
    private static List<Printer__c> FakePrinters() {
        List<Printer__c> printers = new List<Printer__c>();
        
        printers.add(new Printer__c(Id = fflib_IDGenerator.generate(Printer__c.SObjectType), Name = 'Printer 1', Printer_Id__c = 'abcd1234'));
        printers.add(new Printer__c(Id = fflib_IDGenerator.generate(Printer__c.SObjectType), Name = 'Printer 2', Printer_Id__c = 'wxyz4321'));
        
        return printers;
    }
    //
    //************************************************* Event Registration History***********************************************
    //
    private static testMethod void EventRegistrationHistory(){
        EventRegistrationExtController sut = new EventRegistrationExtController(new ApexPages.StandardSetController(new List<Event_Registration__c>()));
        sut.getHistoryForSelected();
        List<Event_Registration__History> eventRegistrationWithHistory = new List<Event_Registration__History>();
        
        sut.getCsvString(eventRegistrationWithHistory);
        sut.getHistoryCSVPage();
        
        
    } 
}