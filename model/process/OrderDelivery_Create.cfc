component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="orderDelivery";
	
	// Data Properties
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	property name="fulfillmentMethod" cfc="FulfillmentMethod" fieldtype="many-to-one" fkcolumn="fulfillmentMethodID";
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	property name="shippingAddress" cfc="Address" fieldtype="many-to-one" fkcolumn="shippingAddressID";
	property name="orderDeliveryItems" singularname="orderDeliveryItem" cfc="OrderDeliveryItem" fieldtype="one-to-many" fkcolumn="orderDeliveryID";

	variables.orderDeliveryItems = [];
	
	public void function addOrderDeliveryItem( required any orderDeliveryItem ) {
		arrayAppend(variables.orderDeliveryItems, arguments.orderDeliveryItem );
	}
}