component displayname="Shipping Rate" entityname="SlatwallShippingRate" table="SlatwallShippingRate" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="shippingRateID" type="string" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="minWeight" type="numeric";
	property name="maxWeight" type="numeric";
	property name="minPrice" type="numeric";
	property name="maxPrice" type="numeric";
	property name="cost" type="numeric";
	
	// Related Object Properties
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	property name="shippingZone" cfc="ShippingZone" fieldtype="many-to-one" fkcolumn="shippingZoneID";
	
}