public interface IMatsonEventRegistrationsSelector extends fflib_ISObjectSelector {
	List<Event_Registration__c> selectById(Set<ID> idSet);
    Event_Registration__c selectRegistrationWithEventFieldsById(Id recordId);
    List<Event_Registration__c> selectActiveEFT1RegistationByEventStartDate(Date eventStartDay);
    List<Event_Registration__c> selectEventRegistrationsByEventId(Id newEventId);
    List<Event_Registration__c> selectRegistrationByIdAndAdviserId(Set<Id> adviserIds, Id eventId);
    List<Event_Registration__c> selectAllCheckedEventRegistrations(Id eventId, String[] checkedRegistrations);
    List<Event_Registration__c> selectAdviserEventRegistrationsByEventId(Id newEventId);
    List<Event_Registration__c> selectEventRegistrationsByAdviserIdsAndEventIds(List<Id> eligibleAdviserIds, Id eventId);
    List<Event_Registration__c> filterEventRegistrationListByAdviserName(String name, List<Event_Registration__c> myList);
    String getSelectAllQuery();
    List<Event_Registration__c> selectFutureRegistrationsWithEventFields();
}