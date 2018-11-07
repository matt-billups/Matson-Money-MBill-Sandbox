public interface IEmailTemplateLookupTableSelector extends fflib_ISObjectSelector{
    List<EmailTemplateLookupTable__c> selectById(Set<ID> idSet);
    List<EmailTemplateLookupTable__c> selectByType(string folderType) ;
    List<EmailTemplateLookupTable__c> selectAll();
    EmailTemplateLookupTable__c selectByName(string name) ;
    EmailTemplateLookupTable__c selectByDeveloperName(string developerName) ;
    
}