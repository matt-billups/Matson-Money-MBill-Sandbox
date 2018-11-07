public with sharing class PrintTableTentEvents extends ApplicationDomain implements IPrintTableTentEvents {
    
    public PrintTableTentEvents(List<Print_Table_Tent__e> events) {
        super(events);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new PrintTableTentEvents(sObjectList);
        }
    }
    
    public override void onAfterInsert() {
        printTableTents();
    }
    
    public void printTableTents() {
        IPrintersSelector printersSelector = (IPrintersSelector)PhoenixCore.Selector.newInstance(Printer__c.SObjectType);
        List<Printer__c> printers = printersSelector.selectAll();
        Map<Id, Printer__c> printersMap = new Map<Id, Printer__c>(printers);
        IEmailTemplatesSelector emailTemplatesSelector = (IEmailTemplatesSelector)Application.Selector.newInstance(EmailTemplate.SObjectType);
        EmailTemplate template = emailTemplatesSelector.selectByName('Matson Event Table Tent');
        String body = template.HtmlValue;
        IPrintService printService = (IPrintService)PhoenixCore.Service.newInstance(IPrintService.class);
        
        for (Print_Table_Tent__e evt : (List<Print_Table_Tent__e>)Records) {
            String bodyWithFirstName = body.replace('First', evt.Attendee_First_Name__c);
            String bodyWithFullName = bodyWithFirstName.replace('Last', evt.Attendee_Last_Name__c);
            printService.print(printersMap.get(evt.Printer_Id__c).Printer_Id__c, 'Table Tent for ' + evt.Attendee_First_Name__c + ' ' + evt.Attendee_Last_Name__c, 'text/html', bodyWithFullName);
        }
    }
}