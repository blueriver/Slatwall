component displayname="Vendor Address" entityname="SlatwallVendorAddress" table="SlatwallVendorAddress" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="vendorAddressID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
		
	// Related Object Properties
	property name="vendor" cfc="Vendor" fieldtype="many-to-one" fkcolumn="vendorID";
	property name="vendorAddressType" cfc="Type" fieldtype="many-to-one" fkcolumn="vendorAddressTypeID";
	property name="address" cfc="Address" fieldtype="many-to-one" fkcolumn="addressID";
	
	public string function getAddressType() {
		return getVendorAddressType().getType();
	}
}