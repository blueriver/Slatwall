component displayname="Account Phone" entityname="SlatwallAccountPhone" table="SlatwallAccountPhone" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="accountPhoneID" type="string" fieldtype="id" generator="guid";
	property name="phone" type="string";
	
	// Related Object Properties
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="phoneType" cfc="Account" fieldtype="many-to-one" fkcolumn="phoneTypeID";
}