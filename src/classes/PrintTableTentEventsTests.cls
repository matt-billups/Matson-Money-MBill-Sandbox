@isTest
public class PrintTableTentEventsTests {
    
    static String tableTentName = 'Matson Event Table Tent';
    static Id printer1SfId = fflib_IDGenerator.generate(Printer__c.SObjectType);
    
    static testMethod void givenPrintTableTentsExpectPrintServicePrint() {
        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IPrintersSelector mockedPrintersSelector = (IPrintersSelector)mocks.mock(IPrintersSelector.class);
        IEmailTemplatesSelector mockedTemplatesSelector = (IEmailTemplatesSelector)mocks.mock(IEmailTemplatesSelector.class);
        IPrintService mockedPrintService = (IPrintService)mocks.mock(IPrintService.class);
        
        EmailTemplate fakeTemplate = FakeTableTentTemplate();
        List<Printer__c> listOfFakePrinters = FakePrinters();
        List<Print_Table_Tent__e> listOfFakePrintEvents = FakePrintTableTentEvents();
        integer expectedNumberOfCalls = listOfFakePrintEvents.size();
        PrintTableTentEvents sut = (PrintTableTentEvents)Application.Domain.newInstance(listOfFakePrintEvents);
        
        mocks.startStubbing();
        mocks.when(mockedPrintersSelector.sObjectType()).thenReturn(Printer__c.SObjectType);
        mocks.when(mockedPrintersSelector.selectAll()).thenReturn(listOfFakePrinters);
        mocks.when(mockedTemplatesSelector.sObjectType()).thenReturn(EmailTemplate.SObjectType);
        mocks.when(mockedTemplatesSelector.selectByName(tableTentName)).thenReturn(fakeTemplate);
        mocks.stopStubbing();
        
        Application.Selector.setMock(mockedTemplatesSelector);
        PhoenixCore.Selector.setMock(mockedPrintersSelector);
        PhoenixCore.Service.setMock(IPrintService.class, mockedPrintService);
        
        // When
        sut.printTableTents();
        
        // Then
        ((IPrintService)mocks.verify(mockedPrintService, expectedNumberOfCalls)).print(fflib_Match.anyString(), fflib_Match.anyString(), fflib_Match.anyString(), fflib_Match.anyString());
    }
    
    private static EmailTemplate FakeTableTentTemplate() {
        EmailTemplate emailTemplate = new EmailTemplate();
        emailTemplate.DeveloperName = 'TableTent';
        emailTemplate.Name = tableTentName;
        emailTemplate.Subject = tableTentName;
        emailTemplate.HtmlValue = '<html>First<br>Last<br>Matson Money</html>';
        
        return emailTemplate;
    }
    
    private static List<Printer__c> FakePrinters() {
        List<Printer__c> printers = new List<Printer__c>();
        
        printers.add(new Printer__c(Id = printer1SfId, Name = 'Printer 1', Printer_Id__c = 'abcd1234'));
        printers.add(new Printer__c(Id = fflib_IDGenerator.generate(Printer__c.SObjectType), Name = 'Printer 2', Printer_Id__c = 'wxyz4321'));
        
        return printers;
    }
    
    private static List<Print_Table_Tent__e> FakePrintTableTentEvents() {
        List<Print_Table_Tent__e> events = new List<Print_Table_Tent__e>();
        
        events.add(new Print_Table_Tent__e(Attendee_First_Name__c = 'Bob', Attendee_Last_Name__c = 'Smith', Printer_Id__c = printer1SfId));
        events.add(new Print_Table_Tent__e(Attendee_First_Name__c = 'Frank', Attendee_Last_Name__c = 'Smith', Printer_Id__c = printer1SfId));
        
        return events;
    }
}