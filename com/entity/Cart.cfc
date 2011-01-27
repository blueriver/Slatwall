component displayname="Cart" entityname="SlatwallCart" table="SlatwallCart" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="cartID" type="string" fieldtype="id" generator="guid";
	
	// Related Object Properties
	property name="account" cfc="Account" fieldtype="one-to-many" fkcolumn="accountID";
	property name="cartItems" cfc="CartItem" fieldtype="many-to-one" fkcolumn="cartID";

}