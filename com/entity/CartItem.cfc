component displayname="Cart Item" entityname="SlatwallCartItem" table="SlatwallCartItem" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="cartItemID" type="string" fieldtype="id" generator="guid";
	property name="quantity" type="numeric";
	
	// Related Object Properties
	property name="cart" cfc="Cart" fieldtype="one-to-many" fkcolumn="cartID";
	property name="sku" cfc="Sku" fieldtype="one-to-many" fkcolumn="skuID";

}