component displayname="Vendor Phone" entityname="SlatwallVendorPhone" table="SlatwallVendorPhone" persistent="true" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="vendorPhoneID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="phone" ormtype="string";
	
	// Related Object Properties
	property name="vendor" cfc="Vendor" fieldtype="many-to-one" fkcolumn="vendorID";
	property name="vendorPhoneType" cfc="Type" fieldtype="many-to-one" fkcolumn="vendorPhoneTypeID";
	
	public string function getPhoneType() {
		return getVendorPhoneType().getType();
	}
}