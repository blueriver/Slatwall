component displayname="Vendor Brand" entityname="SlatwallVendorBrand" table="SlatwallVendorBrand" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="vendorBrandID" type="string" fieldtype="id" generator="guid";
	
	// Related Object Properties
	property name="vendor" cfc="Vendor" fieldtype="many-to-one" fkcolumn="vendorID";
	property name="brand" cfc="Brand" fieldtype="many-to-one" fkcolumn="brandID";
	
}
