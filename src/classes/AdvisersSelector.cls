public with sharing class AdvisersSelector extends fflib_SObjectSelector implements IAdvisersSelector {

    public static IAdvisersSelector newInstance()
    {
        return (IAdvisersSelector) Application.Selector.newInstance(Adviser__c.SObjectType);
    }

    public Schema.SObjectType getSObjectType() {
        return Adviser__c.SObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<SObjectField> {
            Adviser__c.Id,
            Adviser__c.Name_on_Credit_Card__c,
            Adviser__c.Credit_Card_Number__c,
            Adviser__c.Credit_Card_Expiration__c,
            Adviser__c.Assistant_Email__c,
            Adviser__c.Transfer_Email__c,
            Adviser__c.Status__c
        };
    }

    public List<Adviser__c> selectById(Set<Id> idSet) {
        return (List<Adviser__c>)selectSObjectsById(idSet);
    }
    
    public Set<Id> getSetOfAllIds() {

        return new Map<Id, Adviser__c>([SELECT Id FROM Adviser__c]).keySet();
    }
    
    public String getSelectAllQuery() {
        return newQueryFactory().toSOQL();
    }
    
    public List<Adviser__c> selectEligibleMassSwitchAdviserIds(Set<Id> pastAdviserSet, Set<Id> advisersToExclude){
        fflib_QueryFactory query = newQueryFactory();
        string condition = ('Id in: pastAdviserSet AND Id NOT in: advisersToExclude AND (Status__c = \'Active Prospect\' OR Status__c = \'Active Adviser\')');
        query.setCondition(condition);
        return (List<Adviser__c>)  Database.query( query.toSOQL() );
    }
}