trigger addAccountOnCreateContact on Contact (before insert) {
    
    Account account = new Account();
	List<Account> accts = [SELECT Id, Name FROM Account WHERE Name = 'Matson Money Default' LIMIT 1];
    
    if (accts.size() < 1) {
        account.Name = 'Matson Money Default';
        insert account;
    }
    else {
        account = accts[0];
    }
    
    for (Contact c : Trigger.new){
        c.AccountId = account.Id;
    }
}