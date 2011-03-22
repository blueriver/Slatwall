component displayname="Cart" entityname="SlatwallCart" table="SlatwallCart" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="cartID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	
	// Related Object Properties
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="cartItems" singularname="cartItem" type="array" cfc="CartItem" fieldtype="one-to-many" fkcolumn="cartID" cascade="all" inverse="true";
	
	public array function getCartItems() {
		if(!structKeyExists(variables, "cartItems")) {
			variables.cartItems = arrayNew(1);
		}
		return variables.cartItems;
	}
	
	public numeric function getTotalItems() {
		return arrayLen(getCartItems());
	}
	
	public numeric function getTotalQuantity() {
		var cartItems = getCartItems();
		var totalQuantity = 0;
		for(var i=1; i<=arrayLen(cartItems); i++) {
			totalQuantity += cartItems[i].getQuantity(); 
		}
		return totalQuantity;
	}

}