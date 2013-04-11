component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="vendorOrder";
	
	// Data Properties
	property name="locationID" hb_formFieldType="select" hb_rbKey="entity.location";
	property name="vendorOrderID";
	property name="packingSlipNumber";
	property name="boxCount";
	
	public any function getLocationIDOptions() {
		if(!structKeyExists(variables, "locationIDOptions")) {
			sl = getService("locationService").getLocationSmartList();
			sl.addSelect('locationName', 'name');
			sl.addSelect('locationID', 'value');
			variables.locationIDOptions = sl.getRecords();
		}
		return variables.locationIDOptions;
	}
	
}