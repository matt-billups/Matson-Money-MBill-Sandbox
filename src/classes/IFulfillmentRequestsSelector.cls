public interface IFulfillmentRequestsSelector extends fflib_ISObjectSelector {
    IFulfillmentRequestsSelector newInstance();
    List<Fulfillment_Request__c> selectFulfillmentRequestsByContactIdAndProductId(Id contactId, Id productId);
}