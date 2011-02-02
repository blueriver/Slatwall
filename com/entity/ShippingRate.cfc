component displayname="Shipping Rate" entityname="SlatwallShippingRate" table="SlatwallShippingRate" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="shippingRateID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="minWeight" ormtype="float";
	property name="maxWeight" ormtype="float";
	property name="minPrice" ormtype="float";
	property name="maxPrice" ormtype="float";
	property name="cost" ormtype="float";
	
	// Related Object Properties
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	property name="shippingZone" cfc="ShippingZone" fieldtype="many-to-one" fkcolumn="shippingZoneID";
	
}