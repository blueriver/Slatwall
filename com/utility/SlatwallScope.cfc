component accessors="true" extends="BaseObject" {
	
	property name="currentProduct" type="any";
	
	public any function init() {
		return this;
	}
	
	public any function getCurrentAccount() {
		return getService("sessionService").getCurrent().getAccount();
	}
	
	public any function getCurrentCart() {
		return getService("sessionService").getCurrent().getCart();
	}

	public any function getCurrentProduct() {
		if(!isDefined("variables.currentProduct")) {
			variables.currentProduct = getService("productService").getNewEntity();
		}
		return variables.currentProduct;
	}
	
	public any function account(string property, string value) {
		if(isDefined("arguments.property") && isDefined("arguments.value")) {
			return evaluate("getCurrentAccount().set#arguments.property#(#arguments.value#)");
		} else if (isDefined("arguments.property")) {
			return evaluate("getCurrentAccount().get#arguments.property#()");
		} else {
			return getCurrentAccount();	
		}
	}
	
	public any function cart(string property, string value) {
		if(isDefined("arguments.property") && isDefined("arguments.value")) {
			return evaluate("getCurrentCart().set#arguments.property#(#arguments.value#)");
		} else if (isDefined("arguments.property")) {
			return evaluate("getCurrentCart().get#arguments.property#()");
		} else {
			return getCurrentCart();	
		}
	}
	
	public any function product(string property, string value) {
		if(isDefined("arguments.property") && isDefined("arguments.value")) {
			return evaluate("getCurrentProduct().set#arguments.property#(#arguments.value#)");
		} else if (isDefined("arguments.property")) {
			return evaluate("getCurrentProduct().get#arguments.property#()");
		} else {
			return getCurrentProduct();	
		}
	}
	
	public string function rbKey(required string key, string local) {
		if(isDefined("arguments.local")) {
			return getRBFactory().getKeyValue(arguments.local, arguments.key);
		} else {
			return getRBFactory().getKeyValue(session.rb, arguments.key);
		}
	}
	
	public string function setting(required string settingName) {
		return getService("settingService").getBySettingName(arguments.settingName);		
	}
}
