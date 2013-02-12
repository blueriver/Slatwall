component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="content";
	
	// Data Properties
	property name="skuID";
	property name="productID";			// Only used on new sku
	property name="price";				// Only used on new sku
	property name="productCode";		// Only used on new product
	property name="productTypeID";		// Only used on new product
	
	public any function init() {
		setSkuID("");
		setProductID("");
		setProductTypeID("");
		
		return super.init();	
	}	
}