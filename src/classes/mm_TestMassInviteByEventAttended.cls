@isTest
public class mm_TestMassInviteByEventAttended {

	static testMethod void givenSearchKeyExpectFutureEvents() {
        
		// given
		        
        fflib_ApexMocks mocks = new fflib_ApexMocks();
  		IMatsonEventsSelector mockedMatsonEventsSelector = (IMatsonEventsSelector)mocks.mock(IMatsonEventsSelector.class);
        List<Event__c> listOfFakeEvents = CreateListOfFakePastEvents();
        String searchKey = 'Test';		// Search key similar to Event Name
        String name = '%' + searchKey + '%';
        
        mocks.startStubbing();
        mocks.when(mockedMatsonEventsSelector.sObjectType()).thenReturn(Event__c.SObjectType);    
        mocks.when(mockedMatsonEventsSelector.findAllNoncancelledFutureEventsBySearchKey(name)).thenReturn(listOfFakeEvents);
        mocks.stopStubbing();
        
        Application.Selector.setMock(mockedMatsonEventsSelector);

        // when
        List<Event__c> futureEvents = mm_MassInviteByEventAttendedController.SearchFutureEvents(searchKey);
        
        // then
		system.assertEquals(1, futureEvents.size());
      	
    }
    
    
    static testMethod void givenSearchKeyExpectPastEvents() {
        
		// given
		        
        fflib_ApexMocks mocks = new fflib_ApexMocks();
  		IMatsonEventsSelector mockedMatsonEventsSelector = (IMatsonEventsSelector)mocks.mock(IMatsonEventsSelector.class);
        List<Event__c> listOfFakeEvents = CreateListOfFakeFutureEvents();
        String searchKey = 'Test';		// Search key similar to Event Name
        String name = '%' + searchKey + '%';
        
        mocks.startStubbing();
        mocks.when(mockedMatsonEventsSelector.sObjectType()).thenReturn(Event__c.SObjectType);    
        mocks.when(mockedMatsonEventsSelector.findAllPastEventsBySearchKey(name)).thenReturn(listOfFakeEvents);
        mocks.stopStubbing();
        
        Application.Selector.setMock(mockedMatsonEventsSelector);

        // when
        List<Event__c> pastEvents = mm_MassInviteByEventAttendedController.SearchPastEvents(searchKey);
        
        // then
		system.assertEquals(1, pastEvents.size());
      	
    }
    
    static testMethod void givenEventIdsExpectEventRegistrations() {
        
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IMatsonEventRegistrationsSelector mockedEventRegistrationsSelector = (IMatsonEventRegistrationsSelector)mocks.mock(IMatsonEventRegistrationsSelector.class);
        IAdvisersSelector mockedAdvisersSelector = (IAdvisersSelector)mocks.mock(IAdvisersSelector.class);
        
        Id pastEventId = CreateFakePastEvent().Id;
        Id futureEventId = CreateFakeFutureEvent().Id;
        
        Adviser__c firstAdviser = CreateFakeAdviser();
        Adviser__c secondAdviser = CreateFakeAdviser();
        
        Event_Registration__c firstPastRegistration = GivenEventIdAndAdviserCreateFakeRegistration(pastEventId, firstAdviser);
        Event_Registration__c secondPastRegistration = GivenEventIdAndAdviserCreateFakeRegistration(pastEventId, secondAdviser);
        Event_Registration__c futureRegistration = GivenEventIdAndAdviserCreateFakeRegistration(futureEventId, firstAdviser);
        
        List<Event_Registration__c> pastEventRegistrations = new List<Event_Registration__c>{firstPastRegistration, secondPastRegistration};
        List<Event_Registration__c> futureEventRegistrations = new List<Event_Registration__c>{futureRegistration};
            
        Set<Id> pastAdviserSet = new Set<Id>{firstAdviser.Id, secondAdviser.Id};
        Set<Id> advisersToExclude = new Set<Id>{firstAdviser.Id};
        List<Adviser__c> eligibleAdvisers = new List<Adviser__c>{secondAdviser};
        List<Id> eligibleAdviserIds = new List<Id>{secondAdviser.Id};
        List<Event_Registration__c> secondRegistrationList = new List<Event_Registration__c>{secondPastRegistration};
            
        mocks.startStubbing();
        
        mocks.when(mockedEventRegistrationsSelector.sObjectType()).thenReturn(Event_Registration__c.SObjectType); 
        mocks.when(mockedAdvisersSelector.sObjectType()).thenReturn(Adviser__c.SObjectType);
        mocks.when(mockedEventRegistrationsSelector.selectEventRegistrationsByEventId(pastEventId)).thenReturn(pastEventRegistrations);        
        mocks.when(mockedEventRegistrationsSelector.selectEventRegistrationsByEventId(futureEventId)).thenReturn(futureEventRegistrations);
        mocks.when(mockedAdvisersSelector.selectEligibleMassSwitchAdviserIds(pastAdviserSet, advisersToExclude)).thenReturn(eligibleAdvisers);
        mocks.when(mockedEventRegistrationsSelector.selectEventRegistrationsByAdviserIdsAndEventIds(eligibleAdviserIds, pastEventId)).thenReturn(secondRegistrationList);
        
        mocks.stopStubbing();
        
        Application.Selector.setMock(mockedEventRegistrationsSelector);
        Application.Selector.setMock(mockedAdvisersSelector);
        
        // when

        List<Event_Registration__c> selectedEventRegistrations = mm_MassInviteByEventAttendedController.FindRegistrationsByEvent(pastEventId, futureEventId);
        
        // then
        
        system.assertEquals(secondRegistrationList, selectedEventRegistrations);
        
    }
    
    static testMethod void givenEventRegistrationsExpectAdvisers(){
        
        // given
        
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IMatsonEventRegistrationsSelector mockedCheckedEventRegistrationsSelector = (IMatsonEventRegistrationsSelector)mocks.mock(IMatsonEventRegistrationsSelector.class);
        
        Event__c pastEvent = CreateFakePastEvent();
        
        Adviser__c firstAdviser = CreateFakeAdviser();
        Adviser__c secondAdviser = CreateFakeAdviser();
        
        Event_Registration__c firstRegistration = GivenEventIdAndAdviserCreateFakeRegistration(pastEvent.Id, firstAdviser);
        Event_Registration__c secondRegistration = GivenEventIdAndAdviserCreateFakeRegistration(pastEvent.Id, secondAdviser);
        
        String[] listOfRegistrations = new String[]{firstRegistration.Id, secondRegistration.Id};
        List<Event_Registration__c> listOfEventRegistrationsToReturn = new List<Event_Registration__c>{firstRegistration, secondRegistration};
        
        mocks.startStubbing();
        mocks.when(mockedCheckedEventRegistrationsSelector.sObjectType()).thenReturn(Event_Registration__c.SObjectType);    
        mocks.when(mockedCheckedEventRegistrationsSelector.selectAllCheckedEventRegistrations(pastEvent.Id, listOfRegistrations)).thenReturn(listOfEventRegistrationsToReturn);
        mocks.stopStubbing();
        
        Application.Selector.setMock(mockedCheckedEventRegistrationsSelector);
        
        // when
        
        List<Id> adviserIds = mm_MassInviteByEventAttendedController.GetAdvisersFromRegistrations(pastEvent.Id, listOfRegistrations);
        
        // then
        
        system.assertEquals(2, adviserIds.size());
        
    }
    
    static testMethod void givenEventAndAdviserIdsInviteAdvisers(){
        
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_SobjectUnitOfWork mockUow =
                (fflib_SobjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        
        Event__c futureEvent = CreateFakeFutureEvent();
        Adviser__c firstAdviser = CreateFakeAdviser();
        Adviser__c secondAdviser = CreateFakeAdviser();
        
        Application.UnitOfWork.setMock(mockUow);
        
        List<Id> listOfAdviserIds = new List<Id>{firstAdviser.Id, secondAdviser.Id};
           
        // when
        
        mm_MassInviteByEventAttendedController.InviteAdvisers(futureEvent.Id, listOfAdviserIds, 'Invited');
        
        // then
        
        ((fflib_SobjectUnitOfWork)mocks.verify(mockUow, listOfAdviserIds.size())).registerNew(fflib_Match.sObjectOfType(Event_Registration__c.SObjectType));
        
    }
    
    static testMethod void givenSearchKeyAndRegistrationListFilterAdviesrs(){
        
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_SobjectUnitOfWork mockUow =
                (fflib_SobjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);

        Event__c futureEvent = CreateFakeFutureEvent();
        
        Adviser__c firstAdviser = (Adviser__c)new sfab_FabricatedSObject(Adviser__c.class)
            .setField(Adviser__c.Id, fflib_IDGenerator.generate(Adviser__c.SObjectType))
            .setField(Adviser__c.Status__c, 'Active Prospect')
            .setField(Adviser__c.Primary_Contact__r.Name, 'Test Adviser').toSObject(); 
        
        Adviser__c secondAdviser = CreateFakeAdviser();
        
        Event_Registration__c firstRegistration = GivenEventIdAndAdviserCreateFakeRegistration(futureEvent.Id, firstAdviser);
        Event_Registration__c secondRegistration = GivenEventIdAndAdviserCreateFakeRegistration(futureEvent.Id, secondAdviser);
        
        Application.UnitOfWork.setMock(mockUow);
        
        List<Event_Registration__c> listOfEventRegistrations = new List<Event_Registration__c>{firstRegistration, secondRegistration};
        String searchKey = 'test';
           
        // when
        
        List<Event_Registration__c> returnedRegistrationList = mm_MassInviteByEventAttendedController.FilterEventRegistrationsList(searchKey, listOfEventRegistrations);
        
        // then
        
        ((fflib_SobjectUnitOfWork)mocks.verify(mockUow, returnedRegistrationList.size())).registerNew(fflib_Match.sObjectOfType(Event_Registration__c.SObjectType));
        
    }

    // helper methods

    static Event__c CreateFakeFutureEvent() {
		return (Event__c)new sfab_FabricatedSObject(Event__c.class)
            .setField(Event__c.Id, fflib_IDGenerator.generate(Event__c.SObjectType))
            .setField(Event__c.Venue__c, fflib_IDGenerator.generate(Venue__c.SObjectType))
            .setField(Event__c.Course_Name__c, 'Other')
            .setField(Event__c.Name, 'Test Event')
            .setField(Event__c.Event_Description__c, 'This is a fake event.')
            .setField(Event__c.Event_Start_Date__c, system.today() + 2)
            .setField(Event__c.Maximum_Registration__c, '100').toSObject();
    }
    
    static Event__c CreateFakePastEvent() {
		return (Event__c)new sfab_FabricatedSObject(Event__c.class)
            .setField(Event__c.Id, fflib_IDGenerator.generate(Event__c.SObjectType))
            .setField(Event__c.Venue__c, fflib_IDGenerator.generate(Venue__c.SObjectType))
            .setField(Event__c.Course_Name__c, 'Other')
            .setField(Event__c.Name, 'Test Event')
            .setField(Event__c.Event_Description__c, 'This is a fake event.')
            .setField(Event__c.Event_Start_Date__c, system.today() - 2)
            .setField(Event__c.Maximum_Registration__c, '100').toSObject();
    }
    
    static Event_Registration__c GivenEventIdAndAdviserCreateFakeRegistration(Id eventId, Adviser__c adviser) {
         return (Event_Registration__c)new sfab_FabricatedSObject(Event_Registration__c.class)
            .setField(Event_Registration__c.Event__c, eventId)
            .setField(Event_Registration__c.Reg_Adviser__c, adviser.Id)
             .setField(Event_Registration__c.Status__c, 'Attended')
            .setField(Event_Registration__c.Attendee_Type__c, 'Adviser').toSObject();  
    }       
    
    static List<Event__c> CreateListOfFakePastEvents() {
        return new List<Event__c> {
            CreateFakePastEvent()
        };
    }
    
    static List<Event__c> CreateListOfFakeFutureEvents() {
        return new List<Event__c> {
            CreateFakeFutureEvent()
        };
    }
    
    static Adviser__c CreateFakeAdviser(){
        return (Adviser__c)new sfab_FabricatedSObject(Adviser__c.class)
            .setField(Adviser__c.Id, fflib_IDGenerator.generate(Adviser__c.SObjectType))
            .setField(Adviser__c.Status__c, 'Active Prospect')
            .setField(Adviser__c.Primary_Contact__c, fflib_IDGenerator.generate(Contact.SObjectType)).toSObject(); 
    }
    
    
 }