component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="stockAdjustment";
	
	// Injected, or lazily loaded by ID
	property name="sku";
	
	// Data Properties (IDs)
	property name="skuID";
	
	// Data Properties (Inputs)
	property name="quantity";
	
	public numeric function getQuantity() {
		if(!structKeyExists(variables, "quantity")) {
			variables.quantity = 1;
		}
		return variables.quantity;
	}
	
	public any function getSku() {
		if(!structKeyExists(variables, "sku") && !isNull(getSkuID())) {
			variables.sku = getService("skuService").getSku(getSkuID());
		}
		if(structKeyExists(variables, "sku")) {
			return variables.sku;
		}
	}
}