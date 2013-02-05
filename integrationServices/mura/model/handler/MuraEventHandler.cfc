<cfcomponent extends="Handler">
	
	<cfscript>
		
		// ========================== FRONTENT EVENT HOOKS =================================
		public void function onSiteRequestStart( required any $ ) {
			// Setup the slatwallScope into the muraScope
			verifySlatwallRequest( $=$ );
			
			// Update Login / Logout if needed
			autoLoginLogoutFromSlatwall( $=$ );
			
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
				if( productKeyLocation && productKeyLocation > productTypeKeyLocation && productKeyLocation > brandKeyLocation && !$.slatwall.getCurrentProduct().isNew() && $.slatwall.getCurrentProduct().getActiveFlag() && ($.slatwall.getCurrentProduct().getPublishedFlag() || $.slatwall.getCurrentProduct().setting('productShowDetailWhenNotPublishedFlag'))) {
					$.slatwall.setCurrentContent($.slatwall.getService("contentService").getContent($.slatwall.getCurrentProduct().setting('productDisplayTemplate')));
					$.event('contentBean', $.getBean("content").loadBy(contentID=$.slatwall.getCurrentContent().getCMSContentID()) );
					$.content('body', $.content('body') & doAction('frontend:product.detail'));
					$.content().setTitle( $.slatwall.getCurrentProduct().getTitle() );
					$.content().setHTMLTitle( $.slatwall.getCurrentProduct().getTitle() );
					
					
					// Setup CrumbList
					if(productKeyLocation > 2) {
						var listingPageFilename = left($.event('path'), find("/#$.slatwall.setting('globalURLKeyProduct')#/", $.event('path'))-1);
						listingPageFilename = replace(listingPageFilename, "/#$.event('siteID')#/", "", "all");
						var crumbDataArray = $.getBean("contentManager").getActiveContentByFilename(listingPageFilename, $.event('siteid'), true).getCrumbArray();
					} else {
						var crumbDataArray = $.getBean("contentManager").getCrumbList(contentID="00000000000000000000000000000000001", siteID=$.event('siteID'), setInheritance=false, path="00000000000000000000000000000000001", sort="asc");
					}
					arrayPrepend(crumbDataArray, $.slatwall.getCurrentProduct().getCrumbData(path=$.event('path'), siteID=$.event('siteID'), baseCrumbArray=crumbDataArray));
					$.event('crumbdata', crumbDataArray);
					
				} else if ( productTypeKeyLocation && productTypeKeyLocation > brandKeyLocation && !$.slatwall.getCurrentProductType().isNew() && $.slatwall.getCurrentProductType().getActiveFlag() ) {
					$.slatwall.setCurrentContent($.slatwall.getService("contentService").getContent($.slatwall.getCurrentProductType().setting('productTypeDisplayTemplate')));
					$.event('contentBean', $.getBean("content").loadBy(contentID=$.slatwall.getCurrentContent().getCMSContentID()) );
					$.content('body', $.content('body') & doAction('frontend:producttype.detail'));
					$.content().setTitle( $.slatwall.getCurrentProductType().getProductTypeName() );
					$.content().setHTMLTitle( $.slatwall.getCurrentProductType().getProductTypeName() );
					
				} else if ( brandKeyLocation && !$.slatwall.getCurrentBrand().isNew() && $.slatwall.getCurrentBrand().getActiveFlag()  ) {
					$.slatwall.setCurrentContent($.slatwall.getService("contentService").getContent($.slatwall.getCurrentBrand().setting('brandDisplayTemplate')));
					$.event('contentBean', $.getBean("content").loadBy(contentID=$.slatwall.getCurrentContent().getCMSContentID()) );
					$.content('body', $.content('body') & doAction('frontend:brand.detail'));
					$.content().setTitle( $.slatwall.getCurrentBrand().getBrandName() );
					$.content().setHTMLTitle( $.slatwall.getCurrentBrand().getBrandName() );
				}
			}
		}
		
		public void function onRenderStart( required any $ ) {
			
			// Now that there is a mura contentBean in the muraScope for sure, we can setup our currentContent Variable
			$.slatwall.setCurrentContent( $.slatwall.getService("contentService").getContentByCMSContentID($.content('contentID')) );
			
			// check if user has access to this page
			checkAccess( $=$ );
					
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
		
		public void function onRenderEnd( required any $ ) {
			if(len($.slatwall.getCurrentAccount().getAllPermissions())) {
				// Set up frontend tools
				var fetools = "";
				savecontent variable="fetools" {
					include "/Slatwall/assets/fetools/fetools.cfm";
				};
				
				$.event('__muraresponse__', replace($.event('__muraresponse__'), '</body>', '#fetools#</body>'));
			}
		}
		
		public void function onSiteLoginSuccess( required any $ ) {
			verifySlatwallRequest( $=$ );
			autoLoginLogoutFromSlatwall();
			endSlatwallRequest();
		}
		
		public void function onAfterSiteLogout( required any $ ) {
			verifySlatwallRequest( $=$ );
			autoLoginLogoutFromSlatwall();
			endSlatwallRequest();
		}
		
		public void function onSiteRequestEnd( required any $ ) {
			endSlatwallRequest();
		}
		
		// ========================== ADMIN EVENT HOOKS =================================
		
		// LOGIN / LOGOUT EVENTS
		public void function onGlobalLoginSuccess( required any $ ) {
			verifySlatwallRequest( $=$ );
			autoLoginLogoutFromSlatwall();
			endSlatwallRequest();
		}
		public void function onAfterGlobalLogout( required any $ ) {
			verifySlatwallRequest( $=$ );
			verifyMuraLoginLogout();
			endSlatwallRequest();
		}
		
		// RENDERING EVENTS
		/*
		public string function onContentTabBasicBottomRender(required any $) {
			writeLog(file="Slatwall", text="Mura Integration - onContentTabBasicBottomRender()");
			return "<div>This is my content</div>";
		}
		*/
		
		public void function onContentEdit( required any $ ) {
			verifySlatwallRequest( $=$ );
			writeOutput("EDIT SETTINGS HERE");
			endSlatwallRequest();
		}
		
		
		// SAVE / DELETE EVENTS
		
		public void function onAfterCategorySave( required any $ ) {
			verifySlatwallRequest( $=$ );
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
			
			endSlatwallRequest();
		}
		
		public void function onAfterCategoryDelete( required any $ ) {
			verifySlatwallRequest( $=$ );
			var category = $.slatwall.getService("contentService").getCategoryByCmsCategoryID($.event("categoryID"),true);
			if(!category.isNew() && category.isDeletable()) {
				$.slatwall.getService("contentService").deleteCategory(category);
			}
			
			endSlatwallRequest();
		}
		
		public void function onAfterContentSave( required any $ ) {
			verifySlatwallRequest( $=$ );
			if(!structKeyExists($.getEvent().getAllValues(),"slatwallData")) {
				return;
			}
			var slatwallData = $.getEvent().getAllValues().slatwallData;
			var slatwallContent = saveSlatwallPage();
			if(!isNull(slatwallContent) && slatwallData.allowPurchaseFlag) {
				if(slatwallData.addSku){
					saveSlatwallProduct(slatwallContent);
				}
			} else {
				deleteContentSkus();
			}
			
			endSlatwallRequest();
		}
		
		public void function onAfterContentDelete( required any $ ) {
			verifySlatwallRequest( $=$ );
			deleteContentSkus();
			deleteSlatwallPage();
			
			endSlatwallRequest();
		}
		
		public void function onAfterUserSave( required any $ ) {
			verifySlatwallRequest( $=$ );
			// TODO: Update Slatwall User
			
			endSlatwallRequest();
		}
		
		public void function onAfterUserDelete( required any $ ) {
			verifySlatwallRequest( $=$ );
			// TODO: Delete Slatwall User
			
			endSlatwallRequest();
		}
		
		
		// ========================== MANUALLY CALLED MURA =================================
		
		
		public void function autoLoginLogoutFromSlatwall( required any $ ) {
			// Check to see if the current mura user is logged in (or logged out), and if we should automatically login/logout the slatwall account
			if( getMuraPluginConfig().getSetting("accountSyncType") != "none"
					&& !$.slatwall.getLoggedInFlag()
					&& $.currentUser().isLoggedIn()
					&& (
						getMuraPluginConfig().getSetting("accountSyncType") == "all"
						|| (getMuraPluginConfig().getSetting("accountSyncType") == "systemUserOnly" && $.currentUser().getUserBean().getType() eq 2) 
						|| (getMuraPluginConfig().getSetting("accountSyncType") == "siteUserOnly" && $.currentUser().getUserBean().getType() eq 1)
					)) {
				
				// Login Slatwall Account
				syncMuraAccounts(accountSyncType="all", superUserSyncFlag=getMuraPluginConfig().getSetting("superUserSyncFlag"), muraUserID=$.currentUser('userID'));
				var account = $.slatwall.getService("accountService").getAccountByCMSAccountID($.currentUser('userID'));
				var accountAuth = ormExecuteQuery("SELECT aa FROM SlatwallAccountAuthentication aa WHERE aa.integration.integrationID = ? AND aa.account.accountID = ?", [getMuraIntegrationID(), account.getAccountID()]);
				if (!isNull(account) && arrayLen(accountAuth)) {
					$.slatwall.getService("hibachiSessionService").loginAccount(account=account, accountAuthentication=accountAuth[1]);
				}
				
			} else if ( $.slatwall.getLoggedInFlag()
					&& !$.currentUser().isLoggedIn()
					&& !isNull($.slatwall.getSession().getAccountAuthentication().getIntegration())
					&& $.slatwall.getSession().getAccountAuthentication().getIntegration().getIntegrationPackage() eq "mura") {
				
				// Logout Slatwall Account
				$.slatwall.getService("hibachiSessionService").logoutAccount();
			}
		}
		
		// Helper method to do our access check
		private void function checkAccess( required any $ ) {
			if(!$.slatwall.getService("accessService").hasAccess($.content('contentID'))){
				
				// save the current content to be used on the barrier page
				$.event("restrictedContent",$.content());
				
				// save the current content to be used on the barrier page
				$.event("restrictedContentBody",$.content('body'));
				
				// Set the content of the current content to noAccess
				$.content('body', doAction('frontend:account.noaccess'));
				
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
		
		// This method is explicitly called during application reload from the conntector plugins onApplicationLoad() event
		public void function verifySetup( required any $ ) {
			verifySlatwallRequest( $=$ );
			
			var assignedSitesQuery = getMuraPluginConfig().getAssignedSites();
			var populatedSiteIDs = getMuraPluginConfig().getCustomSetting("populatedSiteIDs");
			
			var integration = $.slatwall.getService("integrationService").getIntegrationByIntegrationPackage("mura");
			if(!integration.getFW1ActiveFlag()) {
				integration.setFW1ActiveFlag(1);
				var ehArr = integration.getIntegrationCFC().getEventHandlers();
				for(var e=1; e<=arrayLen(ehArr); e++) {
					$.slatwall.getService("hibachiEventService").registerEventHandler(ehArr[e]);
				}
			}
			
			for(var i=1; i<=assignedSitesQuery.recordCount; i++) {
				var cmsSiteID = assignedSitesQuery["siteid"][i];
				var siteDetails = $.getBean("settingsBean").loadBy(siteID=cmsSiteID);
				var cmsSiteName = siteDetails.getSite();
				var cmsThemeName = siteDetails.getTheme();
				
				// First lets verify that this site exists on the Slatwall site
				var slatwallSite = $.slatwall.getService("siteService").getSiteByCMSSiteID( cmsSiteID, true );
				
				// If this is a new site, then we can set the site name
				if(slatwallSite.isNew()) {
					slatwallSite.setSiteName( cmsSiteName );
					$.slatwall.getService("siteService").saveSite( slatwallSite );
					slatwallSite.setCMSSiteID( cmsSiteID );
					ormFlush();
				}
				
				// If the plugin is set to create default pages, and this siteID has not been populated then we need to populate it with pages & templates
				if(getMuraPluginConfig().getSetting("createDefaultPages") && !listFindNoCase(populatedSiteIDs, cmsSiteID)) {
					
					// Copy views over to the template directory
					var slatwallTemplatePath = getDirectoryFromPath(expandPath("/Slatwall/public/views/templates")); 
					var muraTemplatePath = getDirectoryFromPath(expandPath("/muraWRM/#cmsSiteID#/includes/themes/#cmsThemeName#/templates"));
					$.slatwall.getService("hibachiUtilityService").duplicateDirectory(source=slatwallTemplatePath, destination=muraTemplatePath, overwrite=false, recurse=true, copyContentExclusionList=".svn,.git");
					
					// Create the necessary pages
					var productListingCMSID = createMuraPage( $=$, muraSiteID=cmsSiteID, pageName="Product Listing", filename="product-listing", template="slatwall-productlisting.cfm", isNav="0" );
					var shoppingCartCMSID = createMuraPage( $=$, muraSiteID=cmsSiteID, pageName="Shopping Cart", filename="shopping-cart", template="slatwall-shoppingcart.cfm", isNav="1" );
					var orderStatusCMSID = createMuraPage( $=$, muraSiteID=cmsSiteID, pageName="Order Status", filename="order-status", template="slatwall-orderstatus.cfm", isNav="1" );
					var orderConfirmationCMSID = createMuraPage( $=$, muraSiteID=cmsSiteID, pageName="Order Confirmation", filename="order-confirmation", template="slatwall-orderconfirmation.cfm", isNav="0" );
					var checkoutCMSID = createMuraPage( $=$, muraSiteID=cmsSiteID, pageName="Checkout", filename="checkout", template="slatwall-checkout.cfm", isNav="1" );
					var accountCMSID = createMuraPage( $=$, muraSiteID=cmsSiteID, pageName="My Account", filename="my-account", template="slatwall-account.cfm", isNav="1" );
					var productTemplateCMSID = createMuraPage( $=$, muraSiteID=cmsSiteID, pageName="Product Template", filename="product-template", template="slatwall-product.cfm", isNav="0" );
					var productTypeTemplateCMSID = createMuraPage( $=$, muraSiteID=cmsSiteID, pageName="Product Type Template", filename="producttype-template", template="slatwall-producttype.cfm", isNav="0" );
					var brandTemplateCMSID = createMuraPage( $=$, muraSiteID=cmsSiteID, pageName="Brand Template", filename="brand-template", template="slatwall-brand.cfm", isNav="0" );
					
					// Now that it has been populated we can add the siteID to the populated site id's list
					getMuraPluginConfig().setCustomSetting("populatedSiteIDs", listAppend(populatedSiteIDs, cmsSiteID));
				}
				
				// Sync all missing content for the siteID
				syncMuraContent( $=$, slatwallSite=slatwallSite, muraSiteID=cmsSiteID );
				
				// Sync all missing categories
				syncMuraCategories( $=$, slatwallSite=slatwallSite, muraSiteID=cmsSiteID );
				
				// Sync all missing accounts
				syncMuraAccounts( $=$, accountSyncType=getMuraPluginConfig().getSetting("accountSyncType"), superUserSyncFlag=getMuraPluginConfig().getSetting("superUserSyncFlag") );
				
			}
		}
		
		
	</cfscript>
	
	<!--- ==================== TAG BASED HELPER METHODS TYPICALLY FOR DB STUFF ==================== --->
	<cffunction name="createMuraPage">
		<cfargument name="$" />
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
		<cfargument name="$" />
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
				<cfset var newContentID = $.slatwall.createHibachiUUID() />
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
					<cfset var newContentID = $.slatwall.createHibachiUUID() />
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
		<cfargument name="$" />
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
				<cfset var newCategoryID = $.slatwall.createHibachiUUID() />
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
					<cfset var newCategoryID = $.slatwall.createHibachiUUID() />
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
		<cfargument name="$" />
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
				<cfset var newAccountID = $.slatwall.createHibachiUUID() />
				
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
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#$.slatwall.createHibachiUUID()#" />,
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
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#$.slatwall.createHibachiUUID()#" />,
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
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#$.slatwall.createHibachiUUID()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#newAccountID#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#getMuraIntegrationID()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.UserID#" />
					)
				</cfquery>
			</cfloop>
		</cfif>
	</cffunction>
</cfcomponent>