public class mm_MassSwitchAdviserCoachController {
    
    @AuraEnabled
    public static List<User> selectAdviserCoachByName(String searchKey) {
        String name = '%' + searchKey + '%';
        String PermSetLabel = 'Adviser Coach';
        List<PermissionSetAssignment> listOfPermSetAssignments = [SELECT id, AssigneeId, Assignee.Name FROM PermissionSetAssignment WHERE PermissionSet.Label LIKE:PermSetLabel Limit 15];
        Set<Id> adviserCoachIds = new Set<Id>();
        for(PermissionSetAssignment permSetAssignment : listOfPermSetAssignments){
            adviserCoachIds.add(permSetAssignment.AssigneeId);
        }
        return [SELECT Id, Name FROM User WHERE Id IN :adviserCoachIds AND Name LIKE :name ];
        
    }
    
    @AuraEnabled
    public static List<Event__c> findByEvent(String searchKey) {
        String name = '%' + searchKey + '%';
        return [SELECT id, Name, Event_Start_Date__c  FROM Event__c WHERE  name LIKE :name LIMIT 5];
    }
    
    @AuraEnabled
    public static List<User> selectAllAdviserCoaches() {
        String PermSetLabel = 'Adviser Coach';
        List<PermissionSetAssignment> listOfPermSetAssignments = [SELECT id, AssigneeId, Assignee.Name FROM PermissionSetAssignment WHERE PermissionSet.Label LIKE:PermSetLabel Limit 15];
        Set<Id> whoIds = new Set<Id>();
        for(PermissionSetAssignment permSetAssignment : listOfPermSetAssignments){
            whoIds.add(permSetAssignment.AssigneeId);
        }
        
        return [SELECT id, Name  FROM User WHERE Id IN :whoIds];
        
    }
    
    @AuraEnabled
    public static List<Adviser__c> findAdviserByAdviserCoach(Id adviserCoachId) {
        
        return [SELECT Id, name, Primary_Contact_Name__c, Adviser_Number__c, Contact_Email__c  FROM Adviser__c WHERE Adviser_Coach__c = :adviserCoachId order by Primary_Contact_Name__c];
        
    }
    
    @AuraEnabled
    public static List<Adviser__c> findAdviserByEvent(Id eventId) {
        
        return [SELECT Id, name, Primary_Contact_Name__c, Adviser_Number__c, Contact_Email__c FROM Adviser__c WHERE Id in (SELECT Reg_Adviser__c FROM Event_Registration__c WHERE Event__c = :eventId) order by Primary_Contact_Name__c];
        
    }
    
    @AuraEnabled
    public static List<Adviser__c> findAllAdviser() {
        
        return [SELECT Id, name, Primary_Contact_Name__c, Adviser_Number__c, Contact_Email__c FROM Adviser__c order by Primary_Contact_Name__c];
        
    }
    
    @AuraEnabled
    public static Void switchAdvisers(Id adviserCoachId, string[] adviserIds )  {
        List<Adviser__c> advisersToBeUpdated = [SELECT Id, Adviser_Coach__c FROM Adviser__c WHERE Id in: adviserIds];        
        for (Adviser__c AdviserId : advisersToBeUpdated) {
          AdviserId.Adviser_Coach__c = adviserCoachId;
        }
        
         update advisersToBeUpdated; 
    }
    
    @AuraEnabled
    public static List<Adviser__c> FilterAdvisersList(String searchKey, List<Adviser__c> adviserList) {
        String name = '%' + searchKey + '%';
        List<Adviser__c> returnList = [SELECT Id, Name, Primary_Contact_Name__c, Adviser_Number__c, Contact_Email__c FROM Adviser__c WHERE Id IN: adviserList AND Primary_Contact__r.Name LIKE: name ORDER BY Primary_Contact_Name__c];
        return returnList;
    }
    
    
}