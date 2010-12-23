component displayname="Brand" entityname="SlatBrand" table="SlatBrand" persistent=true output=false accessors=true extends="slat.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="brandID" feildtype="id" generator="guid";
	property name="brandName" type="string" default="" displayname="Brand Name" persistent="true" hint="This is the common name that the brand goes by.";
	property name="brandWebsite" type="string" default="" displayname="Brand Website" persistent="true" hint="This is the Website of the brand";
	
	// Related Object Properties
	property name="brandVendors" cfc="vendorbrand" fieldtype="one-to-many" fkcolumn="BrandID";

}