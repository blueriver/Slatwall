component displayname="Vendor Brand" entityname="SlatwallVendorBrand" table="SlatwallVendorBrand" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="vendorBrandID" type="numeric" ormtype="integer" fieldtype="id" generator="identity" unsavedvalue="0" default="0";
	
	// Related Object Properties
	property name="vendor" cfc="Vendor" fieldtype="many-to-one" fkcolumn="vendorID";
	property name="brand" cfc="Brand" fieldtype="many-to-one" fkcolumn="brandID";
	
}