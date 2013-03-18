component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="order";

	// Data Properties
	property name="skuID";
	property name="orderFulfillmentID" hb_formFieldType="select";
	property name="quantity";
	
	public any function getQuantity() {
		if(!structKeyExists(variables, "quantity")) {
			variables.quantity = 1;
		}
		return variables.quantity;
	}
	
	public any function getOrderFulfillmentIDOptions() {
		if(!structKeyExists(variables, "orderFulfillmentIDOptions")) {
			variables.orderFulfillmentIDOptions = [];
			var ofArr = getOrder().getOrderFulfillments();
			for(var i=1; i<=arrayLen(ofArr); i++) {
				arrayAppend(variables.orderFulfillmentIDOptions, {name=ofArr[i].getSimpleRepresentation(), value=ofArr[i].getOrderFulfillmentID()});
			}
		}
		return variables.orderFulfillmentIDOptions;
	}
}