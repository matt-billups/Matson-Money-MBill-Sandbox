public class mm_MassInviteByEventAttendedController {
    
    @AuraEnabled
    public static List<Event__c> SearchFutureEvents(String searchKey) {
        String name = '%' + searchKey + '%';
        List<Event__c> searchResults = ((IMatsonEventsSelector)Application.Selector.newInstance(Event__c.SObjectType)).findAllNoncancelledFutureEventsBySearchKey(name);
        // filter out EFT1 Events
        
        for (integer i = 0; i < searchResults.size(); i++){
            if (searchResults[i].Course_Name__c == 'Entrepreneur Foundation Training Session 1'){
                searchResults.remove(i);
            }
        }
        return searchResults;
    }
    
    
    @AuraEnabled
    public static List<Event__c> SearchPastEvents(String searchKey) {
        String name = '%' + searchKey + '%';
        return ((IMatsonEventsSelector)Application.Selector.newInstance(Event__c.SObjectType)).findAllPastEventsBySearchKey(name);
    }
    
    @AuraEnabled
    public static List<Event_Registration__c> FilterEventRegistrationsList(String searchKey, List<Event_Registration__c> registrationList) {
        String name = '%' + searchKey + '%';
        List<Event_Registration__c> includedRegistrations = ((IMatsonEventRegistrationsSelector)Application.Selector.newInstance(Event_Registration__c.SObjectType)).filterEventRegistrationListByAdviserName(name, registrationList);
        return includedRegistrations;
    }
    
    @AuraEnabled
    public static List<Event_Registration__c> FindRegistrationsByEvent(Id eventId, Id newEventId) {        
		List<Event_Registration__c> pastEventRegistrations = ((IMatsonEventRegistrationsSelector)Application.Selector.newInstance(Event_Registration__c.SObjectType)).selectEventRegistrationsByEventId(eventId);
        List<Event_Registration__c> futureEventRegistrations = ((IMatsonEventRegistrationsSelector)Application.Selector.newInstance(Event_Registration__c.SObjectType)).selectEventRegistrationsByEventId(newEventId);
        
        List<Event_Registration__c> pastAttendedEventRegistrations = new List<Event_Registration__c>();
        Set<Id> pastAdviserSet = new Set<Id>();
        for (Event_Registration__c evr : pastEventRegistrations){
            if (evr.Status__c == 'Attended') {
                pastAttendedEventRegistrations.add(evr);
                pastAdviserSet.add(evr.Reg_Adviser__c);
            }
        }

        Set<Id> advisersToExclude = new Set<Id>();
        for (Event_Registration__c evr : futureEventRegistrations) {
            advisersToExclude.add(evr.Reg_Adviser__c);
        }

        List<Adviser__c> eligibleAdvisers = ((IAdvisersSelector)Application.Selector.newInstance(Adviser__c.SObjectType)).selectEligibleMassSwitchAdviserIds(pastAdviserSet, advisersToExclude);
	
        List<Id> eligibleAdviserIds = new List<Id>();
        for (Adviser__c adv : eligibleAdvisers){
            eligibleAdviserIds.add(adv.Id);
        }

        return ((IMatsonEventRegistrationsSelector)Application.Selector.newInstance(Event_Registration__c.SObjectType)).selectEventRegistrationsByAdviserIdsAndEventIds(eligibleAdviserIds, eventId);

    }
    
    @AuraEnabled
    public static List<Id> GetAdvisersFromRegistrations(Id eventId, string[] checkedRegistrations) {
        List<Event_Registration__c> registrations = ((IMatsonEventRegistrationsSelector)Application.Selector.newInstance(Event_Registration__c.SObjectType)).selectAllCheckedEventRegistrations(eventId, checkedRegistrations);
        List<Id> advisers = new List<Id>();
        for (integer i = 0; i < registrations.size(); i++) {
            advisers.add(registrations[i].Reg_Adviser__c);
        }
        return advisers;
    }
    
    @AuraEnabled
    public static Void InviteAdvisers(Id eventId, List<Id> adviserIds, String registrationStatus) {

        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
 		
        for (Id adviser : adviserIds) {
            Event_Registration__c reg = new Event_Registration__c();
            reg.Event__c = eventId;
            reg.Attendee_Type__c = 'Adviser';
            reg.Reg_Adviser__c = adviser;
            reg.Status__c = registrationStatus; 
            uow.registerNew(reg);
        }
        
        uow.commitWork();

    }
}