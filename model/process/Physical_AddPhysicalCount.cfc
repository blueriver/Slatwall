component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="physical";

	// Data Properties
	property name="locationID" hb_formFieldType="select";
	property name="countPostDateTime" hb_formFieldType="datetime";
	property name="countFile" hb_formFieldType="file";
	
	// Chached Properties
	property name="locationIDOptions";
	
	public array function getLocationIDOptions() {
		if(!structKeyExists(variables, "locationIDOptions")) {
			variables.locationIDOptions = [];
			var physicalLocations = getPhysical().getLocations();
			for(var i=1; i<=arrayLen(physicalLocations); i++) {
				arrayAppend(variables.locationIDOptions, {name=physicalLocations[i].getLocationName(), value=physicalLocations[i].getLocationID()});
			}
		}
		
		return variables.locationIDOptions;
	}
	
}