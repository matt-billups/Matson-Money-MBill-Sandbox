trigger EventRegistrationsTrigger on Event_Registration__c (before insert, before update)
{
    for (Event_Registration__c obj : trigger.new)
    {
        // Create registration site token
        String valueToHash =   String.valueOf(obj.Contact__c) + String.valueOf(obj.Event__c);
        String token = mm_SettingsHelper.CreateEventToken(valueToHash);
        obj.Registration_Site_Token__c = token;
    }
}