public with sharing class MatsonEventRegistrations extends ApplicationDomain implements IMatsonEventRegistrations, ICleansable {
    
    public static IMatsonEventRegistrations newInstance(List<Event_Registration__c> listOfEventRegistrations) {
        return (IMatsonEventRegistrations)Application.Domain.newInstance(listOfEventRegistrations);
    }
    
    public MatsonEventRegistrations(List<Event_Registration__c> eventRegistrations) {
        super(eventRegistrations);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        
        public fflib_SObjectDomain construct(List<SObject>sObjectList) {
            return new MatsonEventRegistrations(sObjectList);
        }
        
    }
    
    public void cleanseData() {
        if (Environment.isSandboxOrg()) {
            fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
            for (Event_Registration__c eventRegistration : (List<Event_Registration__c>)Records) {
                if (!String.isBlank(eventRegistration.Adviser_Email__c)) {
                    eventRegistration.Adviser_Email__c = 'scrubbedadviseremail@example.com';
                }
                
                if (!String.isBlank(eventRegistration.Attendee_Email__c)) {
                    eventRegistration.Attendee_Email__c = 'scrubbedattendeeemail@example.com';
                }
                
                uow.registerDirty(eventRegistration);
            }
            
            uow.commitWork();
        }
        else {
            System.debug('THIS IS NOT A SANDBOX AND CLEANSE DATA SHOULD NEVER BE RUN IN PRODUCTION');
        }
    }
}