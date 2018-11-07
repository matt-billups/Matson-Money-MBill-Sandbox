public with sharing  class EventRegistrationFormController {
    
    
    //creating an object like class for guest information
    
    public class GuestInformation
    {
        public String  guestType;
        public String guestFirstName;
        public String guestLastName;
        public String guestEmail;
        public String guestPhone;
        public String guestShirt;
        
        
        
        public GuestInformation(String  guestType, string guestFirstName, String guestLastName ,String guestEmail, String guestPhone,String guestShirt )
        {
            guestType = guestType;
            guestFirstName = guestFirstName;
            guestLastName = guestLastName;
            guestEmail = guestEmail;
            guestPhone = guestPhone;
            guestShirt = guestShirt;
        }
    }
    @AuraEnabled
    public static void updateInformation(String regPrimaryId, string regConformation, String regFirstName, String regLastName,String regStreet,String regState,String regCity, String regZip,String regPhone, String regEmail, String regTshirt)
    {
        Event_Registration__c EVR = [Select Id, Attendee_Type__c, Reg_Adviser__c ,Name,Registration_Type__c,Primary_Contact_Id__c, Status__c, Attendee_Mailing_Address__c, Attendee_Mailing_City__c,
                                     Attendee_Mailing_State__c, Event_Course_Name__c,Attendee_Mailing_Zip_Code__c,Attendee_Mobile_Phone__c ,Event__c,Event_Name__c, Event_Start_Date__c, Event_End_Date__c
                                     FROM Event_Registration__c WHERE Confirmation_Number__c =:regConformation limit 1];
        Contact contact = [Select Id,FirstName,LastName,Email,MailingStreet,MailingPostalCode,MailingCity,MailingState, Phone  FROM Contact Where Id = :EVR.Primary_Contact_Id__c limit 1];
        contact.MailingStreet= regStreet;
        contact.MailingCity = regCity;
        contact.MailingState = regState;
        contact.MailingPostalCode = RegZip;
        contact.Email= regEmail;
        Contact.Phone = regPhone;
        update contact;
        
        EVR.T_Shirt_Size__c = regTshirt;
        update EVR;
        
    }
    @AuraEnabled
    public static Map<Integer,string> GetRegistorationInformation(string Cnumber){
        system.debug('Pleaseeee');
        
       try{
            Event_Registration__c EVR = [Select Id, Attendee_Type__c, Reg_Adviser__c ,Name,Registration_Type__c,Primary_Contact_Id__c, Status__c, Attendee_Mailing_Address__c, Attendee_Mailing_City__c,
                                         Attendee_Mailing_State__c, Event_Course_Name__c,Attendee_Mailing_Zip_Code__c,Attendee_Mobile_Phone__c ,Event__c,Event_Name__c, Event_Start_Date__c, Event_End_Date__c
                                         FROM Event_Registration__c WHERE Confirmation_Number__c =:Cnumber limit 1]; 
            string statusNotCompleted = 'false';
            
            if(EVR.Event_Course_Name__c == 'Entrepreneur Foundation Training Session 1')
            {
                Adviser__c Adviser = [Select Id, sales_status__c, Pain_Money_Total__c, X3_Biggest_Money_Problems__c from Adviser__c where Id = :EVR.Reg_Adviser__c];
                
                if(Adviser.Pain_Money_Total__c != null && Adviser.X3_Biggest_Money_Problems__c != null )
                {
                    // update Event Registation to Registered
                    EVR.Status__c ='Registered';
                    update EVR;
                    
                }
                else
                {
                    statusNotCompleted= 'true';
                }
            }
            else
            {
                // update Event Registation to Registered
                EVR.Status__c ='Registered';
                update EVR;
            }    
            // Getting first name, Last name, Email from contacts 
            Contact contact = [Select Id,FirstName,LastName,Email  FROM Contact Where Id = :EVR.Primary_Contact_Id__c limit 1];
            
            // Puting Event Date Time into word format
             String EventStart;
            if(EVR.Event_Start_Date__c != NULL)
            {
            Datetime dt1 = EVR.Event_Start_Date__c;
            EventStart = dt1.format('MMMM d,  yyyy');
            }
            else
            {
                 EventStart= ' ';
            }
            
            String EventEnd;
            if(EVR.Event_End_Date__c != NULL)
            {
            Datetime dt2 = EVR.Event_End_Date__c;
            EventEnd = dt2.format('MMMM d,  yyyy');
            }
            else
            {
                EventEnd=' ';
            }
            
            
            Map<Integer, String> RegInfo = new Map<Integer, String>();
            
            RegInfo.put(0, EVR.Attendee_Type__c); 
            RegInfo.put(1, EVR.Status__c );
            RegInfo.put(2, contact.FirstName);
            RegInfo.put(3, contact.LastName);
            RegInfo.put(4, EVR.Attendee_Mailing_Address__c) ; 
            RegInfo.put(5,EVR.Attendee_Mailing_City__c);
            RegInfo.put(6,EVR.Attendee_Mailing_State__c);
            RegInfo.put(7,EVR.Attendee_Mailing_Zip_Code__c);
            RegInfo.put(8,EVR.Attendee_Mobile_Phone__c);
            RegInfo.put(9, contact.Email);
            RegInfo.put(10, EVR.Event_Name__c);
            RegInfo.put(11, EventStart);
            RegInfo.put(12,  EventEnd);
            RegInfo.put(13, EVR.Event__c );
            RegInfo.put(14, EVR.Reg_Adviser__c);
            RegInfo.put(15, statusNotCompleted);
            RegInfo.put(16,EVR.Primary_Contact_Id__c);
            
            return RegInfo;
        }
       catch(Exception ex)
        {
            Map<Integer, String> RegInfo = new Map<Integer, String>();
           RegInfo.put(0, 'true');
            return RegInfo;
            
       }  
    }


    @AuraEnabled
    public static string[] registorGuests(Integer numberOfGuest, string guestInformationList, string eventId , string adviserId)  
        
    { 
        string guest1;
        string guest2;
        string guest3;
        string guest4;
        string guest5;
        Integer x;
        x = integer.valueof(numberOfGuest);        
        system.debug('json'+ (x-1) );
        String didNotFind = 'SomeString';
        string isContact = 'true';
        //List<GuestInformation> message = new List<GuestInformation>();
        
        List<GuestInformation> guestinformation = (List<GuestInformation>)JSON.deserialize(guestInformationList, List<GuestInformation>.class);
        system.debug('here');
        for(integer i=0; i <= (x - 1); i ++)
        {   System.debug('made it here for loop'+ i);
         string gEmail = guestinformation[i].guestEmail;
         string gtype = guestinformation[i].guestType;
         string gFirstName = guestinformation[i].guestFirstName;
         string gLastName = guestinformation[i].guestLastName;
         string gPhone = guestinformation[i].guestPhone;
         string gShirt =guestinformation[i].guestShirt;
         
         
         list<Contact> c = [Select Id From Contact where FirstName = :gFirstName and LastName = :gLastName and (MobilePhone = :gPhone or Email = : gEmail or  Office_Phone__c = :gPhone) limit 1  ];
         if(!c.isEmpty())
         {
             //check for event reg already
             List<Event_Registration__c> EVR = [Select Id from Event_Registration__c where Contact__c = :c[0].Id and Event__c = :eventId];
             
             if(EVR.isEmpty())
             {
                 if(gtype == 'Active Client')
                 {
                     Event_Registration__c ER = new Event_Registration__c();
                     ER.Attendee_Type__c = 'Client';
                     ER.Status__c = 'Registered';
                     ER.Reg_Adviser__c = adviserId;
                     ER.Event__c = eventId;
                     ER.Contact__c = c[0].Id ;
                     ER.T_Shirt_Size__c= gShirt;
                     insert ER;
                 }
                 else if(gtype == 'Spouse')
                 {
                     Event_Registration__c ER = new Event_Registration__c();
                     ER.Attendee_Type__c = 'Spouse';
                     ER.Reg_Adviser__c = adviserId;
                     ER.Status__c = 'Registered';
                     ER.Event__c = eventId;
                     ER.Contact__c = c[0].Id ;
                     ER.T_Shirt_Size__c= gShirt;
                     insert ER;
                 }
                 else if(gtype == 'Team Member')
                 {
                     list<Adviser__c> ADV =[Select Id From Adviser__c where Primary_contact__c = :c[0].Id];
                     
                     if(!ADV.isEmpty())
                     {
                         Event_Registration__c ER = new Event_Registration__c();
                         ER.Attendee_Type__c = 'Adviser';
                         ER.Reg_Adviser__c = ADV[0].Id;
                         ER.Event__c = eventId;
                         ER.Status__c = 'Registered';
                         ER.Contact__c = c[0].Id ;
                         ER.T_Shirt_Size__c= gShirt;
                         insert ER;
                     }
                     Else
                     {
                         Event_Registration__c ER = new Event_Registration__c();
                         ER.Attendee_Type__c = 'Team Member';
                         ER.Reg_Adviser__c = adviserId;
                         ER.Event__c = eventId;
                         ER.Status__c = 'Registered';
                         ER.Contact__c = c[0].Id ;
                         ER.T_Shirt_Size__c= gShirt;
                         insert ER;
                     }
                 }
                 else if(gType == 'Millennial Guest (age 16-30)' || gtype =='Guest')
                 {
                     system.debug(adviserId);
                     Event_Registration__c ER = new Event_Registration__c();
                     ER.Reg_Adviser__c = adviserId;
                     ER.Event__c = eventId;
                     ER.Status__c = 'Registered';
                     ER.Contact__c = c[0].Id ;
                     ER.T_Shirt_Size__c= gShirt;
                     
                     if(gType == 'Millennial Guest (age 16-30)')
                     {
                         ER.Attendee_Type__c = 'Millennial Guest';
                     }
                     else
                     {
                         ER.Attendee_Type__c = gType;
                     }
                     insert ER;
                 }
             }
         }
         else if(c.isEmpty()&&(gtype == 'Active Client' || gtype == 'Team Member'))
         {
             //return Something in error
             didNotFind = i + ', ' + guestinformation[i].guestEmail + ', ' + guestinformation[i].guestFirstName + ', ' +
                 guestinformation[i].guestLastName + ', ' +  guestinformation[i].guestPhone;
             isContact = 'false';
             break;
         }
         else
         {
             Contact Con = new Contact();
             Con.FirstName = gFirstName;
             Con.LastName = gLastName;
             Con.Email = gEmail;
             if(gType == 'Millennial Guest (age 16-30)')
             {
                 con.Contact_Designation__c = 'Millennial Guest';
             }
             else
             {
                 Con.Contact_Designation__c = gtype; 
             }
             
             Con.MobilePhone = gPhone;
             insert Con;
             
             
             Event_Registration__c ER = new Event_Registration__c();
             ER.Reg_Adviser__c = adviserId;
             ER.Event__c = eventId;
             ER.Status__c = 'Registered';
             ER.Contact__c = Con.Id;
             ER.T_Shirt_Size__c= gShirt;
             
             if(gType == 'Millennial Guest (age 16-30)')
             {
                 ER.Attendee_Type__c = 'Millennial Guest';
             }
             else
             {
                 ER.Attendee_Type__c = gType;
             }
             insert ER;
             
         }
         
         if(i==0)
         {
             guest1 =guestinformation[i].guestFirstName + ' '+  guestinformation[i].guestLastName;
         }
         else if(i==1)
         {
             guest2 = guestinformation[i].guestFirstName + ' ' +guestinformation[i].guestLastName; 
         }
         else if(i==2)
         {
             guest3 = guestinformation[i].guestFirstName + ' ' +guestinformation[i].guestLastName; 
         }  
         else if(i==3)
         {
             guest4 = guestinformation[i].guestFirstName + ' ' +guestinformation[i].guestLastName; 
         } 
         else if(i==4)
         {
             guest5 = guestinformation[i].guestFirstName + ' ' +guestinformation[i].guestLastName; 
         } 
        }
        string [] results = new string [] {isContact,didNotFind,guest1,guest2,guest3,guest4,guest5};     
            system.debug(results);
        return results;
        
    }
    
    
    
}