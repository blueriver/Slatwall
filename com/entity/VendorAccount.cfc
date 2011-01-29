component displayname="Vendor Account" entityname="SlatwallVendorAccount" table="SlatwallVendorAccount" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="vendorAccountID" type="numeric" ormtype="integer" fieldtype="id" generator="identity" unsavedvalue="0" default="0";

	// Related Object Properties
	property name="vendor" cfc="Vendor" fieldtype="many-to-one" fkcolumn="vendorID";
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="roleType" cfc="Type" fieldtype="many-to-one" fkcolumn="typeID";
}