public with sharing  class mm_publicEmailOptOut {
	
    @AuraEnabled
    public static boolean emailOptOut(string email)
    {
        system.debug(email);
        List<contact> c =[ Select id, HasOptedOutOfEmail from Contact where Email = : email];
         
        Boolean emailOptedOut = true;
        if(c.isEmpty())
        {
           emailOptedOut = false;
        }
        else
        {
           for( contact i : c)
           {
               i.HasOptedOutOfEmail = true;
               update i;
               system.debug('in for loop '+ i.id);
           }
           emailOptedOut = true;
        }
        
        return emailOptedOut;
    }
}