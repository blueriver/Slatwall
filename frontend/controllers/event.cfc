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
component persistent="false" accessors="true" output="false" extends="BaseController" {
	
	// Slatwall Service Injection
	property name="productService" type="any";
	property name="accountService" type="any";
	property name="sessionService" type="any";
	property name="requestCacheService" type="any";
	
	// Mura Service Injection
	property name="contentManager" type="any";
	
	public void function before(required any rc) {
		variables.fw.setView("frontend:event.blank");
	}
	
	public void function onSiteRequestStart(required any rc) {
		// This hook is what enables SEO friendly product URL's... It is also what sets up the product in the slatwall scope, ext
		if( listLen(rc.path, "/") >= 3 && listGetAt(rc.path, 2, "/") == setting("product_urlKey")) {
			
			// Load Product
			var product = getProductService().getProductByFilename(listGetAt(rc.path, 3, "/"));
			
			// If Product Exists, is Active, and is published then put the product in the slatwall scope and setup product template for muras contentBean to be loaded later
			if(!isNull(product)) {
				getRequestCacheService().setValue("currentProduct", product);
				getRequestCacheService().setValue("currentProductID", product.getProductID());
				rc.$.event('slatAction', 'frontend:product.detail');
				rc.$.event('contentBean', getContentManager().getActiveContentByFilename(product.getTemplate(),rc.$.event('siteid'),true));
			}	
		}
	}
	
	public void function onRenderStart(required any rc) {
		// This checks for Product Listing Pages
		if( rc.$.content().getSubType() == "SlatwallProductListing" ) {
			if(rc.$.event('slatAction') == "") {
				rc.$.event("slatAction", "frontend:product.listcontentproducts");
				if(!structKeyExists(form, "P:Show") && !structKeyExists(url, "P:Show")) {
					rc.$.slatwall.productList().setPageRecordsShow(rc.$.content('productsPerPage'));	
				}
			}
		// Checks for shopping cart
		} else if (rc.$.content('filename') == 'shopping-cart') {
			if(rc.$.event('slatAction') == "") {
				rc.$.event("slatAction", "frontend:cart.detail");
			}
			
		// Checks for Checkout page
		} else if (rc.$.content('filename') == 'checkout') {
			if(rc.$.event('slatAction') == "") {
				rc.$.event("slatAction", "frontend:checkout.detail");
			}
		// Checks for My-Account page
		} else if (rc.$.content('filename') == 'my-account') {
			if(rc.$.event('slatAction') == "") {
				rc.$.event("slatAction", "frontend:account.detail");
			}
		}
	}
	
	public void function onRenderEnd(required any rc) {
		
		// Add necessary html to the header
		if( getFW().secureDisplay("admin:main.dashboard") ){
			var oldContent = rc.$.event( "__MuraResponse__" );
			var newContent = Replace(oldContent, "</head>", "#getFW().view("common:toolbar/menu")#</head>");
			rc.$.event("__MuraResponse__", newContent);
		}
	}
	
	public void function onAfterPageSlatwallProductListingSave(required any rc) {
		getProductService().updateProductContentPaths(contentID=rc.$.content("contentID"));
	}
	
	public void function onAfterPageSlatwallProductListingDelete(required any rc) {
		getProductService().deleteProductContent(rc.$.content("contentID"));
	}
}
