trigger mm_Client_Primary_Contact on Investor__c (after update, after insert) {
    List<Id> InvestorClientIdList = new List<id>();
    for(Investor__c inv : Trigger.new){
        
        InvestorClientIdList.add(inv.ClientId__c);
    }
    Client__c cli = [SELECT id, Primary_Investor_Contact__c FROM Client__c WHERE id in :InvestorClientIdList];
    for (Investor__c inv: Trigger.new){
        //system.debug('loop');
        //Client__c cli = [SELECT id, Primary_Investor_Contact__c FROM Client__c WHERE id=: inv.ClientId__c];
        
        if (inv.Is_Primary_Contact__c == True && cli.Primary_Investor_Contact__c == null){
            cli.Primary_Investor_Contact__c = inv.Id;
        }
        else if (inv.Is_Primary_Contact__c == False && cli.Primary_Investor_Contact__c == inv.Id){
            cli.Primary_Investor_Contact__c = null;
        }
        
        
        
    }
    update cli;
}