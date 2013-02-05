<cfcomponent extends="Handler">
	<cfscript>
	
		// This method is explicitly called during application reload from the conntector plugins onApplicationLoad() event
		public void function verifySetup( required any $ ) {
			var assignedSitesQuery = getPluginConfig().getAssignedSites();
			var populatedSiteIDs = getPluginConfig().getCustomSetting("populatedSiteIDs");
			
			var integration = getSlatwallScope().getService("integrationService").getIntegrationByIntegrationPackage("mura");
			if(!integration.getFW1ActiveFlag()) {
				integration.setFW1ActiveFlag(1);
				var ehArr = integration.getIntegrationCFC().getEventHandlers();
				for(var e=1; e<=arrayLen(ehArr); e++) {
					getSlatwallScope().getService("hibachiEventService").registerEventHandler(ehArr[e]);
				}
			}
			
			for(var i=1; i<=assignedSitesQuery.recordCount; i++) {
				var cmsSiteID = assignedSitesQuery["siteid"][i];
				var siteDetails = $.getBean("settingsBean").loadBy(siteID=cmsSiteID);
				var cmsSiteName = siteDetails.getSite();
				var cmsThemeName = siteDetails.getTheme();
				
				// First lets verify that this site exists on the Slatwall site
				var slatwallSite = getSlatwallScope().getService("siteService").getSiteByCMSSiteID( cmsSiteID, true );
				
				// If this is a new site, then we can set the site name
				if(slatwallSite.isNew()) {
					slatwallSite.setSiteName( cmsSiteName );
					getSlatwallScope().getService("siteService").saveSite( slatwallSite );
					slatwallSite.setCMSSiteID( cmsSiteID );
					ormFlush();
				}
				
				// If the plugin is set to create default pages, and this siteID has not been populated then we need to populate it with pages & templates
				if(getPluginConfig().getSetting("createDefaultPages") && !listFindNoCase(populatedSiteIDs, cmsSiteID)) {
					
					// Copy views over to the template directory
					var slatwallTemplatePath = getDirectoryFromPath(expandPath("/Slatwall/public/views/templates")); 
					var muraTemplatePath = getDirectoryFromPath(expandPath("/muraWRM/#cmsSiteID#/includes/themes/#cmsThemeName#/templates"));
					getSlatwallScope().getService("hibachiUtilityService").duplicateDirectory(source=slatwallTemplatePath, destination=muraTemplatePath, overwrite=false, recurse=true, copyContentExclusionList=".svn,.git");
					
					// Create the necessary pages
					var productListingCMSID = createMuraPage( $=arguments.$, muraSiteID=cmsSiteID, pageName="Product Listing", filename="product-listing", template="slatwall-productlisting.cfm", isNav="0" );
					var shoppingCartCMSID = createMuraPage( $=arguments.$, muraSiteID=cmsSiteID, pageName="Shopping Cart", filename="shopping-cart", template="slatwall-shoppingcart.cfm", isNav="1" );
					var orderStatusCMSID = createMuraPage( $=arguments.$, muraSiteID=cmsSiteID, pageName="Order Status", filename="order-status", template="slatwall-orderstatus.cfm", isNav="1" );
					var orderConfirmationCMSID = createMuraPage( $=arguments.$, muraSiteID=cmsSiteID, pageName="Order Confirmation", filename="order-confirmation", template="slatwall-orderconfirmation.cfm", isNav="0" );
					var checkoutCMSID = createMuraPage( $=arguments.$, muraSiteID=cmsSiteID, pageName="Checkout", filename="checkout", template="slatwall-checkout.cfm", isNav="1" );
					var accountCMSID = createMuraPage( $=arguments.$, muraSiteID=cmsSiteID, pageName="My Account", filename="my-account", template="slatwall-account.cfm", isNav="1" );
					var productTemplateCMSID = createMuraPage( $=arguments.$, muraSiteID=cmsSiteID, pageName="Product Template", filename="product-template", template="slatwall-product.cfm", isNav="0" );
					var productTypeTemplateCMSID = createMuraPage( $=arguments.$, muraSiteID=cmsSiteID, pageName="Product Type Template", filename="producttype-template", template="slatwall-producttype.cfm", isNav="0" );
					var brandTemplateCMSID = createMuraPage( $=arguments.$, muraSiteID=cmsSiteID, pageName="Brand Template", filename="brand-template", template="slatwall-brand.cfm", isNav="0" );
					
					// Now that it has been populated we can add the siteID to the populated site id's list
					getPluginConfig().setCustomSetting("populatedSiteIDs", listAppend(populatedSiteIDs, cmsSiteID));
				}
				
				// Sync all missing content for the siteID
				syncMuraContent( $=arguments.$, slatwallSite=slatwallSite, muraSiteID=cmsSiteID );
				
				// Sync all missing categories
				syncMuraCategories( $=arguments.$, slatwallSite=slatwallSite, muraSiteID=cmsSiteID );
				
				// Sync all missing accounts
				syncMuraAccounts( accountSyncType=getPluginConfig().getSetting("accountSyncType"), superUserSyncFlag=getPluginConfig().getSetting("superUserSyncFlag") );
				
			}
		}
		
		private void function verifyLoginLogout(required any $) {
			// Check to see if the current mura user is logged in (or logged out), and if we should automatically login/logout the slatwall account
			if( getPluginConfig().getSetting("accountSyncType") != "none"
					&& !getSlatwallScope().getLoggedInFlag()
					&& $.currentUser().isLoggedIn()
					&& (
						getPluginConfig().getSetting("accountSyncType") == "all"
						|| (getPluginConfig().getSetting("accountSyncType") == "systemUserOnly" && $.currentUser().getUserBean().getType() eq 2) 
						|| (getPluginConfig().getSetting("accountSyncType") == "siteUserOnly" && $.currentUser().getUserBean().getType() eq 1)
					)) {
			
				loginCurrentMuraUser($);
			} else if (getSlatwallScope().getLoggedInFlag()
					&& !$.currentUser().isLoggedIn()
					&& !isNull(getSlatwallScope().getSession().getAccountAuthentication().getIntegration())
					&& getSlatwallScope().getSession().getAccountAuthentication().getIntegration().getIntegrationPackage() eq "mura") {
			
				logoutCurrentMuraUser($);
			}
		}
		
		// ========================== FRONTENT EVENT HOOKS =================================
		
		public void function onSiteRequestStart(required any $) {
			// Call the Slatwall Event Handler that gets the request setup
			getSlatwallApplication().setupGlobalRequest();
			
			// Setup the newly create slatwallScope into the muraScope
			arguments.$.setCustomMuraScopeKey("slatwall", request.slatwallScope);
			
			// Update Login / Logout if needed
			verifyLoginLogout($=arguments.$);
			
			// If we aren't on the homepage we can do our own URL inspection
			if( len($.event('path')) ) {
				
				// Inspect the path looking for slatwall URL key, and then setup the proper objects in the slatwallScope
				var brandKeyLocation = 0;
				var productKeyLocation = 0;
				var productTypeKeyLocation = 0;
				if (listFindNoCase($.event('path'), getSlatwallScope().setting('globalURLKeyBrand'), "/")) {
					brandKeyLocation = listFindNoCase($.event('path'), getSlatwallScope().setting('globalURLKeyBrand'), "/");
					if(brandKeyLocation < listLen($.event('path'),"/")) {
						getSlatwallScope().setCurrentBrand( getSlatwallScope().getService("brandService").getBrandByURLTitle(listGetAt($.event('path'), brandKeyLocation + 1, "/"), true) );
					}
				}
				if(listFindNoCase($.event('path'), getSlatwallScope().setting('globalURLKeyProduct'), "/")) {
					productKeyLocation = listFindNoCase($.event('path'), getSlatwallScope().setting('globalURLKeyProduct'), "/");
					if(productKeyLocation < listLen($.event('path'),"/")) {
						getSlatwallScope().setCurrentProduct( getSlatwallScope().getService("productService").getProductByURLTitle(listGetAt($.event('path'), productKeyLocation + 1, "/"), true) );	
					}
				}
				if (listFindNoCase($.event('path'), getSlatwallScope().setting('globalURLKeyProductType'), "/")) {
					productTypeKeyLocation = listFindNoCase($.event('path'), getSlatwallScope().setting('globalURLKeyProductType'), "/");
					if(productTypeKeyLocation < listLen($.event('path'),"/")) {
						getSlatwallScope().setCurrentProductType( getSlatwallScope().getService("productService").getProductTypeByURLTitle(listGetAt($.event('path'), productTypeKeyLocation + 1, "/"), true) );
					}
				}
				
				// Setup the proper content node and populate it with our FW/1 view on any keys that might have been found, use whichever key was farthest right
				if( productKeyLocation && productKeyLocation > productTypeKeyLocation && productKeyLocation > brandKeyLocation && !getSlatwallScope().getCurrentProduct().isNew() && getSlatwallScope().getCurrentProduct().getActiveFlag() && (getSlatwallScope().getCurrentProduct().getPublishedFlag() || getSlatwallScope().getCurrentProduct().setting('productShowDetailWhenNotPublishedFlag'))) {
					getSlatwallScope().setCurrentContent(getSlatwallScope().getService("contentService").getContent(getSlatwallScope().getCurrentProduct().setting('productDisplayTemplate')));
					$.event('contentBean', $.getBean("content").loadBy(contentID=getSlatwallScope().getCurrentContent().getCMSContentID()) );
					$.content('body', $.content('body') & doAction('frontend:product.detail'));
					$.content().setTitle( getSlatwallScope().getCurrentProduct().getTitle() );
					$.content().setHTMLTitle( getSlatwallScope().getCurrentProduct().getTitle() );
					
					
					// Setup CrumbList
					if(productKeyLocation > 2) {
						var listingPageFilename = left($.event('path'), find("/#getSlatwallScope().setting('globalURLKeyProduct')#/", $.event('path'))-1);
						listingPageFilename = replace(listingPageFilename, "/#$.event('siteID')#/", "", "all");
						var crumbDataArray = $.getBean("contentManager").getActiveContentByFilename(listingPageFilename, $.event('siteid'), true).getCrumbArray();
					} else {
						var crumbDataArray = $.getBean("contentManager").getCrumbList(contentID="00000000000000000000000000000000001", siteID=$.event('siteID'), setInheritance=false, path="00000000000000000000000000000000001", sort="asc");
					}
					arrayPrepend(crumbDataArray, getSlatwallScope().getCurrentProduct().getCrumbData(path=$.event('path'), siteID=$.event('siteID'), baseCrumbArray=crumbDataArray));
					$.event('crumbdata', crumbDataArray);
					
				} else if ( productTypeKeyLocation && productTypeKeyLocation > brandKeyLocation && !getSlatwallScope().getCurrentProductType().isNew() && getSlatwallScope().getCurrentProductType().getActiveFlag() ) {
					getSlatwallScope().setCurrentContent(getSlatwallScope().getService("contentService").getContent(getSlatwallScope().getCurrentProductType().setting('productTypeDisplayTemplate')));
					$.event('contentBean', $.getBean("content").loadBy(contentID=getSlatwallScope().getCurrentContent().getCMSContentID()) );
					$.content('body', $.content('body') & doAction('frontend:producttype.detail'));
					$.content().setTitle( getSlatwallScope().getCurrentProductType().getProductTypeName() );
					$.content().setHTMLTitle( getSlatwallScope().getCurrentProductType().getProductTypeName() );
					
				} else if ( brandKeyLocation && !getSlatwallScope().getCurrentBrand().isNew() && getSlatwallScope().getCurrentBrand().getActiveFlag()  ) {
					getSlatwallScope().setCurrentContent(getSlatwallScope().getService("contentService").getContent(getSlatwallScope().getCurrentBrand().setting('brandDisplayTemplate')));
					$.event('contentBean', $.getBean("content").loadBy(contentID=getSlatwallScope().getCurrentContent().getCMSContentID()) );
					$.content('body', $.content('body') & doAction('frontend:brand.detail'));
					$.content().setTitle( getSlatwallScope().getCurrentBrand().getBrandName() );
					$.content().setHTMLTitle( getSlatwallScope().getCurrentBrand().getBrandName() );
				}
			}
		}
		
		public void function onSiteRequestEnd(required any $) {
			getSlatwallApplication().endHibachiLifecycle();
		}
		
		public void function onRenderStart(required any $) {
			
			// Now that there is a mura contentBean in the muraScope for sure, we can setup our currentContent Variable
			getSlatwallScope().setCurrentContent( getSlatwallScope().getService("contentService").getContentByCMSContentID($.content('contentID')) );
			
			// check if user has access to this page
			checkAccess($);
					
			// Check for any slatActions that might have been passed in and render that page as the first
			if(len($.event('slatAction'))) {
				$.content('body', $.content('body') & doAction($.event('slatAction')));
				
			// If no slatAction was passed in, then check for keys in mura to determine what page to render
			} else {
				// Check to see if the current content is a listing page, so that we add our frontend view to the content body
				if(isBoolean(getSlatwallScope().getCurrentContent().setting('contentProductListingFlag')) && getSlatwallScope().getCurrentContent().setting('contentProductListingFlag')) {
					$.content('body', $.content('body') & doAction('frontend:product.listcontentproducts'));
				}
				
				// Render any of the 'special' pages that might need to be rendered
				if($.content('filename') == getSlatwallScope().setting('globalPageShoppingCart')) {
					$.content('body', $.content('body') & doAction('frontend:cart.detail'));
				} else if($.content('filename') == getSlatwallScope().setting('globalPageOrderStatus')) {
					$.content('body', $.content('body') & doAction('frontend:order.detail'));
				} else if($.content('filename') == getSlatwallScope().setting('globalPageOrderConfirmation')) {
					$.content('body', $.content('body') & doAction('frontend:order.confirmation'));
				} else if($.content('filename') == getSlatwallScope().setting('globalPageMyAccount')) {
					// Checks for My-Account page
					if($.event('showitem') != ""){
						$.content('body', $.content('body') & doAction('frontend:account.#$.event("showitem")#'));
					} else {
						$.content('body', $.content('body') & doAction('frontend:account.detail'));
					}
				} else if($.content('filename') == getSlatwallScope().setting('globalPageCreateAccount')) {
					$.content('body', $.content('body') & doAction('frontend:account.create'));
				} else if($.content('filename') == getSlatwallScope().setting('globalPageCheckout')) {
					$.content('body', $.content('body') & doAction('frontend:checkout.detail'));
				}
			}
		}
		
		public void function onRenderEnd(required any $) {
			if(len(getSlatwallScope().getCurrentAccount().getAllPermissions())) {
				// Set up frontend tools
				var fetools = "";
				savecontent variable="fetools" {
					include "/Slatwall/assets/fetools/fetools.cfm";
				};
				
				$.event('__muraresponse__', replace($.event('__muraresponse__'), '</body>', '#fetools#</body>'));
			}
		}
		
		public void function onSiteLoginSuccess(required any $) {
			if(!structKeyExists($, "slatwall")) {
				startSlatwallAdminRequest($);
				verifyLoginLogout($=arguments.$);
				endSlatwallAdminRequest($);
			} else {
				verifyLoginLogout($=arguments.$);	
			}
		}
		
		public void function onAfterSiteLogout(required any $) {
			if(!structKeyExists($, "slatwall")) {
				startSlatwallAdminRequest($);
				verifyLoginLogout($=arguments.$);
				endSlatwallAdminRequest($);
			} else {
				verifyLoginLogout($=arguments.$);	
			}
		}
		
		// ========================== ADMIN EVENT HOOKS =================================
		
		// LOGIN / LOGOUT EVENTS
		
		public void function onGlobalLoginSuccess(required any $) {
			startSlatwallAdminRequest($);
			verifyLoginLogout($=arguments.$);
			endSlatwallAdminRequest($);
		}
		public void function onAfterGlobalLogout(required any $) {
			startSlatwallAdminRequest($);
			verifyLoginLogout($=arguments.$);
			endSlatwallAdminRequest($);
		}
		
		// RENDERING EVENTS
		/*
		public string function onContentTabBasicBottomRender(required any $) {
			writeLog(file="Slatwall", text="Mura Integration - onContentTabBasicBottomRender()");
			return "<div>This is my content</div>";
		}
		*/
		
		public void function onContentEdit(required any $) {
			startSlatwallAdminRequest($);
			writeOutput("EDIT SETTINGS HERE");
			endSlatwallAdminRequest($);
		}
		
		
		// SAVE / DELETE EVENTS
		
		public void function onAfterCategorySave(required any $) {
			startSlatwallAdminRequest($);
					
			var categoryBean = $.event("categoryBean");
			var category = getSlatwallScope().getService("contentService").getCategoryByCmsCategoryID(categoryBean.getCategoryID(),true);
			var parentCategory = getSlatwallScope().getService("contentService").getCategoryByCmsCategoryID(categoryBean.getParentID());
			if(!isNull(parentCategory)) {
				category.setParentCategory(parentCategory);
			}
			category.setCategoryName(categoryBean.getName());
			category.setCmsSiteID($.event('siteID'));
			category.setCmsCategoryID(categoryBean.getCategoryID());
			category = getSlatwallScope().getService("contentService").saveCategory(category);
			
			endSlatwallAdminRequest($);
		}
		
		public void function onAfterCategoryDelete(required any $) {
			startSlatwallAdminRequest($);
			
			var category = getSlatwallScope().getService("contentService").getCategoryByCmsCategoryID($.event("categoryID"),true);
			if(!category.isNew() && category.isDeletable()) {
				getSlatwallScope().getService("contentService").deleteCategory(category);
			}
			
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
		
		public void function onAfterUserSave(required any $) {
			startSlatwallAdminRequest($);
			
			// TODO: Update Slatwall User
			
			endSlatwallAdminRequest($);
		}
		
		public void function onAfterUserDelete(required any $) {
			startSlatwallAdminRequest($);
			
			// TODO: Delete Slatwall User
			
			endSlatwallAdminRequest($);
		}
		
		// ========================== Private Helper Methods ==============================
		
		// Helper method to do our access check
		private void function checkAccess(required any $) {
			if(!getSlatwallScope().getService("accessService").hasAccess($.content('contentID'))){
				
				// save the current content to be used on the barrier page
				$.event("restrictedContent",$.content());
				
				// save the current content to be used on the barrier page
				$.event("restrictedContentBody",$.content('body'));
				
				// Set the content of the current content to noAccess
				$.content('body', doAction('frontend:account.noaccess'));
				
				// get the slatwall content
				var slatwallContent = getSlatwallScope().getService("contentService").getRestrictedContentBycmsContentID($.content("contentID"));
				
				// set slatwallContent in rc to be used on the barrier page
				$.event("slatwallContent",slatwallContent);
				
				// get the barrier page template
				var restrictedContentTemplate = getSlatwallScope().getService("contentService").getContent(slatwallContent.getSettingDetails('contentRestrictedContentDisplayTemplate').settingvalue);
				
				// set the content to the barrier page template
				if(!isNull(restrictedContentTemplate)) {
					$.event('contentBean', $.getBean("content").loadBy(contentID=restrictedContentTemplate.getCMSContentID()));
				}
			}
		}
		
	</cfscript>
	
	<!--- ========================== Private Logic Helpers ============================== --->
	<cffunction name="createMuraPage">
		<cfargument name="$" type="any" required="true" />
		<cfargument name="muraSiteID" type="string" required="true" />
		<cfargument name="pageName" type="string" required="true" />
		<cfargument name="filename" type="string" required="true" />
		<cfargument name="template" type="string" required="true" />
		<cfargument name="isNav" type="numeric" required="true" />
		
		<cfset var thisPage = $.getBean("contentManager").getActiveContentByFilename(filename=arguments.filename, siteid=arguments.muraSiteID) />
		<cfif thisPage.getIsNew()>
			<cfset thisPage.setDisplayTitle(arguments.pageName) />
			<cfset thisPage.setHTMLTitle(arguments.pageName) />
			<cfset thisPage.setMenuTitle(arguments.pageName) />
			<cfset thisPage.setIsNav(arguments.isNav) />
			<cfset thisPage.setActive(1) />
			<cfset thisPage.setApproved(1) />
			<cfset thisPage.setIsLocked(0) />
			<cfset thisPage.setParentID("00000000000000000000000000000000001") />
			<cfset thisPage.setFilename(arguments.filename) />
			<cfset thisPage.setSiteID(arguments.muraSiteID) />
			<cfset thisPage.save() />
		</cfif>
		
		<cfreturn thisPage.getContentID() />
	</cffunction>
	
	<cffunction name="syncMuraContent">
		<cfargument name="$" type="any" required="true" />
		<cfargument name="slatwallSite" type="any" required="true" />
		<cfargument name="muraSiteID" type="string" required="true" />
		
		<cfset var parentMappingCache = {} />
		<cfset var missingContentQuery = "" />
		
		<cfquery name="missingContentQuery">
			SELECT
				tcontent.contentID,
				tcontent.parentID,
				tcontent.menuTitle
			FROM
				tcontent
			WHERE
				tcontent.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
			  AND
			  	tcontent.type NOT IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="Module,Plugin" list="true" />)
			  AND
				NOT EXISTS( SELECT contentID FROM SlatwallContent WHERE SlatwallContent.cmsContentID = tcontent.contentID)
			ORDER BY
				LENGTH(tcontent.path)
		</cfquery>
		
		<cfset var allParentsFound = true />
		<cfloop query="missingContentQuery">
			
			<cfset var rs = "" />
			
			<!--- Creating Home Page --->
			<cfif missingContentQuery.parentID eq "00000000000000000000000000000000END">
				<cfset var newContentID = getSlatwallScope().createHibachiUUID() />
				<cfquery name="rs">
					INSERT INTO SlatwallContent (
						contentID,
						contentIDPath,
						activeFlag,
						siteID,
						cmsContentID,
						title
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#newContentID#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#newContentID#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="1" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.slatwallSite.getSiteID()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingContentQuery.contentID#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingContentQuery.menuTitle#" />
					)
				</cfquery>
			<!--- Creating Internal Page, or resetting if parent can't be found --->	
			<cfelse>
				
				<cfif not structKeyExists(parentMappingCache, missingContentQuery.parentID)>
					<cfset var parentContentQuery = "" />
					<cfquery name="parentContentQuery">
						SELECT contentID, contentIDPath FROM SlatwallContent WHERE cmsContentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#missingContentQuery.parentID#" /> 
					</cfquery>
					<cfif parentContentQuery.recordCount>
						<cfset parentMappingCache[ missingContentQuery.parentID ] = {} />
						<cfset parentMappingCache[ missingContentQuery.parentID ].contentID = parentContentQuery.contentID />
						<cfset parentMappingCache[ missingContentQuery.parentID ].contentIDPath = parentContentQuery.contentIDPath />
					</cfif>
				</cfif>
				
				<cfif structKeyExists(parentMappingCache,  missingContentQuery.parentID)>
					<cfset var newContentID = getSlatwallScope().createHibachiUUID() />
					<cfquery name="rs">
						INSERT INTO SlatwallContent (
							contentID,
							contentIDPath,
							parentContentID,
							activeFlag,
							siteID,
							cmsContentID,
							title
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#newContentID#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#parentMappingCache[ missingContentQuery.parentID ].contentIDPath#,#newContentID#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#parentMappingCache[ missingContentQuery.parentID ].contentID#" />,
							<cfqueryparam cfsqltype="cf_sql_bit" value="1" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.slatwallSite.getSiteID()#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingContentQuery.contentID#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingContentQuery.menuTitle#" />
						)
					</cfquery>
				<cfelse>
					<cfset allParentsFound = false />
				</cfif>
			</cfif>
		</cfloop>
		
		<!--- Move Recursively through the entire site tree --->
		<cfif !allParentsFound>
			<cfset syncMuraContent(argumentcollection=arguments) />
		</cfif>
	</cffunction>
	
	<cffunction name="syncMuraCategories">
		<cfargument name="$" type="any" required="true" />
		<cfargument name="slatwallSite" type="any" required="true" />
		<cfargument name="muraSiteID" type="string" required="true" />
		
		<cfset var parentMappingCache = {} />
		<cfset var missingCategoryQuery = "" />
		
		<cfquery name="missingCategoryQuery">
			SELECT
				tcontentcategories.categoryID,
				tcontentcategories.parentID,
				tcontentcategories.name
			FROM
				tcontentcategories
			WHERE
				NOT EXISTS( SELECT categoryID FROM SlatwallCategory WHERE SlatwallCategory.cmsCategoryID = tcontentcategories.categoryID )
			ORDER BY
				LENGTH(tcontentcategories.path)
		</cfquery>
		
		<cfset var allParentsFound = true />
		<cfloop query="missingCategoryQuery">
			
			<cfset var rs = "" />
			
			<!--- Creating Home Page --->
			<cfif !len(missingCategoryQuery.parentID)>
				<cfset var newCategoryID = getSlatwallScope().createHibachiUUID() />
				<cfquery name="rs">
					INSERT INTO SlatwallCategory (
						categoryID,
						categoryIDPath,
						siteID,
						cmsCategoryID,
						categoryName
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#newCategoryID#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#newCategoryID#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.slatwallSite.getSiteID()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingCategoryQuery.categoryID#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingCategoryQuery.name#" />
					)
				</cfquery>
			<!--- Creating Internal Page, or resetting if parent can't be found --->	
			<cfelse>
				
				<cfif not structKeyExists(parentMappingCache, missingCategoryQuery.parentID)>
					<cfset var parentCategoryQuery = "" />
					<cfquery name="parentCategoryQuery">
						SELECT categoryID, categoryIDPath FROM SlatwallCategory WHERE cmsCategoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#missingCategoryQuery.parentID#" /> 
					</cfquery>
					<cfif parentCategoryQuery.recordCount>
						<cfset parentMappingCache[ missingCategoryQuery.parentID ] = {} />
						<cfset parentMappingCache[ missingCategoryQuery.parentID ].categoryID = parentCategoryQuery.categoryID />
						<cfset parentMappingCache[ missingCategoryQuery.parentID ].categoryIDPath = parentCategoryQuery.categoryIDPath />
					</cfif>
				</cfif>
				
				<cfif structKeyExists(parentMappingCache,  missingCategoryQuery.parentID)>
					<cfset var newCategoryID = getSlatwallScope().createHibachiUUID() />
					<cfquery name="rs">
						INSERT INTO SlatwallCategory (
							categoryID,
							categoryIDPath,
							parentCategoryID,
							siteID,
							cmsCategoryID,
							categoryName
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#newCategoryID#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#parentMappingCache[ missingCategoryQuery.parentID ].categoryIDPath#,#newCategoryID#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#parentMappingCache[ missingCategoryQuery.parentID ].categoryID#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.slatwallSite.getSiteID()#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingCategoryQuery.categoryID#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingCategoryQuery.name#" />
						)
					</cfquery>
				<cfelse>
					<cfset allParentsFound = false />
				</cfif>
			</cfif>
		</cfloop>
		
		<!--- Move Recursively through the entire site tree --->
		<cfif !allParentsFound>
			<cfset syncMuraCategories(argumentcollection=arguments) />
		</cfif>
	</cffunction>
	
	<cffunction name="syncMuraAccounts">
		<cfargument name="accountSyncType" type="string" required="true" />
		<cfargument name="superUserSyncFlag" type="boolean" required="true" />
		<cfargument name="muraUserID" type="string" />
		
		<cfif arguments.accountSyncType neq "none">
			<cfset var missingUsersQuery = "" />
			<cfquery name="missingUsersQuery">
				SELECT
					UserID,
					S2,
					Fname,
					Lname,
					Email,
					Company,
					MobilePhone,
					isPublic
				FROM
					tusers
				WHERE
					tusers.type = <cfqueryparam cfsqltype="cf_sql_integer" value="2" />
				<cfif arguments.accountSyncType eq "systemUserOnly">
					AND tusers.isPublic = <cfqueryparam cfsqltype="cf_sql_integer" value="0" /> 
				<cfelseif arguments.accountSyncType eq "siteUserOnly">
					AND tusers.isPublic = <cfqueryparam cfsqltype="cf_sql_integer" value="1" />
				</cfif>
				
				<cfif structKeyExists(arguments, "userID") and len(arguments.muraUserID)>
					AND tusers.userID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.muraUserID#" />
				<cfelse>
					AND NOT EXISTS( SELECT cmsAccountID FROM SlatwallAccount WHERE SlatwallAccount.cmsAccountID = tusers.userID )
				</cfif>
			</cfquery>
			
			<cfset var muraIntegrationQuery = "" />
			<cfquery name="muraIntegrationQuery">
				SELECT integrationID FROM SlatwallIntegration WHERE integrationPackage = <cfqueryparam cfsqltype="cf_sql_varchar" value="mura" />
			</cfquery>
			
			<cfloop query="missingUsersQuery">
				
				<cfset var rs = "" />
				<cfset var newAccountID = getSlatwallScope().createHibachiUUID() />
				
				<!--- Create Account --->
				<cfquery name="rs">
					INSERT INTO SlatwallAccount (
						accountID,
						firstName,
						lastName,
						company,
						cmsAccountID,
						superUserFlag
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#newAccountID#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.Fname#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.Lname#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.Company#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.UserID#" />,
						<cfif arguments.superUserSyncFlag and missingUsersQuery.s2>
							<cfqueryparam cfsqltype="cf_sql_bit" value="1" />	
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_bit" value="0" />
						</cfif>
					)
				</cfquery>
				
				<!--- Create Email --->
				<cfif len(missingUsersQuery.Email)>
					<cfquery name="rs">
						INSERT INTO SlatwallAccountEmailAddress (
							accountEmailAddressID,
							accountID,
							emailAddress
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#getSlatwallScope().createHibachiUUID()#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#newAccountID#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.Email#" />
						)
					</cfquery>
				</cfif>
				
				<!--- Create Phone --->
				<cfif len(missingUsersQuery.MobilePhone)>
					<cfquery name="rs">
						INSERT INTO SlatwallAccountPhoneNumber (
							accountPhoneNumberID,
							accountID,
							phoneNumber
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#getSlatwallScope().createHibachiUUID()#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#newAccountID#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.MobilePhone#" />
						)
					</cfquery>
				</cfif>
				
				<!--- Create Authentication --->
				<cfquery name="rs">
					INSERT INTO SlatwallAccountAuthentication (
						accountAuthenticationID,
						accountID,
						integrationID,
						integrationAccessToken
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#getSlatwallScope().createHibachiUUID()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#newAccountID#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#getMuraIntegrationID()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.UserID#" />
					)
				</cfquery>
			</cfloop>
		</cfif>
	</cffunction>
	
	<cffunction name="loginCurrentMuraUser">
		<cfargument name="$" />
		
		<cfset syncMuraAccounts(accountSyncType="all", superUserSyncFlag=getPluginConfig().getSetting("superUserSyncFlag"), muraUserID=$.currentUser('userID')) />
		<cfset var account = getSlatwallScope().getService("accountService").getAccountByCMSAccountID($.currentUser('userID')) />
		<cfset var accountAuth = ormExecuteQuery("SELECT aa FROM SlatwallAccountAuthentication aa WHERE aa.integration.integrationID = ? AND aa.account.accountID = ?", [getMuraIntegrationID(), account.getAccountID()]) />
		<cfif !isNull(account) && arrayLen(accountAuth)>
			<cfset getSlatwallScope().getService("hibachiSessionService").loginAccount(account=account, accountAuthentication=accountAuth[1]) />
		</cfif>
	</cffunction>
	
	<cffunction name="logoutCurrentMuraUser">
		<cfargument name="$" />
		
		<cfset getSlatwallScope().getService("hibachiSessionService").logoutAccount() />
	</cffunction>
	
	<cffunction name="getMuraIntegrationID">
		<cfif not structKeyExists(variables, "muraIntegrationID")>
			<cfset var muraIntegrationQuery = "" />
			<cfquery name="muraIntegrationQuery">
				SELECT integrationID FROM SlatwallIntegration WHERE integrationPackage = <cfqueryparam cfsqltype="cf_sql_varchar" value="mura" />
			</cfquery>
			<cfset variables.muraIntegrationID = muraIntegrationQuery.integrationID />
		</cfif>
		<cfreturn variables.muraIntegrationID />
	</cffunction>
</cfcomponent>

<!---
// Plugin Install Settings
	// Account Sync Type 														['none'|'all'|'admin only'|'public only']
	// Add Mura Super Users with Slatwall Account to Slatwall Super User Group	[yes|no]								
	// Would you like to automatically create the default pages, and copy over slatwall template files [yes|no]			
	
// Integration Settings
	// integrationMuraAccountSyncType						
	// integrationMuraAutoLoginToSlatwall					
	// integrationMuraAutoLoginToMura						

// Install
	// Call the first Slatwall Request
	// Move Settings From Plugin-Install into Integration
	// Enable FW/1 Integration
	// Enable Authentication Integration
	// Enable Content Integration

	
// MURA EVENTS
	// onApplicationLoad
		// Loop over all sites that this plugin is installed for, and make sure that there is a siteID on both sides
		// Loop over all content of all sites, and make sure that they are synced
		// Loop over all categories of all sites, and make sure that they are synced
		// Loop over all accounts of all sites, and make sure that they are synced - based on the sync settings "integrationMuraAccountSyncType"
		
	// onSiteRequest
		// Run anything in "slatAction"
		// Look for productType hook
		// Look for product hook
		// Look for brand hook

	// onLogin
	
	// onLogout
	
	// onCreateAccount
	
	// onUpdateAccount
	
	// onDeleteAccount
	
	// onCreateCategory
	
	// onUpdateCategory
	
	// onDeleteCategory
	
	// onCreateContent
	
	// onUpdateContent
	
	// onContentDelete
	
	// onSiteRequest
			
			
// SLATWALL EVENTS
	// onLogin
	
	// onLogout
	
	// onCreateAccount
	
	// onUpdateAccount
	
	// onDeleteAccount
	
	// onCreateCategory
	
	// onUpdateCategory
	
	// onDeleteCategory
	
	// onCreateContent
	
	// onUpdateContent
	
	// onDeleteContent
	
	
	private void function saveSlatwallSetting(required any $, required struct settingData, required any slatwallContent) {
		for(var settingName in arguments.settingData) {
			// create new setting if there is data 
			if(arguments.settingData[settingName] != "") {
				var setting = getSlatwallScope().getService("settingService").getSettingBySettingNameANDcmsContentID([settingName,arguments.slatwallContent.getCmsContentID()],true);
				setting.setSettingName(settingName);
				setting.setSettingValue(arguments.settingData[settingName]);
				//setting.setContent(arguments.slatwallContent);
				setting.setcmsContentID(arguments.slatwallContent.getCmsContentID());
				getSlatwallScope().getService("settingService").saveSetting(setting);
			} else {
				// if nothing is selected the delete the setting so it can use inherited
				var setting = getSlatwallScope().getService("settingService").getSettingBySettingNameANDcmsContentID([settingName,arguments.slatwallContent.getCmsContentID()],true);
				if(!setting.isNew()) {
					getSlatwallScope().getService("settingService").deleteSetting(setting);
				}
			}
		}
	}
	
	private any function saveSlatwallPage(required any $) {
		var slatwallData = $.getEvent().getAllValues().slatwallData;
		var slatwallContent = getSlatwallScope().getService("contentService").getContentByCmsContentID($.content("contentID"),true);
		slatwallContent.setCmsSiteID($.event('siteID'));
		slatwallContent.setCmsContentID($.content("contentID"));
		slatwallContent.setCmsContentIDPath($.content("path"));
		slatwallContent.setTitle($.content("title"));
		var contentRestrictAccessFlag = slatwallContent.getSettingDetails('contentRestrictAccessFlag');
		var contentProductListingFlag = slatwallContent.getSettingDetails('contentProductListingFlag');
		// check if content needs to be saved
		if(slatwallData.templateFlag || slatwallData.setting.contentProductListingFlag != "" || contentProductListingFlag.settingValueFormatted || slatwallData.setting.contentRestrictAccessFlag != "" || contentRestrictAccessFlag.settingValueFormatted || slatwallData.setting.contentRestrictedContentDisplayTemplate != "") {
			createParentSlatwallPage($);
			// set the parent content
			var parentContent = getSlatwallScope().getService("contentService").getContentByCmsContentID($.content("parentID"));
			if(!isNull(parentContent)) {
				slatwallContent.setParentContent(parentContent);
			}
			slatwallContent = getSlatwallScope().getService("contentService").saveContent(slatwallContent,slatwallData);
			// now save all the content settings
			saveSlatwallSetting($,slatwallData.setting,slatwallContent);
			return slatwallContent;
		}
	}
	
	private void function createParentSlatwallPage(required any $) {
		var contentIDPathArray = listToArray($.content('path'));
		var parentCount = arrayLen(contentIDPathArray) - 1;
		// create all except first (home) and last (the content being saved)
		for(var i = 2; i < parentCount; i++) {
			var slatwallContent = getSlatwallScope().getService("contentService").getContentByCmsContentID(contentIDPathArray[i],true);
			if(slatwallContent.isNew()) {
				var muraContent = $.getBean('content').loadBy(contentID=contentIDPathArray[i]) ;
				slatwallContent.setCmsSiteID(muraContent.getSiteID());
				slatwallContent.setCmsContentID(muraContent.getContentID());
				slatwallContent.setCmsContentIDPath(muraContent.getPath());
				slatwallContent.setTitle(muraContent.getTitle());
				if(!isNull(parentSlatwallContent)) {
					slatwallContent.setParentContent(parentSlatwallContent);
				}
				var parentSlatwallContent = getSlatwallScope().getService("contentService").saveContent(slatwallContent);
			}
		}
	}
	
	private void function saveSlatwallProduct(required any $, any slatwallContent) {
		var slatwallData = $.getEvent().getAllValues().slatwallData;
		slatwallData.product.accessContents = slatwallContent.getContentID();
		// if sku is selected, related sku to content
		if(slatwallData.product.sku.skuID != "") {
			var sku = getSlatwallScope().getService("SkuService").getSku(slatwallData.product.sku.skuID, true);
			sku.addAccessContent(slatwallContent);
		} else {
			var product = getSlatwallScope().getService("ProductService").getProduct(slatwallData.product.productID, true);
			if(product.isNew()){
				// if new product set up required properties
				product.setProductName($.content("title"));
				product.setPublishedFlag($.content("approved"));
				var productType = getSlatwallScope().getService("ProductService").getProductTypeBySystemCode("contentAccess");
				product.setProductType(productType);
				product.setProductCode(createUUID());
				product.setActiveFlag(1);
				product = getSlatwallScope().getService("ProductService").saveProduct( product, slatwallData.product );
			} else {
				var newSku = getSlatwallScope().getService("SkuService").newSku();
				newSku.setPrice(slatwallData.product.price);
				newSku.setProduct(product);
				newSku.setSkuCode(product.getProductCode() & "-#arrayLen(product.getSkus()) + 1#");
				newSku.addAccessContent( slatwallContent );
				getSlatwallScope().getService("SkuService").saveSKU( newSku );
			}
		}
		
	}
	
	// Helper method to go in and delete content skus
	private void function deleteContentSkus(required any $) {
		var slatwallContent = getSlatwallScope().getService("contentService").getContentByCmsContentID($.content("contentID"),true);
		if(!slatwallContent.isNew()) {
			while(arrayLen(slatwallContent.getSkus())){
				var thisSku = slatwallContent.getSkus()[1];
				slatwallContent.removeSku(thisSku);
			}
			getSlatwallScope().getService("contentService").saveContent(slatwallContent);
		}
	}

	// Helper method to go in and delete a content node that was previously saved in Slatwall. 
	private void function deleteSlatwallPage(required any $) {
		var slatwallContent = getSlatwallScope().getService("contentService").getContentByCmsContentID($.content("contentID"),true);
		// do not delete content form slatwall, only make it inactive
		if(!slatwallContent.isNew()) {
			slatwallContent.setActiveFlag(0);
			getSlatwallScope().getService("contentService").saveContent(slatwallContent);
		}
	}
	
	
	
	
	
public struct function getMailServerSettings() {
		var config = getConfigBean();
		var settings = {};
		if(!config.getUseDefaultSMTPServer()) {
			settings = {
				server = config.getMailServerIP(),
				username = config.getMailServerUsername(),
				password = config.getMailServerPassword(),
				port = config.getMailServerSMTPPort(),
				useSSL = config.getMailServerSSL(),
				useTLS = config.getMailServerTLS()
			};
		}
		return settings;
	}
	
	public void function setupIntegration() {
		logHibachi("Setting Service - verifyMuraRequirements - Started", true);
		verifyMuraFrontendViews();
		verifyMuraRequiredPages();
		pullMuraCategory();
		logHibachi("Setting Service - verifyMuraRequirements - Finished", true);
	}
	
	private void function verifyMuraFrontendViews() {
		logHibachi("Setting Service - verifyMuraFrontendViews - Started", true);
		var assignedSites = getPluginConfig().getAssignedSites();
		for( var i=1; i<=assignedSites.recordCount; i++ ) {
			logHibachi("Verify Mura Frontend Views For Site ID: #assignedSites["siteID"][i]#");
			
			var baseSlatwallPath = getDirectoryFromPath(expandPath("/muraWRM/plugins/Slatwall/frontend/views/")); 
			var baseSitePath = getDirectoryFromPath(expandPath("/muraWRM/#assignedSites["siteID"][i]#/includes/display_objects/custom/slatwall/"));
			
			getService("hibachiUtilityService").duplicateDirectory(baseSlatwallPath,baseSitePath,false,true,".svn");
		}
		logHibachi("Setting Service - verifyMuraFrontendViews - Finished", true);
	}

	private void function verifyMuraRequiredPages() {
		logHibachi("Setting Service - verifyMuraRequiredPages - Started", true);
		
		var requiredMuraPages = [
			{settingName="globalPageShoppingCart",settingValue="shopping-cart",title="Shopping Cart",fileName="shopping-cart",isNav="1",isLocked="1"},
			{settingName="globalPageOrderStatus",settingValue="order-status",title="Order Status",fileName="order-status",isNav="1",isLocked="1"},
			{settingName="globalPageOrderConfirmation",settingValue="order-confirmation",title="Order Confirmation",fileName="order-confirmation",isNav="0",isLocked="1"},
			{settingName="globalPageMyAccount",settingValue="my-account",title="My Account",fileName="my-account",isNav="1",isLocked="1"},
			{settingName="globalPageCreateAccount",settingValue="create-account",title="Create Account",fileName="create-account",isNav="1",isLocked="1"},
			{settingName="globalPageCheckout",settingValue="checkout",title="Checkout",fileName="checkout",isNav="1",isLocked="1"},
			{settingName="productDisplayTemplate",settingValue="",title="Default Template",fileName="default-template",isNav="0",isLocked="0",templateFlag="1",slatwallContentFlag="1"},
			{settingName="productTypeDisplayTemplate",settingValue="",title="Default Template",fileName="default-template",isNav="0",isLocked="0",templateFlag="1",slatwallContentFlag="1"},
			{settingName="brandDisplayTemplate",settingValue="",title="Default Template",fileName="default-template",isNav="0",isLocked="0",templateFlag="1",slatwallContentFlag="1"}
		];
		
		var assignedSites = getPluginConfig().getAssignedSites();
		for( var i=1; i<=assignedSites.recordCount; i++ ) {
			logHibachi("Verify Mura Required Pages For Site ID: #assignedSites["siteID"][i]#", true);
			var thisSiteID = assignedSites["siteID"][i];
			
			for(var page in requiredMuraPages) {
				var muraPage = createMuraPage(page,thisSiteID);
				if(structKeyExists(page,"slatwallContentFlag")) {
					var slatwallContent = createSlatwallContent(muraPage,page);
					page.settingValue = slatwallContent.getContentID();
				}
				createSetting(page,thisSiteID);
				// persist all changes
				ormflush();
			}
		}
		logHibachi("Setting Service - verifyMuraRequiredPages - Finished", true);
	}
	
	private void function createSetting(required struct page,required any siteID) {
		var settingList = getService("settingService").listSetting({settingName=arguments.page.settingName});
		
		if(!arrayLen(settingList)){
			var setting = getService("settingService").newSetting();
			setting.setSettingValue(arguments.page.settingValue);
			setting.setSettingName(arguments.page.settingName);
			getService("settingService").saveSetting(setting);
		}
	}
	
	private any function createMuraPage(required struct page,required any siteID) {
		// Setup Mura Page
		var thisPage = getContentManager().getActiveContentByFilename(filename=arguments.page.fileName, siteid=arguments.siteID);
		if(thisPage.getIsNew()) {
			thisPage.setDisplayTitle(arguments.page.title);
			thisPage.setHTMLTitle(arguments.page.title);
			thisPage.setMenuTitle(arguments.page.title);
			thisPage.setIsNav(arguments.page.isNav);
			thisPage.setActive(1);
			thisPage.setApproved(1);
			thisPage.setIsLocked(arguments.page.isLocked);
			thisPage.setParentID("00000000000000000000000000000000001");
			thisPage.setFilename(arguments.page.fileName);
			thisPage.setSiteID(arguments.siteID);
			thisPage.save();
		}
		return thisPage;
	}
	
	private any function createSlatwallContent(required any muraPage, required struct pageAttributes) {
		var thisPage = getService("contentService").getcontentByCmsContentID(arguments.muraPage.getContentID(),true);
		if(thisPage.isNew()){
			thisPage.setCmsSiteID(arguments.muraPage.getSiteID());
			thisPage.setCmsContentID(arguments.muraPage.getContentID());
			thisPage.setTitle(arguments.muraPage.getTitle());
			thisPage = getService("contentService").saveContent(thisPage,arguments.pageAttributes);
		}
		return thisPage;
	}
	
	private void function pullMuraCategory() {
		logHibachi("Setting Service - pullMuraCategory - Started", true);
		var assignedSites = getPluginConfig().getAssignedSites();
		for( var i=1; i<=assignedSites.recordCount; i++ ) {
			logHibachi("Pull mura category For Site ID: #assignedSites["siteID"][i]#");
			
			var categoryQuery = getCategoryManager().getCategoriesBySiteID(siteID=assignedSites["siteID"][i]);
			for(var j=1; j<=categoryQuery.recordcount; j++) {
				var category = getService("contentService").getCategoryByCmsCategoryID(categoryQuery.categoryID[j],true);
				if(category.isNew()){
					category.setCmsSiteID(categoryQuery.siteID[j]);
					category.setCmsCategoryID(categoryQuery.categoryID[j]);
					category.setCategoryName(categoryQuery.name[j]);
					category = getService("contentService").saveCategory(category);
				}
			}
		}
		logHibachi("Setting Service - pullMuraCategory - Finished", true);
	}

	public any function getPluginConfig() {
		if(!structKeyExists(variables, "pluginConfig")) {
			variables.pluginConfig = application.pluginManager.getConfig("Slatwall");
		}
		return variables.pluginConfig;
	}	
	
	
	
	


--->
