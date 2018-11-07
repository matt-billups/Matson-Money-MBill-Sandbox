public interface ISettingsHelperService {
    API_Settings__mdt getAPISetting(String settingName);
    Boolean IsSandboxOrg();
    String EventRegistrationSiteUrl();
    String CreateEventToken(String ValueToHash);
    Boolean VerifyEventToken(String eventId, String contactId, String authToken);
    void UpdateHouseAccountContactId(Id houseAccountId);
    String HouseAccountContactId();
}