public interface IMatsonEventsSelector extends fflib_ISObjectSelector {
	List<Event__c> selectById(Set<ID> idSet);
    List<Event__c> findAllNoncancelledFutureEventsBySearchKey(String searchKey);
    List<Event__c> findAllPastEventsBySearchKey(String searchKey);
    List<Event__c> selectFutureEvents();
}