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

	// If the page request was an admin request then we need to setup all of the defaults from mura
	if(isAdminRequest()) {
		include "../../config/applicationSettings.cfm";
		include "../../config/mappings.cfm";
		include "../mappings.cfm";
	}
	
	include "fw1Config.cfm";
	variables.slatwallVfsRoot = "ram:///" & this.name;
	this.mappings[ "/slatwallVfsRoot" ] = variables.slatwallVfsRoot;
	
	public void function setPluginConfig(required any pluginConfig) {
		application.slatwall.pluginConfig = arguments.pluginConfig; 
	}
	
	public any function getPluginConfig() {
		if( isDefined('application.slatwall.pluginConfig') ) {
			return application.slatwall.pluginConfig;	
		}
	}

	// Start: Standard Application Functions. These are also called from the fw1EventAdapter.
	public void function setupApplication(any $) {
		// Check to see if the base application has been loaded, if not redirect then to the homepage of the site.
		if( isAdminRequest() && (!structKeyExists(application, "appinitialized") || application.appinitialized == false)) {
			location(url="http://#cgi.HTTP_HOST#", addtoken=false);
		}
		
		// This insures that the required session values are setup
		setupMuraSessionRequirements();
		
		// This will allow for the Taffy API to reload on next request
		if(structKeyExists(application, "_taffy")){
			structDelete(application,"_taffy");	
		}
		
		// This sets up the Plugin Config for later use
		if ( not structKeyExists(request,"pluginConfig") or request.pluginConfig.getPackage() neq variables.framework.applicationKey){
	  		include "plugin/config.cfm";
		}
		setPluginConfig(request.PluginConfig);
		
		// Make sure the correct version is in the plugin config
		var versionFile = getDirectoryFromPath(getCurrentTemplatePath()) & "version.txt";
		if( fileExists( versionFile ) ) {
			getPluginConfig().getApplication().setValue('SlatwallVersion', trim(fileRead(versionFile)));
		}
		
		// Set this in the application scope to be used on the frontend
		getPluginConfig().getApplication().setValue( "fw", this);
		
		// Set the setup confirmed as false
		getPluginConfig().getApplication().setValue('applicationSetupConfirmed', false);
		
		// Set vfs root for slatwall
		getPluginConfig().getApplication().setValue('slatwallVfsRoot', slatwallVfsRoot);
		
		// Make's sure that our entities get updated
		ormReload();
		
		// Get Coldspring Config
		var serviceFactory = "";
		var integrationService = "";
		var rbFactory = "";
		var xml = "";
		var xmlPath = "";

	    xmlPath = expandPath( '/plugins/Slatwall/config/coldspring.xml' );
		xml = xmlParse(FileRead("#xmlPath#")); 
		
		// Build Coldspring factory
		serviceFactory=createObject("component","coldspring.beans.DefaultXmlBeanFactory").init();
		serviceFactory.loadBeansFromXmlObj( xml );
		
		// Set mura as the parent Bean Factory
		serviceFactory.setParent( application.serviceFactory );
		
		// Set a data service coldspring as the child factory, with the Slatwall as it's parent
		integrationService = serviceFactory.getBean("integrationService");
		serviceFactory = integrationService.updateColdspringWithDataIntegration( serviceFactory, xml );
		
		// Place the service factory into the required application scopes
		getpluginConfig().getApplication().setValue( "serviceFactory", serviceFactory );
		setBeanFactory( getPluginConfig().getApplication().getValue( "serviceFactory" ) );
		
		// Build RB Factory
		rbFactory= new mura.resourceBundle.resourceBundleFactory(application.settingsManager.getSite('default').getRBFactory(), getDirectoryFromPath(expandPath("/plugins/Slatwall/resourceBundles/") ));
		getpluginConfig().getApplication().setValue( "rbFactory", rbFactory);
		
		// Setup Default Data... This is only for development and should be moved to the update function of the plugin once rolled out.
		getBeanFactory().getBean("DataService").loadDataFromXMLDirectory(xmlDirectory = ExpandPath("/plugins/Slatwall/config/DBData"));
		
		// Load all Slatwall Settings
		getBeanFactory().getBean("settingService").reloadConfiguration();
		
		// Reload All Integrations
		getBeanFactory().getBean("integrationService").updateIntegrationsFromDirectory();
		
		// Set the first request to True so that it runs
		getPluginConfig().getApplication().setValue("firstRequestOfApplication", true);
		
		getBeanFactory().getBean("logService").logMessage(message="Application Setup Complete", generalLog=true);
		
		variables.framework.baseURL = "#application.configBean.getContext()#/plugins/Slatwall/";
	}
	
	public void function setupRequest() {
		getBeanFactory().getBean("logService").logMessage(message="Slatwall Lifecycle Started: #request.context.slatAction#");
		
		// Check to see if the base application has been loaded, if not redirect then to the homepage of the site.
		if( isAdminRequest() && (!structKeyExists(application, "appinitialized") || application.appinitialized == false)) {
			location(url="http://#cgi.HTTP_HOST#", addtoken=false);
		}
		
		if( getPluginConfig().getApplication().getValue("firstRequestOfApplication", true) ) {
			// Log that this started
			getBeanFactory().getBean("logService").logMessage(message="First Request of Application Setup Started", generalLog=true);
			
			// Call the setup method of mura requirements in the setting service, this has to be done from the setup request instead of the setupApplication, because mura needs to have certain things in place first
			getBeanFactory().getBean("settingService").verifyMuraRequirements();
			
			// Set this to false in the application so that it doesn't run again
			getPluginConfig().getApplication().setValue("firstRequestOfApplication", false);
			
			// Log that this finished
			getBeanFactory().getBean("logService").logMessage(message="First Request of Application Setup Finished", generalLog=true);
		}
		
		// This verifies that all mura session variables are setup
		setupMuraSessionRequirements();
		
		// Enable the request cache service
		getBeanFactory().getBean("requestCacheService").enableRequestCache();
		
		if(!getBeanFactory().getBean("requestCacheService").keyExists(key="ormHasErrors")) {
			getBeanFactory().getBean("requestCacheService").setValue(key="ormHasErrors", value=false);
		}
		
		// Look for mura Scope in the request context.  If it doens't exist add it.
		if (!structKeyExists(request.context,"$")){
			if (!structKeyExists(request, "muraScope")) {
				request.muraScope = getBeanFactory().getBean("muraScope").init(application.serviceFactory.getBean("contentServer").bindToDomain());
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
		getBeanFactory().getBean("SessionService").confirmSession();
		
		// Setup structured Data
		request.context.structuredData = getBeanFactory().getBean("utilityFormService").buildFormCollections(request.context);
		
		// Run subsytem specific logic.
		if(isAdminRequest()) {
			controller("admin:BaseController.subSystemBefore");
		} else {
			controller("frontend:BaseController.subSystemBefore");
		}
	}
	
	public void function setupView() {
		// If this is an integration subsystem, then apply add the default layout to the request.layout
		if( !listFind("admin,frontend,common", getSubsystem(request.context.slatAction))) {
			arrayAppend(request.layouts, "/Slatwall/admin/layouts/default.cfm");
			getAssetWire().addViewToAssets("/Slatwall/admin/views/main/default.cfm");
		}
	}
	
	// End: Standard Application Functions. These are also called from the fw1EventAdapter.

	// Helper Functions
	public boolean function isAdminRequest() {
		return not structKeyExists(request,"servletEvent");
	}
	
	public string function getExternalSiteLink(required String Address) {
		return buildURL(action='external.site', queryString='es=#arguments.Address#');
	}
	
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
	
	private void function setupMuraSessionRequirements() {
		// Set default mura session variables when needed
		param name="session.rb" default="en";
		param name="session.locale" default="en";
		param name="session.dtLocale" default="en-US";
		param name="session.siteid" default="default";
		param name="session.dashboardSpan" default="30";
	}
	
	
	// Override onRequest function to add some custom logic to the end of the request
	public any function getSubsystemDirPrefix( string subsystem ) {
		if ( subsystem eq '' ) {
			return '';
		}
		if ( !listFind('admin,frontend,common', arguments.subsystem) ) {
			return 'integrationServices/' & subsystem & '/';
		}
		return subsystem & '/';
	}
	
	// Override onRequest function to add some custom logic to the end of the request
	public any function onRequest() {
		super.onRequest(argumentCollection=arguments);
		endSlatwallLifecycle();
	}
	
	// Override redirect function to flush the ORM when needed
	public void function redirect() {
		endSlatwallLifecycle();
		super.redirect(argumentCollection=arguments);
	}
	
	// Additional redirect function to redirect to an exact URL and flush the ORM Session when needed
	public void function redirectExact(required string location, boolean addToken=false) {
		endSlatwallLifecycle();
		location(arguments.location, arguments.addToken);
	}
	
	// This handels all of the ORM persistece.
	public void function endSlatwallLifecycle() {
		if(getBeanFactory().getBean("requestCacheService").getValue("ormHasErrors")) {
			getBeanFactory().getBean("requestCacheService").clearCache(keys="currentSession,currentProduct,currentProductList");
			ormClearSession();
			getBeanFactory().getBean("logService").logMessage("ormClearSession() Called");
		} else {
			ormFlush();
			getBeanFactory().getBean("logService").logMessage("ormFlush() Called");
		}
		getBeanFactory().getBean("logService").logMessage("Slatwall Lifecycle Finished: #request.context.slatAction#");
	}
	
	// This is used to setup the frontend path to pull from the siteid directory
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
	
	// Start assetWire functions ==================================
	public any function getAssetWire() {
		if(!structKeyExists(request, "assetWire")) {
			request.assetWire = new assets.assetWire(this); 
		}
		return request.assetWire;
	}
	
	private void function buildViewAndLayoutQueue() {
		super.buildViewAndLayoutQueue();
		if(structKeyExists(request, "view")) {
			getAssetWire().addViewToAssets(request.view);
		}
	}
	
	private string function internalLayout( string layoutPath, string body ) {
		var rtn = super.internalLayout(argumentcollection=arguments);
		
		if(arguments.layoutPath == request.layouts[arrayLen(request.layouts)]) {
			if( !listFind("frontend,common", getSubsystem(request.action)) || request.action == "frontend:event.onRenderEnd" || request.action == "frontend:event.onAdminModuleNav") {
				getBeanFactory().getBean("utilityTagService").cfhtmlhead(getAssetWire().getAllAssets());
			}
		}
		return rtn;
	}
		
	public string function view( string path, struct args = { } ) {
		getAssetWire().addViewToAssets(trim(parseViewOrLayoutPath( path, "view" )));
		return super.view(argumentcollection=arguments);
	}
	
	// End assetWire functions ==================================
}