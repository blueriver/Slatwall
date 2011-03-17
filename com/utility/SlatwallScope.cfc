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
		if(!isDefined("arguments.local")) {
			arguments.local = session.rb;
		}
		return getRBFactory().getKeyValue(arguments.local, arguments.key);
	}

	public boolean function secureDisplay(required string action) {
		return secureDisplay(arguments.action);
	}
	
	public string function getLoginURL(string returnURL="", string returnAction="") {
		var loginURL = "";
		
		if($.siteConfig().getExtranetSSL()) {
			loginURL &= "https://";
		} else {
			loginURL &= "http://";
		}
		
		loginURL &= "#$.siteConfig().getDomain()#/";
		
		if(application.configBean.getSiteIDInURLS()) {
			loginURL &= "#$.siteConfig('siteid')#/";
		}
		if(application.configBean.getIndexFileInURLS()) {
			loginURL &= "index.cfm";
		}
		if(find("?",loginURL)) {
			loginURL &= "&";
		} else {
			loginURL &= "?";
		}
		
		loginURL &= "##returnURL=" & URLEncodedFormat("http://#$.siteConfig().getDomain()#/plugins/Slatwall/?slatAction=#slatAction#");
		
		return loginURL;
	}
}
