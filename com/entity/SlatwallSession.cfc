component displayname="Session" entityname="SlatwallSession" table="SlatwallSession" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="sessionID" type="string" fieldtype="id" generator="guid";
	
	// Related Object Properties
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="cart" cfc="Cart" fieldtype="many-to-one" fkcolumn="cartID";
	
}