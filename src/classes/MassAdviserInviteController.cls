public class MassAdviserInviteController {
    
    @AuraEnabled
    public static List<Adviser__c> getAdvisers(Id eventId, boolean isgetBothAdviserAndProspest) 
    {
        Event__c E =[select Id, Course_Name__c from Event__c Where Id = :eventId];       
        if(E.Course_Name__c == 'Entrepreneur Foundation Training Session 1')
        {
            RecordType RT =[select ID From RecordType where name = 'Adviser Prospect'];
            List<Adviser__c> adviserList =  [SELECT Id, name,Primary_Contact_Name__c, Company__c, Contact_Email__c, Status__c, Adviser_Number__c, X3_Biggest_Money_Problems__c, Pain_Money_Total__c, Inventory_Date__c
                    FROM Adviser__c where 
                    Id NOT IN(SELECT Reg_Adviser__c from Event_Registration__c where Event__c=:eventId AND Attendee_Type__c = 'Adviser') 
                    AND RecordTypeId = :RT.ID  
                    AND (Status__c <>'BlackListed') 
                    AND (Status__c <> 'Terminated' )
                    AND (Pain_Money_Total__c !=null)
                    AND (Inventory_Date__c != null)
                    and Primary_Contact__r.IsEmailBounced <> true
                    and (Primary_Contact__r.Email <> null or Primary_Contact__r.Email <> '')                
                   ];
            // Filter out Advisers that have not filled out 3 Biggest Money Problems field
            List<Adviser__c> returnList = new List<Adviser__c>();
            for (Adviser__c adviser : adviserList){
                if (adviser.X3_Biggest_Money_Problems__c != null){
                    returnList.add(adviser);
                }
            }
            return returnList;
        }
        else if(isgetBothAdviserAndProspest == false) 
        {
            return [SELECT Id, name,Primary_Contact_Name__c, Company__c, Contact_Email__c, Adviser_Number__c
                    FROM Adviser__c where 
                    Primary_Contact__c NOT IN(SELECT Contact__c from Event_Registration__c where Event__c=:eventId ) 
                    AND Status__c <>'BlackListed' AND Status__c <> 'Terminated' 
                    AND RecordType.Name <>'Adviser Prospect'and Primary_Contact__r.IsEmailBounced <> true and (Primary_Contact__r.Email <> null or Primary_Contact__r.Email <> '') ORDER BY Primary_Contact_Name__c ASC];
        }
        else if(isgetBothAdviserAndProspest == true){
             return [SELECT Id, name,Primary_Contact_Name__c, Company__c, Contact_Email__c, Adviser_Number__c
                    FROM Adviser__c where 
                   Primary_Contact__c NOT IN(SELECT Contact__c from Event_Registration__c where Event__c=:eventId ) 
                    AND Status__c <>'BlackListed' AND Status__c <> 'Terminated' and Primary_Contact__r.IsEmailBounced <> true and (Primary_Contact__r.Email <> null or Primary_Contact__r.Email <> '') ORDER BY Primary_Contact_Name__c ASC];
        }
        else{
             return null;
        }
    }
    @AuraEnabled
    public static string getEventName(Id eventId)
    {
        
        Event__c E =[select Id,
                     Name,
                     Email_Invite_Body__c
                     from Event__c Where Id = :eventId];
        
        Return E.Name;        
    }
    
    @AuraEnabled
    public static boolean eventCancelled(Id eventId)
    {
        Event__c e = [SELECT Id, Event_Status__c FROM Event__c WHERE Id =: eventId];
        String status = string.valueOf(e.Event_Status__c);
        Boolean myBool = false;
        if (status == 'Cancelled'){
            myBool = true;
        }
        return myBool;            
    }    
    
    @AuraEnabled
    public static boolean eventCompleted(Id eventId)
    {
        Event__c e = [SELECT Id, Event_End_Date__c FROM Event__c WHERE Id =: eventId];
        Boolean myBool = false;
        if (e.Event_End_Date__c < System.today()){
            myBool = true;
        }
        return myBool;            
    }
    
    @AuraEnabled
    public static void inviteAdvisersToEvent(Id eventId, string[] adviserIds)
    {
        String query = 'SELECT Id FROM Adviser__c WHERE Id IN: adviserIds ORDER BY Primary_Contact_Name__c ASC';
        Id batchInstanceId = Database.executeBatch(new BatchMassInviteAdvisers(query, eventId, adviserIds),20);
    }
    
    @AuraEnabled
    public static List<Adviser__c> filterAdviserResults(String searchKey, List<Adviser__c> adviserList) {
        
        String name = '%' + searchKey + '%';
        List<Adviser__c> filteredAdviserList = [SELECT Id, Primary_Contact_Name__c, Adviser_Number__c, Contact_Email__c FROM Adviser__c WHERE Id IN: adviserList AND Primary_Contact__r.Name LIKE: name];
        return filteredAdviserList;
        
    }
    
}