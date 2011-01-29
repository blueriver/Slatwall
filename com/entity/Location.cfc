component displayname="Location" entityname="SlatwallLocation" table="SlatwallLocation" persistent=true accessors=true output=false extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="locationID" type="numeric" ormtype="integer" fieldtype="id" generator="identity" unsavedvalue="0" default="0";
	property name="locationName" type="string" persistent=true;
	property name="sellStockOnWeb" type="boolean";
	property name="sellStockOnWebWholesale" type="boolean";
	
}