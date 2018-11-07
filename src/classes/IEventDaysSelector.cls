public interface IEventDaysSelector {
    List<Event_Days__c> getByEvent(Id eventId);
}