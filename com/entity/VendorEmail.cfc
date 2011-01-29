component displayname="Vendor Email" entityname="SlatwallVendorEmail" table="SlatwallVendorEmail" persistent="true" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="vendorEmailID" type="numeric" ormtype="integer" fieldtype="id" generator="identity" unsavedvalue="0" default="0";
	property name="email" type="string" persistent="true";
	
	// Related Object Properties
	property name="vendor" cfc="Vendor" fieldtype="many-to-one" fkcolumn="vendorID";
	property name="vendorEmailType" cfc="Type" fieldtype="many-to-one" fkcolumn="vendorEmailTypeID";
	
	public string function getEmailType() {
		return getVendorEmailType().getType();
	}
}