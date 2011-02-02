component displayname="Account Email" entityname="SlatwallAccountEmail" table="SlatwallAccountEmail" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="accountPhoneID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="email" ormtype="string";
	
	// Related Object Properties
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="accountEmailType" cfc="Account" fieldtype="many-to-one" fkcolumn="accountEmailTypeID";
	
	public string function getEmailType() {
		return getAccountEmailType().getType();
	}
}