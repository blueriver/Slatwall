component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="product";

	// Data Properties
	property name="updatePriceFlag";
	property name="price" hb_rbKey="entity.sku.price";
	property name="updateListPriceFlag";
	property name="listPrice" hb_rbKey="entity.sku.listPrice";
	
}