component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {
	
	property name="sessionService";
	
	public void function addCartItem(required any sku, numeric quantity=1, any cart) {
		
		// Check to see if a cart was passed into the method call	
		if(!structKeyExists(arguments, "cart")) {
			arguments.cart = getSessionService().getCurrent().getCart();
		}
		
		var cartItems = arguments.cart.getCartItems();
		var exists = false;
		
		// Check the existing cart items and just add quantity if sku exists
		for(var i = 1; i <= arrayLen(cartItems); i++) {
			if(cartItems[i].getSku().getSkuID() == arguments.sku.getSkuID()) {
				exists = true;
				cartItems[i].setQuantity(cartItems[i].getQuantity() + arguments.quantity);
			}
		}
		
		// If the sku doesn't exist in the cart, then create a new cart item and add it
		if(!exists) {
			var newCartItem = getNewEntity(entityName="SlatwallCartItem");
			newCartItem.setQuantity(arguments.quantity);
			newCartItem.setCart(arguments.cart);
			newCartItem.setSku(arguments.sku);
			arguments.cart.addCartItem(newCartItem);
		}
		
		save(arguments.cart);
	}
	
}