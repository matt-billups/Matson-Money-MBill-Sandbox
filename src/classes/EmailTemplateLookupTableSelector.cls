public class EmailTemplateLookupTableSelector extends fflib_SObjectSelector implements IEmailTemplateLookupTableSelector{
    
    public static IEmailTemplateLookupTableSelector newInstance()
    {
        return (IEmailTemplateLookupTableSelector) Application.Selector.newInstance(EmailTemplateLookupTable__c.SObjectType);
    }
    
    public List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {
            EmailTemplateLookupTable__c.Id,
                EmailTemplateLookupTable__c.Name,
                EmailTemplateLookupTable__c.EmailTemplateId__c,
                EmailTemplateLookupTable__c.EmailTemplateType__c,
                EmailTemplateLookupTable__c.EmailTemplateDeveloperName__c
                };
                    }
    
    public Schema.SObjectType getSObjectType()
    {
        return EmailTemplateLookupTable__c.sObjectType;
    }
    
    public List<EmailTemplateLookupTable__c> selectById(Set<ID> idSet)
    {
        return (List<EmailTemplateLookupTable__c>) selectSObjectsById(idSet);
    }
    
    public List<EmailTemplateLookupTable__c> selectByType(string emailTemplateType) {
        
        fflib_QueryFactory folderQueryFactory = newQueryFactory();
        folderQueryFactory.setCondition('EmailTemplateType = :emailTemplateType');
        return Database.query(folderQueryFactory.toSOQL());
        
    }
    
    public EmailTemplateLookupTable__c selectByName(String name) {
        
        fflib_QueryFactory queryFactory = newQueryFactory();
        queryFactory.setCondition('IsActive__c = true And Name = :name');
        
        return (EmailTemplateLookupTable__c)  Database.query( queryFactory.toSOQL() +' LIMIT 1' ) ;
    }
    
    public EmailTemplateLookupTable__c selectByDeveloperName(string developerName)  {
        
        fflib_QueryFactory queryFactory = newQueryFactory();
        EmailTemplateLookupTable__c emailTemplateLookup = null;
        
        queryFactory.setCondition('IsActive__c = true And EmailTemplateDeveloperName__c = :developerName');
        
        List<EmailTemplateLookupTable__c> listOfEmailTemplateLookups = Database.query( queryFactory.toSOQL() +' LIMIT 1' );
        
        if (listOfEmailTemplateLookups.size() > 0) {
            emailTemplateLookup = listOfEmailTemplateLookups[0];
        }
        
        return emailTemplateLookup;
    }
    public List<EmailTemplateLookupTable__c> selectAll() {
        
        fflib_QueryFactory queryFactory = newQueryFactory();
        return Database.query(queryFactory.toSOQL());
    }   
}