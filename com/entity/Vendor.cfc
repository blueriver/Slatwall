component displayname="Vendor" entityname="SlatVendor" table="SlatVendor" persistent="true" accessors="true" output="false" extends="slat.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="vendorID" fieldtype="id" generator="guid";
	property name="vendorName" type="string" persistent="true";
	property name="vendorWebsite" type="string" persistent="true";
	property name="accountNumber" type="string" persistent="true";
	
	// Related Object Properties
	property name="phoneNumbers" cfc="vendorphone" fieldtype="one-to-many" fkcolumn="VendorID" type="array" cascade="all" inverse="true";
	property name="emailAddresses" cfc="vendoremail" fieldtype="one-to-many" fkcolumn="VendorID" type="array" cascade="all" inverse="true";
	property name="brands" cfc="vendorbrand" fieldtype="one-to-many" fkcolumn="VendorID" type="array" cascade="all" inverse="true";
	
}