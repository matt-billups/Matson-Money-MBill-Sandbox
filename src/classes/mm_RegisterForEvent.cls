@RestResource(urlMapping='/mm_RegisterForEvent/*')
global with sharing class mm_RegisterForEvent {
    @HttpPost
    global static void Register() {
        Registration inputRegistration = (Registration)JSON.deserialize(RestContext.request.requestBody.toString(), Registration.class);
        
        // Make sure all required questions are answered for all attendees
        List<Map<string, Object>> requiredUnansweredQuestions = ValidateQuestionAnswers(inputRegistration);
        
        // If any required questions are not answered, return the ContactID(s) and unanswered Question ID(s)        
        if(requiredUnansweredQuestions.size() > 0) {
            RestContext.Response.ResponseBody = blob.valueof(JSON.serialize(new Map<string, object> {
                'Success' => false,
                    'RequiredUnansweredQuestions' => requiredUnansweredQuestions
                    }));
            return;
        }
        
        // Get existing contact objects
        List<Contact> contacts = GetContactsFromRegistration(inputRegistration);
        
        // Update inputRegistration's contact IDs from existing contacts
        UpdateContactIdsFromData(contacts, inputRegistration);
        
        // Add any contacts that don't exist to the database
        List<Contact> addedContacts = AddNonExistingContactsToDatabase(contacts, inputRegistration);
        
        // Update inputRegistration's contact IDs from added contacts
        UpdateContactIdsFromData(addedContacts, inputRegistration);
        
        // Get the primary registrant's EventRegistrationId
        string parentRegistrationId = GetParentEventRegistrationId(inputRegistration);        
        
        Event_Registration__c primaryEventRegistration = CreateEventRegistrationForPrimaryRegistrant(inputRegistration, parentRegistrationId);
        
        upsert primaryEventRegistration Id;
        
        parentRegistrationId = primaryEventRegistration.Id;
        
		List<Guest> guestsOfOtherRegistrant = new List<Guest>();
        List<Event_Registration__c> existingSalesForceRegistrations = GetExistingAndCreateNewEventRegistrations(inputRegistration, parentRegistrationId, guestsOfOtherRegistrant);
        
        if(existingSalesForceRegistrations != null) {
            List<Event_Registration__c> registrationsToUpdate = new List<Event_Registration__c>();
            
            for(Event_Registration__c existingSalesForceRegistration: existingSalesForceRegistrations) {
                // Match previously-registered guest with currently-registered guests on Event and Contact
                if(existingSalesForceRegistration.Event__c == primaryEventRegistration.Event__c && existingSalesForceRegistration.Contact__c == primaryEventRegistration.Contact__c) {
                    // make sure the currently-registered EventRegistrationId is current so we can upsert the record
                    if(existingSalesForceRegistration.Id != null) {
                        primaryEventRegistration.Id = existingSalesForceRegistration.Id;
                    }
                }
                
                boolean salesForceGuestFoundInWebsiteGuestList = false;
                
                if(inputRegistration.Guests != null && inputRegistration.Guests.size() > 0) {
                    for(Guest websiteGuest: inputRegistration.Guests) {
                        if(websiteGuest.ContactId == existingSalesForceRegistration.Contact__c && ExplicitlyTrue(websiteGuest.IsDeleted)) {
                            existingSalesForceRegistration.Status__c = 'Cancelled';
                            registrationsToUpdate.add(existingSalesForceRegistration);
                        }
                        else if (websiteGuest.ContactId == existingSalesForceRegistration.Contact__c && !ExplicitlyTrue(websiteGuest.IsDeleted) && existingSalesForceRegistration.Status__c == 'Cancelled') {
                            existingSalesForceRegistration.Status__c = 'Registered';
                            existingSalesForceRegistration.Parent_Registration__c = primaryEventRegistration.Id;
                            registrationsToUpdate.add(existingSalesForceRegistration);
                        }
                        
                        if(websiteGuest.ContactId == existingSalesForceRegistration.Contact__c)
                        {
                            salesForceGuestFoundInWebsiteGuestList = true;
                        }
                    }
                }
                
                //This guest is missing from the website guest list. This guest must be cancelled.
                if (!salesForceGuestFoundInWebsiteGuestList && existingSalesForceRegistration.Id != parentRegistrationId)
                {
                    existingSalesForceRegistration.Status__c = 'Cancelled';
                    registrationsToUpdate.add(existingSalesForceRegistration);
                }
            }
            
            // If there are any guests of another registrant, return success = false
            if(guestsOfOtherRegistrant.size() != 0) {
                RestContext.Response.ResponseBody = blob.valueof(JSON.serialize(new Map<string, object> {
                    'Success' => false,
                        'GuestsAlreadyRegistered' => guestsOfOtherRegistrant
                        }));
                return;
            }
            
            update registrationsToUpdate;
        }
        
        //currentRegistrations contactId's must not be null at this point
        // Match the Event Registration IDs with the registrants
        UpdateCurrentEventRegistrationIds(inputRegistration, existingSalesForceRegistrations);
        
        // Save the questions
        if(inputRegistration.Questions != null && inputRegistration.Questions.size() > 0) {
            // Get existing answers so we can update them
            List<Event_Registration_Answer__c> existingSalesForceAnswers = GetExistingSalesForceAnswers(inputRegistration);
            
            // Get existing answer selections so we can update those too
            List<Event_Registration_Answer_Selection__c> existingSalesForceAnswerSelections = GetExistingAnswerSelections(existingSalesForceAnswers);
            
            // Consolidate all of the questions into a single list of questions
            List<Question> websiteListOfQuestionAnswers = GetAllWebsiteQuestionAnswersFromInputRegistration(inputRegistration);
            
            List<Event_Registration_Answer__c> answersToInsert = new List<Event_Registration_Answer__c>();
            List<Event_Registration_Answer__c> newlyCreatedSalesForceAnswers = new List<Event_Registration_Answer__c>();
            List<Event_Registration_Answer__c> allSalesForceAnswers = new List<Event_Registration_Answer__c>();
            List<Event_Registration_Answer__c> existingSalesForceAnswersToUpdate = new List<Event_Registration_Answer__c>();
            List<Event_Registration_Answer_Selection__c> answerSelectionsToInsert = new List<Event_Registration_Answer_Selection__c>();
            
            string getNewSalesForceAnswersQuery = 'SELECT Id, Event_Event_Question__c, Event_Registration__c, Checkbox_Answer__c, Text_Answer__c, Answer_Type__c, Attendee_Name__c FROM Event_Registration_Answer__c WHERE ';
            string getAllSalesForceAnswersQuery = 'SELECT Id, Event_Event_Question__c, Event_Registration__c, Checkbox_Answer__c, Text_Answer__c, Answer_Type__c, Attendee_Name__c FROM Event_Registration_Answer__c WHERE (Event_Registration__c = \'' + inputRegistration.EventRegistrationId + '\')';
            
            boolean isFirstLoopThrough = true;
            
            //Insert missing SalesForce answers
            for(Question websiteQuestionAnswer : websiteListOfQuestionAnswers) {
                Event_Registration_Answer__c existingSalesForceAnswer = GetExistingAnswerForSingleQuestion(websiteQuestionAnswer, existingSalesForceAnswers);
                
                if(existingSalesForceAnswer == null) {
                    // There is no existing answer, so insert answer and answer selections (if applicable)
                    Event_Registration_Answer__c answerToInsert = CreateEventRegistrationAnswer(websiteQuestionAnswer);
                    answersToInsert.add(answerToInsert);
                    if (isFirstLoopThrough)
                    {
                        getNewSalesForceAnswersQuery += '(Event_Registration__c = \'' + answerToInsert.Event_Registration__c + '\') ';
                        isFirstLoopThrough = false;
                    }
                    else
                    {
                        getNewSalesForceAnswersQuery += 'OR (Event_Registration__c = \'' + answerToInsert.Event_Registration__c + '\') ';
                    }
                    getAllSalesForceAnswersQuery += 'OR (Event_Registration__c = \'' + answerToInsert.Event_Registration__c + '\') ';
                }
                else
                {
                    getAllSalesForceAnswersQuery += 'OR (Event_Registration__c = \'' + existingSalesForceAnswer.Event_Registration__c + '\') ';
                }
            }
            
            insert answersToInsert;
            
            //Get new Answers
            try {
                newlyCreatedSalesForceAnswers = database.query(getNewSalesForceAnswersQuery);
            }
            catch(QueryException ex) {
                // Ignore
            }
            
            //Get all Answers
            try {
                allSalesForceAnswers = database.query(getAllSalesForceAnswersQuery);
            }
            catch(QueryException ex) {
                // Ignore
            }
            
            
            //All answers should exist in SalesForce already by this point
            for(Question websiteQuestionAnswer : websiteListOfQuestionAnswers) {
                // Match the existing answer for this question
                Event_Registration_Answer__c existingSalesForceAnswer = GetExistingAnswerForSingleQuestion(websiteQuestionAnswer, allSalesForceAnswers);
                
                if(existingSalesForceAnswer == null) {
                    System.debug('DEBUG YOU SHOULD NOT SEE THIS! ALL ANSWERS SHOULD EXIST IN SALESFORCE ALREADY! YOU HAVE GOT A BUG!');
                }
                else {
                    // An answer exists, so update it
                    if(websiteQuestionAnswer.AnswerType == 'Checkbox') {
                        existingSalesForceAnswer.Checkbox_Answer__c = ExplicitlyTrue(websiteQuestionAnswer.Checked);
                    }
                    if(websiteQuestionAnswer.AnswerType == 'Text') {
                        existingSalesForceAnswer.Text_Answer__c = websiteQuestionAnswer.Answer;
                    }
                    if(websiteQuestionAnswer.Options != null && websiteQuestionAnswer.Options.size() > 0) {
                        for(Option websiteAnswerSelection : websiteQuestionAnswer.Options) {
                            Event_Registration_Answer_Selection__c salesForceAnswerSelection = GetSelectedOptionFromExistingSelections(websiteAnswerSelection.Id, existingSalesForceAnswer.Id, existingSalesForceAnswerSelections);
                            
                            if(ExplicitlyTrue(websiteAnswerSelection.Selected)) {
                                if(salesForceAnswerSelection == null) {
                                    // Selection doesn't exist, so add it
                                    salesForceAnswerSelection = CreateRegistrationAnswerSelection(existingSalesForceAnswer.Id, websiteAnswerSelection.Id);
                                    answerSelectionsToInsert.add(salesForceAnswerSelection);
                                }
                            } else {
                                if(salesForceAnswerSelection != null) {
                                    // Selection exists and shouldn't, so delete it.
                                    delete salesForceAnswerSelection;
                                }
                            }
                        }
                    }
                    
                    existingSalesForceAnswersToUpdate.add(existingSalesForceAnswer);
                }
            }
            
            insert answerSelectionsToInsert;
            update existingSalesForceAnswersToUpdate;
        }
        
        // Finally, if we get here, everything worked like it should have!
        RestContext.response.responseBody = blob.valueOf(JSON.serialize(new Map<string, object> {
            'Success' => true
                }));
    }
    
    private static boolean ExplicitlyTrue(boolean b)
    {
        if(b == null) return false;
        return b;
    }
    
    private static List<Contact> GetContactsFromRegistration(Registration inputRegistration) {
        string existingGuestsQuery = 'SELECT Id, FirstName, LastName, Email FROM Contact WHERE ';
        existingGuestsQuery += '(FirstName = \'' + inputRegistration.FirstName + '\' AND LastName = \'' + inputRegistration.LastName + '\' AND Email = \'' + inputRegistration.EmailAddress + '\') ';
        if(inputRegistration.Guests != null && inputRegistration.Guests.size() > 0) {
            for(Guest g: inputRegistration.Guests) {
                existingGuestsQuery += 'OR (FirstName = \'' + g.FirstName + '\' AND LastName = \'' + g.LastName + '\' AND Email = \'' + g.EmailAddress + '\') ';
            }
        }
        List<Contact> Contacts;
        try {
            Contacts = Database.query(existingGuestsQuery);
        }
        catch(QueryException ex) {
            // Swallow, don't care
        }
        return Contacts;
    }
    
    private static Map<string, Object> CheckForRequiredUnansweredQuestions(List<EventEventQuestion__c> salesForceQuestions, List<Question> websiteQuestions, string contactId)
    {        
        List<string> RequiredUnansweredQuestionIdsForCurrentRegistrant = new List<string>();
        
        for(EventEventQuestion__c salesForceQuestion : salesForceQuestions) {
            
            if (!ExplicitlyTrue(salesForceQuestion.IsActive__c))
            {
                // Question is not active, do nothing
                System.debug('DEBUG salesForceQuestion.IsActive__c:' + salesForceQuestion.IsActive__c);
            }
            else
            {
                if(!ExplicitlyTrue(salesForceQuestion.Is_Required__c)) {
                    // Question is not required, do nothing
                    System.debug('DEBUG salesForceQuestion.Is_Required__c:' + salesForceQuestion.Is_Required__c);
                }
                else
                {
                    if(websiteQuestions != null && websiteQuestions.size() > 0) {
                        for(Question websiteQuestion : websiteQuestions) {
                            if(salesForceQuestion.Id == websiteQuestion.Id) {
                                if((websiteQuestion.Answer == '' || websiteQuestion.Answer == null) && websiteQuestion.AnswerType == 'Text') {
                                    RequiredUnansweredQuestionIdsForCurrentRegistrant.Add(websiteQuestion.Id);
                                } else if(websiteQuestion.Checked == null && websiteQuestion.AnswerType == 'Checkbox') {
                                    RequiredUnansweredQuestionIdsForCurrentRegistrant.Add(websiteQuestion.Id);
                                } else {
                                    if(websiteQuestion.Options != null && websiteQuestion.Options.size() > 0) {
                                        boolean hasOptionSelected = false;
                                        for(Option o : websiteQuestion.Options) {
                                            if(ExplicitlyTrue(o.Selected)) {
                                                hasOptionSelected = true;
                                            }
                                        }
                                        if(!hasOptionSelected){
                                            RequiredUnansweredQuestionIdsForCurrentRegistrant.Add(websiteQuestion.Id);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else {
                        RequiredUnansweredQuestionIdsForCurrentRegistrant.Add(salesForceQuestion.Id);
                    }
                }
            }
        }
        if(RequiredUnansweredQuestionIdsForCurrentRegistrant.size() > 0) {
            return new Map<string, Object> {
                'ContactId' => contactId,
                    'QuestionIds' => RequiredUnansweredQuestionIdsForCurrentRegistrant
                    };
                        }
        return null;
    }
    
    private static List<Map<string, object>> ValidateQuestionAnswers(Registration inputRegistration) {
        // Make sure all required questions are answered
        List<EventEventQuestion__c> salesForceQuestions = [SELECT Id,
                                                      Is_Required__c,
                                                      IsActive__c
                                                      FROM EventEventQuestion__c
                                                      WHERE Matson_Event__c = :inputRegistration.EventId];
        
        List<Map<string, Object>> RequiredUnansweredQuestions = new List<Map<string, Object>>();
        
        // Check primary registrant
        Map<string, Object> RequiredUnansweredQuestionsForPrimaryRegistrant = CheckForRequiredUnansweredQuestions(salesForceQuestions, inputRegistration.Questions, inputRegistration.ContactId);
        if(RequiredUnansweredQuestionsForPrimaryRegistrant != null) {
            RequiredUnansweredQuestions.Add(RequiredUnansweredQuestionsForPrimaryRegistrant);
        }
        
        // Check guests
        if(inputRegistration.Guests != null && inputRegistration.Guests.size() > 0) {
            for(Guest g : inputRegistration.Guests)
            {
                if(ExplicitlyTrue(g.IsDeleted)) {
                    // We're deleting the guest. Do nothing.
                } else {
                    Map<string, Object> RequiredUnansweredQuestionsForCurrentRegistrant = CheckForRequiredUnansweredQuestions(salesForceQuestions, g.Questions, g.ContactId);
                    if(RequiredUnansweredQuestionsForCurrentRegistrant != null) {
                        RequiredUnansweredQuestions.Add(RequiredUnansweredQuestionsForCurrentRegistrant);
                    }
                }
            }
        }
        return RequiredUnansweredQuestions;
    }
    
    private static void UpdateContactIdsFromData(List<Contact> Contacts, Registration inputRegistration) {
        // Update contact IDs for the input object
        for(Contact c: Contacts) {
            if(c.FirstName == inputRegistration.FirstName && c.LastName == inputRegistration.LastName && c.Email == inputRegistration.EmailAddress) {
                inputRegistration.ContactId = c.Id;
            }
            if(inputRegistration.Guests != null) {
                for(Guest g: inputRegistration.Guests) {
                    if(c.FirstName == g.FirstName && c.LastName == g.LastName && c.Email == g.EmailAddress) {
                        g.ContactId = c.Id;
                    }
                }
            }
        }
    }
    
    private static List<Contact> AddNonExistingContactsToDatabase(List<Contact> Contacts, Registration inputRegistration) {
        List<Contact> contactsToAdd = new List<Contact>();
        
        // Check if registrant exists and add the contact to the Contacts list if it doesn't
        AddNonExistingContactToList(contactsToAdd, inputRegistration.ContactId, inputRegistration.FirstName, inputRegistration.LastName, inputRegistration.EmailAddress, Contacts);
        
        // Do the same as above for each guest
        if(inputRegistration.Guests != null && inputRegistration.Guests.size() > 0) {
            for(Guest g: inputRegistration.Guests) {
                AddNonExistingContactToList(contactsToAdd, g.ContactId, g.FirstName, g.LastName, g.EmailAddress, Contacts);
            }
        }
        
        insert contactsToAdd;
        return contactsToAdd;
    }
    
    private static void AddNonExistingContactToList(List<Contact> contactsToAdd, string sourceContactId, string sourceFirstName, string sourceLastName, string sourceEmail, List<Contact> existingContacts) {
        Contact existingRegistrant = null;
        if(existingContacts != null && existingContacts.size() > 0) {
            for(Contact registrant : existingContacts) {
                if(registrant.Id == sourceContactId) {
                    existingRegistrant = registrant;
                }
            }
        }
        if(existingRegistrant == null) {
            Contact registrant = new Contact();
            registrant.FirstName = sourceFirstName;
            registrant.LastName = sourceLastName;
            registrant.Email = sourceEmail;
            registrant.Contact_Designation__c = 'Guest';
            contactsToAdd.Add(registrant);
        }
    }
    
    private static string GetParentEventRegistrationId(Registration inputRegistration) {
        try {
            Event_Registration__c eventRegistrationFromData = [SELECT Id FROM Event_Registration__c WHERE Event__c = :inputRegistration.EventId AND Contact__c = :inputRegistration.ContactId LIMIT 1];
            return eventRegistrationFromData.Id;
        } catch (QueryException ex) {
            return null;
        }
    }
    
    private static Event_Registration__c CreateEventRegistrationForPrimaryRegistrant(Registration inputRegistration, string parentRegistrationId) {
        return CreateEventRegistration(true, inputRegistration.EventId, inputRegistration.AttendeeType, inputRegistration.ContactId, 'Registered', inputRegistration.ShirtSize, parentRegistrationId);
    }
    
    private static Event_Registration__c CreateEventRegistrationForGuest(string eventId, Guest guest, string parentRegistrationId) {
        return CreateEventRegistration(false, eventId, 'Guest', guest.ContactId, (guest.RegistrationStatus == null ? 'Registered' : guest.RegistrationStatus), guest.ShirtSize, parentRegistrationId);
    }
    
    private static Event_Registration__c CreateEventRegistration(boolean isPrimary, string eventId, string attendeeType, string contactId, string status, string shirtSize, string id) {
        Event_Registration__c er = new Event_Registration__c();
        er.Event__c = eventId;
        er.Attendee_Type__c = attendeeType;
        er.Status__c = status;
        er.T_Shirt_Size__c = shirtSize;
        
        if(isPrimary) {
            er.Id = id;
            if(attendeeType == 'Adviser') {
                try {
                    Adviser__c adviser = [SELECT Id FROM Adviser__c WHERE Primary_Contact__c = :contactId LIMIT 1];
                    er.Reg_Adviser__c = adviser.Id;
                }
                catch (QueryException ex) {
                    // Don't do anything
                }
            } else {
                er.Contact__c = contactId;
            }
        } else {
            er.Contact__c = contactId;
            er.Parent_Registration__c = id;
        }
        return er;
    }
    
    private static List<Event_Registration__c> GetExistingAndCreateNewEventRegistrations(Registration inputRegistration, string parentRegistrationId, List<Guest> guestsOfOtherRegistrant) {
        string existingRegistrationsQuery = 'SELECT Id, Event__c, Contact__c, Parent_Registration__c, Status__c, Attendee_Type__c FROM Event_Registration__c WHERE (Event__c = \'' + inputRegistration.EventId + '\' AND Contact__c = \'' +inputRegistration.ContactId + '\') ';
        List<Event_Registration__c> previouslyRegisteredGuests;
        List<Event_Registration__c> registrationsToInsert = new List<Event_Registration__c>();
        
		existingRegistrationsQuery += 'OR (Event__c = \'' + inputRegistration.EventId + '\' AND Parent_Registration__c = \'' + parentRegistrationId +'\') ';
        
        try {
            previouslyRegisteredGuests = database.query(existingRegistrationsQuery);
        }
        catch(QueryException ex) {
            // Swallow, don't care if no one else is registered
        }
        
        if(inputRegistration.Guests != null && inputRegistration.Guests.size() > 0) {
            for(Guest websiteGuest: inputRegistration.Guests) {
                boolean foundGuest = false;
                
                for(Event_Registration__c prg: previouslyRegisteredGuests) {
                    if(prg.Contact__c == websiteGuest.ContactId) {
                        foundGuest = true;
                    }
                }
                
                //Guest from microsite could not be found for this particular Event and ParentRegistration combination
                if (!foundGuest)
                {
                    //Check if this guest can be found for this event anywhere, maybe under another parent
                    List<Event_Registration__c> registrationsOfDifferentParent = new List<Event_Registration__c>();
                    try {
                        registrationsOfDifferentParent = [SELECT Id,
                                Event__c,
                                Attendee_Type__c,
                                Status__c,
                                T_Shirt_Size__c,
								Contact__c,
                                Parent_Registration__c
                                FROM Event_Registration__c
                                WHERE Event__c = :inputRegistration.EventId
                            	AND Contact__c = :websiteGuest.ContactId
                                AND Status__c = :'Registered'];
                    } catch (QueryException ex) {
                        return null;
                    }
                    
        			if(registrationsOfDifferentParent != null && registrationsOfDifferentParent.size() > 0) {
                    	guestsOfOtherRegistrant.add(websiteGuest);
                    }
                    else
                    {
                        Event_Registration__c newGuestRegistration = new Event_Registration__c();
                        newGuestRegistration.Event__c = inputRegistration.EventId;
                        newGuestRegistration.Attendee_Type__c = 'Guest';
                        newGuestRegistration.Status__c = 'Registered';
                        newGuestRegistration.T_Shirt_Size__c = websiteGuest.ShirtSize;
                        newGuestRegistration.Contact__c = websiteGuest.ContactId;
                        newGuestRegistration.Parent_Registration__c = parentRegistrationId;
                        
                        registrationsToInsert.Add(newGuestRegistration); 
                    } 
                }
            }
            
            Insert registrationsToInsert;
        }
        
        //Re-run select now that the missing registrations were inserted
        try {
            previouslyRegisteredGuests = database.query(existingRegistrationsQuery);
        }
        catch(QueryException ex) {
            // Swallow, don't care if no one else is registered
        }
        
        return previouslyRegisteredGuests;
    }
    
    private static void DeleteQuestionAnswerDataForRegistrationsToDelete(Set<string> eventRegistrationIdsOfAnswersToDelete) {
        List<Event_Registration_Answer__c> answersToDelete = [SELECT Id
                                                              FROM Event_Registration_Answer__c
                                                              WHERE Event_Registration__c IN :eventRegistrationIdsOfAnswersToDelete];
        List<Event_Registration_Answer_Selection__c> selectedAnswersToDelete = [SELECT Id
                                                                                FROM Event_Registration_Answer_Selection__c
                                                                                WHERE Event_Registration_Answer__c IN :answersToDelete];
        delete selectedAnswersToDelete;
        delete answersToDelete;
    }
    
    private static void UpdateCurrentEventRegistrationIds(Registration inputRegistration, List<Event_Registration__c> currentRegistrations) {
        for(Event_Registration__c currentRegistration : currentRegistrations) {
            if(currentRegistration.Contact__c == inputRegistration.ContactId || currentRegistration.Attendee_Type__c == 'Adviser') {
                inputRegistration.EventRegistrationId = currentRegistration.Id;
            }
            if(inputRegistration.Guests != null && inputRegistration.Guests.size() > 0) {
                for(Guest inputGuest : inputRegistration.Guests) {
                    if(inputGuest.ContactId == currentRegistration.Contact__c) {
                        inputGuest.EventRegistrationId = currentRegistration.Id;            
                    }
                }
            }
        }
    }
    
    private static List<Event_Registration_Answer__c> GetExistingSalesForceAnswers(Registration inputRegistration) {
        List<Event_Registration_Answer__c> salesForceAnswers = new List<Event_Registration_Answer__c>();
        List<Event_Registration_Answer__c> websiteAnswers = new List<Event_Registration_Answer__c>();
        
        Set<string> eeqIds = new Set<String>();
        for(Question q : inputRegistration.Questions) {
            eeqIds.add(q.Id);
        }
        Set<string> erIds = new Set<String>();
        erIds.Add(inputRegistration.EventRegistrationId);
        if(inputRegistration.Guests != null && inputRegistration.Guests.size() > 0) {
            for(Guest g : inputRegistration.Guests) {
                erIds.Add(g.EventRegistrationId);
            }
        }
        try {
            salesForceAnswers = [SELECT Id,
                                 Event_Event_Question__c,
                                 Event_Registration__c,
                                 Checkbox_Answer__c,
                                 Text_Answer__c,
                                 Answer_Type__c,
                                 Attendee_Name__c
                                 FROM Event_Registration_Answer__c
                                 WHERE Event_Event_Question__c IN :eeqIds
                                 AND Event_Registration__c IN :erIds
                                ];
            
            return salesForceAnswers;
        } catch(QueryException ex) {
            return null;
        }
    }
    
    private static List<Event_Registration_Answer_Selection__c> GetExistingAnswerSelections(List<Event_Registration_Answer__c> existingAnswers) {
        Set<string> answerIds = new Set<string>();
        for(Event_Registration_Answer__c a : existingAnswers) {
            answerIds.add(a.Id);
        }
        try {
            return [SELECT Id,
                    Event_Question_Option__c,
                    Event_Registration_Answer__c
                    FROM Event_Registration_Answer_Selection__c
                    WHERE Event_Registration_Answer__c IN :answerIds];
        } catch (QueryException ex) {
            return null;
        }
    }
    
    private static List<Question> GetAllWebsiteQuestionAnswersFromInputRegistration(Registration inputRegistration) {
        List<Question> websiteQuestionAnswers = new List<Question>();
        
        for(Question websiteQuestionAnswer : inputRegistration.Questions) {
            // Match Event Registration IDs so we can treat all questions the same
            websiteQuestionAnswer.EventRegistrationId = inputRegistration.EventRegistrationId;
        }
        websiteQuestionAnswers.addAll(inputRegistration.Questions);
        if(inputRegistration.Guests != null && inputRegistration.Guests.size() > 0) {
            for(Guest inputGuest : inputRegistration.Guests) {
                if(!ExplicitlyTrue(inputGuest.IsDeleted)) {
                    for(Question guestWebsiteQuestionAnswer : inputGuest.Questions) {
                        // Match Event Registration IDs so we can treat all questions the same
                        guestWebsiteQuestionAnswer.EventRegistrationId = inputGuest.EventRegistrationId;
                    }
                    websiteQuestionAnswers.addAll(inputGuest.Questions);
                }
            }
        }
        return websiteQuestionAnswers;
    }
    
    private static Event_Registration_Answer__c GetExistingAnswerForSingleQuestion(Question websiteQuestionAnswer, List<Event_Registration_Answer__c> existingSalesForceAnswers) {
        for(Event_Registration_Answer__c existingSalesForceAnswer : existingSalesForceAnswers) {
            if(existingSalesForceAnswer.Event_Event_Question__c == websiteQuestionAnswer.Id && existingSalesForceAnswer.Event_Registration__c == websiteQuestionAnswer.EventRegistrationId && websiteQuestionAnswer.EventRegistrationId != null) {
                return existingSalesForceAnswer;
            }
        }
        return null;
    }
    
    private static Event_Registration_Answer__c CreateEventRegistrationAnswer(Question websiteQuestionAnswer) {
        Event_Registration_Answer__c answerToInsert = new Event_Registration_Answer__c();
        if(websiteQuestionAnswer.AnswerType == 'Checkbox' && websiteQuestionAnswer.Checked != null) {
            answerToInsert.Checkbox_Answer__c = ExplicitlyTrue(websiteQuestionAnswer.Checked);
        }
        answerToInsert.Event_Event_Question__c = websiteQuestionAnswer.Id;
        answerToInsert.Event_Registration__c = websiteQuestionAnswer.EventRegistrationId;
        if(websiteQuestionAnswer.AnswerType == 'Text') {
            answerToInsert.Text_Answer__c = websiteQuestionAnswer.Answer;   
        }
        return answerToInsert;
    }
    
    private static Event_Registration_Answer_Selection__c CreateRegistrationAnswerSelection(string answerId, string optionId) {
        Event_Registration_Answer_Selection__c selectedOption = new Event_Registration_Answer_Selection__c();
        selectedOption.Event_Question_Option__c = optionId;
        selectedOption.Event_Registration_Answer__c = answerId;
        return selectedOption;
    }
    
    private static void AddSelectedOptionsToAnswerSelections(string answerId, List<Option> options, List<Event_Registration_Answer_Selection__c> answerSelectionsToInsert) {
        if(options != null && options.size() > 0) {
            for(Option o : options) {
                if(ExplicitlyTrue(o.Selected)) {
                    Event_Registration_Answer_Selection__c selectedOption = CreateRegistrationAnswerSelection(answerId, o.Id);
                    answerSelectionsToInsert.add(selectedOption);
                }
            }
        }
    }
    
    private static Event_Registration_Answer_Selection__c GetSelectedOptionFromExistingSelections(string optionId, string answerId, List<Event_Registration_Answer_Selection__c> existingAnswerSelections) {
        for(Event_Registration_Answer_Selection__c sel : existingAnswerSelections) {
            if(sel.Event_Question_Option__c == optionId && sel.Event_Registration_Answer__c == answerId) {
                return sel;
            }
        }
        return null;
    }
    
    public class Registration {
        public string FirstName;
        public string LastName;
        public string EmailAddress;
        public string ContactType;
        public string EventId;
        public string ShirtSize;
        public string AttendeeType;
        public List<Guest> Guests;
        public string ContactId;
        public boolean IsGuest;
        public List<Question> Questions;
        public string EventRegistrationId;
    }
    
    public class Guest {
        public string FirstName;
        public string LastName;
        public string EmailAddress;
        public boolean IsDeleted;
        public string ContactId;
        public string ParentEventRegistrationId;
        public string RegistrationStatus;
        public string ShirtSize;
        public List<Question> Questions;
        public string EventRegistrationId;
    }
    
    public class Option {
        public string Id;
        public boolean Selected;
    }
    
    public class Question {
        public string Id;
        public List<Option> Options;
        public string Answer;
        public boolean IsRequired;
        public string AnswerType;
        public boolean Checked;
        public string EventRegistrationId;
    }
    
    public class DebugException extends Exception {}
}