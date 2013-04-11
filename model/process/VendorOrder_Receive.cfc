component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="vendorOrder";
	
	// Data Properties
	property name="stockReceiverTypeID";
	property name="locationID" hb_formFieldType="select" hb_rbKey="entity.location";
	property name="vendorOrderID";
	property name="packingSlipNumber";
	property name="boxCount";
	property name="vendorOrderItems" cfc="VendorOrderItem" fieldtype="one-to-many";
	
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