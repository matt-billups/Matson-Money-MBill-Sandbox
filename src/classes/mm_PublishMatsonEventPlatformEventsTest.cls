@isTest
private class mm_PublishMatsonEventPlatformEventsTest
{
	@isTest
	static void testPublishedSecondaryEventPlatformEvent()
	{
		RecordType primary = [SELECT Id FROM RecordType WHERE Name = 'Primary Matson Event'];
		RecordType secondary = [SELECT Id FROM RecordType WHERE Name = 'Secondary Matson Event'];

		Event__c event = createEvent('Test Event', primary.Id, NULL, NULL);
		System.debug('Platform Event List size: ' + mm_PublishMatsonEventPlatformEvents.events.size());
		Event__c event2 = createEvent('Test Event', secondary.Id, event.Id, 'Kids Program');
		update event2;
		System.assertEquals(1, mm_PublishMatsonEventPlatformEvents.events.size());
		delete event2;
		System.assertEquals(2, mm_PublishMatsonEventPlatformEvents.events.size());

	}

	@isTest
	static void testPublishedAgendaPlatformEvent(){
		RecordType primary = getRecordType('Primary Matson Event');
		Event__c event = createEvent('Test Event', primary.Id, NULL, NULL);
		Event_Days__c testAgenda = createAgenda(event.Id);
		update testAgenda;
		System.assertEquals(1, mm_PublishMatsonEventPlatformEvents.events.size());
		delete testAgenda;
		System.assertEquals(2, mm_PublishMatsonEventPlatformEvents.events.size());
	}

	@isTest
	static void testPublishedEventRegistrationPlatformEvent(){
		RecordType primary = getRecordType('Primary Matson Event');
		Event__c event = createEvent('Test Event', primary.Id, NULL, NULL);
		Contact c = createContact();
		Event_Registration__c testRegistration = createRegistration(event.Id, c.Id);
		update testRegistration;
		System.assertEquals(1, mm_PublishMatsonEventPlatformEvents.events.size());
		delete testRegistration;
		System.assertEquals(2, mm_PublishMatsonEventPlatformEvents.events.size());
	}

	static Event__c createEvent(String eventName, Id recordType_Id, Id primEventId, String secondaryEventType) {
        Event__c event = new Event__c();
        event.Name = eventName;
        event.RecordTypeId = recordType_Id;
        event.Primary_Matson_Event__c = primEventId;
        event.Event_Start_Date__c = System.today().addDays(7);
        event.Event_End_Date__c = System.today().addDays(8);
        event.Email_Cancelled_Body__c = 'Cancelled Body';
        event.Email_Cancelled_Template__c = 'Matson Event Cancelled Email - Standard';
        event.Email_Invite_Body__c = 'Invite Body';
        event.Email_Invite_Template__c = '  Matson Event Invited Email - Standard';
        event.Email_Registered_Body__c = 'Registered Body';
        event.Email_Registered_Template__c = '  Matson Event Registered Email - Standard';
        event.Email_Reminder_1_Week_Body__c = '1 Week Body';
        event.Email_Reminder_1_Week_Template__c = ' Matson Event Reminder 1 Week Before Email - Standard';
        event.Email_Reminder_2_Week_Body__c = '2 Week Body';
        event.Email_Reminder_2_Week_Template__c = 'Matson Event Reminder 2 Weeks Before Email - Standard';
        event.Maximum_Registration__c = 50;
        event.Course_Name__c = 'Other';
        event.Secondary_Event_Type__c = secondaryEventType;

        insert event;
        return event;
    }

    static RecordType getRecordType(String rtName){
    	RecordType rt = [SELECT Id FROM RecordType WHERE Name =: rtName];
    	return rt;
    }

    static Event_Days__c createAgenda(Id eventId){
    	Event_Days__c agenda = new Event_Days__c();
    	agenda.Matson_Event__c = eventId;
    	agenda.Name = 'Test Agenda';

    	insert agenda;
    	return agenda;
    }

    static Contact createContact(){
    	Contact c = new Contact();
    	c.FirstName = 'Test';
    	c.LastName = 'Contact';
    	c.Email = 'test@test.com';

    	insert c;
    	return c;
    }

    static Event_Registration__c createRegistration(Id eventId, Id contactId){
    	Event_Registration__c reg = new Event_Registration__c();
    	reg.Event__c = eventId;
    	reg.Status__c = 'Queued';
    	reg.Attendee_Type__c = 'Client';
    	reg.Contact__c = contactId;

    	insert reg;
    	return reg;
    }

    static Event_Expense__c createExpense(Id eventId){
    	Vendor__c v = new Vendor__c(Name = 'Test Vendor');
    	insert v;
    	Event_Expense__c expense = new Event_Expense__c();
    	expense.Event__c = eventId;
    	expense.Vendor_Name__c = v.Id;

    	insert expense;
    	return expense;
    }

 	static Event_Hotel__c createEventHotel(Id eventId){
		Hotel__c h = new Hotel__c(Name = 'Test Hotel');
		insert h;
		Event_Hotel__c hotel = new Event_Hotel__c();
		hotel.MAtson_Event__c = eventId;
		hotel.Hotel__C = h.Id;

		insert hotel;
		return hotel;
	}

	static Matson_Event_Speaker__c createSpeaker(Id eventId, Id contactId){
		Matson_Event_Speaker__c speaker = new Matson_Event_Speaker__c();
		speaker.Matson_Event__c = eventId;
		speaker.Speaker_Contact__c = contactId;
		speaker.Sort_Order__c = 1;

		insert speaker;
		return speaker;
	}

	static Event_Waiver__c createWaiver(Id eventId){
		Waiver__c w = new Waiver__c(Name = 'Test Waiver', Is_Active__c = TRUE);
		Event_Waiver__c waiver = new Event_Waiver__c();
		waiver.Matson_Event__c = eventId;
		waiver.Waiver__c = w.Id;

		insert waiver;
		return waiver;
	}

	static EventEventQuestion__c createQuestion(Id eventId){
		RecordType questionRT = [SELECT Id FROM RecordType WHERE Name = 'New'];
		EventQuestion__c q = new EventQuestion__c(Question_Text__c = 'Test question', RecordTypeId = questionRT.Id);
		EventEventQuestion__c question = new EventEventQuestion__c();
		question.Matson_Event__c = eventId;
		question.Event_Question__c = q.Id;
		question.IsActive__c = TRUE;
		question.Sort_Order__c = 1;
		question.Question_Type__c = 'Registration';

		insert question;
		return question;
	}

	static Custom_Tab__c createCustomTab(Id eventId){
		Custom_Tab__c tab = new Custom_Tab__c();
		tab.Matson_Event__c = eventId;
		tab.Name = 'Test Tab';

		insert tab;
		return tab;
	}
}