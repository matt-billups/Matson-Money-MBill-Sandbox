trigger ChangeRecordTypeOnConvertQuickAction on Adviser__c (before update) {
    RecordType RT = [SELECT Id,Name FROM RecordType WHERE Name = 'Adviser' and SobjectType='Adviser__c'];
    for (Adviser__c a : Trigger.new) {
        if (a.getQuickActionName () == Schema.Adviser__c.QuickAction.Convert_To_Adviser)
        {
            a.RecordTypeId = RT.Id;
            a.Status__c = 'Active Adviser';
        }
    }
}