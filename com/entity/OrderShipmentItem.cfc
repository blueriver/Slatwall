component displayname="Order Shipment Item" entityname="SlatwallOrderShipmentItem" table="SlatwallOrderShipmentItem" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="orderShipmentItemID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="quantityShipped" ormtype="integer";
	
	// Related Object Properties
	property name="orderShipment" cfc="OrderShipment" fieldtype="many-to-one" fkcolumn="orderShipmentID";
	property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
	
}