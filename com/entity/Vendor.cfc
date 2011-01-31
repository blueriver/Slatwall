component displayname="Vendor" entityname="SlatwallVendor" table="SlatwallVendor" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="vendorID" type="string" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="vendorName" type="string" persistent="true";
	property name="vendorWebsite" type="string" persistent="true";
	property name="accountNumber" type="string" persistent="true";
	
	// Related Object Properties
	property name="phoneNumbers" type="array" cfc="VendorPhone" fieldtype="one-to-many" fkcolumn="vendorID" cascade="all" inverse="true";
	property name="emailAddresses" type="array" cfc="VendorEmail" fieldtype="one-to-many" fkcolumn="vendorID" cascade="all" inverse="true";
	property name="brands" type="array" cfc="VendorBrand" fieldtype="one-to-many" fkcolumn="vendorID" cascade="all" inverse="true";
	
}