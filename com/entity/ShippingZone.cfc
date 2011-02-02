component displayname="Shipping Zone" entityname="SlatwallShippingZone" table="SlatwallShippingZone" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="shippingZoneID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="shippingZoneName" ormtype="string";
	
	// Related Object Properties
	property name="shippingZoneLocations" singularname="shippingZoneLocation" type="array" cfc="ShippingZoneLocation" fieldtype="one-to-many" fkcolumn="shippingZoneID" inverse="true" cascade="all";
	
}