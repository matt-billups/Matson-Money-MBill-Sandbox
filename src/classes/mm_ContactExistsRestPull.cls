@RestResource(urlMapping='/mm_ContactExistsRestPull/*')
global with sharing class mm_ContactExistsRestPull {
    @HttpGet
    global static String GetContacts() { 
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //accepts param(s) of:
        //EVID - Event__c Salesforce ID
        //CONID - Contact Salesforce ID
        // FN -Firstname
        // LN -Lastname
        // EM -Email
        // NN - NicknameString 
        //TOKEN - Authorization Token from email
        
        //URL example: /services/apexrest/mm_ContactExistsRestPull/?EVID=a0ec0000004bCPbAAM&FN=Walt&LN=Disney&EM=braden.fraley@matsonmoney.com&NN=Mickey&TOKEN=poll7b3hRbV9Vhq5moEOaah4e3x%2Bi7tLoF2TuorD%2BLw%3D
        
        //get param(s) from URL
        Map<String, String> params = RestContext.request.params;
        String ReturnedAUTHTOKEN = params.get('TOKEN');
        String EVID = params.get('EVID');
        String CONID = params.get('CONID');
        String FN = params.get('FN');
        String LN = params.get('LN');
        String EM = params.get('EM'); 
        String NN = params.get('NN');       
        
        //boolean conExists = False;
        String Conexists = 'True';
        String ConNotexists = 'False';
        String Authorized = 'Authorized';
        String NotAuthorized = 'Not Authorized';
        
        If(!string.isBlank(ReturnedAUTHTOKEN))
        {    
            
            List<Contact> con = [Select 
                                 Id
                                 from Contact where id=:CONID Limit 1];
            List<Event__c> EVNT = [Select 
                                   Id,
                                   Name, 
                                   Venue__c,
                                   Event_Website__c,
                                   PublicRegistration__c,
                                   Event_Start_Date__c,
                                   Event_End_Date__c,
                                   Venue_Street_Address_1__c,
                                   Venue_City__c,
                                   Venue_State__c,
                                   Venue_Postal_Code__c
                                   
                                   from Event__c where id = :EVID Limit 1]; 
            List<Venue__c> VEN = [Select 
                                  Id, 
                                  Name
                                  from Venue__c where id=:EVNT[0].Venue__c Limit 1];
            
            String ValueToHash = '';
            String Encrypted = '';
            if(!string.isBlank(con[0].id) &&!string.isBlank(EVNT[0].id) )
            {
                ValueToHash =   String.valueOf(con[0].id)+String.valueOf(EVNT[0].id);
            } 
            
            Encrypted = mm_SettingsHelper.CreateEventToken(ValueToHash);
            
            
            If(ReturnedAUTHTOKEN.substring(0, 40).equals(Encrypted.substring(0, 40)))
            { 
                List<Event_Registration__c> REG = [Select 
                                                   Id
                                                   from Event_Registration__c where Event__c = :EVNT[0].id AND Contact__c = :con[0].id Limit 1];
                List<Adviser__c> adv = [Select 
                                        Id
                                        from Adviser__c where Primary_Contact__c = :con[0].id Limit 1];
                If(REG.isEmpty())
                {
                    Event_Registration__c evr;
                    
                    If(!adv.isEmpty())
                    {
                        //Create an Event Registraion once contact auth set registration as adviser
                        evr = new Event_Registration__c();
                        evr.Reg_Adviser__c = adv[0].Id;
                        evr.Event__c = EVNT[0].Id;
                        evr.Attendee_Type__c = 'Adviser';
                        evr.T_Shirt_Size__c = 'L';
                        evr.Status__c = 'Invited';
                        insert evr;
                    }
                    Else
                    {
                        //Create an Event Registraion once contact authorized
                        evr = new Event_Registration__c();
                        evr.Contact__c = con[0].Id;
                        evr.Event__c = EVNT[0].Id;
                        evr.Attendee_Type__c = 'Guest';
                        evr.T_Shirt_Size__c = 'L';
                        evr.Status__c = 'Invited';
                        
                        insert evr;
                    }
                    
                    return Authorized;
                }
                Else
                {
                    return Authorized; 
                }
                
                
            }
            Else
            {
                return NotAuthorized;
            }
            
        }
        Else
        {
            
            Contact cont = null;
            List<Contact> con = [Select     
                                 Id,
                                 Name,
                                 FirstName,
                                 LastName,
                                 Email,
                                 Nickname__c
                                 from Contact where (LastName = :LN AND Email = :EM ) AND (FirstName = :FN OR Nickname__c = :FN ) Limit 1];
            
            if(!con.isEmpty())
            {
                cont = con[0];
                
                List<Event__c> EVNT = [Select 
                                       Id,
                                       Name,
                                       Event_Website__c,
                                       Event_Start_Date__c
                                       from Event__c where id = :EVID Limit 1]; 
                String ValueToHash = '';
                String Encrypted = '';
                if(!string.isBlank(cont.Id) &&!string.isBlank(EVNT[0].id) )
                {
                    ValueToHash =   String.valueOf(cont.id)+String.valueOf(EVNT[0].id);
                }
                
                Encrypted = mm_SettingsHelper.CreateEventToken(ValueToHash);
                
                ///included in email asking to authorize
                String ENDPOINTURL = mm_SettingsHelper.EventRegistrationSiteUrl();
                String AUTHLINK = ENDPOINTURL + EVNT[0].id  +'/'+ cont.id+ '/'+Encrypted;
               
                
                OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where Address ='registration@matsonmoney.com' limit 1];
                
                List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
                EmailTemplate emailTemplate = [Select Id, Subject, HtmlValue, Body from EmailTemplate where developername = 'EventContactAuthen'];
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateID(emailTemplate.Id); 
                
                
                
                
                String htmlBody = emailTemplate.HtmlValue;
                htmlBody = htmlBody.replace('{!Contact.FirstName}', con[0].FirstName);
                htmlBody = htmlBody.replace('{!Contact.LastName}', con[0].LastName);
                htmlBody = htmlBody.replace('{!Contact.Email}', con[0].Email);
                htmlBody = htmlBody.replace('{!Event__c.Name}', EVNT[0].Name);
                htmlBody = htmlBody.replace('{!Event__c.Event_Website__c}', EVNT[0].Event_Website__c);
                htmlBody = htmlBody.replace('{!TOKEN}', Encrypted);
                htmlBody = htmlBody.replace('{!AuthentLink}', AUTHLINK);            
                
                String plainBody = emailTemplate.Body;
                plainBody = plainBody.replace('{!Contact.FirstName}', con[0].FirstName);
                plainBody = plainBody.replace('{!Event__c.Name}', EVNT[0].Name);
                
                
                mail.setTargetObjectId(con[0].id);
                mail.setSubject('Your ' + EVNT[0].Name+ ' Matson Money Event Link and Authentication');
                
                mail.setHtmlBody(htmlBody);
                mail.setPlainTextBody(plainBody);
                mail.setSaveAsActivity(false);
                mail.setOrgWideEmailAddressId(owa.id);
                //mail.setSenderDisplayName('Matson Money Event Team');
                allmsg.add(mail);
                Messaging.sendEmail(allmsg,false);
                
                return Conexists;
                
            }
            Else
            {
 
                return ConNotexists;
            }
            
        }      
        
    }   
    
}