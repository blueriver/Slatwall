component displayname="Vendor Brand" entityname="SlatVendorBrand" table="SlatVendorBrand" persistent="true" accessors="true" output="false" extends="slat.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="vendorBrandID" fieldtype="id" generator="increment";
	
	// Related Object Properties
	property name="vendor" cfc="vendor" fieldtype="many-to-one" fkcolumn="VendorID";
	property name="brand" cfc="brand" fieldtype="many-to-one" fkcolumn="BrandID";
	
}
