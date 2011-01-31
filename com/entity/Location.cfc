component displayname="Location" entityname="SlatwallLocation" table="SlatwallLocation" persistent=true accessors=true output=false extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="locationID" type="string" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="locationName" type="string" persistent=true;
	property name="sellStockOnWeb" type="boolean";
	property name="sellStockOnWebWholesale" type="boolean";
	
}