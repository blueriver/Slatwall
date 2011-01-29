component displayname="Cart Item" entityname="SlatwallCartItem" table="SlatwallCartItem" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="cartItemID" type="numeric" ormtype="integer" fieldtype="id" generator="identity" unsavedvalue="0" default="0";
	property name="quantity" type="numeric";
	
	// Related Object Properties
	property name="cart" cfc="Cart" fieldtype="many-to-one" fkcolumn="cartID";
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";

}