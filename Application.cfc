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
component extends="org.fw1.framework" output="false" {

	include "../../config/applicationSettings.cfm";
	include "../../config/mappings.cfm";
	include "../mappings.cfm";
	
	include "fw1Config.cfm";
	this.mappings[ "/slatwallVfsRoot" ] = "ram:///" & this.name;
	
	public void function verifyApplicationSetup() {
		
		if(structKeyExists(url, variables.framework.reload)) {
			application.slatwall.initialized = false;
		}
		
		// Check to see if out application stuff is initialized
		if(!structKeyExists(application, "slatwall") || !structKeyExists(application.slatwall, "initialized") || !application.slatwall.initialized) {
			
			// If not, lock the application until this is finished
			lock scope="Application" timeout="120"  {
				
				// Check again so that the qued requests don't back up
				if(!structKeyExists(application, "slatwall") || !structKeyExists(application.slatwall, "initialized") || !application.slatwall.initialized) {
					
					// Log that the application is starting it's setup
					writeLog(file="Slatwall", text="Application Setup Started");
					
					application.slatwall = structNew();
					application.slatwall.version = "";
					application.slatwall.initialized = false;
					application.slatwall.fw = this;
					application.slatwall.slatwallVfsRoot = this.mappings[ "/slatwallVfsRoot" ];
					
					// Make sure the correct version is in the application scope
					var versionFile = getDirectoryFromPath(getCurrentTemplatePath()) & "version.txt";
					if( fileExists( versionFile ) ) {
						application.slatwall.version = trim(fileRead(versionFile));
					}
					
					// Set vfs root for slatwall 
					if(!directoryExists(application.slatwall.slatwallVfsRoot)) {
						directoryCreate(application.slatwall.slatwallVfsRoot);
					}
					
					// This will force the Taffy API to reload on next request
					if(structKeyExists(application, "_taffy")){
						structDelete(application,"_taffy");	
					}
					
					// Make's sure that our entities get updated
					ormReload();
					
					// ========================= Coldspring Setup =========================
					
					// Get Coldspring Config
					var serviceFactory = "";
					var integrationService = "";
					var rbFactory = "";
					var xml = "";
					var xmlPath = "";
			
				    xmlPath = expandPath( '/Slatwall/config/coldspring.xml' );
					xml = xmlParse(FileRead("#xmlPath#")); 
					
					// Build Coldspring factory
					serviceFactory=createObject("component","coldspring.beans.DefaultXmlBeanFactory").init();
					serviceFactory.loadBeansFromXmlObj( xml );
					
					// Set a data service coldspring as the child factory, with the Slatwall as it's parent
					integrationService = serviceFactory.getBean("integrationService");
					serviceFactory = integrationService.updateColdspringWithDataIntegration( serviceFactory, xml );
					
					// Place the service factory into the required application scopes
					setBeanFactory( serviceFactory );
					
					//========================= END: Coldsping Setup =========================
					
					//========================= ValidateThis Setup =========================
					
					// Setup the ValidateThis Framework
					
					var validateThisConfig = {
						definitionPath = "/Slatwall/com/validation/",
						injectResultIntoBO = true,
						defaultFailureMessagePrefix = ""
					};
					
					// Create The Validate This Facade object
					var vtFacade = new ValidateThis.ValidateThis(validateThisConfig);
					
					// Place the validation facade object in the plugin config application scope
					application.slatwall.validateThis = vtFacade;
					
					//========================= END: ValidateThis Setup =========================
					
					// Build RB Factory
					rbFactory= new mura.resourceBundle.resourceBundleFactory(application.settingsManager.getSite('default').getRBFactory(), getDirectoryFromPath(expandPath("/plugins/Slatwall/resourceBundles/") ));
					application.slatwall.rbFactory = rbFactory;
					
					// Setup Default Data... This is only for development and should be moved to the update function of the plugin once rolled out.
					getBeanFactory().getBean("dataService").loadDataFromXMLDirectory(xmlDirectory = ExpandPath("/Slatwall/config/dbdata"));
					
					// Run Scripts
					getBeanFactory().getBean("updateService").runScripts();
					
					// Reload All Integrations
					getBeanFactory().getBean("integrationService").updateIntegrationsFromDirectory();
					
					// Set the frameworks baseURL to be used by the buildURL() method
					variables.framework.baseURL = "#application.configBean.getContext()#/plugins/Slatwall/";
					
					// Call the setup method of mura requirements in the setting service, this has to be done from the setup request instead of the setupApplication, because mura needs to have certain things in place first
					var muraIntegrationService = createObject("component", "Slatwall.integrationServices.mura.Integration").init();
					muraIntegrationService.setupIntegration();
					
					// Set initialized to true
					application.slatwall.initialized = true;
					
					// Log that the application is finished setting up
					writeLog(file="Slatwall", text="Application Setup Complete");
				}
			}
		}
	}

	public void function setupRequest() {
		
		// Verify that the application is setup
		verifyApplicationSetup();
		
		// Run Sku Cache & Product Cache Update Threads if needed
		getBeanFactory().getBean("productCacheService").executeProductCacheUpdates();
		
		if(!getBeanFactory().getBean("requestCacheService").keyExists(key="ormHasErrors")) {
			getBeanFactory().getBean("requestCacheService").setValue(key="ormHasErrors", value=false);
		}
		
		// Look for mura Scope in the request context.  If it doens't exist add it.
		if (!structKeyExists(request.context,"$")){
			if (!structKeyExists(request, "muraScope")) {
				request.muraScope = application.serviceFactory.getBean("muraScope").init(application.serviceFactory.getBean("contentServer").bindToDomain());
			}
			request.context.$ = request.muraScope;
		}
		
		// Make sure that the mura Scope has a siteid.  If it doesn't then use the session siteid
		if(request.context.$.event('siteid') == "") {
			request.context.$.event('siteid', session.siteid);
		}
		
		// Setup slatwall scope in request cache If it doesn't already exist
		if(!getBeanFactory().getBean("requestCacheService").keyExists(key="slatwallScope")) {
			getBeanFactory().getBean("requestCacheService").setValue(key="slatwallScope", value= new Slatwall.com.utility.SlatwallScope());	
		}
		
		// Inject slatwall scope into the mura scope
		if( !structKeyExists(request, "custommurascopekeys") || !structKeyExists(request.custommurascopekeys, "slatwall") ) {
			request.context.$.setCustomMuraScopeKey("slatwall", getBeanFactory().getBean("requestCacheService").getValue(key="slatwallScope"));
		}
		
		// Add a reference to the mura scope to the request cache service
		getBeanFactory().getBean("requestCacheService").setValue(key="muraScope", value=request.context.$);
		
		// Confirm Session Setup
		getBeanFactory().getBean("sessionService").confirmSession();
		
		// Setup structured Data
		var structuredData = getBeanFactory().getBean("utilityFormService").buildFormCollections(request.context);
		if(structCount(structuredData)) {
			structAppend(request.context, structuredData);	
		}
		
		// Run subsytem specific logic.
		if(getSubsystem(request.context.slatAction) == "admin") {
			controller("admin:BaseController.subSystemBefore");
		} else if (getSubsystem(request.context.slatAction) == "frontend") {
			controller("frontend:BaseController.subSystemBefore");
		} else {
			request.context.sectionTitle = getSubsystem(request.context.slatAction);
			request.context.itemTitle = getSection(request.context.slatAction);
		}
	}
	
	public void function setupView() {
		
		var httpRequestData = getHTTPRequestData();
		if(structKeyExists(httpRequestData.headers, "Content-Type") and httpRequestData.headers["content-type"] eq "application/json") {
			setupResponse();
		}
		
		if(structKeyExists(url, "modal") && url.modal) {
			request.layouts = [ "/Slatwall/admin/layouts/modal.cfm" ];
		}
		
		// If this is an integration subsystem, then apply add the default layout to the request.layout
		if( !listFind("admin,frontend", getSubsystem(request.context.slatAction)) && (!structKeyExists(request,"layout") || request.layout)) {
			arrayAppend(request.layouts, "/Slatwall/admin/layouts/default.cfm");
		}
	}
	
	public void function setupResponse() {
		endSlatwallLifecycle();
		var httpRequestData = getHTTPRequestData();
		if(structKeyExists(httpRequestData.headers, "Content-Type") and httpRequestData.headers["content-type"] eq "application/json") {
			writeOutput( serializeJSON(request.context) );
			abort;
		}
	}
	
	// End: Standard Application Functions. These are also called from the fw1EventAdapter.

	// This handels all of the ORM persistece.
	public void function endSlatwallLifecycle() {
		if(getBeanFactory().getBean("requestCacheService").getValue("ormHasErrors")) {
			getBeanFactory().getBean("requestCacheService").clearCache(keys="currentSession,currentProduct,currentProductList");
			ormClearSession();
		} else {
			ormFlush();
		}
	}

	// ===================== APPLICATION HELPER FUNCTIONS =============================
	
	// Uses the current mura user to check security against a given action
	public boolean function secureDisplay(required string action) {
		var hasAccess = false;
		var permissionName = UCASE("PERMISSION_#getSubsystem(arguments.action)#_#getSection(arguments.action)#_#getItem(arguments.action)#");
		
		if(getSubsystem(arguments.action) != "admin") {
			hasAccess = true;
		} else {
			if(request.context.$.currentUser().getS2()) {
				hasAccess = true;
			} else if (listLen( request.context.$.currentUser().getMemberships() ) >= 1) {
				var rolesWithAccess = "";
				if(find("save", permissionName)) {
					rolesWithAccess = application.slatwall.pluginConfig.getApplication().getValue("serviceFactory").getBean("settingService").getPermissionValue(permissionName=replace(permissionName, "save", "edit")); 
					listAppend(rolesWithAccess, application.slatwall.pluginConfig.getApplication().getValue("serviceFactory").getBean("settingService").getPermissionValue(permissionName=replace(permissionName, "save", "update")));
				} else {
					rolesWithAccess = application.slatwall.pluginConfig.getApplication().getValue("serviceFactory").getBean("settingService").getPermissionValue(permissionName=permissionName);
				}
				
				for(var i=1; i<= listLen(rolesWithAccess); i++) {
					if( find( listGetAt(rolesWithAccess, i), request.context.$.currentUser().getMemberships() ) ) {
						hasAccess=true;
						break;
					}
				}
			}
		}
		return hasAccess;
	}
	
	// Allows for integration services to have a seperate directory structure
	public any function getSubsystemDirPrefix( string subsystem ) {
		if ( subsystem eq '' ) {
			return '';
		}
		if ( !listFind('admin,frontend', arguments.subsystem) ) {
			return 'integrationServices/' & subsystem & '/';
		}
		return subsystem & '/';
	}
	
	// Additional redirect function to redirect to an exact URL and flush the ORM Session when needed
	public void function redirectExact(required string location, boolean addToken=false) {
		endSlatwallLifecycle();
		location(arguments.location, arguments.addToken);
	}
	
	// This is used to setup the frontend path to pull from the siteid directory or the theme directory if the file exists
	public string function customizeViewOrLayoutPath( struct pathInfo, string type, string fullPath ) {
		if(arguments.pathInfo.subsystem == "frontend" && arguments.type == "view") {
			var themeView = replace(arguments.fullPath, "/Slatwall/frontend/views/", "#request.context.$.siteConfig('themeAssetPath')#/display_objects/custom/slatwall/");
			var siteView = replace(arguments.fullPath, "/Slatwall/frontend/views/", "#request.context.$.siteConfig('assetPath')#/includes/display_objects/custom/slatwall/");
			
			if(fileExists(expandPath(themeView))) {
				arguments.fullPath = themeView;	
			} else if (fileExists(expandPath(siteView))) {
				arguments.fullPath = siteView;
			}
			
		}
		return arguments.fullPath;
	}	
}
