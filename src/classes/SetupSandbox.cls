global class SetupSandbox implements SandboxPostCopy  {

    global void runApexClass(SandboxContext context) {
        cleanseData();
        setupHouseAccountContact();
        updateHouseAccountSiteTokenOnEvents();
    }

    // Used for manual runs
    // To run the SetupSandbox class manually, use the following command:
    // new SetupSandbox().runSetup(true or false);
    // Choose true if you want to cleanse data or false otherwise.
    public void runSetup(Boolean cleanData) {
        if (cleanData) {
            cleanseData();
        }
        
        setupHouseAccountContact();
        updateHouseAccountSiteTokenOnEvents();
    }

    private void cleanseData() {
        IDataCleansingService cleansingService = dataCleansingService();

        // Clean contacts, then clean event registrations
        cleansingService.cleanse(contactsSelector().getSelectAllQuery(), matsonEventRegistrationsSelector().getSelectAllQuery());

        // Clean advisers
        cleansingService.cleanse(advisersSelector().getSelectAllQuery(), '');
    }

    private void setupHouseAccountContact() {
        List<Contact> houseAccountContacts = contactsSelector().selectByName('House', 'Account');
        Contact houseAccount;
        if (houseAccountContacts.size() < 1) {
            houseAccount = createHouseAccountContact();
            createHouseAccountAdviser(houseAccount.Id);
        }
        else {
            houseAccount = houseAccountContacts[0];
        }

        settingsHelperService().UpdateHouseAccountContactId(houseAccount.Id);
    }

    private Contact createHouseAccountContact() {
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
        Contact houseAccount = new Contact();
        houseAccount.FirstName = 'House';
        houseAccount.LastName = 'Account';
        houseAccount.Nickname__c = 'Dan';
        houseAccount.Office_Phone__c = '5132048000';
        houseAccount.Fax = '5132048005';
        houseAccount.Email = 'scrubbedcontactemail@example.com';
        houseAccount.MailingStreet = '5955 Deerfield Blvd';
        houseAccount.MailingCity = 'Mason';
        houseAccount.MailingState = 'Ohio';
        houseAccount.MailingPostalCode = '45040';
        houseAccount.Matson_Event_Marketing_Email_Opt_Out__c = true;
        
        uow.registerNew(houseAccount);
        uow.commitWork();

        return houseAccount;
    }

    private void createHouseAccountAdviser(Id contactId) {
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
        User adviserCoach = [SELECT Id FROM User WHERE Alias = 'AAsh'];
        List<RecordType> adviserRecordTypes = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Adviser__c'];
        Map<String, Id> recordTypeIdMap = new Map<String, Id>();
        for (RecordType recType : adviserRecordTypes) {
            recordTypeIdMap.put(recType.Name, recType.Id);
        }
        
        Adviser__c houseAccountAdv = new Adviser__c();
        houseAccountAdv.Legacy_RepNo__c = 99998;
        houseAccountAdv.Primary_Contact__c = contactId;
        houseAccountAdv.Status__c = 'Active Adviser';
        houseAccountAdv.Office_Id__c = '1';
        houseAccountAdv.Service_Team__c = '2';
        houseAccountAdv.Company__c = 'Matson Money, Inc.';
        houseAccountAdv.Website__c = 'https://www.matsonmoney.com/';
        houseAccountAdv.Designation__c = 'Unknown';
        houseAccountAdv.Reg_RepNo__c = '99998';
        houseAccountAdv.Legacy_Date_Established__c = Date.parse('8/12/1994');
        houseAccountAdv.Firm_ID__c = 'House';
        houseAccountAdv.Accounting_Customer_Id__c = 'HOUSE';
        houseAccountAdv.Master_RepNo__c = '0';
        houseAccountAdv.Adviser_Coach__c = adviserCoach.Id;
        houseAccountAdv.RecordTypeId = recordTypeIdMap.get('Adviser');
        
        uow.registerNew(houseAccountAdv);
        uow.commitWork();
    }

    private void updateHouseAccountSiteTokenOnEvents() {
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
        List<Event__c> futureEvents = matsonEventsSelector().selectFutureEvents();
        for (Event__c event : futureEvents) {
            String valueToHash = String.valueOf(settingsHelperService().HouseAccountContactId()) + String.valueOf(event.Id);
            String token = settingsHelperService().CreateEventToken(valueToHash);
            event.House_Account_Site_Token__c = token;
            uow.registerDirty(event);
        }

        uow.commitWork();
    }

    private static IDataCleansingService dataCleansingService() {
        return (IDataCleansingService)Application.Service.newInstance(IDataCleansingService.class);
    }

    private static IAdvisersSelector advisersSelector() {
        return (IAdvisersSelector)Application.Selector.newInstance(Adviser__c.SObjectType);
    }

    private static IContactsSelector contactsSelector() {
        return (IContactsSelector)PhoenixCore.Selector.newInstance(Contact.SObjectType);
    }

    private static IMatsonEventRegistrationsSelector matsonEventRegistrationsSelector() {
        return (IMatsonEventRegistrationsSelector)Application.Selector.newInstance(Event_Registration__c.SObjectType);
    }

    private static IMatsonEventsSelector matsonEventsSelector() {
        return (IMatsonEventsSelector)Application.Selector.newInstance(Event__c.SObjectType);
    }

    private static ISettingsHelperService settingsHelperService() {
        return (ISettingsHelperService)Application.Service.newInstance(ISettingsHelperService.class);
    }
}