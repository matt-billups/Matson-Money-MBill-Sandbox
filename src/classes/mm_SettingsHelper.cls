/**
* @author Brian K. Broughton (brian.broughton@pinnsg.com)
* @version 1.0.0
* @description Helper class for API Settings Custom Metadata Type
*
*
**/ 
public class mm_SettingsHelper implements ISettingsHelperService {
    
    /**
* @description Uses SOQL to retrieve API Settings using DeveloperName
* @settingName String DeveloperName of API_Settings. 
* @return API_Settings__mdt 
   **/ 
    public static API_Settings__mdt getAPISetting(String settingName) {
        
        API_Settings__mdt setting = null;
        
        List<API_Settings__mdt> settings = [select Username__c, Password__c, ApiKey__c, Endpoint_Base__c, Auth_Header_Field_Pattern__c from API_Settings__mdt WHERE DeveloperName  =: settingName limit 1];
        
        if (settings.size() > 0) setting = settings.get(0);
        
        return setting;
    }
    
    public static Boolean IsSandboxOrg() {
        
        //Check if this is a Sandbox
        List<Organization> orgs = [select IsSandbox from Organization limit 1];
        Boolean isSandbox = True;
        
        if(orgs.size() > 0 ){ 
            isSandbox  = orgs[0].IsSandbox; 
        }
        
        return isSandbox;        
    }
    
    public static String EventRegistrationSiteUrl() {
        
        String url = '';
        External_Endpoints__c externalEndPoints = External_Endpoints__c.getInstance();
        
        if(externalEndPoints != null){ 
            url = externalEndPoints.Event_Registration_URL__c;
        }
        
        return url;        
    }
    
    public static String CreateEventToken(String ValueToHash) {
        String EncryptThis = ValueToHash;
        EventTokenHashKey__c k = EventTokenHashKey__c.getOrgDefaults();
        String privateKey = k.Crypto__c;
        String NoPlus = null;
        if(EncryptThis != null && k != null && privatekey != null){
            Blob b = Crypto.generateMac('HmacSHA256', Blob.valueOf(EncryptThis), Blob.valueOf(privateKey));
            string sixfourencoded = EncodingUtil.base64Encode(b);
            String target = '/';
            String replacement = '-';
            String target2 = '+';
            String replacement2 = '_';
            String NoDash = sixfourencoded.replace(target, replacement);
            NoPlus = NoDash.replace(target2, replacement2);
        }
        
        return NoPlus;        
    }
    
    public static Boolean VerifyEventToken(String eventId, String contactId, String authToken) {
        If(!string.isBlank(authToken))
        {    
            String ValueToHash = '';
            String Encrypted = '';
            
            if(!string.isBlank(contactId) &&!string.isBlank(eventId) )
            {
                ValueToHash =   String.valueOf(contactId) + String.valueOf(eventId);
            } 
            
            Encrypted = CreateEventToken(ValueToHash);
            If(!authToken.substring(0, 40).equals(Encrypted.substring(0, 40)))
            { 
            	return false;
            }
            
            return true;
        }
        Else
        {
            return false;
        }
    }
    
    public static void UpdateHouseAccountContactId(Id houseAccountId) {
        Well_Known_IDs__c wellKnownIDs = Well_Known_IDs__c.getOrgDefaults();
        wellKnownIDs.House_Account_Contact_ID__c = houseAccountId;
        upsert wellKnownIDs;
    }
    
    public static String HouseAccountContactId() {
        return Well_Known_IDs__c.getOrgDefaults().House_Account_Contact_ID__c;
    }
}