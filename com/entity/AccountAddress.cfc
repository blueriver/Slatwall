component displayname="Account Address" entityname="SlatwallAccountAddress" table="SlatwallAccountAddress" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="accountAddressID" type="numeric" ormtype="integer" fieldtype="id" generator="identity" unsavedvalue="0" default="0";
	
	// Related Object Properties
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="address" cfc="Address" fieldtype="many-to-one" fkcolumn="addressID";
	property name="accountAddressType" cfc="Account" fieldtype="many-to-one" fkcolumn="accountAddressTypeID";
	
	public string function getAddressType() {
		return getAccountAddressType().getType();
	}
}