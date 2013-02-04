<cfcomponent>
	<cfscript>
	
		// This method is explicitly called during application reload from the conntector plugins onApplicationLoad() event
		public void function verifySetup( required any $ ) {
			var assignedSitesQuery = getPluginConfig().getAssignedSites();
			var populatedSiteIDs = getPluginConfig().getCustomSetting("populatedSiteIDs");
			
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
				syncMuraAccounts( $=arguments.$, slatwallSite=slatwallSite, muraSiteID=cmsSiteID, accountSyncType=getPluginConfig().getSetting("accountSyncType"), superUserSyncFlag=getPluginConfig().getSetting("superUserSyncFlag") );
				
			}
		}
		
		
		// ========================== FRONTENT EVENT HOOKS =================================
		
		public void function onSiteRequestStart(required any $) {
			writeLog(file="Slatwall", text="Mura Integration - onSiteRequestStart() called");
			// Call the Slatwall Event Handler that gets the request setup
			getSlatwallApplication().setupGlobalRequest();
			
			// Setup the newly create slatwallScope into the muraScope
			arguments.$.setCustomMuraScopeKey("slatwall", request.slatwallScope);
		}
		
		public void function onSiteRequestEnd(required any $) {
			writeLog(file="Slatwall", text="Mura Integration - onSiteRequestEnd() called");
			getSlatwallApplication().endHibachiLifecycle();
		}
		
		public void function onRenderStart(required any $) {
			writeLog(file="Slatwall", text="Mura Integration - onRenderStart() called");
		}
		
		public void function onRenderEnd(required any $) {
			writeLog(file="Slatwall", text="Mura Integration - onRenderEnd() called");
		}
		
		// ========================== ADMIN EVENT HOOKS =================================
		
		public string function onContentTabBasicBottomRender(required any $) {
			writeLog(file="Slatwall", text="Mura Integration - onContentTabBasicBottomRender()");
			return "<div>This is my content</div>";
		}
		
		public void function onAfterCategorySave(required any $) {
			writeLog(file="Slatwall", text="Mura Integration - onAfterCategorySave() called");
		}
		
		public void function onAfterCategoryDelete(required any $) {
			writeLog(file="Slatwall", text="Mura Integration - onAfterCategoryDelete() called");
		}
		
		public void function onAfterContentSave(required any $) {
			writeLog(file="Slatwall", text="Mura Integration - onAfterContentSave() called");
		}
		
		public void function onAfterContentDelete(required any $) {
			writeLog(file="Slatwall", text="Mura Integration - onAfterContentDelete() called");
		}
		
		
		
		// ========================== Private Helper Methods ==============================
		
		// Helper Method for doAction()
		private string function doAction(required any action) {
			if(!structKeyExists(url, "$")) {
				url.$ = request.muraScope;
			}
			return getSlatwallApplication().doAction(arguments.action);
		}
		
		// Helper method to get the Slatwall Application
		private any function getSlatwallApplication() {
			if(!structKeyExists(variables, "slatwallApplication")) {
				variables.slatwallApplication = createObject("component", "Slatwall.Application");
			}
			return variables.slatwallApplication;
		}
		
		// Helper method to get the SlatwallScope
		private any function getSlatwallScope() {
			return request.slatwallScope;
		}
		
		// Helper method to return the mura plugin config for the slatwall-mura connector
		private any function getPluginConfig() {
			if(!structKeyExists(variables, "pluginConfig")) {
				variables.pluginConfig = application.pluginManager.getConfig("slatwall-mura");
			}
			return variables.pluginConfig;
		}
		
		// For admin request start, we call the Slatwall Event Handler that gets the request setup
		private void function startSlatwallAdminRequest(required any $) {
			if(!structKeyExists(request, "slatwallScope")) {
				// Call the Slatwall Event Handler that gets the request setup
				getSlatwallApplication().setupGlobalRequest();
						
				// Setup the newly create slatwallScope into the muraScope
				arguments.$.setCustomMuraScopeKey("slatwall", request.slatwallScope);
			}
		}
		
		// For admin request end, we call the endLifecycle
		private void function endSlatwallAdminRequest(required any $) {
			getSlatwallApplication().endSlatwallLifecycle();
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
		<cfargument name="$" type="any" required="true" />
		<cfargument name="slatwallSite" type="any" required="true" />
		<cfargument name="muraSiteID" type="string" required="true" />
		<cfargument name="accountSyncType" type="string" required="true" />
		<cfargument name="superUserSyncFlag" type="boolean" required="true" />
		
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
					NOT EXISTS( SELECT cmsAccountID FROM SlatwallAccount WHERE SlatwallAccount.cmsAccountID = tusers.userID )
				  AND
					tusers.type = <cfqueryparam cfsqltype="cf_sql_integer" value="2" />
				<cfif arguments.accountSyncType eq "systemUserOnly">
					AND tusers.isPublic = <cfqueryparam cfsqltype="cf_sql_integer" value="0" /> 
				<cfelseif arguments.accountSyncType eq "siteUserOnly">
					AND tusers.isPublic = <cfqueryparam cfsqltype="cf_sql_integer" value="1" />
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
						accountID
						firstName,
						lastName,
						company,
						cmsAccountID,
						superAdminFlag
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
				<cfif len(missingUserQuery.Email)>
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
				<cfif len(missingUserQuery.MobilePhone)>
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
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#muraIntegrationQuery.integrationID#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.UserID#" />
					)
				</cfquery>
				<!---
						UserID,
						S2,
						Fname,
						Lname,
						Email,
						Company,
						MobilePhone,
						isPublic
				--->
			</cfloop>
			
		</cfif>
		
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
	
	
	

	public void function onSiteRequestStart(required any $) {
		
		// Call the Slatwall Event Handler that gets the request setup
		getSlatwallApplication().setupGlobalRequest();
		
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
	
	// At the end of a frontend request, we call the endLifecycle
	public any function onSiteRequestEnd(required any $) {
		getSlatwallApplication().endSlatwallLifecycle();
	}
	
	// display slatwall link in mura left nav
	public any function onAdminModuleNav(required any $) {
		return '<li><a href="' & application.configBean.getContext() & '/plugins/Slatwall">Slatwall</a></li>';
	}
	
	// Hook into the onRender start so that we can do any slatActions that might have been called, or if the current content is a listing page
	public any function onRenderStart(required any $) {
		// Now that there is a mura contentBean in the muraScope for sure, we can setup our currentContent Variable
		$.slatwall.setCurrentContent( $.slatwall.getService("contentService").getContentByCMSContentID($.content('contentID')) );
		
		// check if user has access to this page
		checkAccess($);
				
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
	
	public void function onRenderEnd(required any $) {
		 
		if(len($.slatwall.getCurrentAccount().getAllPermissions())) {
			// Set up frontend tools
			var fetools = "";
			savecontent variable="fetools" {
				include "/Slatwall/assets/fetools/fetools.cfm";
			};
			
			$.event('__muraresponse__', replace($.event('__muraresponse__'), '</body>', '#fetools#</body>'));
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
	
	
	
	// Helper method to do our access check
	private void function checkAccess(required any $) {
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
			} else {
				// if nothing is selected the delete the setting so it can use inherited
				var setting = $.slatwall.getService("settingService").getSettingBySettingNameANDcmsContentID([settingName,arguments.slatwallContent.getCmsContentID()],true);
				if(!setting.isNew()) {
					$.slatwall.getService("settingService").deleteSetting(setting);
				}
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
			createParentSlatwallPage($);
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
	
	private void function createParentSlatwallPage(required any $) {
		var contentIDPathArray = listToArray($.content('path'));
		var parentCount = arrayLen(contentIDPathArray) - 1;
		// create all except first (home) and last (the content being saved)
		for(var i = 2; i < parentCount; i++) {
			var slatwallContent = $.slatwall.getService("contentService").getContentByCmsContentID(contentIDPathArray[i],true);
			if(slatwallContent.isNew()) {
				var muraContent = $.getBean('content').loadBy(contentID=contentIDPathArray[i]) ;
				slatwallContent.setCmsSiteID(muraContent.getSiteID());
				slatwallContent.setCmsContentID(muraContent.getContentID());
				slatwallContent.setCmsContentIDPath(muraContent.getPath());
				slatwallContent.setTitle(muraContent.getTitle());
				if(!isNull(parentSlatwallContent)) {
					slatwallContent.setParentContent(parentSlatwallContent);
				}
				var parentSlatwallContent = $.slatwall.getService("contentService").saveContent(slatwallContent);
			}
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
				newSku.setSkuCode(product.getProductCode() & "-#arrayLen(product.getSkus()) + 1#");
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
		// do not delete content form slatwall, only make it inactive
		if(!slatwallContent.isNew()) {
			slatwallContent.setActiveFlag(0);
			$.slatwall.getService("contentService").saveContent(slatwallContent);
		}
	}
	
--->
