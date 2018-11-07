@RestResource(urlMapping='/mm_GetEventRegistration/*')
global with sharing class mm_GetEventRegistration {
    @HttpGet	
    global static void GetEventRegistration() {
        Map<String, String> params = RestContext.request.params;
        
        String eventId = params.get('EVID');
        String contactId = params.get('CONID');
        String authToken = params.get('TOKEN');
        
        // Get the event. If null, return because there's nothing to get
        Event__c theEvent = GetEvent(eventId);
        if(theEvent == null) return;
        
        //  Make sure the contact is not null either
        Contact theContact = GetContact(contactId);
        if(theContact == null) return;
        
        // Get the primary event registration
        Event_Registration__c parentER = GetPrimaryEventRegistration(eventId, contactId);
        if(parentER == null) return;
        
        Boolean isTokenValid = mm_SettingsHelper.VerifyEventToken(eventId, contactId, authToken);
        if(!isTokenValid) return;
        
        // Get the guest event registrations
        List<Event_Registration__c> guestERs = GetGuestEventRegistrations(parentER.Id);

        // Get the event event questions so we can match answers to them
        List<EventEventQuestion__c> questions = GetEventEventQuestions(eventId);
                
        List<Question> eventQuestions = new List<Question>();
        List<Event_Registration_Answer__c> existingAnswers = null;
        List<Event_Registration_Answer_Selection__c> existingAnswerSelections = null;
        
        if(questions != null && questions.size() > 0) {
            Set<string> eqIds = new Set<string>();
            Set<string> eeqIds = new Set<string>();
            for(EventEventQuestion__c q : questions) {
                eqIds.add(q.Event_Question__r.Id);
                eeqIds.add(q.Id);
            }
            
            // Get the question options
        	List<EventQuestionOption__c> questionOptions = GetQuestionOptions(eqids);
            
            // Build the event questions
            eventQuestions = BuildEventQuestions(questions, questionOptions);
            
            // Get the existing answers
            existingAnswers = GetExistingAnswers(eeqIds, parentER, guestERs);

            // Get the existing answer selections
            if(existingAnswers != null && existingAnswers.size() > 0) {
                existingAnswerSelections = GetExistingAnswerSelections(existingAnswers);
            }
            
        }
        
        boolean isGuest = RegistrantIsGuest(parentER, theEvent);
        
        Registration rI = BuildRegistration(parentER, eventQuestions, isGuest);
                
        // Place question answers where they belong for the primary registrant
        SetQuestionAnswers(rI.Questions, parentER.Id, existingAnswers, existingAnswerSelections);
        
        // Build the list of registration guests to return
        List<Guest> guests = new List<Guest>();
        
        for(Event_Registration__c er: guestERs) {
            //Don't return guests that are cancelled or else they will show up on the microsite list of guests
            if (er.Status__c != 'Cancelled')
            {
                Guest g = BuildGuest(er, eventQuestions);
                SetQuestionAnswers(g.Questions, er.Id, existingAnswers, existingAnswerSelections);
                guests.add(g);  
            }
        }
        
        rI.Guests = guests;
        
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(rI, true));
    }
    
    private static Event__c GetEvent(string eventId) {
        try {
            return [SELECT Id, PublicRegistration__c FROM Event__c WHERE Id = :eventId LIMIT 1];
        }
        catch(QueryException ex) {
            return null; // Event doesn't exist so return null
        }        
    }
    
    private static Contact GetContact(string contactId) {
        try {
            return [SELECT Id FROM Contact WHERE Id = :contactId LIMIT 1];
        }
        catch(QueryException ex) {
            return null; // Contact doesn't exist so return null
        }
    }
    
    private static Event_Registration__c GetPrimaryEventRegistration(string eventId, string contactId) {
        try {
            return [SELECT Id,
                        Event__c,
                        T_Shirt_Size__c,
                        Contact__r.Id,
                        Contact__r.FirstName,
                        Contact__r.LastName,
                        Contact__r.Email,
                        Status__c,
                        Attendee_Type__c,
                        Parent_Registration__c
                        FROM Event_Registration__c
                        WHERE Contact__c =:contactId
                        AND Event__c = :eventId
                        LIMIT 1];
        }
        catch(QueryException ex) {
            return null; // Event Registration doesn't exist so return null
        }
    }
    
    private static List<Event_Registration__c> GetGuestEventRegistrations(string parentEventRegistrationId) {
        try {
            return [SELECT Id,
                        T_Shirt_Size__c,
                        Contact__r.Id,
                        Contact__r.FirstName,
                        Contact__r.LastName,
                        Contact__r.Email,
                        Status__c
                        FROM Event_Registration__c
                        WHERE Parent_Registration__c = :parentEventRegistrationId];
        }
        catch(QueryException ex) {
            return null;
        }
    }
    
    private static List<EventEventQuestion__c> GetEventEventQuestions(string eventId) {
        try {
            return [SELECT Event_Question__c,
                                     Is_Required__c,
                                     Event_Question__r.Answer_Type__c,
                                     Event_Question__r.Question_Text__c,
                                     Event_Question__r.Id,
                                     Id,
                                     Sort_Order__c
                                FROM EventEventQuestion__c
                               WHERE Matson_Event__c = :eventId
                                 AND IsActive__c = true];
        } catch (QueryException ex) {
            return null;
        }
    }
    
    private static List<EventQuestionOption__c> GetQuestionOptions(Set<string> eventQuestionIds) {
        try {
            return [SELECT Id,
                    Option__c,
                    Sort_Order__c,
                    Event_Question__c
                    FROM EventQuestionOption__c
                    WHERE Event_Question__c IN :eventQuestionIds];
        } catch (QueryException ex) {
            return null;
        }
    }
    
    private static List<Event_Registration_Answer__c> GetExistingAnswers(Set<string> eventEventQuestionIds, Event_Registration__c parentER, List<Event_Registration__c> guestERs) {
        Set<string> erIds = new Set<string>();
        erIds.add(parentER.Id);
        if(guestERs != null && guestERs.size() > 0) {
            for(Event_Registration__c g : guestERs) {
                erIds.add(g.Id);
            }
        }
        try {
            return [SELECT Id,
                    Event_Event_Question__c,
                    Event_Registration__c,
                    Checkbox_Answer__c,
                    Text_Answer__c,
                    Answer_Type__c
                    FROM Event_Registration_Answer__c
                    WHERE Event_Event_Question__c IN :eventEventQuestionIds
                    AND Event_Registration__c IN :erIds
                   ];
        } catch(QueryException ex) {
            return null;
        }
    }
    
    private static List<Question> BuildEventQuestions(List<EventEventQuestion__c> questions, List<EventQuestionOption__c> questionOptions) {
        List<Question> eventQuestions = new List<Question>();
        for(EventEventQuestion__c q : questions) {
            List<Option> options = new List<Option>();
            
            for(EventQuestionOption__c o : questionOptions) {
                if(o.Event_Question__c == q.Event_Question__r.Id) {
                    Option optionToAdd = new Option();
                    optionToAdd.Id = o.Id;
                    optionToAdd.Order = o.Sort_Order__c;
                    optionToAdd.Text = o.Option__c;
                    options.add(optionToAdd);
                }
            }
            
            Question questionToAdd = new Question();
            questionToAdd.Id = q.Id;
            questionToAdd.Text = q.Event_Question__r.Question_Text__c;
            questionToAdd.Order = q.Sort_Order__c;
            questionToAdd.IsRequired = q.Is_Required__c;
            questionToAdd.AnswerType = q.Event_Question__r.Answer_Type__c;
            questionToAdd.Options = options;
            eventQuestions.add(questionToAdd);
        }
        return eventQuestions;
    }
    
    private static List<Event_Registration_Answer_Selection__c> GetExistingAnswerSelections(List<Event_Registration_Answer__c> existingAnswers) {
        List<Event_Registration_Answer_Selection__c> existingAnswerSelections = new List<Event_Registration_Answer_Selection__c>();
        Set<string> answerIds = new Set<string>();
        for(Event_Registration_Answer__c a : existingAnswers) {
            answerIds.add(a.Id);
        }
        try {
            existingAnswerSelections = [SELECT Id,
                                        Event_Question_Option__c,
                                        Event_Registration_Answer__c
                                        FROM Event_Registration_Answer_Selection__c
                                        WHERE Event_Registration_Answer__c IN :answerIds];
        } catch (QueryException ex) {
            // Swallow (apparently there aren't any existing answer selections)
        }
        return existingAnswerSelections;
    }
    
    private static boolean RegistrantIsGuest(Event_Registration__c parentER, Event__c theEvent) {
        if(parentER.Parent_Registration__c != null) {
            return true;
        }
        return false;
    }
    
    private static Registration BuildRegistration(Event_Registration__c parentER, List<Question> eventQuestions, boolean isGuest) {
        Registration rI = new Registration();
        rI.AttendeeType = parentER.Attendee_Type__c;
        rI.ContactId = parentER.Contact__r.Id;
        rI.EmailAddress = parentER.Contact__r.Email;
        rI.EventId = parentER.Event__c;
        rI.EventRegistrationId = parentER.Id;
        rI.FirstName = parentER.Contact__r.FirstName;
        rI.IsGuest = isGuest;
        rI.LastName = parentER.Contact__r.LastName;
        rI.ShirtSize = parentER.T_Shirt_Size__c;
        rI.RegistrationStatus = parentER.Status__c;
        rI.Questions = (List<Question>)JSON.deserialize(JSON.serialize(eventQuestions), List<Question>.class);
        return rI;
    }
    
    private static Guest BuildGuest(Event_Registration__c er, List<Question> eventQuestions) {
        Guest g = new Guest();
        g.FirstName = er.Contact__r.FirstName;
        g.LastName = er.Contact__r.LastName;
        g.EmailAddress = er.Contact__r.Email;
        g.ContactId = er.Contact__r.Id;
        g.ShirtSize = er.T_Shirt_Size__c;
        g.RegistrationStatus = er.Status__c;
        g.Questions = (List<Question>)JSON.deserialize(JSON.serialize(eventQuestions), List<Question>.class);
        return g;
    }
    
    private static void SetQuestionAnswers(List<Question> questions, string eventRegistrationId, List<Event_Registration_Answer__c> existingAnswers, List<Event_Registration_Answer_Selection__c> existingAnswerSelections) {
        for(Question q : questions) {
            for(Event_Registration_Answer__c a : existingAnswers) {
                if(a.Event_Registration__c == eventRegistrationId && a.Event_Event_Question__c == q.Id) {
                    if(a.Answer_Type__c == 'Text') {
                        q.Answer = a.Text_Answer__c;
                    }
                    else if(a.Answer_Type__c == 'Checkbox') {
                    	q.Checked = a.Checkbox_Answer__c;
                    } else {
                        for(Option o : q.Options) {
                            for(Event_Registration_Answer_Selection__c ea : existingAnswerSelections) {
                                if(ea.Event_Question_Option__c == o.Id && ea.Event_Registration_Answer__c == a.Id) {
                                    o.Selected = true;
                                }
                            }
                        }
                    }
                }
            }
        }
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
        public string RegistrationStatus;
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
        public string Text;
        public decimal Order;
    }
    
    public class Question {
        public string Id;
        public List<Option> Options;
        public string Answer;
        public boolean IsRequired;
        public string AnswerType;
        public boolean Checked;
        public string EventRegistrationId;
        public string Text;
        public decimal Order;
    }
    
    public class DebugException extends Exception{}
}