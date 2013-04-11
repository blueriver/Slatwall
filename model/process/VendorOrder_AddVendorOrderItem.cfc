component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="vendorOrder";
	
	// Injected From Smart List
	property name="sku";

	// Data Properties
	property name="skuID";
	property name="price";
	property name="cost";
	property name="quantity";
	property name="vendorOrderItemTypeSystemCode";
	property name="deliverToLocationID" hb_formFieldType="select";
	
	public any function init() {
		return super.init();
	}
	
	public any function getSku() {
		if(!structKeyExists(variables, "sku")) {
			variables.sku = getService("skuService").getSku(getSkuID());
		}
		return variables.sku;
	}
	
	public any function getPrice() {
		if(!structKeyExists(variables, "price")) {
			variables.price = 0;
			if(!structKeyExists(variables, "sku")) {
				variables.price = getSku().getPriceByCurrencyCode( getOrder().getCurrencyCode() );
			}
		}
		return variables.price;
	}
	
	public any function getCost() {
		if(!structKeyExists(variables, "cost")) {
			variables.cost = 0;
		}
		return variables.cost;
	}
	
	
	public any function getQuantity() {
		if(!structKeyExists(variables, "quantity")) {
			variables.quantity = 1;
		}
		return variables.quantity;
	}
	
	public any function getVendorOrderItemTypeSystemCode() {
		if(!structKeyExists(variables, "vendorOrderItemTypeSystemCode")) {
			variables.vendorOrderItemTypeSystemCode = "voitPurchase";
		}
		return variables.vendorOrderItemTypeSystemCode;
	}
	
	public any function getDeliverToLocationIDOptions() {
		if(!structKeyExists(variables, "deliveryToLocationIDOptions")) {
			sl = getService("locationService").getLocationSmartList();
			sl.addSelect('locationName', 'name');
			sl.addSelect('locationID', 'value');
			variables.deliveryToLocationIDOptions = sl.getRecords();
		}
		return variables.deliveryToLocationIDOptions;
	}
	
}