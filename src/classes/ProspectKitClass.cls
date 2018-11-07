public without sharing class ProspectKitClass {
    
    Public static Product2 p = [select Id from Product2 where ProductCode = 'PKAAK-001'];

    @AuraEnabled
    public static List<Fulfillment_Request__c> GetProspectKitFulfillment(Id contactId) {
        
        IFulfillmentRequestsSelector requestsSelector = FulfillmentRequestsSelector.newInstance();

        List<Fulfillment_Request__c> listOfFulfillmentRequests =  requestsSelector.selectFulfillmentRequestsByContactIdAndProductId(contactId, p.Id);

        return listOfFulfillmentRequests;
        
    }

    @AuraEnabled
    public static void CreateProspectKitFulfillment(Id contactId, string name, string street, string city, string state, string zipCode )
    {
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

        userinfo.getName();
        Fulfillment_Request__c FR = new Fulfillment_Request__c();
        FR.Product__c = p.ID;
        FR.Contact__c = contactId;
        FR.Requested_Date_Time__c = system.now();
        FR.Ship_By__c = system.today().AddDays(2);
        FR.Ship_To_Name__c = name;
        FR.Street_Address__c = street;
        FR.City__c = city;
        FR.State__c = state;
        FR.Zip_Code__c = zipCode;

        uow.registerNew(FR);
        uow.commitWork();
     }  
}