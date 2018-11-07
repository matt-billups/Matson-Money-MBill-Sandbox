public abstract class mm_TriggerHandler {

    public virtual void execute() {
        if(Trigger.isBefore) {
            if(Trigger.isInsert)
                beforeInsert();
            else if(Trigger.isUpdate)
                beforeUpdate();
            else if(Trigger.isDelete)
                beforeDelete();
        }
        else if(Trigger.isAfter) {
            if(Trigger.isInsert)
                afterInsert();
            else if(Trigger.isUpdate)
                afterUpdate();
            else if(Trigger.isDelete)
                afterDelete();
        }
    }
    
    public virtual void beforeInsert() {      
    }
    
    public virtual void beforeUpdate() {      
    }

    public virtual void beforeDelete() {      
    }

    public virtual void afterInsert() {      
    }
    
    public virtual void afterUpdate() {      
    }

    public virtual void afterDelete() {      
    }

}