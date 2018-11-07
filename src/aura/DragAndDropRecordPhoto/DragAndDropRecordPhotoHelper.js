({
    checkPermissions: function(component, helper, files) {
        var action = component.get("c.checkUserPermission");
         action.setParams({
            parentId: component.get("v.recordId")
             });
        action.setCallback(this, function(a) {
            var editPerm = a.getReturnValue();
            if (editPerm) {
                helper.readFile(component, helper, files);
            }
            else {
                component.set("v.message", "Insufficient permissions");
                helper.toast(component, helper, "You do not have permission to edit this record.", "error");
            }
        });
        $A.enqueueAction(action); 
    },
    
    readFile: function(component, helper, files) {
        if (files.length>1) {
            helper.toast(component, helper, "You can only upload one picture.", "info");
            return;
        }
        var file = files[0];
        if (!file) return;
        if (!file.type.match(/(image.*)/)) {
            helper.toast(component, helper, "File type not supported.", "info");
            return;
        }
        if (file.size > 750000) {
            helper.toast(component, helper, "File size is too big (suggested size: less than 730 KB).", "info");
            return;
        }
        var reader = new FileReader();
        reader.onloadend = function() {
            var dataURL = reader.result;
            component.set("v.pictureSrc", dataURL);
            helper.upload(component, helper, file, dataURL.match(/,(.*)$/)[1]);
        };
        reader.readAsDataURL(file);
    },
    
    upload: function(component, helper, file, base64Data) {
        var action = component.get("c.saveAttachment");
        action.setParams({
            parentId: component.get("v.recordId"),
            fileName: file.name,
            base64Data: base64Data, 
            contentType: file.type
        });
        action.setCallback(this, function(a) {
            var pic = a.getReturnValue();
            var state = a.getState();
            if (state == "SUCCESS") {
                component.set("v.message", "Image uploaded");
                helper.toast(component, helper, "Image uploaded successfully.", "success");
            }
            else {
                component.set("v.message", "Image not uploaded");
                helper.toast(component, helper, "System error.", "error");
            }
        });
        component.set("v.message", "Uploading...");
        $A.enqueueAction(action); 
    },
    
    toast: function(component, helper, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type": type,
            "duration": 7000
        });
        toastEvent.fire();
    }
    
})