public class Application {
    
    // Configure and create the ServiceFactory for this Application
    public static final fflib_Application.ServiceFactory Service =
        new fflib_Application.ServiceFactory(
            new Map<Type, Type> {
                    IEmailTemplateService.class => EmailTemplateService.class,
                    IMassEmailService.class => MassEmailService.class,
                    IEmailService.class => EmailService.class,
                    IDataCleansingService.class => CleanseDataWorker.class,
                    IPlatformEventService.class => PlatformEventService.class,
                    ISettingsHelperService.class => mm_SettingsHelper.class });

    // Configure and create the SelectorFactory for this Application
    public static final fflib_Application.SelectorFactory Selector =
        new fflib_Application.SelectorFactory(
            new Map<SObjectType, Type> {
                OrgWideEmailAddress.SObjectType => OrgWideEmailAddressesSelector.class,
                    EmailTemplate.SObjectType => EmailTemplatesSelector.class,
                    Event__c.SObjectType => MatsonEventsSelector.class,
                    Event_Registration__c.SObjectType => MatsonEventRegistrationsSelector.class,
                    Adviser__c.SObjectType => AdvisersSelector.class,
                    Event_Days__c.SObjectType => EventDaysSelector.class,
                    Fulfillment_Request__c.SObjectType => FulfillmentRequestsSelector.class,
                    User.SObjectType => UserSelector.class,
                    Folder.SObjectType => FolderSelector.class,
                    EmailTemplateLookupTable__c.SObjectType => EmailTemplateLookupTableSelector.class,
                    EventEventQuestion__c.SObjectType => EventEventQuestionsSelector.class,
                    Contact.SObjectType => ContactsSelector.class });

    // Configure and create the DomainFactory for this Application
    public static final fflib_Application.DomainFactory Domain =
        new fflib_Application.DomainFactory(
            Application.Selector,
            // Map SObjectType to Domain Class Constructors
            new Map<SObjectType, Type> {
                Adviser__c.SObjectType => Advisers.Constructor.class,
                EventEventQuestion__c.SObjectType => EventEventQuestions.Constructor.class,
                Print_Table_Tent__e.SObjectType => PrintTableTentEvents.Constructor.class,
                Contact.SObjectType => Contacts.Constructor.class,
                Event_Registration__c.SObjectType => MatsonEventRegistrations.Constructor.class,
                Event__c.SObjectType => MatsonEvents.Constructor.class });

    // Configure and create the UnitOfWorkFactory for this Application
    public static final fflib_Application.UnitOfWorkFactory UnitOfWork =
        new fflib_Application.UnitOfWorkFactory(
            new List<SObjectType> {
                Event__c.SObjectType,
                    Event_Registration__c.SObjectType,
                    Adviser__c.SObjectType,
                    Contact.SObjectType,
                    FulFillment_Request__c.SObjectType,
                    EventEventQuestion__c.SObjectType});
}