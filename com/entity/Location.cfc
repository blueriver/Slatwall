component displayname="Location" entityname="SlatwallLocation" table="SlatwallLocation" persistent=true accessors=true output=false extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="locationID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="locationName" ormtype="string" persistent=true;
	property name="sellStockOnWeb" ormtype="boolean";
	property name="sellStockOnWebWholesale" ormtype="boolean";
	
}