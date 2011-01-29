component displayname="Order Shipment" entityname="SlatwallOrderShipment" table="SlatwallOrderShipment" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="orderShipmentID" type="string" fieldtype="id" generator="guid";
	property name="trackingNumber" type="string";
	property name="shippedDateTime" type="date";
	
	// Related Object Properties
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	property name="orderShipping" cfc="OrderShipping" fieldtype="many-to-one" fkcolumn="orderShippingID";
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	
}