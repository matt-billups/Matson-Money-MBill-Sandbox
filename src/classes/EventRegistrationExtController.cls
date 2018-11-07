public with sharing class EventRegistrationExtController {
    
    @TestVisible String selectedEmailTemplateName;
    @TestVisible String selectedEmailTemplateBody;
    @TestVisible String selectedOrgWideEmailAddressId;
    @TestVisible ApexPages.StandardSetController setController;
    @TestVisible String selectedEmailTemplateFolderName;
    @TestVisible EmailTemplateLookupTable__c emailTemplateLookup;
    @TestVisible MassEmailRequest actualMassEmailRequestSentToTheService;
    @TestVisible String selectedPrinterId;
    @TestVisible public Boolean displayList {get;set;}
    @TestVisible Boolean displayConfirm = TRUE;
    
    private final String TRANSACTIONAL_EMAIL_TEMPLATE_TYPE = 'Transactional';
    
    public eventRegistrationExtController(ApexPages.StandardSetController controller) {
        setController = controller;
        if (!Test.isRunningTest()) controller.addFields(new List<String>{'Contact__c', 'contact__r.Matson_Event_Marketing_Email_Opt_Out__c','Event_Email_Opt_Out_URL__c',
                                                        'Event__c','Attendee_Email__c', 'Contact__r.FirstName', 'Contact__r.LastName', 'Contact__r.Email'
                                                        });
        setController.setPageSize(2000);
    }
    
    public PageReference sendToSelected() {
        sendEmails(setController.getSelected());
        return getEmailsSentSuccessfullyPage();
    }
    
    public PageReference sendToAll() {
        sendEmails(setController.getRecords());
        return getEmailsSentSuccessfullyPage();
    }
    
    public PageReference sendProofToMe() {
        
        if (!isRecordsExist()) {
            return null;
        }
        
        Event_Registration__c firstRegistration = (Event_Registration__c)setController.getRecords()[0];
        sendEmail(firstRegistration, UserInfo.getUserEmail(), this.selectedOrgWideEmailAddressId);
        
        return getEmailsSentSuccessfullyPage();
    }
    
    public List<SelectOption> getEmailTemplateListItems() {
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('', '-- Please select an email template --'));
        
        for(EmailTemplate template : emailTemplatesSelector().selectByFolderName(selectedEmailTemplateFolderName)){
            if (isEmailTemplateLookupRecordExists(template.DeveloperName) == true) {
                options.add(new SelectOption(template.DeveloperName, template.Name));
            }
        }
        
        return options;
    }
    
    public List<SelectOption> getEmailTemplateFolderListItems() {
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('', '-- Please select an email template folder --'));
        
        for(Folder emailFolder : folderSelector().selectByType('Email')) {
            if (emailFolder.Name != null && emailFolder.Name.length() > 0) {
                options.add(new SelectOption(emailFolder.Name, emailFolder.Name));
            }
        }
        
        return options;
    }
    
    public List<SelectOption> getEmailAddressListItems() {
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('', '-- Please select an email address --'));
        
        for(OrgWideEmailAddress orgWideEmailAddress : orgWideEmailAddressSelector().selectAll()) {
            
            if (orgWideEmailAddress.Address != null && orgWideEmailAddress.Address.length() > 0) {
                options.add(new SelectOption(orgWideEmailAddress.Id , orgWideEmailAddress.DisplayName));
            }
        }
        
        return options;
    }
    
    public Boolean isFromAddressSelected {
        get { return this.selectedOrgWideEmailAddressId != null && this.selectedOrgWideEmailAddressId.length() > 0; }
    }   
    
    public Boolean isEmailTemplateFolderSelected {
        
        get {  return this.selectedEmailTemplateFolderName != null && this.selectedEmailTemplateFolderName.length() > 0; }
    }
    
    public Boolean isTemplateSelected {
        get { return this.selectedEmailTemplateName != null && this.selectedEmailTemplateName.length() > 0; }
    }
    
    public String getSelectedEmailTemplate() {
        return this.selectedEmailTemplateName;
    }
    
    public void setSelectedEmailTemplate(String selectedUniqueEmailTemplateName) {
        
        if (selectedUniqueEmailTemplateName == null || selectedUniqueEmailTemplateName.length() < 1) {
            this.selectedEmailTemplateBody = '';
            return;
        }
        
        this.selectedEmailTemplateName = selectedUniqueEmailTemplateName;
        
        EmailTemplate template = emailTemplatesSelector().selectByDeveloperName(selectedUniqueEmailTemplateName);
        EmailTemplateLookupTable__c emailTemplateLookup = getEmailTemplateLookup(selectedUniqueEmailTemplateName);
        
        if (template != null && emailTemplateLookup != null) {
            this.selectedEmailTemplateBody = template.HtmlValue;
            this.emailTemplateLookup = emailTemplateLookup;
            
        }
    }
    
    public String getSelectedOrgWideEmailAddressId() {
        return this.selectedOrgWideEmailAddressId;
    }
    
    public void setSelectedOrgWideEmailAddressId(String emailAddressId) {
        this.selectedOrgWideEmailAddressId = emailAddressId;
    }
    
    public void setSelectedEmailTemplateFolderName(String emailTemplateFolderName) {
        
        this.selectedEmailTemplateFolderName = emailTemplateFolderName;
    }
    
    public String getSelectedEmailTemplateFolderName() {
        
        return this.selectedEmailTemplateFolderName;
    }
    
    public String getSelectedEmailTemplateBody() {
        return this.selectedEmailTemplateBody;
    }
    
    public Boolean hasSelectedRegistrations {
        get {
            return setController.getSelected().size() > 0;
        }
    }
    
    private EmailTemplateLookupTable__c getEmailTemplateLookup(String uniqueEmailTemplateName) {
        return emailTemplateLookupTableSelector().selectByDeveloperName(uniqueEmailTemplateName);
    }
    
    private Boolean isEmailTemplateLookupRecordExists(String uniqueEmailTemplateName) {
        return getEmailTemplateLookup(uniqueEmailTemplateName) != null;
    }
    
    private Boolean isRecordsExist() {
        return setController.getRecords().size() > 0;
    }
    
    public PageReference printSelectedTableTents() {
        printTableTents(setController.getSelected(), this.selectedPrinterId);
        return getTableTentsPrintedSuccessfullyPage();
    }
    
    public PageReference printAllTableTents() {
        printTableTents(setController.getRecords(), this.selectedPrinterId);
        return getTableTentsPrintedSuccessfullyPage();
    }  
    
    public PageReference printTableTentProof() {
        if (!isRecordsExist()) {
            return null; 
        }
        
        Event_Registration__c firstRegistration = (Event_Registration__c)setController.getRecords()[0];
        printTableTent(firstRegistration, this.selectedPrinterId);
        
        return getTableTentsPrintedSuccessfullyPage();
    }
    
    public List<SelectOption> getPrinterListItems() {
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('', '-- Please select a printer --'));
        
        for (Printer__c printer : printersSelector().selectAll()) {
            options.add(new SelectOption(printer.Id, printer.Name));
        }
        
        return options;
    }  
    
    public boolean isPrinterSelected {
        get { return !String.isBlank(this.selectedPrinterId); }
    }
    
    public String getSelectedPrinterId() {
        return this.selectedPrinterId;
    }
    
    public void setSelectedPrinterId(String printerId) {
        this.selectedPrinterId = printerId;
    }
    
    private PageReference getEmailsSentSuccessfullyPage() {
        PageReference successPage = Page.Emails_Sent_Successfully;
        successPage.setRedirect(true);
        return successPage;
    }
    
    private void sendEmails(List<Event_Registration__c> listOfEventRegistrations) {
        callEmailService(listOfEventRegistrations, this.selectedEmailTemplateName, this.selectedOrgWideEmailAddressId);
    }
    
    private void sendEmail(Event_Registration__c registration, String emailAddressOverride, String orgWideEmailAddressId) {
        callEmailService(new List<Event_Registration__c> { registration }, this.selectedEmailTemplateName, emailAddressOverride, orgWideEmailAddressId);
    }
    
    private Integer callEmailService(List<Event_Registration__c> listOfEventRegistrations, String emailTemplateName, String orgWideEmailAddressId) {
        processEmailServiceRequest(listOfEventRegistrations, emailTemplateName, null, orgWideEmailAddressId);
        return listOfEventRegistrations.size();
    }
    
    private Integer callEmailService(List<Event_Registration__c> listOfEventRegistrations, String emailTemplateName, String emailAddressOverride, String orgWideEmailAddressId) {
        processEmailServiceRequest(listOfEventRegistrations, emailTemplateName, emailAddressOverride, orgWideEmailAddressId);
        return listOfEventRegistrations.size();
    }
    
    private void processEmailServiceRequest(List<Event_Registration__c> listOfEventRegistrations, String emailTemplateName, String emailAddressOverride, String orgWideEmailAddressId) {
        
        MassEmailRequest massEmailRequest = new MassEmailRequest();
        massEmailRequest.emailTemplateDeveloperName = emailTemplateName;
        massEmailRequest.orgWideEmailAddressId = orgWideEmailAddressId;
        massEmailRequest.emailAddressOverride = emailAddressOverride;
        massEmailRequest.isSandboxRequest = Environment.IsSandboxOrg();
        massEmailRequest.isTransactionalEmail = isTranactionalEmail(this.emailTemplateLookup);
        
        for(Event_Registration__c eventRegistration : listOfEventRegistrations) {
            massEmailRequest.listOfEmailRequests.add(new EmailRequest(eventRegistration.Contact__c, eventRegistration.Attendee_Email__c, eventRegistration.Id, UserInfo.getUserEmail(), isContactOptedOutOfMatsonMarketingEmails(eventRegistration)));
        }
        
        // Necessary hack due to limitation of Apex Stub API. Stub API does not allow you to mock
        // an interface/class that resides in a different namespace.
        
        this.actualMassEmailRequestSentToTheService = massEmailRequest;
        
        if (!Test.isRunningTest()) {
            massEmailService().sendEmails(massEmailRequest, 20);
        }
    }
    
    private PageReference getTableTentsPrintedSuccessfullyPage() {
        PageReference successPage = Page.Table_Tents_Printed_Successfully;
        successPage.setRedirect(true);        
        return successPage;
    }
    
    private void printTableTents(List<Event_Registration__c> registrations, String printerId) {
        Map<Id, Event_Registration__c> registrationMap = new Map<Id, Event_Registration__c>(registrations);
        List<Event_Registration__c> updatedRegistrations = getRegistrationInfo(registrationMap.keySet());
        
        List<AttendeeInfo> attendeeInfoObjects = new List<AttendeeInfo>();
        
        for (Event_Registration__c updatedRegistration : updatedRegistrations) {
            attendeeInfoObjects.add(new AttendeeInfo(updatedRegistration.Attendee_First_Name__c, updatedRegistration.Attendee_Last_Name__c));
        }
        
        createPrintTableTentEvents(attendeeInfoObjects, printerId);
    }
    
    private void printTableTent(Event_Registration__c registration, String printerId) {
        Event_Registration__c updatedRegistration = getRegistrationInfo(new Set<Id> { registration.Id })[0];
        createPrintTableTentEvents(new List<AttendeeInfo> { new AttendeeInfo(updatedRegistration.Attendee_First_Name__c, updatedRegistration.Attendee_Last_Name__c) }, printerId);
    }
    
    private void createPrintTableTentEvents(List<AttendeeInfo> attendeeInfoObjects, String printerId) {
        List<Print_Table_Tent__e> printEvents = new List<Print_Table_Tent__e>();
        
        for (AttendeeInfo infoObj : attendeeInfoObjects) {
            printEvents.add(new Print_Table_Tent__e(Attendee_First_Name__c = infoObj.FirstName, Attendee_Last_Name__c = infoObj.LastName, Printer_Id__c = printerId));
        }
        
        platformEventService().publish(printEvents);
    }
    
    public List<Event_Registration__c> getRegistrationInfo(Set<Id> registrationIds) {
        return eventRegistrationsSelector().selectById(registrationIds);
    }
    
    private static IOrgWideEmailAddressesSelector orgWideEmailAddressSelector() {
        return (IOrgWideEmailAddressesSelector)Application.Selector.newInstance(OrgWideEmailAddress.SObjectType);
    }
    
    private static IEmailTemplatesSelector emailTemplatesSelector() {
        return (IEmailTemplatesSelector)Application.Selector.newInstance(EmailTemplate.SObjectType);
    }
    private static IEmailTemplateLookupTableSelector emailTemplateLookupTableSelector() {
        return (IEmailTemplateLookupTableSelector)Application.Selector.newInstance(EmailTemplateLookupTable__c.SObjectType);
    }
    
    private static IFolderSelector folderSelector() {
        return (IFolderSelector)Application.Selector.newInstance(Folder.SObjectType);
    }
    
    private static IMassEmailService massEmailService() {
        return (IMassEmailService)Application.Service.newInstance(IMassEmailService.class);
    }
    
    public Boolean isTranactionalEmail(EmailTemplateLookupTable__c emailTemplateLookup) {
        return emailTemplateLookup != null && emailTemplateLookup.EmailTemplateType__c == TRANSACTIONAL_EMAIL_TEMPLATE_TYPE;
    }
    
    public Boolean isContactOptedOutOfMatsonMarketingEmails(Event_Registration__c registration){
        system.debug('registration.Contact__r.Matson_Event_Marketing_Email_Opt_Out__c ' + registration.Contact__r.Matson_Event_Marketing_Email_Opt_Out__c);
        return registration.Contact__r.Matson_Event_Marketing_Email_Opt_Out__c;
    }
    
    private static IPrintersSelector printersSelector() {
        return (IPrintersSelector)PhoenixCore.Selector.newInstance(Printer__c.SObjectType);
    }
    
    private static IMatsonEventRegistrationsSelector eventRegistrationsSelector() {
        return (IMatsonEventRegistrationsSelector)Application.Selector.newInstance(Event_Registration__c.SObjectType);
    }
    
    private static IPlatformEventService platformEventService() {
        return (IPlatformEventService)Application.Service.newInstance(IPlatformEventService.class);
    }
        //
    //************************************************* Event Registration History***********************************************
    //
    public  List<Event_Registration__History> getEventRegistrationHistoryList(){
        
        if(setController.getSelected().size() < 1)
        {
            setController.setSelected(setController.getRecords()); 
        }
        List<Event_Registration__History> eventRegistrationWithHistory = [select 
                                                                          Parent.Attendee_Name__c,
                                                                          Field,
                                                                          OldValue,
                                                                          NewValue,
                                                                          CreatedDate, 
                                                                          Createdby.Name,
                                                                          Parent.Event_Name__c             
                                                                          From  Event_Registration__history 
                                                                          Where Parent.ID in :setController.getSelected() and (Field = 'Status__c' or Field ='Created') 
                                                                          ORDER BY  Parent.Event_Name__c, Parent.Attendee_Name__c, CreatedDate asc];
        return eventRegistrationWithHistory;
        
    }
    public string getHistoryForSelected() {
        
        
        List<Event_Registration__History> eventRegistrationWithHistory = getEventRegistrationHistoryList();                                                            
        return getCsvString(eventRegistrationWithHistory);
    }
    public String getCsvString(List<Event_Registration__History> eventRegistrationWithHistory) {
        TimeZone tz = UserInfo.getTimeZone();

        String[] rows = new String[0];
        String[] line = new String[0];
        // Create Hearder
        line.add('Registrant Name');
        line.add('Field Changed');
        line.add('Old Value');
        line.add('New Value');
        line.add('Date Changed');
        line.add('Modified By');
        line.add('Event Name');
        
        rows.add(String.join(line, ','));
        
        for(Event_Registration__History history : eventRegistrationWithHistory){
            line = new String[0];
            line.add(history.Parent.Attendee_Name__c); 					//Registrant Name
            line.add(string.valueOf(history.Field)); 					//Field Changed
            line.add(string.valueOf(history.OldValue)); 				//old vaule
            line.add(string.valueOf(history.NewValue)); 				//new Vaule
            line.add(history.CreatedDate.format('MM/dd/yy h:mm a')); 	//Date Changed
            line.add(history.Createdby.Name);              				//Modified By
            line.add(history.Parent.Event_Name__c);         			//Event Name
            rows.add(String.join(line, ','));
        }
        
        return String.join(rows,'\n');
    }
    
    public PageReference  getHistoryCSVPage(){
       PageReference historyCsvPage = Page.Event_Registration_History_Report;
        return historyCsvPage;
    }

    //********** Code added by Matt Billups **********
    public List<Event_Registration__c> getListOfRecipients() {
        return setController.getRecords();
    }

    public Boolean getDisplayConfirm() {
        if(this.selectedOrgWideEmailAddressId != null && this.selectedOrgWideEmailAddressId.length() > 0 && displayConfirm == TRUE){
            return displayConfirm = TRUE;
        }else return displayConfirm = FALSE;
    }

    public PageReference confirmClick() {
        displayConfirm = FALSE;
        displayList = TRUE;
        return NULL;
    }

    public Boolean displayRecipientList() {
        displayConfirm = FALSE;
        return displayList = TRUE;
    }

    //********** End code added by Matt Billups **********
    
    class AttendeeInfo {
        String FirstName;
        String LastName;
        
        AttendeeInfo(String firstName, String lastName) {
            this.FirstName = firstName;
            this.LastName = lastName;
        }
    }
}