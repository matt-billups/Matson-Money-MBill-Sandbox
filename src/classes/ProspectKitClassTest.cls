@isTest public class ProspectKitClassTest {
    
    static testMethod void givenContactHasFulfillmentsRequest()
    {
        
        
        //given
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');  
        
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IFulfillmentRequestsSelector mockedFulfillmentRequestsSelector = (IFulfillmentRequestsSelector)mocks.mock(IFulfillmentRequestsSelector.class);
        
        Contact fakeContact = fakeContact();
        Product2 fakeProduct = createFakeProduct();
        
        Fulfillment_Request__c fakeFulfillment = fakeFulfillmentRequest(fakeContact, fakeProduct );
        
        List<Fulfillment_Request__c> fakeListOfFullfillments  = new List<Fulfillment_Request__c>();
        fakeListOfFullfillments.add(fakeFulfillment);
        
        mocks.startStubbing();
        mocks.when(mockedFulfillmentRequestsSelector.sObjectType()).thenReturn(Fulfillment_Request__c.sObjectType);
        mocks.when(mockedFulfillmentRequestsSelector.selectFulfillmentRequestsByContactIdAndProductId(fakeContact.Id, fakeProduct.Id)).thenReturn(fakeListOfFullfillments); 
        mocks.stopStubbing();
        
        Application.Selector.setMock(mockedFulfillmentRequestsSelector); 
        //When
        
        test.startTest();
        
        List <Fulfillment_Request__c> returnedListOFFulfillments  = ProspectKitClass.GetProspectKitFulfillment(fakeContact.Id);
        
        test.stopTest();
        
        // Then
        system.assertEquals(fakeListOfFullfillments, returnedListOFFulfillments);
        
    }
    static testMethod void givenContactInformationCreateFulfillmentRequest(){
        //given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        Application.UnitOfWork.setMock(mockUow); 
        
        
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');
        Contact fakeContact = fakeContact();
        Product2 fakeProduct = createFakeProduct();
        
        
        //When
        
        test.startTest();        
        ProspectKitClass.CreateProspectKitFulfillment(fakeContact.Id, fakeContact.Name, fakeContact.MailingStreet, fakeContact.MailingCity, fakeContact.MailingState, fakeContact.MailingPostalCode);
        test.stopTest();
        
         // Then
         ((fflib_SobjectUnitOfWork) mocks.verify(mockUow,
                                                mocks
                                                .times(1))).commitWork();
                                                        
    }
    
    static Product2 createFakeProduct()
    {
        
        Product2 p = new Product2();
        p.Name = 'Test Water';
        p.ProductCode = 'PKAAK-001';
        p.IsActive = true;
        insert p;
        return p;
    }
    
    static Fulfillment_Request__c fakeFulfillmentRequest(Contact con , Product2 product )
    {
        Fulfillment_Request__c request = new Fulfillment_Request__c();
        request.Contact__c = con.id;
        request.Product__c = product.id;
        return request;
    }
    static Contact fakeContact()
    {
        Contact con = new Contact();
        con.id = fflib_IDGenerator.generate(Contact.SObjectType);
        con.MailingStreet = '1234 Johns Ave';
        con.MailingCity = 'Mason';
        con.MailingState = 'Ohio';
        con.MailingPostalCode = '45040';
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        
        return con;
    }
    
}