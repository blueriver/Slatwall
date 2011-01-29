component displayname="Cart" entityname="SlatwallCart" table="SlatwallCart" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="cartID" type="numeric" ormtype="integer" fieldtype="id" generator="identity" unsavedvalue="0" default="0";
	
	// Related Object Properties
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="cartItems" type="array" cfc="CartItem" fieldtype="one-to-many" fkcolumn="cartID" cascade="all" inverse="true";

}