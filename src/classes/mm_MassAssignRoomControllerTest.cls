@isTest
private class mm_MassAssignRoomControllerTest
{
    @testSetup static void Setup()
    {
        Id venueId = InsertVenue();
        List<Event__c> events = InsertEvents(venueId);
        List<Venue_Room__c> rooms = InsertVenueRooms(venueId);
        InsertRegistrations(events[1].Id, rooms[0].Id);
    }
    
    @isTest static void TestFindAllFutureEvents()
    {
        List<Event__c> expected = [SELECT Id, Name FROM Event__c WHERE Event_End_Date__c >=: date.today() ORDER BY Event_Start_Date__c, Name];
        List<Event__c> actual = mm_MassAssignRoomController.FindAllFutureEvents();
        
        System.assertEquals(expected.size(), actual.size());
        for (Integer i = 0; i < expected.size(); i++)
        {
            System.assertEquals(expected[i].Name, actual[i].Name);
        }
    }
    
    @isTest static void TestFindVenueRoomsByEvent()
    {
        Event__c event = [SELECT Id, Venue__c FROM Event__c WHERE Name = 'Test Event 1'];
        List<Venue_Room__c> expected = [SELECT Id, Room_Name__c, Capacity__c FROM Venue_Room__c WHERE Venue__c =: event.Venue__c ORDER BY Room_Name__c];
        List<Venue_Room__c> actual = mm_MassAssignRoomController.FindVenueRoomsByEvent(event.Id);
        
        System.assertEquals(expected.size(), actual.size());
        for (Integer i = 0; i < expected.size(); i++)
        {
            System.assertEquals(expected[i].Room_Name__c, actual[i].Room_Name__c);
        }
    }
    
    @isTest static void TestVenueRoomRegistrationCount()
    {
        Event__c event = [SELECT Id FROM Event__c WHERE Name = 'Test Event 1'];
        Venue_Room__c room = [SELECT Id FROM Venue_Room__c WHERE Room_Name__c = 'Room 0'];
        List<Event_Registration__c> registrations = [SELECT Id FROM Event_Registration__c WHERE Event__c =: event.Id AND Venue_Room__c =: room.Id AND (Status__c = 'Registered' OR Status__c = 'Attended') ORDER BY Attendee_Name__c];
        Integer expected = registrations.size();
        Integer actual = mm_MassAssignRoomController.VenueRoomRegistrationCount(event.Id, room.Id);
        
        System.assertEquals(expected, actual);
    }
    
    @isTest static void TestFindRegistrationsByEvent()
    {
        Event__c event = [SELECT Id FROM Event__c WHERE Name = 'Test Event 1'];
        List<Event_Registration__c> expected = [SELECT Id, Name, Attendee_Name__c, Attendee_Type__c, Venue_Room_Name__c, Parent_Registration__c, Mass_Assign_Room_Sort_Value__c, Status__c FROM Event_Registration__c WHERE Event__c =: event.Id AND (Status__c = 'Registered' OR Status__c = 'Attended') ORDER BY Venue_Room_Name__c, Mass_Assign_Room_Sort_Value__c, Attendee_Type__c, Attendee_Name__c];
        List<Event_Registration__c> actual = mm_MassAssignRoomController.FindRegistrationsByEvent(event.Id);
        
        System.assertEquals(expected.size(), actual.size());
        for (Integer i = 0; i < expected.size(); i++)
        {
            System.assertEquals(expected[i].Attendee_Name__c, actual[i].Attendee_Name__c);
        }
    }
    
    @isTest static void TestAssignRoom()
    {
        Event__c event = [SELECT Id FROM Event__c WHERE Name = 'Test Event 1'];
        Venue_Room__c room = [SELECT Id FROM Venue_Room__c WHERE Room_Name__c = 'Room 0'];
        List<Event_Registration__c> regs = [SELECT Id, Venue_Room__c FROM Event_Registration__c WHERE Event__c =: event.Id AND (Status__c = 'Registered' OR Status__c = 'Attended')];
        Integer expected = regs.size();
        
        List<String> regIds = new List<String>();
        for (Event_Registration__c reg : regs)
        {
            regIds.add(reg.Id);
        }
        
        Integer actual = mm_MassAssignRoomController.AssignRoom(room.Id, regIds);
        
        System.assertEquals(expected, actual);
        for (Event_Registration__c reg : regs)
        {
            System.assertEquals(room.Id, reg.Venue_Room__c);
        }
    }
    
    private static Id InsertVenue()
    {
        Venue__c venue = new Venue__c();
        venue.Name = 'Test Venue';
        venue.Concierge__c = 'Mason';
        venue.Street_Address_1__c = '123 Main St';
        venue.City__c = 'Anywho';
        venue.Venue_State__c = 'OH';
        venue.Postal_Code_Zip__c = '12345';
        
        insert venue;
        return venue.Id;
    }
    
    private static List<Event__c> InsertEvents(Id venueId)
    {
        List<Event__c> events = new List<Event__c>();
        Event__c event;
        
        //create test custom setting:
        //privateKey
        insert new EventTokenHashKey__c(Crypto__c = '123456789123456789112234');
        
        for (Integer i = 0; i < 3; i++)
        {
            event = new Event__c();
            event.Course_Name__c = 'Other';
            event.Name = 'Test Event ' + i;
            event.Event_Description__c = 'Event description';
            event.Venue__c = venueId;
            event.Maximum_Registration__c = 100;
            if (i == 0)
            {
                event.Event_Start_Date__c = date.today().addDays(-32);
                event.Event_End_Date__c = date.today().addDays(-30);
            }
            else
            {
                event.Event_Start_Date__c = date.today().addDays(30*i);
                event.Event_End_Date__c = date.today().addDays(32*i);
            }
            
            events.add(event);
        }
        
        insert events;
        return events;
    }
    
    private static List<Venue_Room__c> InsertVenueRooms(Id venueId)
    {
        List<Venue_Room__c> rooms = new List<Venue_Room__c>();
        Venue_Room__c room;
        
        for (Integer i = 0; i < 2; i++)
        {
            room = new Venue_Room__c();
            room.Venue__c = venueId;
            room.Room_Name__c = 'Room ' + i;
            room.Capacity__c = 50;
            
            rooms.add(room);
        }
        
        insert rooms;
        return rooms;
    }
    
    private static void InsertRegistrations(Id eventId, Id roomId)
    {
        List<Event_Registration__c> regs = new List<Event_Registration__c>();
        List<Contact> contacts = InsertContacts();
        Event_Registration__c reg;
        
        for (Integer i = 0; i < 5; i++)
        {
            reg = new Event_Registration__c();
            reg.Event__c = eventId;
            reg.Attendee_Type__c = 'Other';
            reg.Venue_Room__c = roomId;
            reg.Contact__c = contacts[i].Id;
            reg.Status__c = 'Attended';
            reg.Waiver_Status__c = 'Electronically Signed';
            
            regs.add(reg);
        }
        
        insert regs;
    }
    
    private static List<Contact> InsertContacts()
    {
        List<Contact> contacts = new List<Contact>();
        Contact contact;
        
        for (Integer i = 0; i < 5; i++)
        {
            contact = new Contact();
            contact.FirstName = 'John ' + i;
            contact.LastName = 'Smith ' + i;
            contact.Email = 'john.smith' + i + '@example.com';
            
            contacts.add(contact);
        }
        
        insert contacts;
        return contacts;
    }
}