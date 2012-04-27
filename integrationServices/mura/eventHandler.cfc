component extends="mura.plugin.pluginGenericEventHandler" {

	// On Application Load, we can clear the slatwall application key and register all of the methods in this eventHandler with the config
	public void function onApplicationLoad() {
		
		// Set this object as an event handler
		variables.pluginConfig.addEventHandler(this);
		
		// Load the Slatwall Application if Mura Reloads
		getSlatwallFW1Application().onApplicationStart();
		
		// Setup slatwall as not initialized so that it loads on next request
		application.slatwall.initialized = false;
		
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
				$.content('body', $.content('body') & doAction('frontend:product.detail'));
				$.content().setTitle( $.slatwall.getCurrentProduct().getTitle() );
				$.content().setHTMLTitle( $.slatwall.getCurrentProduct().getTitle() );
				
			} else if ( productTypeKeyLocation && productTypeKeyLocation > brandKeyLocation && !$.slatwall.getCurrentProductType().isNew() && $.slatwall.getCurrentProductType().getActiveFlag() && $.slatwall.getCurrentProductType().getPublishedFlag() ) {
				$.slatwall.setCurrentContent($.slatwall.getService("contentService").getContent($.slatwall.getCurrentProductType().setting('productTypeDisplayTemplate')));
				$.event('contentBean', $.getBean("content").loadBy(contentID=$.slatwall.getCurrentContent().getCMSContentID()) );
				$.content('body', $.content('body') & doAction('frontend:producttype.detail'));
				$.content().setTitle( $.slatwall.getCurrentProductType().getTitle() );
				$.content().setHTMLTitle( $.slatwall.getCurrentProductType().getTitle() );
				
			} else if ( brandKeyLocation && !$.slatwall.getCurrentBrand().isNew() && $.slatwall.getCurrentBrand().getActiveFlag() && $.slatwall.getCurrentProductType().getPublishedFlag()  ) {
				$.slatwall.setCurrentContent($.slatwall.getService("contentService").getContent($.slatwall.getCurrentBrand().setting('brandDisplayTemplate')));
				$.event('contentBean', $.getBean("content").loadBy(contentID=$.slatwall.getCurrentContent().getCMSContentID()) );
				$.content('body', $.content('body') & doAction('frontend:brand.detail'));
				$.content().setTitle( $.slatwall.getCurrentBrand().getTitle() );
				$.content().setHTMLTitle( $.slatwall.getCurrentBrand().getTitle() );
			}
		}
	}
	
	// At the end of a frontend request, we call the endLifecycle
	public any function onSiteRequestEnd(required any $) {
		getSlatwallFW1Application().endSlatwallLifecycle();
	}
	
	// display slatwall link in mura left nav
	public any function onAdminModuleNav(required any $) {
		return '<li><a href="' & application.configBean.getContext() & '/plugins/Slatwall">Slatwall</a></li>';
	}
	
	// Hook into the onRender start so that we can do any slatActions that might have been called, or if the current content is a listing page
	public any function onRenderStart(required any $) {
		// check if user has access to this page
		checkAccess($);
				
		// Now that there is a mura contentBean in the muraScope for sure, we can setup our currentContent Variable
		$.slatwall.setCurrentContent( $.slatwall.getService("contentService").getContentByCMSContentID($.content('contentID')) );
		
		// Check for any slatActions that might have been passed in and render that page as the first
		if(len($.event('slatAction'))) {
			$.content('body', $.content('body') & doAction($.event('slatAction')));
			
		// If no slatAction was passed in, then check for keys in mura to determine what page to render
		} else {
			// Check to see if the current content is a listing page, so that we add our frontend view to the content body
			if(isBoolean($.slatwall.getCurrentContent().setting('contentProductListingFlag')) && $.slatwall.getCurrentContent().setting('contentProductListingFlag')) {
				$.content('body', $.content('body') & doAction('frontend:product.listcontentproducts'));
			}
			
			// Render any of the 'special' pages that might need to be rendered
			if($.content('filename') == $.slatwall.setting('globalPageShoppingCart')) {
				$.content('body', $.content('body') & doAction('frontend:cart.detail'));
			} else if($.content('filename') == $.slatwall.setting('globalPageOrderStatus')) {
				$.content('body', $.content('body') & doAction('frontend:order.detail'));
			} else if($.content('filename') == $.slatwall.setting('globalPageOrderConfirmation')) {
				$.content('body', $.content('body') & doAction('frontend:order.confirmation'));
			} else if($.content('filename') == $.slatwall.setting('globalPageMyAccount')) {
				// Checks for My-Account page
				if($.event('showitem') != ""){
					$.content('body', $.content('body') & doAction('frontend:account.#$.event("showitem")#'));
				} else {
					$.content('body', $.content('body') & doAction('frontend:account.detail'));
				}
			} else if($.content('filename') == $.slatwall.setting('globalPageCreateAccount')) {
				$.content('body', $.content('body') & doAction('frontend:account.create'));
			} else if($.content('filename') == $.slatwall.setting('globalPageCheckout')) {
				$.content('body', $.content('body') & doAction('frontend:checkout.detail'));
			}
		}
		
	}
	
	// on category save, create/update the category in slatwall
	public void function onAfterCategorySave(required any $) {
		startSlatwallAdminRequest($);
				
		var categoryBean = $.event("categoryBean");
		var category = $.slatwall.getService("contentService").getCategoryByCmsCategoryID(categoryBean.getCategoryID(),true);
		var parentCategory = $.slatwall.getService("contentService").getCategoryByCmsCategoryID(categoryBean.getParentID());
		if(!isNull(parentCategory)) {
			category.setParentCategory(parentCategory);
		}
		category.setCategoryName(categoryBean.getName());
		category.setCmsSiteID($.event('siteID'));
		category.setCmsCategoryID(categoryBean.getCategoryID());
		category = $.slatwall.getService("contentService").saveCategory(category);
		
		endSlatwallAdminRequest($);
	}
	
	// on category delete, try to delete slatwall category
	public void function onAfterCategoryDelete(required any $) {
		startSlatwallAdminRequest($);
		
		var category = $.slatwall.getService("contentService").getCategoryByCmsCategoryID($.event("categoryID"),true);
		if(!category.isNew() && category.isDeletable()) {
			$.slatwall.getService("contentService").deleteCategory(category);
		}
		
		endSlatwallAdminRequest($);
	}
	
	public void function onContentEdit(required any $) {
		startSlatwallAdminRequest($);
		include "onContentEdit.cfm";
		endSlatwallAdminRequest($);
	}
	
	public void function onAfterContentSave(required any $) {
		startSlatwallAdminRequest($);
		
		if(!structKeyExists($.getEvent().getAllValues(),"slatwallData")) {
			return;
		}
		var slatwallData = $.getEvent().getAllValues().slatwallData;
		var slatwallContent = saveSlatwallPage($);
		if(!isNull(slatwallContent) && slatwallData.allowPurchaseFlag) {
			if(slatwallData.addSku){
				saveSlatwallProduct($,slatwallContent);
			}
		} else {
			deleteContentSkus($);
		}
		
		endSlatwallAdminRequest($);
	}
	
	public void function onAfterContentDelete(required any $) {
		startSlatwallAdminRequest($);
		
		deleteContentSkus($);
		deleteSlatwallPage($);
		
		endSlatwallAdminRequest($);
	}
	
	
	// ========================== Private Helper Methods ==============================
	
	// Helper Method for doAction()
	private string function doAction(required any action) {
		if(!structKeyExists(url, "$")) {
			url.$ = request.muraScope;
		}
		return getSlatwallFW1Application().doAction(arguments.action);
	}
	
	// Helper method to get the Slatwall Application
	private any function getSlatwallFW1Application() {
		if(!structKeyExists(request, "slatwallFW1Application")) {
			request.slatwallFW1Application = createObject("component", "Slatwall.Application");
		}
		return request.slatwallFW1Application;
	}
	
	// For admin request start, we call the Slatwall Event Handler that gets the request setup
	private void function startSlatwallAdminRequest(required any $) {
		if(!structKeyExists(request, "slatwallScope")) {
			// Call the Slatwall Event Handler that gets the request setup
			getSlatwallFW1Application().setupGlobalRequest();
					
			// Setup the newly create slatwallScope into the muraScope
			arguments.$.setCustomMuraScopeKey("slatwall", request.slatwallScope);
		
			// Setup structured Data 
			var structuredData = request.slatwallScope.getService("utilityFormService").buildFormCollections($.getEvent().getAllValues());
			if(structCount(structuredData)) {
				for(var key in structuredData) {
					$.event(key,structuredData[key]);
				}
			}
		}
	}
	
	// For admin request end, we call the endLifecycle
	private void function endSlatwallAdminRequest(required any $) {
		getSlatwallFW1Application().endSlatwallLifecycle();
	}
	
	// Helper method to do our access check
	private void function checkAccess(required any $) {
		if(!$.slatwall.getService("accessService").hasAccess($.content('contentID'))){
			
			// Set the content of the current content to noAccess
			$.content('body', doAction('frontend:account.noaccess'));
			
			// save the current content to be used on the barrier page
			$.event("restrictedContent",$.content());
			
			// get the slatwall content
			var slatwallContent = $.slatwall.getService("contentService").getRestrictedContentBycmsContentID($.content("contentID"));
			
			// set slatwallContent in rc to be used on the barrier page
			$.event("slatwallContent",slatwallContent);
			
			// get the barrier page template
			var restrictedContentTemplate = $.slatwall.getService("contentService").getContent(slatwallContent.getSettingDetails('contentRestrictedContentDisplayTemplate').settingvalue);
			
			// set the content to the barrier page template
			if(!isNull(restrictedContentTemplate)) {
				$.event('contentBean', $.getBean("content").loadBy(contentID=restrictedContentTemplate.getCMSContentID()));
			}
		}
	}
	
	private void function saveSlatwallSetting(required any $, required struct settingData, required any slatwallContent) {
		for(var settingName in arguments.settingData) {
			// create new setting if there is data 
			if(arguments.settingData[settingName] != "") {
				var setting = $.slatwall.getService("settingService").getSettingBySettingNameANDcmsContentID([settingName,arguments.slatwallContent.getCmsContentID()],true);
				setting.setSettingName(settingName);
				setting.setSettingValue(arguments.settingData[settingName]);
				//setting.setContent(arguments.slatwallContent);
				setting.setcmsContentID(arguments.slatwallContent.getCmsContentID());
				$.slatwall.getService("settingService").saveSetting(setting);
			}
		}
	}
	
	private any function saveSlatwallPage(required any $) {
		var slatwallData = $.getEvent().getAllValues().slatwallData;
		var slatwallContent = $.slatwall.getService("contentService").getContentByCmsContentID($.content("contentID"),true);
		slatwallContent.setCmsSiteID($.event('siteID'));
		slatwallContent.setCmsContentID($.content("contentID"));
		slatwallContent.setCmsContentIDPath($.content("path"));
		slatwallContent.setTitle($.content("title"));
		var contentRestrictAccessFlag = slatwallContent.getSettingDetails('contentRestrictAccessFlag');
		var contentProductListingFlag = slatwallContent.getSettingDetails('contentProductListingFlag');
		// check if content needs to be saved
		if(slatwallData.templateFlag || slatwallData.setting.contentProductListingFlag != "" || contentProductListingFlag.settingValueFormatted || slatwallData.setting.contentRestrictAccessFlag != "" || contentRestrictAccessFlag.settingValueFormatted || slatwallData.setting.contentRestrictedContentDisplayTemplate != "") {
			// set the parent content
			var parentContent = $.slatwall.getService("contentService").getContentByCmsContentID($.content("parentID"));
			if(!isNull(parentContent)) {
				slatwallContent.setParentContent(parentContent);
			}
			slatwallContent = $.slatwall.getService("contentService").saveContent(slatwallContent,slatwallData);
			// now save all the content settings
			saveSlatwallSetting($,slatwallData.setting,slatwallContent);
			return slatwallContent;
		}
	}
	
	private void function saveSlatwallProduct(required any $, any slatwallContent) {
		var slatwallData = $.getEvent().getAllValues().slatwallData;
		slatwallData.product.accessContents = slatwallContent.getContentID();
		// if sku is selected, related sku to content
		if(slatwallData.product.sku.skuID != "") {
			var sku = $.slatwall.getService("SkuService").getSku(slatwallData.product.sku.skuID, true);
			sku.addAccessContent(slatwallContent);
		} else {
			var product = $.slatwall.getService("ProductService").getProduct(slatwallData.product.productID, true);
			if(product.isNew()){
				// if new product set up required properties
				product.setProductName($.content("title"));
				product.setPublishedFlag($.content("approved"));
				var productType = $.slatwall.getService("ProductService").getProductTypeBySystemCode("contentAccess");
				product.setProductType(productType);
				product.setProductCode(createUUID());
				product.setActiveFlag(1);
				product = $.slatwall.getService("ProductService").saveProduct( product, slatwallData.product );
			} else {
				var newSku = $.slatwall.getService("SkuService").newSku();
				newSku.setPrice(slatwallData.product.price);
				newSku.setProduct(product);
				newSku.addAccessContent( slatwallContent );
				$.slatwall.getService("SkuService").saveSKU( newSku );
			}
		}
		
	}
	
	// Helper method to go in and delete content skus
	private void function deleteContentSkus(required any $) {
		var slatwallContent = $.slatwall.getService("contentService").getContentByCmsContentID($.content("contentID"),true);
		if(!slatwallContent.isNew()) {
			while(arrayLen(slatwallContent.getSkus())){
				var thisSku = slatwallContent.getSkus()[1];
				slatwallContent.removeSku(thisSku);
			}
			$.slatwall.getService("contentService").saveContent(slatwallContent);
		}
	}

	// Helper method to go in and delete a content node that was previously saved in Slatwall. 
	private void function deleteSlatwallPage(required any $) {
		var slatwallContent = $.slatwall.getService("contentService").getContentByCmsContentID($.content("contentID"),true);
		if(!slatwallContent.isNew() && !slatwallContent.isDeletable()) {
			slatwallContent.setCmsContentID("");
			slatwallContent.setCmsContentIDPath("");
			$.slatwall.getService("contentService").saveContent(slatwallContent);
		} else if(!slatwallContent.isNew()) {
			$.slatwall.getService("contentService").deleteContent(slatwallContent);
		}
	}
}

