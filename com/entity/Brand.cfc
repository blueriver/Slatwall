component displayname="Brand" entityname="SlatwallBrand" table="SlatwallBrand" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="brandID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="brandName" ormtype="string" default="" displayname="Brand Name" persistent="true" hint="This is the common name that the brand goes by.";
	property name="brandWebsite" ormtype="string" default="" displayname="Brand Website" persistent="true" hint="This is the Website of the brand";
	
	// Related Object Properties
	property name="brandVendors" singularname="brandVendor" cfc="VendorBrand" fieldtype="one-to-many" fkcolumn="brandID" inverse="true" cascade="all";

}