component displayname="Account Phone" entityname="SlatwallAccountPhone" table="SlatwallAccountPhone" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="accountPhoneID" type="string" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="phone" type="string";
	
	// Related Object Properties
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="accountPhoneType" cfc="Account" fieldtype="many-to-one" fkcolumn="accountPhoneTypeID";
	
	public string function getPhoneType() {
		return getAccountPhoneType().getType();
	}
}