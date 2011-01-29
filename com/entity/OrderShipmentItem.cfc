component displayname="Order Shipment Item" entityname="SlatwallOrderShipmentItem" table="SlatwallOrderShipmentItem" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="orderShipmentItemID" type="string" fieldtype="id" generator="guid";
	property name="quantityShipped" type="numeric";
	
	// Related Object Properties
	property name="orderShipment" cfc="OrderShipment" fieldtype="many-to-one" fkcolumn="orderShipmentID";
	property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
	
}