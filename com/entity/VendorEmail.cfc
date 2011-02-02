component displayname="Vendor Email" entityname="SlatwallVendorEmail" table="SlatwallVendorEmail" persistent="true" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="vendorEmailID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="email" ormtype="string";
	
	// Related Object Properties
	property name="vendor" cfc="Vendor" fieldtype="many-to-one" fkcolumn="vendorID";
	property name="vendorEmailType" cfc="Type" fieldtype="many-to-one" fkcolumn="vendorEmailTypeID";
	
	public string function getEmailType() {
		return getVendorEmailType().getType();
	}
}