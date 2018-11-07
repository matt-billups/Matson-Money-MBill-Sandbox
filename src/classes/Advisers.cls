public with sharing class Advisers extends ApplicationDomain implements ICleansable {
    
    public Advisers(List<Adviser__c> advisers) {
        super(advisers);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        
        public fflib_SObjectDomain construct(List<SObject>sObjectList) {
            return new Advisers(sObjectList);
        }
        
    }
    
    public void cleanseData() {
        if (Environment.isSandboxOrg()) {
            fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
            for (Adviser__c adviser : (List<Adviser__c>)Records) {
                if (!String.isBlank(adviser.Name_on_Credit_Card__c) || !String.isBlank(adviser.Credit_Card_Number__c) || !String.isBlank(adviser.Credit_Card_Expiration__c)) {
                    adviser.Name_on_Credit_Card__c = '';
                    adviser.Credit_Card_Number__c = '';
                    adviser.Credit_Card_Expiration__c = '';
                }
                
                if (!String.isBlank(adviser.Assistant_Email__c)) {
                    adviser.Assistant_Email__c = 'scrubbedassistantemail@example.com';
                }
                
                if (!String.isBlank(adviser.Transfer_Email__c)) {
                    adviser.Transfer_Email__c = 'scrubbedtransferemail@example.com';
                }
                
                uow.registerDirty(adviser);
            }
            
            uow.commitWork();
        }
        else {
            System.debug('THIS IS NOT A SANDBOX AND CLEANSE DATA SHOULD NEVER BE RUN IN PRODUCTION');
        }
    }
}