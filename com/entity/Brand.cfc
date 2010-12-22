component output="false" accessors="true" displayname="Brand" table="slatbrand" persistent="true" extends="slat.com.entity.BaseEntity" {
	
	property name="BrandID" feildtype="id" generator="guid";
	property name="BrandName" type="string" default="" displayname="Brand Name" hint="This is the common name that the brand goes by.";
	property name="BrandWebsite" type="string" default="" displayname="Brand Website" hint="This is the Website of the brand";
	property name="BrandVendors" cfc="vendorbrand" fieldtype="one-to-many" fkcolumn="BrandID";

}