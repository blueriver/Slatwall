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
		getFW().setView("frontend:event.blank");
	}
	
	public void function onSiteRequestStart(required any rc) {
		
		// This hook is what enables SEO friendly product URL's... It is also what sets up the product in the slatwall scope, ext
		var keyLocation = listFind(rc.path, setting('product_urlKey'), "/");

		if( keyLocation && keyLocation < listLen(rc.path,"/") ) {
			// Load Product
			getRequestCacheService().setValue("currentProductURLTitle", listGetAt(rc.path, keyLocation+1, "/"));
			var product = getProductService().getProductByURLTitle(getRequestCacheService().getValue("currentProductURLTitle"));
			
			// If Product Exists, is Active, and is published then put the product in the slatwall scope and setup product template for muras contentBean to be loaded later
			if(!isNull(product)) {
				getRequestCacheService().setValue("currentProduct", product);
				getRequestCacheService().setValue("currentProductID", product.getProductID());
				rc.$.event('slatAction', 'frontend:product.detail');
				rc.$.event('contentBean', getContentManager().getActiveContentByFilename(product.getSetting('displayTemplate'), rc.$.event('siteid'), true));
				
				// Check if this came from a product listing page and setup the base crumb list array
				if( keyLocation gt 2) {
					var listingPageFilename = left(rc.path, find("/#setting('product_urlKey')#/", rc.path)-1);
					listingPageFilename = replace(listingPageFilename, "/#$.event('siteID')#/", "", "all");
					getRequestCacheService().setValue("currentListingPageOfProduct", getContentManager().getActiveContentByFilename(listingPageFilename, rc.$.event('siteid'), true));
					var crumbDataArray = getRequestCacheService().getValue("currentListingPageOfProduct").getCrumbArray();
				} else {
					var crumbDataArray = getContentManager().getCrumbList(contentID="00000000000000000000000000000000001", siteID=rc.$.event('siteID'), setInheritance=false, path="00000000000000000000000000000000001", sort="asc");
				}
				
				// add the product to the base crumb list array
				arrayPrepend(crumbDataArray, product.getCrumbData(path=rc.path, siteID=$.event('siteID'), baseCrumbArray=crumbDataArray));
				
				// Push the new crumb list into the event
				rc.$.event('crumbdata', crumbDataArray);
			}	
		}
	}
	
	public void function onRenderStart(required any rc) {
		// This checks for Product Listing Pages
		if( rc.$.event('slatAction') == "") {
			if( rc.$.content().getSubType() == "SlatwallProductListing" ) {
				rc.$.event("slatAction", "frontend:product.listcontentproducts");
				if(!structKeyExists(form, "P:Show") && !structKeyExists(url, "P:Show")) {
					rc.$.slatwall.productList().setPageRecordsShow(rc.$.content('productsPerPage'));	
				}
			// Checks for shopping cart
			} else if (rc.$.content('filename') == 'shopping-cart') {
				rc.$.event("slatAction", "frontend:cart.detail");
				
			// Checks for Checkout page
			} else if (rc.$.content('filename') == 'checkout') {
				rc.$.event("slatAction", "frontend:checkout.detail");
				
			// Checks for My-Account page
			} else if (rc.$.content('filename') == 'my-account') {
				rc.$.event("slatAction", "frontend:account.detail");
				
			// Checks for Order Status page
			} else if (rc.$.content('filename') == 'order-status') {
				rc.$.event("slatAction", "frontend:order.detail");
				
			// Checks for Order Confirmation page
			} else if (rc.$.content('filename') == 'order-confirmation') {
				rc.$.event("slatAction", "frontend:order.confirmation");

			}
		}
	}
	
	public void function onRenderEnd(required any rc) {
		
		// Add necessary html to the header
		if( getFW().secureDisplay("admin:main.default") ){
			var oldContent = rc.$.event( "__MuraResponse__" );
			var newContent = Replace(oldContent, "</head>", "#getFW().view("admin:toolbar/menu")#</head>");
			rc.$.event("__MuraResponse__", newContent);
		}
	}
	
	public void function onAfterPageSlatwallProductListingSave(required any rc) {
		getProductService().updateProductContentPaths(contentID=rc.$.content("contentID"), siteID=rc.$.event('siteID'));
	}
	
	public void function onAfterPageSlatwallProductListingDelete(required any rc) {
		getProductService().deleteProductContent(rc.$.content("contentID"));
	}
	
	public void function onAfterCategoryUpdate(required any rc) {
		getProductService().updateProductCategoryPaths(categoryID=rc.$.event("categoryID"), siteID=rc.$.event('siteID'));
	}
	
	public void function onAfterCategoryDelete(required any rc) {
		getProductService().deleteProductCategory(rc.$.event("categoryID"));
	}
	
}
