/*
 * Purpose: clear out necessary fields when the record type is changed from Secondary to Primary
 * Author: Matt Billups
 * Date: 9/20/18
 */

trigger mm_ClearSecondaryMatsonEventFields on Event__c (before update) {

    //Get the existing record types so we have their Ids and Developer Name
    Map<Id, String> recordTypeMap = new Map<Id, String>();
    for(RecordType rt : [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Primary_Matson_Event' OR DeveloperName = 'Secondary_Matson_Event']){
        recordTypeMap.put(rt.Id, rt.DeveloperName);
    }

    for(Event__c event : Trigger.new){

        //Get value of Event before the update
        Event__c oldEvent = Trigger.oldMap.get(event.Id);

        //Check that the record type was changed
        if(oldEvent.RecordTypeId != event.RecordTypeId){

            //Check what the record type change is from and to
            if(recordTypeMap.get(oldEvent.RecordTypeId) == 'Secondary_Matson_Event' && recordTypeMap.get(event.RecordTypeId) == 'Primary_Matson_Event'){
                event.Primary_Matson_Event__c = NULL;
                event.Secondary_Event_Type__c = NULL;
            }
        }
    }
}