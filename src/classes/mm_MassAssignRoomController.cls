public class mm_MassAssignRoomController {
    
    @AuraEnabled
    public static List<Event__c> FindAllFutureEvents()
    {
        return [SELECT Id, Name FROM Event__c WHERE Event_End_Date__c >=: date.today() ORDER BY Event_Start_Date__c, Name];
    }
    
    @AuraEnabled
    public static List<Venue_Room__c> FindVenueRoomsByEvent(Id eventId)
    {
        Event__c e = [SELECT Venue__c FROM Event__c WHERE Id =: eventId];
        
        return [SELECT Id, Room_Name__c, Capacity__c FROM Venue_Room__c WHERE Venue__c =: e.Venue__c ORDER BY Room_Name__c];
    }
    
    @AuraEnabled
    public static Integer VenueRoomRegistrationCount(Id eventId, Id roomId)
    {
        List<Event_Registration__c> registrations = [SELECT Id FROM Event_Registration__c WHERE Event__c =: eventId AND Venue_Room__c =: roomId AND (Status__c = 'Registered' OR Status__c = 'Attended') ORDER BY Attendee_Name__c];
        
        return registrations.size();
    }
    
    @AuraEnabled
    public static List<Event_Registration__c> FindRegistrationsByEvent(Id eventId)
    {
        return [SELECT Id, Name, Attendee_Name__c, Attendee_Type__c, Venue_Room_Name__c, Parent_Registration__c, Mass_Assign_Room_Sort_Value__c, Status__c FROM Event_Registration__c WHERE Event__c =: eventId AND (Status__c = 'Registered' OR Status__c = 'Attended') ORDER BY Venue_Room_Name__c, Mass_Assign_Room_Sort_Value__c, Attendee_Type__c, Attendee_Name__c];
    }
    
    @AuraEnabled
    public static Integer AssignRoom(Id roomId, string[] eventRegistrationIds)
    {
        List<Event_Registration__c> registrationsToUpdate = [SELECT Id, Venue_Room__c FROM Event_Registration__c WHERE Id in: eventRegistrationIds];
        
        for (Event_Registration__c eventReg : registrationsToUpdate)
        {
            eventReg.Venue_Room__c = roomId;
        }
        
        update registrationsToUpdate;
        
        return registrationsToUpdate.size();
    }
}