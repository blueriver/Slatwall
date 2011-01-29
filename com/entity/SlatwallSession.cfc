component displayname="Session" entityname="SlatwallSession" table="SlatwallSession" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="sessionID" type="numeric" ormtype="integer" fieldtype="id" generator="identity" unsavedvalue="0" default="0";
	
	// Related Object Properties
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="cart" cfc="Cart" fieldtype="many-to-one" fkcolumn="cartID";
	
}