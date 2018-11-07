@isTest public class getAgendaTest {
    static testMethod void givenAgenda(){
        //given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IEventDaysSelector mockedEventDaySelector  = (IEventDaysSelector)mocks.mock(IEventDaysSelector.class);
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        Application.UnitOfWork.setMock(mockUow); 
        
        Event__c fakeEvent = fakeEvent();
        Event_Days__c fakeEventDay = fakeEventDay(fakeEvent);
        List <Event_Days__c> listOfFakeEventDays = new List<Event_Days__c>();
        listOfFakeEventDays.add(fakeEventDay);
        
        mocks.startStubbing();
        mocks.when(mockedEventDaySelector.getByEvent(fakeEvent.Id)).thenReturn(listOfFakeEventDays);
        mocks.stopStubbing();
        
        
        
         //When
        
        test.startTest();
        getAgenda getDays = new getAgenda();
        getDays.eventId = fakeEvent.Id;
        getDays.getAgendaList();
        test.stopTest();
        
    }
    static Event__c fakeEvent()
    {
        Event__c event1 = new Event__c();
        event1.Id = fflib_IDGenerator.generate(Event__c.SObjectType);
        return event1;
    }
    static Event_Days__c  fakeEventDay( Event__c fakeEvent)
    {
        Event_Days__c fakeEventDay = new Event_Days__c();
        fakeEventDay.Matson_Event__c = fakeEvent.Id;
        fakeEventDay.Id = fflib_IDGenerator.generate(Event_Days__c.SObjectType);
        
        return fakeEventDay;
    }
}