component displayname="Shipping Zone" entityname="SlatwallShippingZone" table="SlatwallShippingZone" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="shippingZoneID" type="string" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="shippingZoneName" type="string";
	
	// Related Object Properties
	property name="shippingZoneLocations" type="array" cfc="ShippingZoneLocation" fieldtype="one-to-many" fkcolumn="shippingZoneID";
	
}