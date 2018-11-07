trigger mm_isPrimaryContact on Investor__c (before update, before insert) {
    
    //Investor__c iv = [select ClientId__c, Is_Primary_Contact__c from Investor__c where id in:trigger.new];
    /*system.debug(trigger.new[0].ClientId__c);
    system.debug(trigger.new[0].Is_Primary_Contact__c);
    
    boolean alreadyPrimary = false;
    string primaryContactName = '';
    
    if (trigger.new[0].Is_Primary_Contact__c == true)
    {
        List<Investor__c> ivl = [select Is_Primary_Contact__c, id, First_Name__c, Last_Name__c from Investor__c where ClientId__c =:trigger.new[0].ClientId__c and id !=: trigger.new[0].id];
        
        if (!ivl.isEmpty() )
        {
            for (Investor__c i: ivl)
            {
                system.debug('made it' + i);
                if (i.Is_Primary_Contact__c == true)
                {
                    alreadyPrimary = true;
                    primaryContactName = i.First_Name__c + ' ' + i.Last_Name__c;
                    break;
                }
            }
        }
        
        if (alreadyPrimary == true)
        {
            trigger.new[0].addError('There is already a primary contact for this client. The primary contact is: ' + primaryContactName);
        }
    }*/
}