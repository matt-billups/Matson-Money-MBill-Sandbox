global class mm_GeoCodingUtil {
    
    // We need a future method to call Google Geocoding API from Salesforce
    @future (callout = true)
    public static void geocodeAddress(id objectId, String sObjectName, String objectAddress, String geoLocationFieldName)
    {
        // Key for Google Maps Geocoding API
        String geocodingKey = 'AIzaSyDJwCwFkzvu6yoJCWhIoknyCMELkuDT-z0';
        
        // Create a string for the address to pass to Google Geocoding API
        String geoAddress = objectAddress;
        
        // Encode the string so we can pass it as part of URL
        geoAddress = EncodingUtil.urlEncode(geoAddress, 'UTF-8');
        
        // Build and make the callout to the Geocoding API
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address=' + geoAddress + '&key=' + geocodingKey + '&sensor=false');
        request.setMethod('GET');
        request.setTimeout(60000);
        
        try
        {
            // Make the http callout
            HttpResponse response = http.send(request);
            
            // Parse JSON to extract coordinates
            JSONParser responseParser = JSON.createParser(response.getBody());
            
            // Initialize coordinates
            double latitude = null;
            double longitude = null;
            
            while(responseParser.nextToken() != null)
            {    
                if ((responseParser.getCurrentToken() == JSONToken.FIELD_NAME) && (responseParser.getText() == 'location'))
                {
                    responseParser.nextToken();
                    
                    while(responseParser.nextToken() != JSONToken.END_OBJECT)
                    { 
                        String locationText = responseParser.getText();
                        responseParser.nextToken();
                        
                        if (locationText == 'lat')
                        {
                            latitude = responseParser.getDoubleValue();
                        }
                        else if (locationText == 'lng')
                        {
                            longitude = responseParser.getDoubleValue();
                        }
                    }
                }
            }
            
            // First construct fields to be used in the query - get lat and long field name
            String sObjectGeocodeLatitudeFieldName = geoLocationFieldName.substringBeforeLast('c') + 'Latitude__s';
            String sObjectGeocodeLongitudeFieldName = geoLocationFieldName.substringBeforeLast('c') + 'Longitude__s';
            
            // Construct query
            String queryStrLimit1 = 'SELECT Id, ' + sObjectGeocodeLatitudeFieldName + ', ' + sObjectGeocodeLongitudeFieldName + ' FROM ' + sObjectName + ' WHERE Id =: objectId';
            sObject s = Database.query(queryStrLimit1);
            
            // Update sObject
            s.put(sObjectGeocodeLatitudeFieldName, latitude);
            s.put(sObjectGeocodeLongitudeFieldName, longitude);
            update s;
        }
        catch (Exception e)
        {
            System.debug(LoggingLevel.ERROR, 'Error Geocoding Address - ' + e.getMessage() + '  (' + e.getLineNumber() + ')');
        }
    }
}