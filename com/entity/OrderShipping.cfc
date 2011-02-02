component displayname="Order Shipping" entityname="SlatwallOrderShipping" table="SlatwallOrderShipping" persistent=true accessors=true output=false extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="orderShippingID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="cost" ormtype="float";
	
	// Related Object Properties
	property name="address" cfc="Address" fieldtype="many-to-one" fkcolumn="addressID";
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	property name="orderShippingItems" singularname="orderShippingItem" cfc="OrderItem" fieldtype="one-to-many" fkcolumn="orderShippingID" inverse="true" cascade="all";
	
}