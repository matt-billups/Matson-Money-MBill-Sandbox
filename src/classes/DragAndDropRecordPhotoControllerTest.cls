@isTest(SeeAllData=true) private class DragAndDropRecordPhotoControllerTest {
    
    @isTest static void testdeleteAttachmentFalse() {
        // Input: Id parentId
        // Returns: false
        
        Contact c = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'test.contact@example.com', MobilePhone = '5135550123', MailingStreet = '165 W McMillan St',
                                MailingCity = 'Cincinnati', MailingState = 'Ohio', MailingPostalCode = '45219');
        insert c;
        Adviser__c a = new Adviser__c(Primary_Contact__c = c.Id, Status__c = 'Active Prospect');
        insert a;
        
        System.assertEquals(false, DragAndDropRecordPhotoController.deleteAttachment(a.id));
    }
    
    @isTest static void testdeleteAttachmentTrue() {
        // Input: Id parentId
        // Returns: true
        
        Contact c = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'test.contact@example.com', MobilePhone = '5135550123', MailingStreet = '165 W McMillan St',
                                MailingCity = 'Cincinnati', MailingState = 'Ohio', MailingPostalCode = '45219');
        insert c;
        Adviser__c a = new Adviser__c(Primary_Contact__c = c.Id, Status__c = 'Active Prospect');
        insert a;
        StaticResource bearcats = [SELECT Id, Name, Body, ContentType FROM StaticResource WHERE Name = 'Bearcats'];
        
        String body = EncodingUtil.base64Encode(bearcats.Body);
        Id attachmentId = DragAndDropRecordPhotoController.saveAttachment(a.Id, bearcats.Name, body, bearcats.ContentType);
        
        System.assertEquals(true, DragAndDropRecordPhotoController.deleteAttachment(a.id));
    }
    
    @isTest static void testsaveAttachment() {
        // Input: Id parentId, String fileName, String base64Data, String contentType
        // Returns: Attachment.Id
        
        Contact c = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'test.contact@example.com', MobilePhone = '5135550123', MailingStreet = '165 W McMillan St',
                                MailingCity = 'Cincinnati', MailingState = 'Ohio', MailingPostalCode = '45219');
        insert c;
        Adviser__c a = new Adviser__c(Primary_Contact__c = c.Id, Status__c = 'Active Prospect');
        insert a;
        StaticResource bearcats = [SELECT Id, Name, Body, ContentType FROM StaticResource WHERE Name = 'Bearcats'];
        
        String body = EncodingUtil.base64Encode(bearcats.Body);
        Id attachmentId = DragAndDropRecordPhotoController.saveAttachment(a.Id, bearcats.Name, body, bearcats.ContentType);
        
        Attachment attachment = [SELECT Id, Body FROM Attachment WHERE Id =: attachmentId];
        System.assertEquals(bearcats.Body, attachment.Body);
    }
    
    
    @isTest static void testgetAdviserProfilePicture() {
        // Input: Id parentId
        // Returns: Attachment
        
        Contact c = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'test.contact@example.com', MobilePhone = '5135550123', MailingStreet = '165 W McMillan St',
                                MailingCity = 'Cincinnati', MailingState = 'Ohio', MailingPostalCode = '45219');
        insert c;
        Adviser__c a = new Adviser__c(Primary_Contact__c = c.Id, Status__c = 'Active Prospect');
        insert a;
        StaticResource bearcats = [SELECT Id, Name, Body, ContentType FROM StaticResource WHERE Name = 'Bearcats'];
        
        String body = EncodingUtil.base64Encode(bearcats.Body);
        Id attachmentId = DragAndDropRecordPhotoController.saveAttachment(a.Id, bearcats.Name, body, bearcats.ContentType);
        
        Attachment attachment = DragAndDropRecordPhotoController.getAdviserProfilePicture(a.Id);
        
        System.assertEquals(attachmentId, attachment.Id);
    }
    
    @isTest static void testgetAdviserProfilePictureNull() {
        // Input: Id parentId
        // Returns: Attachment
        
        Contact c = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'test.contact@example.com', MobilePhone = '5135550123', MailingStreet = '165 W McMillan St',
                                MailingCity = 'Cincinnati', MailingState = 'Ohio', MailingPostalCode = '45219');
        insert c;
        Adviser__c a = new Adviser__c(Primary_Contact__c = c.Id, Status__c = 'Active Prospect');
        insert a;
        
        Attachment attachment = DragAndDropRecordPhotoController.getAdviserProfilePicture(a.Id);
        
        System.assertEquals(null, attachment);
    }
    
    @isTest static void testcheckUserPermissionFalse() {
        // Input: 
        // Returns: false
        
        Boolean editPerm;
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@example.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='standarduserProd@example.com');
        
        Contact c = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'test.contact@example.com', MobilePhone = '5135550123', MailingStreet = '165 W McMillan St',
                                MailingCity = 'Cincinnati', MailingState = 'Ohio', MailingPostalCode = '45219');
        insert c;
        
        Adviser__c a = new Adviser__c(Primary_Contact__c = c.Id, Status__c = 'Active Prospect');
        insert a;
        System.runAs(u) {
            editPerm = DragAndDropRecordPhotoController.checkUserPermission(a.id);
        }
        
        System.assertEquals(false, editPerm);
    }
    
    @isTest static void testcheckUserPermissionTrue() {
        // Input: 
        // Returns: true
        
        Boolean editPerm;
        
        Contact c = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'test.contact@example.com', MobilePhone = '5135550123', MailingStreet = '165 W McMillan St',
                                MailingCity = 'Cincinnati', MailingState = 'Ohio', MailingPostalCode = '45219');
        insert c;
                Adviser__c a = new Adviser__c(Primary_Contact__c = c.Id, Status__c = 'Active Prospect');
        insert a;
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@example.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='standarduserProd@example.com');
        
        System.runAs(u) {
        editPerm = DragAndDropRecordPhotoController.checkUserPermission(a.id);        
        }
        System.assertEquals(true, editPerm);
    }
    
}