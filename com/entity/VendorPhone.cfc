component displayname="Vendor Phone" entityname="SlatwallVendorPhone" table="SlatwallVendorPhone" persistent="true" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="vendorPhoneID" fieldtype="id" generator="increment";
	property name="phone" type="string" persistent="true";
	
	// Related Object Properties
	property name="vendor" cfc="Vendor" fieldtype="many-to-one" fkcolumn="vendorID";
	property name="vendorPhoneType" cfc="Type" fieldtype="many-to-one" fkcolumn="vendorPhoneTypeID";
	
	public string function getPhoneType() {
		return getVendorPhoneType().getType();
	}
}