public with sharing class getAgenda {

    public String eventId {get;set;}

 
    public List<Event_Days__c> getAgendaList() {
         system.debug('eventID' + eventID);
        return eventDaysSelector().getByEvent(System.currentPageReference().getParameters().get('EventId'));
    }

    private static IEventDaysSelector eventDaysSelector() {
        return (IEventDaysSelector)Application.Selector.newInstance(Event_Days__c.SObjectType);
    }
}