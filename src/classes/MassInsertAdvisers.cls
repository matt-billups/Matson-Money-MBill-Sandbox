public class MassInsertAdvisers {
    
    private static List<string> firstNames = new List<string> {'Liam', 'Emma', 'Noah', 'Ava', 'Carter', 'Olivia', 'William', 'Charlotte', 'Mason', 'Harper', 'Owen', 'Sophia', 'Benjamin', 'Evelyn', 'Jackson', 'Amelia', 'Oliver', 'Isabella', 'Elijah', 'Avery',
                                                            'James', 'Abigail', 'Lucas', 'Elizabeth', 'Michael', 'Nora', 'Wyatt', 'Mia', 'Grayson', 'Madison', 'Henry', 'Lillian', 'Lincoln', 'Ella', 'Alexander', 'Scarlett', 'Jacob', 'Emily', 'Joseph', 'Riley',
                                                            'Ethan', 'Grace', 'Logan', 'Addison', 'Aiden', 'Brooklyn', 'Gabriel', 'Aubrey', 'Jaxon', 'Layla', 'Levi', 'Hannah', 'Samuel', 'Paisley', 'Andrew', 'Claire', 'John', 'Aria', 'Jack', 'Ellie',
                                                            'Luke', 'Chloe', 'Hunter', 'Zoey', 'Landon', 'Lily', 'Connor', 'Eleanor', 'Cameron', 'Stella', 'Anthony', 'Kennedy', 'Colton', 'Penelope', 'Charles', 'Lucy', 'Matthew', 'Savannah', 'Caleb',
                                                            'Natalie', 'Carson', 'Audrey', 'Daniel', 'Lydia', 'Isaac', 'Quinn', 'Hudson', 'Skylar', 'Isaiah', 'Anna', 'David', 'Gabriella', 'Jaxson', 'Madelyn', 'Eli', 'Cora', 'Nolan', 'Nevaeh', 'Brayden',
                                                            'Aubree', 'Cooper', 'Violet', 'Christopher', 'Piper', 'Thomas', 'Peyton', 'Parker', 'Willow', 'Joshua', 'Caroline', 'Robert', 'Leah', 'Dominic', 'Reagan', 'Bentley', 'Autumn', 'Braxton', 'Hazel',
                                                            'Jayden', 'Aurora', 'Bryson', 'Kinsley', 'Ryan', 'Mackenzie', 'Easton', 'Adalynn', 'Gavin', 'Clara', 'Jace', 'Mila', 'Evan', 'Serenity', 'Leo', 'Raelynn', 'Josiah', 'Adeline', 'Chase', 'Allison',
                                                            'Greyson', 'Annabelle', 'Austin', 'Kaylee', 'Nathan', 'Rylee', 'Adam', 'Eva', 'Theodore', 'Bailey', 'Weston', 'Vivian', 'Dylan', 'Ruby', 'Jordan', 'Aaliyah', 'Jeremiah', 'Josephine', 'Jonathan',
                                                            'Naomi', 'Asher', 'Sadie', 'Christian', 'Victoria', 'Camden', 'Samantha', 'Brantley', 'Taylor', 'Julian', 'Hadley', 'Maxwell', 'Nova', 'Sebastian', 'Brielle', 'Xavier', 'Faith', 'Everett', 'Ariana',
                                                            'Nicholas', 'Alaina', 'Sawyer', 'Zoe', 'Zachary', 'Kylie', 'Roman', 'Payton', 'Declan', 'Bella', 'Vincent', 'Ivy', 'Tyler', 'Mya', 'Blake', 'Hailey', 'Miles', 'Sofia', 'Ezekiel', 'Gianna', 'Harrison', 'Morgan', 'Grant', 'Julia'};
                                                            
    private static List<string> lastNames = new List<string> {'Smith', 'Johnson', 'Williams', 'Jones', 'Brown', 'Davis', 'Miller', 'Wilson', 'Moore', 'Taylor', 'Anderson', 'Thomas', 'Jackson', 'White', 'Harris', 'Martin', 'Thompson', 'Garcia', 'Martinez', 'Robinson',
                                                            'Clark', 'Rodriguez', 'Lewis', 'Lee', 'Walker', 'Hall', 'Allen', 'Young', 'Hernandez', 'King', 'Wright', 'Lopez', 'Hill', 'Scott', 'Green', 'Adams', 'Baker', 'Gonzalez', 'Nelson', 'Carter', 'Mitchell', 'Perez',
                                                            'Roberts', 'Turner', 'Phillips', 'Campbell', 'Parker', 'Evans', 'Edwards', 'Collins', 'Stewart', 'Sanchez', 'Morris', 'Rogers', 'Reed', 'Cook', 'Morgan', 'Bell', 'Murphy', 'Bailey', 'Rivera', 'Cooper', 'Richardson',
                                                            'Cox', 'Howard', 'Ward', 'Torres', 'Peterson', 'Gray', 'Ramirez', 'James', 'Watson', 'Brooks', 'Kelly', 'Sanders', 'Price', 'Bennett', 'Wood', 'Barnes', 'Ross', 'Henderson', 'Coleman', 'Jenkins', 'Perry', 'Powell',
                                                            'Long', 'Patterson', 'Hughes', 'Flores', 'Washington', 'Butler', 'Simmons', 'Foster', 'Gonzales', 'Bryant', 'Alexander', 'Russell', 'Griffin', 'Diaz', 'Hayes', 'Myers', 'Ford', 'Hamilton', 'Graham', 'Sullivan',
                                                            'Wallace', 'Woods', 'Cole', 'West', 'Jordan', 'Owens', 'Reynolds', 'Fisher', 'Ellis', 'Harrison', 'Gibson', 'Mcdonald', 'Cruz', 'Marshall', 'Ortiz', 'Gomez', 'Murray', 'Freeman', 'Wells', 'Webb', 'Simpson', 'Stevens',
                                                            'Tucker', 'Porter', 'Hunter', 'Hicks', 'Crawford', 'Henry', 'Boyd', 'Mason', 'Morales', 'Kennedy', 'Warren', 'Dixon', 'Ramos', 'Reyes', 'Burns', 'Gordon', 'Shaw', 'Holmes', 'Rice', 'Robertson', 'Hunt', 'Black',
                                                            'Daniels', 'Palmer', 'Mills', 'Nichols', 'Grant', 'Knight', 'Ferguson', 'Rose', 'Stone', 'Hawkins', 'Dunn', 'Perkins', 'Hudson', 'Spencer', 'Gardner', 'Stephens', 'Payne', 'Pierce', 'Berry', 'Matthews', 'Arnold',
                                                            'Wagner', 'Willis', 'Ray', 'Watkins', 'Olson', 'Carroll', 'Duncan', 'Snyder', 'Hart', 'Cunningham', 'Bradley', 'Lane', 'Andrews', 'Ruiz', 'Harper', 'Fox', 'Riley', 'Armstrong', 'Carpenter', 'Weaver', 'Greene',
                                                            'Lawrence', 'Elliott', 'Chavez', 'Sims', 'Austin', 'Peters', 'Kelley', 'Franklin', 'Lawson'};
    
    public static void generateData(Integer numProspects, Integer numNonProspects) {
        
        List<Contact> contacts = insertContacts(numProspects + numNonProspects);
        insertAdvisers(contacts, numProspects);
    }
    
    private static List<Contact> insertContacts(Integer numToCreate) {
        
        List<Integer> firstNameRands = getRandomNumberList(numToCreate, firstNames.size()-1);
        List<Integer> lastNameRands = getRandomNumberList(numToCreate, lastNames.size()-1);
        
        List<Contact> contactsToInsert = new List<Contact>();
        
        for (Integer i = 0; i < numToCreate; i++) {
            string first = firstNames[firstNameRands[i]];
            string last = lastNames[lastNameRands[i]];
            
            Contact con = new Contact();
            con.FirstName = first;
            con.LastName = last;
            con.Email = 'Tanya.Dadosky@matsonmoney.com'; //first + '.' + last + '@example.com';
            con.MailingStreet = '5955 Deerfield Blvd';
            con.MailingCity = 'Mason';
            con.MailingState = 'Ohio';
            con.MailingPostalCode = '45040';
            
            contactsToInsert.add(con);
        }
        
        insert contactsToInsert;
        
        return contactsToInsert;
    }
    
    private static void insertAdvisers(List<Contact> contacts, Integer numProspects) {
        
        Profile adviserCoachProfile = [SELECT Id FROM Profile WHERE Name = 'Sales'];
        User adviserCoach = [SELECT Id FROM User WHERE ProfileId =: adviserCoachProfile.Id LIMIT 1];
        
        // Prep adviser record types to get both prospects and non-prospects
        List<RecordType> adviserRecordTypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Adviser__c'];
        Map<String, Id> recordTypeIdMap = new Map<String, Id>();
        for (RecordType recType : adviserRecordTypes) {
            recordTypeIdMap.put(recType.Name, recType.Id);
        }
        
        // Create advisers
        List<Adviser__c> advisersToInsert = new List<Adviser__c>();
        
        Integer counter = 0;
        for (Contact con : contacts) {
            Adviser__c adv = new Adviser__c();
            adv.Primary_Contact__c = con.Id;
            adv.Service_Team__c = '1';
            adv.Designation__c = 'RIA';
            adv.Adviser_Coach__c = adviserCoach.Id;
            adv.Firm_ID__c = '1234567';
            
            if (counter < numProspects) {
                adv.Status__c = 'Active Prospect';
                adv.RecordTypeId = recordTypeIdMap.get('Adviser Prospect');
            } else {
                adv.Status__c = 'Active Adviser';
                adv.RecordTypeId = recordTypeIdMap.get('Adviser');
            }
            
            advisersToInsert.add(adv);
            counter++;
        }
        
        insert advisersToInsert;
    }
    
    private static List<Integer> getRandomNumberList(Integer numberOfRands, Integer upperLimit) {
        
        List<Integer> randomNumberList = new List<Integer>();
        
        for (Integer i = 0; i < numberOfRands; i++) {
            randomNumberList.add(Math.mod(Math.round(Math.random()*1000), upperLimit));
        }
        
        return randomNumberList;
    }
}