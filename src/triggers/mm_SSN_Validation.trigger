trigger mm_SSN_Validation on Contact (after insert,after update) {
        
        //Loop through all records in the Trigger.new collection -if CON.SSN is not Blank or does not adhere to SSN formatting - we want to throw an error.
        for(Contact contact: Trigger.new){
            
            if(!String.isBlank(contact.Social_Security_Number__c))
            {  
                String SSNRegex = '[0-9]{9}'; 
                Pattern MyPattern = Pattern.compile(SSNRegex);
                Matcher MyMatcher = MyPattern.matcher(contact.Social_Security_Number__c);
                
                if (!MyMatcher.matches()) 
                {
                    contact.addError('Please enter the 9-digit SSN with no dashes.'); 
                }
                
            }
            
        }
    
}