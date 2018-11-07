public interface IAdvisersSelector extends fflib_ISObjectSelector {
    List<Adviser__c> selectById(Set<ID> idSet);
    Set<Id> getSetOfAllIds();
    String getSelectAllQuery();
    List<Adviser__c> selectEligibleMassSwitchAdviserIds(Set<Id> pastAdviserSet, Set<Id> advisersToExclude);
}