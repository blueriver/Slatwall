/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component accessors="true" output="false" extends="BaseObject" {

	public any function init() {
		return this;	
	}
	
	public any function getCurrentProduct() {
		if(!getService("requestCacheService").keyExists("currentProduct")) {
			if(getService("requestCacheService").keyExists("currentProductID")) {
				getService("requestCacheService").setValue("currentProduct", getService("productService").getByID(getService("requestCacheService").getValue("currentProductID")));
			} else {
				getService("requestCacheService").setValue("currentProduct", getService("productService").getNewEntity());	
			}
		}
		return getService("requestCacheService").getValue("currentProduct");
	}
	
	public any function getCurrentSession() {
		return getService("sessionService").getCurrent();
	}
	
	public any function getCurrentAccount() {
		if(!isNull(getCurrentSession().getAccount())) {
			return getCurrentSession().getAccount();
		} else {
			return getService("AccountService").getNewEntity();	
		}
	}
	
	public any function getCurrentCart() {
		if(!isNull(getCurrentSession().getOrder())) {
			return getCurrentSession().getOrder();
		} else {
			return getService("OrderService").getNewEntity();	
		}
	}
	
	private any function getCurrentProductList() {
		if(!getService("requestCacheService").keyExists("currentProductList")) {
			var data = {};
			if(structKeyExists(request, "context")) {
				data = request.context;
			}
			if($.content("showSubPageProducts") eq "") {
				data.showSubPageProducts = 0;
			} else {
				data.showSubPageProducts = $.content("showSubPageProducts");	
			}
			var currentURL = $.createHREF(filename=$.content('filename'));
			if(len(CGI.QUERY_STRING)) {
				currentURL &= "?" & CGI.QUERY_STRING;
			}
			getService("requestCacheService").setValue("currentProductList", getService("productService").getProductContentSmartList(contentID=$.content("contentID"), data=data, currentURL=currentURL, subContentProducts=$.content("showSubPageProducts")));
		}
		return getService("requestCacheService").getValue("currentProductList");
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
	
	public any function productList(string property, string value) {
		if(structKeyExists(arguments, "property") && structKeyExists(arguments, "value")) {
			return evaluate("getCurrentProductList().set#arguments.property#(#arguments.value#)");
		} else if (structKeyExists(arguments, "property")) {
			return evaluate("getCurrentProductList().get#arguments.property#()");
		} else {
			return getCurrentProductList();	
		}
	}
	
	public any function session(string property, string value) {
		if(structKeyExists(arguments, "property") && structKeyExists(arguments, "value")) {
			return evaluate("getCurrentSession().set#arguments.property#(#arguments.value#)");
		} else if (structKeyExists(arguments, "property")) {
			return evaluate("getCurrentSession().get#arguments.property#()");
		} else {
			return getCurrentSession();	
		}
	}
	
	public any function sessionFacade(string property, string value) {
		if(structKeyExists(arguments, "property") && structKeyExists(arguments, "value")) {
			return getService("sessionService").setValue(arguments.property, arguments.value);
		} else if (structKeyExists(arguments, "property")) {
			return getService("sessionService").getValue(arguments.property);
		} else {
			return getService("sessionService");	
		}
	}
	
	public string function rbKey(required string key, string local) {
		if(!isDefined("arguments.local")) {
			arguments.local = session.rb;
		}
		return getRBFactory().getKeyValue(arguments.local, arguments.key);
	}
	
	public string function setting(required string settingName) {
		return Super.setting(arguments.settingName);
	}
}