component extends="mura.plugin.pluginGenericEventHandler" {
	
	// On Application Load, we can clear the slatwall application key and register all of the methods in this eventHandler with the config
	public void function onApplicationLoad() {
		
		// Set this object as an event handler
		variables.pluginConfig.addEventHandler(this);
		
		// Setup slatwall as not initialized so that it loads on next request
		application.slatwall.initialized = false;
		
	}
	
	public void function onSiteRequestStart(required any $) {
		
		getFW().setupGlobalRequest();
		
		/*
		request.custommurascopekeys.slatwall = request.slatwallScope;
		
		
		if( len($.event('path')) ) {
			var keyLocation = listFind($.event('path'), request.slatwallScope.setting('globalURLKeyProduct'), "/");
			
			if( keyLocation && keyLocation < listLen($.event('path'),"/") ) {
				
			}
		}
		
		
		// Make sure that there is a path key in the rc first
		if(structKeyExists(arguments.rc, "path")) {
			// This hook is what enables SEO friendly product URL's... It is also what sets up the product in the slatwall scope, ext
			
			
			if( keyLocation && keyLocation < listLen(rc.path,"/") ) {
				// Load Product
				getRequestCacheService().setValue("currentProductURLTitle", listGetAt(rc.path, keyLocation+1, "/"));
				var product = getProductService().getProductByURLTitle(getRequestCacheService().getValue("currentProductURLTitle"));
				
				// If Product Exists, is Active, and is published then put the product in the slatwall scope and setup product template for muras contentBean to be loaded later
				if(!isNull(product) && product.getActiveFlag() && product.getPublishedFlag()) {
					getRequestCacheService().setValue("currentProduct", product);
					getRequestCacheService().setValue("currentProductID", product.getProductID());
					rc.$.event('slatAction', 'frontend:product.detail');
					rc.$.event('contentBean', getContentManager().getActiveContentByFilename(product.setting('productDisplayTemplate'), rc.$.event('siteid'), true));
					
					// Check if this came from a product listing page and setup the base crumb list array
					if( keyLocation gt 2) {
						var listingPageFilename = left(rc.path, find("/#setting('globalURLKeyProduct')#/", rc.path)-1);
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
		*/
	}
	
	
	
	// ============ Start: Helpers ================
	private void function doAction() {
		
	}
	
	private any function getFW() {
		if(!structKeyExists(application, "slatwall") || !structKeyExists(application.slatwall, "fw")) {
			application.slatwall = {};
			application.slatwall.fw = createObject("component", "Slatwall.Application");
		}
		return application.slatwall.fw;
	}
}