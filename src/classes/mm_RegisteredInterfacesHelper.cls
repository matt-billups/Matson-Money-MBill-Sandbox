/**
 * @author Brian K. Broughton (brian.broughton@pinnsg.com)
 * @version 1.0.0
 * @description Helper class for the Registered Interface custom metadata type.
 *
 *
 **/ 
public class mm_RegisteredInterfacesHelper {

	
	public static Registered_Interface__mdt getRegisteredInterface(string interfaceName) {
		Registered_Interface__mdt registeredInterface = null;

		List<Registered_Interface__mdt> registeredInterfaces = [select DeveloperName, Class_Name__c from Registered_Interface__mdt WHERE DeveloperName  =: interfaceName limit 1];

		if (registeredInterfaces.size() > 0) registeredInterface = registeredInterfaces.get(0);

		return registeredInterface;		
	}

	public static String getTypeName(string interfaceName) {

		String typeName;

		Registered_Interface__mdt registeredInterface = getRegisteredInterface(interfaceName);

		if (registeredInterface != null)
			typeName = registeredInterface.Class_Name__c;

		return typeName;		
	}
}