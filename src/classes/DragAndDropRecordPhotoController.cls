public with sharing class DragAndDropRecordPhotoController {
    
    @AuraEnabled
    public static Attachment getAdviserProfilePicture(Id parentId) {
        
        List<Attachment> attachments = [SELECT Id, Name, LastModifiedDate, ContentType FROM Attachment 
                                        WHERE ParentId =: parentId AND ContentType IN ('image/png', 'image/jpeg', 'image/gif') 
                                        ORDER BY LastModifiedDate DESC];
        if(!attachments.isEmpty()) {
            return attachments[0];
        }
        else {
            return null;
        }
        
    }
    
    @AuraEnabled
    public static Id saveAttachment(Id parentId, String fileName, String base64Data, String contentType) {
        deleteAttachment(parentId);        
        Attachment attachment = new Attachment();
        attachment.ParentId = parentId;
        attachment.Body = EncodingUtil.base64Decode(base64Data);
        attachment.Name = fileName;
        attachment.ContentType = contentType;
        insert attachment;
        return attachment.Id;   
    }
    
    @AuraEnabled
    public static Boolean deleteAttachment(Id parentId) {
        
        Boolean deleted = false;
        List<Attachment> attachments = [SELECT Id, Name, LastModifiedDate, ContentType FROM Attachment 
                                        WHERE ParentId =: parentId AND ContentType IN ('image/png', 'image/jpeg', 'image/gif') 
                                        ORDER BY LastModifiedDate DESC];
        if(!attachments.isEmpty()) {
            deleted = true;
            delete attachments[0];
        }
        return deleted;
    }
    
    @AuraEnabled
    public static Boolean checkUserPermission(Id parentId) {
               
        Schema.SObjectType convertType = parentId.getSobjectType();
        Schema.DescribeSObjectResult drSObj = convertType.getDescribe();
        
        // Edit permission on parent object (Adviser__c) is required to add attachments
        if (!drSObj.isUpdateable()) {
           return false;
        }
        else {
            return true;
        }
        
    }   
    
}