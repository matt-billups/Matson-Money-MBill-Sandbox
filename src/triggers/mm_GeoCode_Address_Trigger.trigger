trigger mm_GeoCode_Address_Trigger on GeoCode_Address__e (after insert) {
    
    for(GeoCode_Address__e geoCodeAddress : Trigger.new)
    {
        mm_GeoCodingUtil.geoCodeAddress(geoCodeAddress.SObject_ID__c, geoCodeAddress.SObject_Name__c, geoCodeAddress.Address__c, geoCodeAddress.Geo_Location_Field_Name__c);
    }
}