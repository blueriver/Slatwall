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
				getService("requestCacheService").setValue("currentProduct", getService("productService").getProduct(getService("requestCacheService").getValue("currentProductID")));
			} else {
				getService("requestCacheService").setValue("currentProduct", getService("productService").newProduct());	
			}
		}
		return getService("requestCacheService").getValue("currentProduct");
	}
	
	public any function getCurrentContent() {
		if(!getService("requestCacheService").keyExists("currentContent")) {
			getService("requestCacheService").setValue( "currentContent", getService("productService").getContentByCMSContentID( request.muraScope.content('contentID'), true ) );
		}
		return getService("requestCacheService").getValue("currentContent");
	}
	
	public any function getCurrentSession() {
		return getService("sessionService").getCurrent();
	}
	
	public any function getCurrentAccount() {
		if(!isNull(getCurrentSession().getAccount())) {
			return getCurrentSession().getAccount();
		} else {
			return getService("AccountService").newAccount();	
		}
	}
	
	public any function getCurrentCart() {
		if(!isNull(getCurrentSession().getOrder())) {
			return getCurrentSession().getOrder();
		} else {
			return getService("OrderService").newOrder();	
		}
	}
	
	private struct function getProductListData(string contentID="") {
		var data = {};
		
		// Setup Basic Filters
		data["F:activeFlag"] = 1;
		data["F:publishedFlag"] = 1;
		if(structKeyExists(request, "context")) {
			structAppend(data, request.context);
		} else {
			structAppend(data, form);
			structAppend(data, url);
		}
		
		// Setup Category stuff
		if($.event("categoryID") != "") {
			data["F:productCategories_categoryID"] = $.event("categoryID");
		}
		
		// Setup Content Related filters and settings
		if(len(arguments.contentID)) {
			if(arguments.contentID == $.content('contentID')) {
				var contentBean = $.content();
			} else {
				var contentBean = $.getBean("content").loadBy(contentID=arguments.contentID, siteID=$.event('siteID'));
			}
			
			if(contentBean.getShowSubPageProducts() eq "") {
				data.showSubPageProducts = 1;
			} else {
				data.showSubPageProducts = contentBean.getShowSubPageProducts();	
			}
		}
		
		return data;
	}
	
	public any function getProductList(string contentID="", setupData=true) {
		if(len(arguments.contentID)) {
			if(!getService("requestCacheService").keyExists("contentProductList#arguments.contentID##yesNoFormat(arguments.setupData)#")) {
				
				var data = {};
				if(arguments.setupData) {
					data = getProductListData(arguments.contentID);
				}
				
				var currentURL = $.createHREF(filename=$.content('filename'));
				if(len(CGI.QUERY_STRING)) {
					currentURL &= "?" & CGI.QUERY_STRING;
				}
				
				getService("requestCacheService").setValue("contentProductList#arguments.contentID##yesNoFormat(arguments.setupData)#", getService("productService").getProductContentSmartList(contentID=$.content("contentID"), data=data, currentURL=currentURL));
			}
			return getService("requestCacheService").getValue("contentProductList#arguments.contentID##yesNoFormat(arguments.setupData)#");
		} else {
			if(!getService("requestCacheService").keyExists("allProductList#yesNoFormat(arguments.setupData)#")) {
				
				var data = {};
				if(arguments.setupData) {
					data = getProductListData(arguments.contentID);
				}
				
				var currentURL = $.createHREF(filename=$.content('filename'));
				if(len(CGI.QUERY_STRING)) {
					currentURL &= "?" & CGI.QUERY_STRING;
				}
				
				getService("requestCacheService").setValue("allProductList#yesNoFormat(arguments.setupData)#", getService("productService").getProductSmartList(data=data, currentURL=currentURL));
			}
			return getService("requestCacheService").getValue("allProductList#yesNoFormat(arguments.setupData)#");
		}
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
		if(structKeyExists(arguments, "property") && structKeyExists(arguments, "value")) {
			return getCurrentCart().invokeMethod("set#arguments.property#", {1=arguments.value});
		} else if (isDefined("arguments.property")) {
			return getCurrentCart().invokeMethod("get#arguments.property#", {});
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
	
	public any function productList(string property, string value, string contentID) {
		if(!structKeyExists(arguments, "contentID")) {
			arguments.contentID = $.content('contentID');
		}
		
		if(structKeyExists(arguments, "property") && structKeyExists(arguments, "value")) {
			return evaluate("getProductList(arguments.contentID).set#arguments.property#(#arguments.value#)");	
		} else if (structKeyExists(arguments, "property")) {
			return evaluate("getProductList(arguments.contentID).get#arguments.property#()");
		} else {
			return getProductList(arguments.contentID);
		}
	}
	
	public any function content(string property, string value) {
		if(isDefined("arguments.property") && isDefined("arguments.value")) {
			return evaluate("getCurrentContent().set#arguments.property#(#arguments.value#)");
		} else if (isDefined("arguments.property")) {
			return evaluate("getCurrentContent().get#arguments.property#()");
		} else {
			return getCurrentContent();
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
	
	public void function addVTScript( ) {
		var script = getValidateThis().getValidationScript( argumentcollection = arguments );
		
		if(!getService("requestCacheService").keyExists("vtScripts")) {
			getService("requestCacheService").setValue("vtScripts", []);	
		}
		
		arrayAppend(getService("requestCacheService").getValue("vtScripts"), script);
	}
	
	public string function renderVTScript() {
		var scripts = [];
		var outputScript = "";
		
		if(getService("requestCacheService").keyExists("vtScripts")) {
			scripts = getService("requestCacheService").getValue("vtScripts");
		}
		
		outputScript &= '<script type="text/javascript">';
		outputScript &= 'jQuery(document).ready(function(){';
		 
		for(var i=1; i<=arrayLen(scripts); i++) {
			outputScript &= replace(replace(replace(replace(scripts[i],'<script type="text/javascript">',''),'</script>',''),'/*<![CDATA[*/','','all'),'/*]]>*/','','all');
		}
		
		outputScript &= '});</script>';
		
		return outputScript;
	}

}