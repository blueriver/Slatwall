component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="order";
	
	// Injected, or lazily loaded by ID
	property name="stock" hb_rbKey="entity.stock";
	property name="sku" hb_rbKey="entity.sku";
	property name="product" hb_rbKey="entity.product";
	property name="location" hb_rbKey="entity.location";
	property name="orderFulfillment" hb_rbKey="entity.orderFulfillment";
	property name="orderReturn" hb_rbKey="entity.orderReturn";
	property name="returnLocation" hb_rbKey="entity.location";
	property name="fulfillmentMethod" hb_rbKey="entity.fulfillmentMethod";
	
	// Data Properties (ID's)
	property name="stockID";
	property name="skuID";
	property name="productID";
	property name="locationID" hb_formFieldType="select" hb_rbKey="entity.location";
	property name="returnLocationID" hb_formFieldType="select" hb_rbKey="entity.orderReturn.returnLocation";
	property name="selectedOptionIDList";
	property name="orderFulfillmentID" hb_formFieldType="select";
	property name="orderReturnID" hb_formFieldType="select" hb_rbKey="entity.orderReturn";
	property name="fulfillmentMethodID" hb_formFieldType="select";
	property name="shippingAccountAddressID" hb_formFieldType="select";
	
	// Data Properties (Inputs)
	property name="price";
	property name="currencyCode";
	property name="quantity";
	property name="orderItemTypeSystemCode";
	property name="saveShippingAccountAddressFlag" hb_formFieldType="yesno";
	property name="saveShippingAccountAddressName";
	property name="fulfillmentRefundAmount" hb_rbKey="entity.orderReturn.fulfillmentRefundAmount";
	
	// Data Properties (Related Populate)
	property name="shippingAddress" cfc="Address" fieldType="many-to-one" persistent="false" fkcolumn="addressID";
	
	
	// Helper property
	property name="assignedOrderItemAttributeSets";
	
	
	// =========================================================
	
	public any function getStock() {
		
		// First we look for a stockID
		if(!structKeyExists(variables, "stock") && !isNull(getStockID())) {
			variables.stock = getService("stockService").getStock( getStockID() );
		}
		
		// Then we look for a sku & location
		if(!structKeyExists(variables, "stock") && !isNull(getSku()) && !isNull(getLocation()) ) {
			variables.stock = getService("stockService").getStockBySkuAndLocation(sku=getSku(), location=getLocation());
		}
		
		// Only if a stock was setup can we return one
		if (structKeyExists(variables, "stock")) {
			return variables.stock;	
		}
		
	}
	
	public any function getSku() {
		
		// First we look for a stockID
		if(!structKeyExists(variables, "sku") && !isNull(getStockID())) {
			var stock = getService("stockService").getStock( getStockID() );
			if(!isNull(stock)) {
				variables.sku = stock.getSku();
			}
		}
		
		// Now we look for a skuID
		if(!structKeyExists(variables, "sku") && !isNull(getSkuID())) {
			variables.sku = getService("skuService").getSku( getSkuID() );
		}
		
		// Then we look for a product & potentiall selected options
		if(!structKeyExists(variables, "sku") && !isNull(getProduct())) {
			
			// By default set this as the "default Sku"
			variables.sku = getProduct().getDefaultSku();
			
			// Then if there was a selected optionID list, we can figure that out
			if(!isNull(getSelectedOptionIDList())) {
				
				var skus = getService("productService").getProductSkusBySelectedOptions(getSelectedOptionIDList(), getProduct().getProductID());
				if(arrayLen(skus) eq 1) {
					variables.sku = skus[1];
				}
			}
		}
		
		// Only if a sku was setup can we return one
		if (structKeyExists(variables, "sku")) {
			return variables.sku;
		}
		
	}
	
	public any function getProduct() {
		
		// First we look to check if a stockID was provided, and if so that superseeds the skuID
		if(!structKeyExists(variables, "product") && !isNull(getStockID())) {
			var stock = getService("stockService").getStock( getStockID() );
			if(!isNull(stock)) {
				variables.product = stock.getSku().getProduct();	
			}
		}
		
		// Now check for a skuID
		if(!structKeyExists(variables, "product") && !isNull(getSkuID())) {
			var sku = getService("skuService").getSku( getSkuID() );
			if(!isNull(sku)) {
				variables.product = sku.getProduct();	
			}
		}
		
		// Lastly we can look for a productID
		if(!structKeyExists(variables, "product") && !isNull(getProductID())) {
			variables.product = getService("productService").getProduct( getProductID() );
		}
		
		// Only if a sku was setup can we return one
		if (structKeyExists(variables, "product")) {
			return variables.product;
		}
		
	}
	
	
	public any function getLocation() {
		
		// First we check for a stockID
		if(!structKeyExists(variables, "location") && !isNull(getStockID()) ) {
			var stock = getService("stockService").getStock( getStockID() );
			if(!isNull(stock)) {
				variables.location = stock.getLocation();
			}
		}
		
		// now we look for a locationID
		if(!structKeyExists(variables, "location") && !isNull(getLocationID())) {
			variables.location = getService("locationService").getLocation(getLocationID());
		}
		
		// If a location now exists, we can return it
		if(structKeyExists(variables, "location")) {
			return variables.location;
		}
	}
	
	public any function getOrderFulfillment() {
		if(!structKeyExists(variables, "orderFulfillment")) {
			variables.orderFulfillment = getService("orderService").getOrderFulfillment(getOrderFulfillmentID());
		}
		if(structKeyExists(variables, "orderFulfillment")) {
			return variables.orderFulfillment;
		}
	}
	
	public any function getOrderReturn() {
		if(!structKeyExists(variables, "orderReturn")) {
			variables.orderReturn = getService("orderService").getOrderReturn(getOrderReturnID());
		}
		if(structKeyExists(variables, "orderReturn")) {
			return variables.orderReturn;
		}
	}
	
	public any function getReturnLocation() {
		if(!structKeyExists(variables, "returnLocation")) {
			variables.returnLocation = getService("locationService").getLocation(getReturnLocationID());
		}
		if(structKeyExists(variables, "returnLocation")) {
			return variables.returnLocation;
		}
	}
	
	public any function getFulfillmentMethod() {
		if(!structKeyExists(variables, "fulfillmentMethod")) {
			variables.fulfillmentMethod = getService("fulfillmentService").getFulfillmentMethod(getFulfillmentMethodID());
		}
		if(structKeyExists(variables, "orderReturn")) {
			return variables.fulfillmentMethod;
		}
	}
	
	// ====================== OPTIONS
	
	public array function getLocationIDOptions() {
		if(!structKeyExists(variables, "locationIDOptions")) {
			variables.locationIDOptions = getService("locationService").getLocationOptions(); 
		}
		return variables.locationIDOptions;
	}
	
	public array function getReturnLocationIDOptions() {
		if(!structKeyExists(variables, "returnLocationIDOptions")) {
			variables.returnLocationIDOptions = getService("locationService").getLocationOptions(); 
		}
		return variables.returnLocationIDOptions;
	}
	
	public array function getOrderFulfillmentIDOptions() {
		if(!structKeyExists(variables, "orderFulfillmentIDOptions")) {
			var ofArr = getOrder().getOrderFulfillments();
			variables.orderFulfillmentIDOptions = [];
			if(!isNull(getSku())) {
				for(var i=1; i<=arrayLen(ofArr); i++) {
					if(listFindNoCase(getSku().setting('skuEligibleFulfillmentMethods'), ofArr[i].getFulfillmentMethod().getFulfillmentMethodID())) {
						arrayAppend(variables.orderFulfillmentIDOptions, {name=ofArr[i].getSimpleRepresentation(), value=ofArr[i].getOrderFulfillmentID()});	
					}
				}	
			}
			arrayAppend(variables.orderFulfillmentIDOptions, {name=getHibachiScope().rbKey('define.new'), value=""});
		}
		return variables.orderFulfillmentIDOptions;
	}
	
	public array function getOrderReturnIDOptions() {
		if(!structKeyExists(variables, "orderReturnIDOptions")) {
			var arr = getOrder().getOrderReturns();
			variables.orderReturnIDOptions = [];
			for(var i=1; i<=arrayLen(arr); i++) {
				arrayAppend(variables.orderReturnIDOptions, {name=arr[i].getSimpleRepresentation(), value=arr[i].getOrderReturnID()});	
			}
			arrayAppend(variables.orderReturnIDOptions, {name=getHibachiScope().rbKey('define.new'), value=""});
		}
		return variables.orderReturnIDOptions;
	}
	
	public array function getFulfillmentMethodIDOptions() {
		if(!structKeyExists(variables, "fulfillmentMethodIDOptions")) {
			
			var sl = getService("fulfillmentService").getFulfillmentMethodSmartList();
			sl.addFilter('activeFlag', 1);
			if(!isNull(getSku()) and len(getSku().setting('skuEligibleFulfillmentMethods'))) {
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
			arrayAppend(variables.shippingAccountAddressIDOptions, {name=getHibachiScope().rbKey('define.new'), value=""});
		}
		return variables.shippingAccountAddressIDOptions;
	}
	
	// ====================== DEFAULT VALUES
	
	public any function getFulfillmentMethodType() {
		if(!isNull(getFulfillmentMethodID())) {
			for(var i=1; i<=arrayLen(getFulfillmentMethodIDOptions()); i++) {
				if(getFulfillmentMethodIDOptions()[i]['value'] eq getFulfillmentMethodID()) {
					return getFulfillmentMethodIDOptions()[i]['fulfillmentMethodType'];
				}
			}
		}
		return "";
	}
	
	public any function getOrderFulfillmentID() {
		if(!structKeyExists(variables, 'orderFulfillmentID')) {
			variables.orderFulfillmentID = getOrderFulfillmentIDOptions()[1]['value'];
		}
		return variables.orderFulfillmentID;
	}
	
	public any function getOrderReturnID() {
		if(!structKeyExists(variables, 'orderReturnID')) {
			variables.orderReturnID = getOrderReturnIDOptions()[1]['value'];
		}
		return variables.orderReturnID;
	}
	
	public any function getOrderItemTypeSystemCode() {
		if(!structKeyExists(variables, 'orderItemTypeSystemCode')) {
			variables.orderItemTypeSystemCode = "oitSale";
		}
		return variables.orderItemTypeSystemCode;
	}
	
	
	public any function getPrice() {
		if(!structKeyExists(variables, "price")) {
			variables.price = 0;
			if(!isNull(getSku())) {
				var priceByCurrencyCode = getSku().getPriceByCurrencyCode( getCurrencyCode() );
				if(!isNull(priceByCurrencyCode)) {
					variables.price = priceByCurrencyCode;
				} else {
					variables.price = "N/A";
				}
			}
		}
		return variables.price;
	}
	
	public string function getCurrencyCode() {
		if(!structKeyExists(variables, "currencyCode")) {
			if(!isNull(getOrder().getCurrencyCode())) {
				variables.currencyCode = getOrder().getCurrencyCode();
			} else if (!isNull(getSku()) && len(getSku().setting('skuCurrency')) eq 3) {
				variables.currencyCode = getSku().setting('skuCurrency');
			} else {
				variables.currencyCode = 'USD';
			}
		}
		return variables.currencyCode;
	}
	
	public any function getFulfillmentRefundAmount() {
		if(!structKeyExists(variables, "fulfillmentRefundAmount")) {
			variables.fulfillmentRefundAmount = 0;
		}
		return variables.fulfillmentRefundAmount;
	}
	
	public any function getQuantity() {
		if(!structKeyExists(variables, "quantity")) {
			variables.quantity = 1;
			if(!isNull(getSku()) && getSku().setting('skuOrderMinimumQuantity') > 1) {
				variables.quantity = getSku().setting('skuOrderMinimumQuantity');
			}
		}
		return variables.quantity;
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
		return variables.saveShippingAccountAddressFlag;
	}
	
	public any function getAssignedOrderItemAttributeSets() {
		if(!isNull(getSkuID()) && !isNull(getSku())) {
			return getSku().getAssignedOrderItemAttributeSetSmartList().getRecords();	
		}
		
		return [];
	}
	
}