component displayname="Vendor" entityname="SlatwallVendor" table="SlatwallVendor" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="vendorID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="vendorName" ormtype="string";
	property name="vendorWebsite" ormtype="string";
	property name="accountNumber" ormtype="string";
	
	// Related Object Properties
	property name="phoneNumbers" singularname="phoneNumber" type="array" cfc="VendorPhone" fieldtype="one-to-many" fkcolumn="vendorID" cascade="all" inverse="true";
	property name="emailAddresses" singularname="emailAddress" type="array" cfc="VendorEmail" fieldtype="one-to-many" fkcolumn="vendorID" cascade="all" inverse="true";
	property name="brands" singularname="brand" type="array" cfc="VendorBrand" fieldtype="one-to-many" fkcolumn="vendorID" cascade="all" inverse="true";
	
}