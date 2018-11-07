public class UserSelector extends fflib_SObjectSelector implements IUserSelector{

    public static IUserSelector newInstance()
    {
        return (IUserSelector) Application.Selector.newInstance(Fulfillment_Request__c.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {
            User.Id,
                User.Name
                };
                    }

    public Schema.SObjectType getSObjectType()
    {
        return User.sObjectType;
    }

}