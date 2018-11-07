public with sharing class EventDaysSelector extends fflib_SObjectSelector implements IEventDaysSelector {


    public SObjectType getSObjectType() {
        return Event_Days__c.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField> {
                Event_Days__c.Id,
                Event_Days__c.Name,
                Event_Days__c.Event_Day_End_Time__c ,
                Event_Days__c.Event_Day_Start_Time__c ,
                Event_Days__c.Event_Day_Start_Date__c
        };
    }

    public override String getOrderBy() {
        return 'OrderRelatedListbyDateandStartTime__c';
    }

    public List<Event_Days__c> getByEvent(Id eventId) {

        fflib_QueryFactory queryFactory = newQueryFactory();

        queryFactory.setCondition('Matson_Event__c = :eventId');

        return (List<Event_Days__c>)Database.query(queryFactory.toSOQL());
    }
}