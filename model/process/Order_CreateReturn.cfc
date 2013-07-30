component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="order";
	
	// Data Properties
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	property name="orderItems" type="array" hb_populateArray="true";
	
	property name="fulfillmentRefundAmount";
	
	variables.orderItems = [];
	
	public array function getLocationOptions() {
		if(!structKeyExists(variables, "locationOptions")) {
			variables.locationOptions = getService('locationService').getLocationOptions(); 
		}
		return variables.locationOptions;
	}
	
	public numeric function getFulfillmentRefundAmount() {
		if(!structKeyExists(variables, "fulfillmentRefundAmount")) {
			variables.fulfillmentRefundAmount = 0;
			if(!getPreProcessDisplayedFlag()) {
				variables.fulfillmentRefundAmount = getOrder().getFulfillmentChargeAfterDiscountTotal();	
			}
		}
		return variables.fulfillmentRefundAmount;
	}
	
}