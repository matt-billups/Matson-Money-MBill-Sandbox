public class mm_RescheduledInventory {
    @InvocableMethod(label='Find and Update Inventory Task' description='Returns the list of account names corresponding to the specified account IDs.')
    public static void GetAdviserID(List<Adviser__c> AdviserIds)
    {
        
        string advID= AdviserIds[0].Id;
        string salesstatus = AdviserIds[0].Sales_Status__c;
        if(salesstatus == 'Inventory Scheduled')
        {
            list <Task> T =[Select ID , Status, ActivityDate from Task where WhatId = :advID and Subject ='Inventory Call' order by ActivityDate Desc limit 1 ];
            DateTime Inventory = AdviserIds[0].Inventory_Date__c;
            if(!T.isEmpty())
            {
                T[0].ActivityDate = Inventory.date();
                T[0].ReminderDateTime = Inventory;
                Update  T[0]; 
            }
            List <Task> T2 =[Select ID , Status, ActivityDate from Task where WhatId = :advID and Subject ='Homework Followup Call' order by ActivityDate Desc limit 1];
            if(!T2.isEmpty())
            {
                T2[0].ActivityDate = Inventory.date() - 2;
                Update T2[0];
            }
        }
    }
}