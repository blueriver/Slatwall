component displayname="Cart" entityname="SlatwallCart" table="SlatwallCart" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="cartID" type="string" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	
	// Related Object Properties
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="cartItems" type="array" cfc="CartItem" fieldtype="one-to-many" fkcolumn="cartID" cascade="all" inverse="true";

}