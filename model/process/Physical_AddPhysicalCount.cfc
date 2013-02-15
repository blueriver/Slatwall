component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="physical";

	// Data Properties
	property name="locationID" hb_formFieldType="select";
	property name="countPostDateTime";
	property name="countFile";
	
	public array function getLocationIDOptions() {
		return getService("locationService").getLocationOptions();
	}
	
}