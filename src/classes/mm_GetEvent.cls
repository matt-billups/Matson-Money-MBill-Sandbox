@RestResource(urlMapping='/mm_GetEvent/*')
global with sharing class mm_GetEvent {
    
    @HttpGet
    global static void GetEvent() {
        Map<string, string> params = RestContext.request.params;
        
        string EVID = params.get('EVID'); 
        
        Event__c theEvent;        
        
        try {
            //Retrive Specific Event specific fields 
            theEvent = [Select Event_Banner__c,
                                              Event_Description__c,
                                              Event_End_Date__c,
                                              Event_Start_Date__c,
                                              Event_Type__c,
                                              Event_Vendor_Account__c,
                                              Event_Vision__c,
                                              Event_Website__c,
                        				      Event_Video_URL__c,
                        					  Event_Overview__c,
                        					  Additional_Agenda_Information__c,
                        					  Speakers_Summary__c,
                                              Id,
                                              Map_to_Venue__c,
                                              Maximum_Registration__c,
                                              Name,
                                              PublicRegistration__c, 
                                              Registered_Attendees__c,
                                              RegistrationEndDate__c,
                                              RegistrationEndTime__c,
                                              T_Shirt_Included__c,
                                              Track__c,
                        					  Summary_Tab__c,
                        					  Agenda_Tab__c,
                        					  Travel_Tab__c,
                        					  Restaurants_Tab__c,
                        					  Concierge_Tab__c,
                        					  FAQs_Tab__c,
                                              Venue__r.Arrival_Instructions__c,
                                              Venue__r.Name,
                                              Venue__r.Street_Address_1__c, 
                                              Venue__r.Street_Address_2__c,
                                              Venue__r.City__c,
                                              Venue__r.Concierge__c,
                                              Venue__r.Venue_State__c,
                                              Venue__r.Postal_Code_Zip__c,
                                              Venue__r.Venue_Geolocation__Latitude__s,
                                              Venue__r.Venue_Geolocation__Longitude__s,
                                              Venue__r.Venue_Time_Zone__c,
                                              Venue__r.Airport_Name__c,
                                              Venue__r.Airport_Street_Address__c,
                                              Venue__r.Airport_City__c,
                                              Venue__r.Airport_State__c,
                                              Venue__r.Airport_Postal_Code_Zip__c,
                                              Venue__r.Airport_Website__c,
                                              Venue__r.Airport_Geolocation__Latitude__s,
                                              Venue__r.Airport_Geolocation__Longitude__s,
                                              Venue__r.Airport_Abbreviation__c
                                         FROM Event__c
                                        WHERE Id = :EVID
                                        LIMIT 1];
        }
        catch(QueryException ex) {
            // If there's no event then we return without setting the JSON response
            return;
        }
        
        // Get and format the list of Frequently-Asked Questions
        Track__c TrackForEvent;
        List<Map<String, Object>> FAQResponse = new List<Map<string, Object>>();
        try {
            TrackforEvent = [SELECT Id, Name FROM Track__c WHERE Id = :theEvent.Track__c LIMIT 1];
            List<Faq__c> eventFAQ = [SELECT Question__c, Answer__c, Order__c FROM FAQ__C WHERE Track__c = :TrackforEvent.Id];
            for(Faq__c faq: eventFAQ) {
                FAQResponse.Add(new Map<string, object> {
                        'Question' => faq.Question__c,
                        'Answer' => faq.Answer__c,
                        'Order' => faq.Order__c
                });
            }
        }
        catch (QueryException ex) {
            // Swallow this - if there are no records, just don't populate the FAQ list.
        }
        
        // Get and format the shirt size options
        List<string> ShirtSizeOptions = new List<string>();
        List<PickListEntry> fieldResult = Event_Registration__c.T_Shirt_Size__c.getDescribe().getPicklistValues();
        for(PickListEntry ple: fieldResult) {
            ShirtSizeOptions.Add(ple.getValue());
        }
        
        // Get and format the Venue Map
        List<Map<String, Object>> Locations = new List<Map<String, Object>>();
        
        // Add the Venue location
        Locations.Add(new Map<String, Object> {
            'Type' => 'Venue',
                'Address' => theEvent.Venue__r.Street_Address_1__c,
                'City' => theEvent.Venue__r.City__c,
                'Description' => 'Venue',
                'Latitude' => theEvent.Venue__r.Venue_Geolocation__Latitude__s,
                'Longitude' => theEvent.Venue__r.Venue_Geolocation__Longitude__s,
                'Name' => theEvent.Venue__r.Name,
                'PostalCode' => theEvent.Venue__r.Postal_Code_Zip__c,
                'State' => theEvent.Venue__r.Venue_State__c,
                'LocationHotelDetails' => null
                });
        
        List<VenueAirport__c> VenueAirports = [SELECT Airport__r.Airport_Street_Address__c,
                                               Airport__r.Airport_City__c,
                                               Airport__r.Airport_Geolocation__Latitude__s,
                                               Airport__r.Airport_Geolocation__Longitude__s,
                                               Airport__r.Airport_Name__c,
                                               Airport__r.Airport_Postal_Code_Zip__c,
                                               Airport__r.Airport_State__c
                                               FROM VenueAirport__c
                                               WHERE Venue__c = :theEvent.Venue__c];
        if(VenueAirports != null && VenueAirports.size() > 0) {
            for(VenueAirport__c airport : VenueAirports) {
                Locations.Add(new Map<string, object> {
                    'Type' => 'Airport',
                        'Address' => airport.Airport__r.Airport_Street_Address__c,
                        'City' => airport.Airport__r.Airport_City__c,
                        'Description' => 'Airport',
                        'Latitude' => airport.Airport__r.Airport_Geolocation__Latitude__s,
                        'Longitude' => airport.Airport__r.Airport_Geolocation__Longitude__s,
                        'Name' => airport.Airport__r.Airport_Name__c,
                        'PostalCode' => airport.Airport__r.Airport_Postal_Code_Zip__c,
                        'State' => airport.Airport__r.Airport_State__c,
                        'LocationHotelDetails' => null
                        });
            }
        }
        
        // Add the Hotel locations
        List<Event_Hotel__c> Hotels;
        try {
            Hotels = [SELECT Id,
                      Name, 
                      Matson_Event__c, 
                      Hotel__c,
                      Hotel__r.Name,
                      Hotel__r.Address__c,
                      Hotel__r.City__c,
                      Hotel__r.Description__c,
                      Hotel__r.Hotel_Phone_Number__c,
                      Hotel__r.Postal_Code_Zip__c,
                      Hotel__r.State__c,
                      Hotel__r.Web_Address__c,
                      Hotel__r.Hotel_Geolocation__Latitude__s,
                      Hotel__r.Hotel_Geolocation__Longitude__s,
                      Featured__c,
                      Special_Rate_URL__c,
                      Discount_Code__c,
                      Featured_Hotel_Description__c,
                      Featured_Hotel_Rate_Description__c
                      FROM Event_Hotel__c
                      WHERE Matson_Event__c = :theEvent.Id];
            
            Set<string> hotelIds = new Set<string>();
            for(Event_Hotel__c hotel : Hotels) {
                hotelIds.add(hotel.Hotel__r.Id);
            }
            
            List<Attachment> hotelAttachments = [SELECT ParentId, Body FROM Attachment 
                                            WHERE ParentId IN :hotelIds AND ContentType IN ('image/png', 'image/jpeg', 'image/gif')];
            
            for(Event_Hotel__c hotel: Hotels) {
                Blob hotelImageBody = null;
                
                //There is only ever going to be one or null pictures per Event_Hotel__c
                for(Attachment hotelAttachment: hotelAttachments) {
                    if (hotelAttachment.ParentId == hotel.Hotel__r.Id)
                    {
                        hotelImageBody = hotelAttachment.Body;
						break;
                    }
                }
                    
        		Map<String, Object> hotelDetails = new Map<String, Object>{
                    'DiscountURL' => hotel.Special_Rate_URL__c,
                    'IsFeatured' => hotel.Featured__c,
					'EncodedImageBody' => hotelImageBody,
					'FeaturedHotelDescription' => hotel.Featured_Hotel_Description__c,
					'FeaturedHotelRateDescription' => hotel.Featured_Hotel_Rate_Description__c
                };
                
                Locations.Add(new Map<String, Object>{
                    'Address' => hotel.Hotel__r.Address__c,
                    'City' => hotel.Hotel__r.City__c,
                    'Latitude' => hotel.Hotel__r.Hotel_Geolocation__Latitude__s,
                    'Longitude' => hotel.Hotel__r.Hotel_Geolocation__Longitude__s,
                    'Name' => hotel.Hotel__r.Name,
                    'Description' => hotel.Hotel__r.Description__c,
                    'PostalCode' => hotel.Hotel__r.Postal_Code_Zip__c,
                    'State' => hotel.Hotel__r.State__c,
                    'Type' => 'Hotel',
                    'LocationHotelDetails' => hotelDetails
                });
            }
        }
        catch(QueryException ex) {
            // Swallow this because if there are no hotels, just don't populate the hotels
        }
                
        // Add the restaurants
        List<Restaurant__c> restaurants;
        try {
            restaurants = [SELECT Id,
                           Name,
                           Street_Address__c,
                           City__c,
                           State__c,
                           Postal_Code_Zip__c,
                           Restaurant_Geolocation__Latitude__s,
                           Restaurant_Geolocation__Longitude__s
                           FROM Restaurant__c
                           WHERE Venue__c = :theEvent.Venue__c ORDER BY Sort_Order__c, Name ASC];
            for(Restaurant__c restaurant: restaurants) {
                Locations.Add(new Map<String, Object> {
                    'Address' => restaurant.Street_Address__c,
                        'City' => restaurant.City__c,
                        'Latitude' => restaurant.Restaurant_Geolocation__Latitude__s,
                        'Longitude' => restaurant.Restaurant_Geolocation__Longitude__s,
                        'Name' => restaurant.Name,
                        'PostalCode' => restaurant.Postal_Code_Zip__c,
                        'State' => restaurant.State__c,
                        'Type' => 'Restaurant',
                        'LocationHotelDetails' => null
                        });
            }
        } catch(QueryException ex) {
            // Swallow because if it fails, we just don't return restaurants
        }
        
        Map<String, Object> venueMap = new Map<String, Object> {
                'ArrivalInstructions' => theEvent.Venue__r.Arrival_Instructions__c,
                'Locations' => Locations
        };
        
        List<Event_Days__c> eventDays;
        Map<String, Object> schedule = new Map<String, Object>();
        List<Map<String, Object>> agenda = new List<Map<String, Object>>();
        try {
            eventDays = [SELECT Id,
                         Name,
                         Event_Day_Start_Date__c,
                         Event_Day_Start_Time__c,
                         Event_Day_End_Time__c,
                         Adviser_Only__c
                         FROM Event_Days__c
                         WHERE Matson_Event__c =:theEvent.Id
                         ORDER BY Start_Time__c];
            // Get and format the Schedule
            
            for(Event_Days__c eventDay: eventDays) {
                    agenda.Add(new Map<String, Object> {
                            'Title' => eventDay.Name,
                            'Start' => eventDay.Event_Day_Start_Date__c.month() + '/' + eventDay.Event_Day_Start_Date__c.day() + '/' + eventDay.Event_Day_Start_Date__c.year() + ' ' + eventDay.Event_Day_Start_Time__c,
                            'End' => eventDay.Event_Day_Start_Date__c.month() + '/' + eventDay.Event_Day_Start_Date__c.day() + '/' + eventDay.Event_Day_Start_Date__c.year() + ' ' + eventDay.Event_Day_End_Time__c
                    });

            }
        }
        catch(QueryException ex) {
            // Swallow this too
        }
        
        schedule.put('Events', agenda);
        
        // Get the Event Questions
        List<Map<String, Object>> Questions = new List<Map<String, Object>>();
        // Start with the lookup table
        List<EventEventQuestion__c> questionLookup = new List<EventEventQuestion__c>();
        try {
            questionLookup = [SELECT Event_Question__c,
                                     Is_Required__c,
                                     Event_Question__r.Answer_Type__c,
                                     Event_Question__r.Question_Text__c,
                                     Id,
                                     Sort_Order__c
                                FROM EventEventQuestion__c
                               WHERE Matson_Event__c = :theEvent.Id
                                 AND IsActive__c = true];
            if(questionLookup.size() > 0) {
                // Get the questions
                for(EventEventQuestion__c lookup: questionLookup) {
                    // Get the answers
                    List<EventQuestionOption__c> questionOptionsFromDb = [SELECT Id,
                                                                   Option__c,
                                                                   Sort_Order__c
                                                                   FROM EventQuestionOption__c
                                                                    WHERE Event_Question__c = :lookup.Event_Question__r.Id];
                    List<Map<String, Object>> QuestionOptions = new List<Map<String, Object>>();
                    for(EventQuestionOption__c option: questionOptionsFromDb) {
                        QuestionOptions.Add(new Map<String, Object>{
                           'Id' => option.Id,
                           'Order' => option.Sort_Order__c,
                           'Text' => option.Option__c
                        });
                    }
                    Map<String, Object> Question = new Map<String, Object>{
                        'Id' => lookup.Id,
                        'Text' => lookup.Event_Question__r.Question_Text__c,
                        'Order' => lookup.Sort_Order__c,
                        'IsRequired' => lookup.Is_Required__c,
                        'AnswerType' => lookup.Event_Question__r.Answer_Type__c,
                        'Options' => QuestionOptions
                    };
                    Questions.Add(Question);
                }
            }
        }
        catch(QueryException ex) {
            // Swallow this too
        }
        
        // Add the Custom tabs
        List<Custom_Tab__c> eventCustomTabs;
        List<Map<String, Object>> customTabs = new List<Map<String, Object>>();
        try {
            eventCustomTabs = [SELECT Name,
                          Content__c,
                          Sort_Order_Display_Before__c,
                          Visible__c
                          FROM Custom_Tab__c
                          WHERE Matson_Event__c = :theEvent.Id];
            
            for(Custom_Tab__c customTab: eventCustomTabs) {
                customTabs.Add(new Map<String, Object> {
                    'Name' => customTab.Name,
                    'Content' => customTab.Content__c,
                    'DisplayBefore' => customTab.Sort_Order_Display_Before__c,
                    'IsVisible' => customTab.Visible__c
                });
            }
        }
        catch(QueryException ex) {
            // Swallow this because if there are no custom tabs, just don't populate the custom tabs
        }
        
        // Add the Speakers
        List<Matson_Event_Speaker__c> matsonEventSpeakers;
        List<Map<String, Object>> speakers = new List<Map<String, Object>>();
        try {
            matsonEventSpeakers = [SELECT Speaker_Contact_Name__c,
                          Biography__c,
                          Sort_Order__c,
                          Speaker_Contact__c,
                          Id
                          FROM Matson_Event_Speaker__c
                          WHERE Matson_Event__c = :theEvent.Id];
            
            Set<string> matsonEventSpeakerIds = new Set<string>();
            for(Matson_Event_Speaker__c matsonEventSpeaker : matsonEventSpeakers) {
                matsonEventSpeakerIds.add(matsonEventSpeaker.Id);
            }
            
            List<Attachment> speakerAttachments = [SELECT ParentId, Body FROM Attachment 
                                            WHERE ParentId IN :matsonEventSpeakerIds AND ContentType IN ('image/png', 'image/jpeg', 'image/gif')];
            
            for(Matson_Event_Speaker__c matsonEventSpeaker: matsonEventSpeakers) {
                Blob speakerImageBody = null;
                
                //There is only ever going to be one or null pictures per Matson_Event_Speaker__c
                for(Attachment speakerAttachment: speakerAttachments) {
                    if (speakerAttachment.ParentId == matsonEventSpeaker.Id)
                    {
                        speakerImageBody = speakerAttachment.Body;
						break;
                    }
                }
                
                speakers.Add(new Map<String, Object> {
                    'Name' => matsonEventSpeaker.Speaker_Contact_Name__c,
                        'Biography' => matsonEventSpeaker.Biography__c,
                        'SortOrder' => matsonEventSpeaker.Sort_Order__c,
                        'ContactId' => matsonEventSpeaker.Speaker_Contact__c,
                        'EncodedSpeakerImageBody' => speakerImageBody
                        });
            }
        }
        catch(QueryException ex) {
            // Swallow this because if there are no speakers, just don't populate the speakers
        }
        
        // Format the event details
        Map<String, Object> eventDetails = new Map<String, Object>{
            'PublicRegistration' => theEvent.PublicRegistration__c,
            'CurrentRegistrations' => theEvent.Registered_Attendees__c,
            'Capacity' => theEvent.Maximum_Registration__c,
            'StartDate' => theEvent.Event_Start_Date__c,
            'EndDate' => theEvent.Event_End_Date__c,
            'RegistrationEnd' => theEvent.RegistrationEndDate__c.month() + '/' + theEvent.RegistrationEndDate__c.day() + '/' + theEvent.RegistrationEndDate__c.year() + ' ' + theEvent.RegistrationEndTime__c,
            'TimeZone' => theEvent.Venue__r.Venue_Time_Zone__c,
            'RequestShirtSize' => theEvent.T_Shirt_Included__c,
            'VideoUrl' => theEvent.Event_Video_URL__c,
            'AdditionalAgendaInformation' => theEvent.Additional_Agenda_Information__c,
            'EventOverview' => theEvent.Event_Overview__c,
            'SpeakerSummary' => theEvent.Speakers_Summary__c,
            'SummaryTab' => theEvent.Summary_Tab__c,
            'AgendaTab' => theEvent.Agenda_Tab__c,
			'TravelTab' => theEvent.Travel_Tab__c,
            'RestaurantsTab' => theEvent.Restaurants_Tab__c,
            'ConciergeTab' => theEvent.Concierge_Tab__c,
            'FAQsTab' => theEvent.FAQs_Tab__c
        };
                    
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new Map<String, Object> {
                'EventId' => theEvent.Id,
                'EventLocation' => theEvent.Venue__r.Concierge__c,
                'Banner' => new Map<string, Object> {
                    'Text' => theEvent.Name,
                    'ImageSource' => theEvent.Event_Banner__c
                },
                'Description' => theEvent.Event_Description__c,
                'FAQ' => FAQResponse,
                'RegistrationTemplate' => new Map<string, Object> {
                    'ShirtSizeOptions' => ShirtSizeOptions,
                    'Questions' => Questions
                },
                'VenueMap' => venueMap,
                'Schedule' => schedule,
                'EventDetails' => eventDetails,
                'CustomTabs' => customTabs,
                'Speakers' => speakers
        }));
    }
}