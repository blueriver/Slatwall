component extends="mura.plugin.pluginGenericEventHandler" {

	private any function getSlatwallFW1Application() {
		if(!structKeyExists(request, "slatwallFW1Application")) {
			request.slatwallFW1Application = createObject("component", "Slatwall.Application");
		}
		return request.slatwallFW1Application;
	}
	
	// On Application Load, we can clear the slatwall application key and register all of the methods in this eventHandler with the config
	public void function onApplicationLoad() {
		
		// Set this object as an event handler
		variables.pluginConfig.addEventHandler(this);
		
		// Load the Slatwall Application if Mura Reloads
		getSlatwallFW1Application().onApplicationStart();
		
		// Setup slatwall as not initialized so that it loads on next request
		application.slatwall.initialized = false;
		
	}
	
	// For admin request start, we call the Slatwall Event Handler that gets the request setup
	public void function onGlobalRequestStart(required any $) {
		getSlatwallFW1Application().setupGlobalRequest();
	}
	
	// For admin request end, we call the endLifecycle
	public void function onGlobalRequestEnd(required any $) {
		getSlatwallFW1Application().endSlatwallLifecycle();
	}
	
	public void function onSiteRequestStart(required any $) {
		
		// Call the Slatwall Event Handler that gets the request setup
		getSlatwallFW1Application().setupGlobalRequest();
		
		// Setup the newly create slatwallScope into the muraScope
		arguments.$.setCustomMuraScopeKey("slatwall", request.slatwallScope);
		
		// If we aren't on the homepage we can do our own URL inspection
		if( len($.event('path')) ) {
			
			// Inspect the path looking for slatwall URL key, and then setup the proper objects in the slatwallScope
			var brandKeyLocation = 0;
			var productKeyLocation = 0;
			var productTypeKeyLocation = 0;
			if (listFindNoCase($.event('path'), $.slatwall.setting('globalURLKeyBrand'), "/")) {
				brandKeyLocation = listFindNoCase($.event('path'), $.slatwall.setting('globalURLKeyBrand'), "/");
				if(brandKeyLocation < listLen($.event('path'),"/")) {
					$.slatwall.setCurrentBrand( $.slatwall.getService("brandService").getBrandByURLTitle(listGetAt($.event('path'), brandKeyLocation + 1, "/"), true) );
				}
			}
			if(listFindNoCase($.event('path'), $.slatwall.setting('globalURLKeyProduct'), "/")) {
				productKeyLocation = listFindNoCase($.event('path'), $.slatwall.setting('globalURLKeyProduct'), "/");
				if(productKeyLocation < listLen($.event('path'),"/")) {
					$.slatwall.setCurrentProduct( $.slatwall.getService("productService").getProductByURLTitle(listGetAt($.event('path'), productKeyLocation + 1, "/"), true) );	
				}
			}
			if (listFindNoCase($.event('path'), $.slatwall.setting('globalURLKeyProductType'), "/")) {
				productTypeKeyLocation = listFindNoCase($.event('path'), $.slatwall.setting('globalURLKeyProductType'), "/");
				if(productTypeKeyLocation < listLen($.event('path'),"/")) {
					$.slatwall.setCurrentProductType( $.slatwall.getService("productService").getProductTypeByURLTitle(listGetAt($.event('path'), productTypeKeyLocation + 1, "/"), true) );
				}
			}
			
			// Setup the proper content node and populate it with our FW/1 view on any keys that might have been found, use whichever key was farthest right
			if( productKeyLocation && productKeyLocation > productTypeKeyLocation && productKeyLocation > brandKeyLocation && !$.slatwall.getCurrentProduct().isNew() && $.slatwall.getCurrentProduct().getActiveFlag() && $.slatwall.getCurrentProduct().getPublishedFlag()) {
				$.slatwall.setCurrentContent($.slatwall.getService("contentService").getContent($.slatwall.getCurrentProduct().setting('productDisplayTemplate')));
				$.event('contentBean', $.getBean("content").loadBy(contentID=$.slatwall.getCurrentContent().getCMSContentID()) );
				$.content('body', $.content('body') & getSlatwallFW1Application().doAction('frontend:product.detail'));
				$.content().setTitle( $.slatwall.getCurrentProduct().getTitle() );
				$.content().setHTMLTitle( $.slatwall.getCurrentProduct().getTitle() );
				
			} else if ( productTypeKeyLocation && productTypeKeyLocation > brandKeyLocation && !$.slatwall.getCurrentProductType().isNew() && $.slatwall.getCurrentProductType().getActiveFlag() && $.slatwall.getCurrentProductType().getPublishedFlag() ) {
				$.slatwall.setCurrentContent($.slatwall.getService("contentService").getContent($.slatwall.getCurrentProductType().setting('productTypeDisplayTemplate')));
				$.event('contentBean', $.getBean("content").loadBy(contentID=$.slatwall.getCurrentContent().getCMSContentID()) );
				$.content('body', $.content('body') & getSlatwallFW1Application().doAction('frontend:producttype.detail'));
				$.content().setTitle( $.slatwall.getCurrentProductType().getTitle() );
				$.content().setHTMLTitle( $.slatwall.getCurrentProductType().getTitle() );
				
			} else if ( brandKeyLocation && !$.slatwall.getCurrentBrand().isNew() && $.slatwall.getCurrentBrand().getActiveFlag() && $.slatwall.getCurrentProductType().getPublishedFlag()  ) {
				$.slatwall.setCurrentContent($.slatwall.getService("contentService").getContent($.slatwall.getCurrentBrand().setting('brandDisplayTemplate')));
				$.event('contentBean', $.getBean("content").loadBy(contentID=$.slatwall.getCurrentContent().getCMSContentID()) );
				$.content('body', $.content('body') & getSlatwallFW1Application().doAction('frontend:brand.detail'));
				$.content().setTitle( $.slatwall.getCurrentBrand().getTitle() );
				$.content().setHTMLTitle( $.slatwall.getCurrentBrand().getTitle() );
			}
		}
	}
	
	// At the end of a frontend request, we call the endLifecycle
	public any function onSiteRequestEnd(required any $) {
		getSlatwallFW1Application().endSlatwallLifecycle();
	}
	
	// Hook into the onRender start so that we can do any slatActions that might have been called
	public any function onRenderStart(required any $) {
		if(len($.event('slatAction'))) {
			writeDump($.event('slatAction'));
			abort;
			$.content('body', $.content('body') & getSlatwallFW1Application().doAction($.event('slatAction')));
		}
	}
	
	public void function onContentEdit(required any $) { 
		include "onContentEdit.cfm";
	}
	
	
}