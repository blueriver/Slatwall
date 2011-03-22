component accessors="true" extends="BaseObject" {

	property name="lastCrumbData" type="array";
	property name="accountID" type="string" default="";
	property name="cartID" type="string" default="";
	
	request.slatwallSession = {};
	
	public any function init() {
		setLastCrumbData(arrayNew(1));
	}
	
	public any function getAccount() {
		if(!structKeyExists(request.slatwallSession, "account")) {
			if(getAccountID() != "") {
				request.slatwallSession.account = getService("accountService").getByID(getAccountID());
			} else {
				request.slatwallSession.account = getService("accountService").getNewEntity();
			}
		}
		return request.slatwallSession.account;
	}
	
	public any function setAccount(required any account) {
		// Update current request session Scope
		request.slatwallSession.account = arguments.account;
		
		// Update accountID for future requests
		setAccountID(arguments.account.getAccountID());
	}
	
	public any function getCart() {
		if(!structKeyExists(request.slatwallSession, "cart")) {
			if(len(getCartID())) {
				request.slatwallSession.cart = getService("cartService").getByID(getCartID());
			} else {
				request.slatwallSession.cart = getService("cartService").getNewEntity();
				if(!getAccount().isNew()) {
					request.slatwallSession.cart.setAccount(getAccount());	
				}
				request.slatwallSession.cart = getService("cartService").save(request.slatwallSession.cart);
			}
			setCartID(request.slatwallSession.cart.getCartID());
		}
		return request.slatwallSession.cart;
	}
}