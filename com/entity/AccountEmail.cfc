component displayname="Account Email" entityname="SlatwallAccountEmail" table="SlatwallAccountEmail" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="accountPhoneID" type="string" fieldtype="id" generator="guid";
	property name="email" type="string";
	
	// Related Object Properties
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="accountEmailType" cfc="Account" fieldtype="many-to-one" fkcolumn="accountEmailTypeID";
	
	public string function getEmailType() {
		return getAccountEmailType().getType();
	}
}