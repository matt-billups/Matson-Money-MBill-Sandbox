public class MatsonEvents extends fflib_SObjectDomain implements IMatsonEvents {
    public static IMatsonEvents newInstance(List<Event__c> sObjectList) {
        return (IMatsonEvents) Application.Domain.newInstance(sObjectList);
    }
    
    public MatsonEvents(List<Event__c> sObjectList) {
        // Domain classes are initialized with lists to enforce bulkification throughout
        super(sObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new MatsonEvents(sObjectList);
		}
	}
    
    public override void onBeforeInsert() {
        for (Event__c event : (List<Event__c>)Records) {
            populateHouseAccountSiteToken(event);
        }
    }
    
    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        for (Event__c event : (List<Event__c>)Records) {
            populateHouseAccountSiteToken(event);
        }
    }
    
    // Create registration site token for House Account
    private static void populateHouseAccountSiteToken(Event__c event) {
        String valueToHash = String.valueOf(settingsHelperService().HouseAccountContactId()) + String.valueOf(event.Id);
        String token = settingsHelperService().CreateEventToken(valueToHash);
        event.House_Account_Site_Token__c = token;
    }
    
    private static ISettingsHelperService settingsHelperService() {
        return (ISettingsHelperService)Application.Service.newInstance(ISettingsHelperService.class);
    }
}