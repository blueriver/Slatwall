component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="order";
	
	// Injected From Smart List
	property name="sku";

	// Data Properties
	property name="skuID";
	property name="price";
	property name="quantity";
	property name="orderFulfillmentID" hb_formFieldType="select";
	property name="fulfillmentMethodID" hb_formFieldType="select";
	property name="shippingAccountAddressID" hb_formFieldType="select";
	property name="shippingAddress" cfc="Address" fieldType="many-to-one" persistent="false" fkcolumn="addressID" hb_populateValidationContext="full";
	property name="saveShippingAccountAddressFlag" hb_formFieldType="yesno";
	property name="saveShippingAccountAddressName";
	property name="assignedOrderItemAttributeSets";
	
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
			arrayAppend(variables.orderFulfillmentIDOptions, {name=getHibachiScope().rbKey('define.new'), value="new"});
		}
		return variables.orderFulfillmentIDOptions;
	}
	
	public array function getFulfillmentMethodIDOptions() {
		if(!structKeyExists(variables, "fulfillmentMethodIDOptions")) {
			
			var sl = getService("fulfillmentService").getFulfillmentMethodSmartList();
			sl.addFilter('activeFlag', 1);
			if(!isNull(getSkuID()) && !isNull(getSku())) {
				sl.addInFilter('fulfillmentMethodID', getSku().setting('skuEligibleFulfillmentMethods'));
			}
			sl.addSelect('fulfillmentMethodName', 'name');
			sl.addSelect('fulfillmentMethodID', 'value');
			sl.addSelect('fulfillmentMethodType', 'fulfillmentMethodType');
			
			variables.fulfillmentMethodIDOptions = sl.getRecords();
		}
		return variables.fulfillmentMethodIDOptions;
	}
	
	public array function getShippingAccountAddressIDOptions() {
		if(!structKeyExists(variables, "shippingAccountAddressIDOptions")) {
			variables.shippingAccountAddressIDOptions = [];
			var s = getService("accountService").getAccountAddressSmartList();
			s.addFilter(propertyIdentifier="account.accountID",value=getOrder().getAccount().getAccountID());
			s.addOrder("accountAddressName|ASC");
			var r = s.getRecords();
			for(var i=1; i<=arrayLen(r); i++) {
				arrayAppend(variables.shippingAccountAddressIDOptions, {name=r[i].getSimpleRepresentation(), value=r[i].getAccountAddressID()});	
			}
			arrayAppend(variables.shippingAccountAddressIDOptions, {name=getHibachiScope().rbKey('define.new'), value="new"});
		}
		return variables.shippingAccountAddressIDOptions;
	}
	
	public any function getShippingAddress() {
		if(!structKeyExists(variables, "shippingAddress")) {
			variables.shippingAddress = getService("addressService").newAddress();
		}
		return variables.shippingAddress;
	}
	
	public any function getSaveShippingAccountAddressFlag() {
		if(!structKeyExists(variables, "saveShippingAccountAddressFlag")) {
			variables.saveShippingAccountAddressFlag = 1;
		}
		variables.saveShippingAccountAddressFlag;
	}
	
	public any function getAssignedOrderItemAttributeSets() {
		if(!isNull(getSkuID()) && !isNull(getSku())) {
			return getSku().getAssignedOrderItemAttributeSetSmartList().getRecords();	
		}
		
		return [];
	}
	
}