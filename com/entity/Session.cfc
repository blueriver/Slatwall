component displayname="Session" entityname="SlatwallSession" table="SlatwallSession" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="sessionID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	
	// Related Object Properties
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="cart" cfc="Cart" fieldtype="many-to-one" fkcolumn="cartID";
	
}