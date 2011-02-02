component displayname="Cart Item" entityname="SlatwallCartItem" table="SlatwallCartItem" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="cartItemID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="quantity" ormtype="integer";
	
	// Related Object Properties
	property name="cart" cfc="Cart" fieldtype="many-to-one" fkcolumn="cartID";
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";

}