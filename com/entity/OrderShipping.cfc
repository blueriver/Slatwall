component displayname="Order Shipping" entityname="SlatwallOrderShipping" table="SlatwallOrderShipping" persistent=true accessors=true output=false extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="orderShippingID" type="string" fieldtype="id" generator="guid";
	property name="cost" type="numeric";
	
	// Related Object Properties
	property name="address" cfc="Address" fieldtype="many-to-one" fkcolumn="addressID";
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	property name="orderShippingItems" cfc="OrderItems" fieldtype="one-to-many" fkcolumn="orderShippingID";
	
}