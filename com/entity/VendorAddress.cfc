component displayname="Vendor Address" entityname="SlatwallVendorAddress" table="SlatwallVendorAddress" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="vendorAddressID" fieldtype="id" generator="increment";
		
	// Related Object Properties
	property name="vendor" cfc="Vendor" fieldtype="many-to-one" fkcolumn="vendorID";
	property name="addressType" cfc="Type" fieldtype="many-to-one" fkcolumn="typeID";
	property name="address" cfc="Address" fieldtype="many-to-one" fkcolumn="addressID";
}