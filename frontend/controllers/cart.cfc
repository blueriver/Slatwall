component persistent="false" accessors="true" output="false" extends="BaseController" {

	property name="cartService" type="any";
	
	public void function detail(required struct rc) {
		param name="rc.cartID" default="";
		
		if(rc.cartID != "") {
			rc.cart = getCartService().getByID(rc.cartID);
		} else {
			rc.cart = rc.$.slatwall.cart();
		}
		
	}
	
}