public class FulfillmentRequestsSelector extends fflib_SObjectSelector implements IFulfillmentRequestsSelector{

    public static IFulfillmentRequestsSelector newInstance()
    {
        return (IFulfillmentRequestsSelector) Application.Selector.newInstance(Fulfillment_Request__c.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {
            Fulfillment_Request__c.Id,
                Fulfillment_Request__c.CreatedById,
                Fulfillment_Request__c.Requested_Date_Time__c,
                Fulfillment_Request__c.Contact__c,
                Fulfillment_Request__c.Product__c
                };
                    }

    public Schema.SObjectType getSObjectType()
    {
        return Fulfillment_Request__c.sObjectType;
    }

    public List<Fulfillment_Request__c> selectFulfillmentRequestsByContactIdAndProductId(Id contactId, Id productId)
    {
        fflib_QueryFactory query = newQueryFactory();

        fflib_SObjectSelector userSelector = new UserSelector();
        userSelector.configureQueryFactoryFields(query, 'CreatedBy');
        string condition = 'Contact__c = :contactId and Product__c = :productId';
        query.setCondition(condition);
        return (List<Fulfillment_Request__c>)  Database.query( query.toSOQL() );
    }
}