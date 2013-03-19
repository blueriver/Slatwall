component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="order";
	
	// Injected From Smart List
	property name="sku";

	// Data Properties
	property name="skuID";
	property name="orderFulfillmentID" hb_formFieldType="select";
	property name="quantity";
	property name="misc";
	
	public any function init() {
		return super.init();
	}
	
	public any function getSku() {
		if(!structKeyExists(variables, "sku")) {
			variables.sku = getService("skuService").getSku(getSkuID());
		}
		return variables.sku;
	}
	
	public any function getQuantity() {
		if(!structKeyExists(variables, "quantity")) {
			variables.quantity = 1;
		}
		return variables.quantity;
	}
	
	public array function getOrderFulfillmentIDOptions() {
		if(!structKeyExists(variables, "orderFulfillmentIDOptions")) {
			var ofArr = getOrder().getOrderFulfillments();
			variables.orderFulfillmentIDOptions = [];
			for(var i=1; i<=arrayLen(ofArr); i++) {
				if(listFindNoCase(ofArr[i].getFulfillmentMethod().getFulfillmentMethodID(), getSku().setting('skuEligibleFulfillmentMethods'))) {
					arrayAppend(variables.orderFulfillmentIDOptions, {name=ofArr[i].getSimpleRepresentation(), value=ofArr[i].getOrderFulfillmentID()});	
				}
			}
			arrayAppend(variables.orderFulfillmentIDOptions, {name=getHibachiScope().rbKey('define.new'), value=""});
		}
		return variables.orderFulfillmentIDOptions;
	}
	
	public string function getOrderFulfillmentID() {
		if(!structKeyExists(variables, "orderFulfillmentID")) {
			variables.orderFulfillmentID = getOrderFulfillmentIDOptions()[1]["value"];
		}
		return variables.orderFulfillmentID;
	}
}