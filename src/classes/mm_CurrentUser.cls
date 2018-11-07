public class mm_CurrentUser {
    
    static Set<String> serviceUserProfiles = new Set<String> {'Service Super User', 'Service User'};
    
    public static Boolean isServiceUser {
        get {
            String profileName = '';
            Profile profile = [Select Name from Profile where Id =: userinfo.getProfileid()];
			
            if (profile != null) {
            	profileName = profile.name;    
            }
            
            return serviceUserProfiles.contains(profileName);
        }
    }
    
    public static String Name {
        get {
            return userinfo.getName();
        }
    }
}