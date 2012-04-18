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

	// Setup Framwork Configuration
	variables.framework=structNew();
	variables.framework.applicationKey="SlatwallFW1";
	variables.framework.base="/Slatwall";
	variables.framework.action="slatAction";
	variables.framework.error="admin:main.error";
	variables.framework.home="admin:main.default";
	variables.framework.defaultSection="main";
	variables.framework.defaultItem="default";
	variables.framework.usingsubsystems=true;
	variables.framework.defaultSubsystem = "admin";
	variables.framework.subsystemdelimiter=":";
	variables.framework.generateSES = false;
	variables.framework.SESOmitIndex = true;
	variables.framework.reload = "reload";
	
	// If we are installed inside of mura, then use the core application settings, otherwise use standalone settings
	if( fileExists(expandPath("../../config/applicationSettings.cfm")) ) {
		
		include "../../config/applicationSettings.cfm";
		include "../../config/mappings.cfm";
		include "../mappings.cfm";
	
	// Default Standalone settings
	} else {
		
		this.name = "slatwall" & hash(getCurrentTemplatePath());
		
		this.mappings[ "/Slatwall" ] = getDirectoryFromPath(getCurrentTemplatePath());
		this.mappings[ "/coldspring" ] = getDirectoryFromPath(getCurrentTemplatePath()) & "org/coldspring";
		this.mappings[ "/ValidateThis" ] = getDirectoryFromPath(getCurrentTemplatePath()) & "org/ValidateThis";
		
		this.ormenabled = true;
		this.datasource = "slatwall";
		
		this.ormsettings = {};
		this.ormsettings.cfclocation = ["com/entity"];
		this.ormSettings.dbcreate = "update";
		this.ormSettings.flushAtRequestEnd = false;
		this.ormsettings.eventhandling = true;
		this.ormSettings.automanageSession = false;
		this.ormSettings.savemapping = false;
		this.ormSettings.skipCFCwitherror = false;
		this.ormSettings.useDBforMapping = true;
		this.ormSettings.autogenmap = true;
		this.ormSettings.logsql = false;
		
	}
	
	this.mappings[ "/slatwallVfsRoot" ] = "ram:///" & this.name;
	
	public void function setValue(required any key, required any value) {
		param name="application.slatwall" default="#structNew()#";
		
		application.slatwall[ arguments.key ] = arguments.value;
	}
	
	public any function getValue(required any key) {
		param name="application.slatwall" default="#structNew()#";
		
		if( structKeyExists(application.slatwall, arguments.key)) {
			return application.slatwall[ arguments.key ];	
		}
		
		throw("You have requested a value for '#arguments.key#' from the core slatwall application that is not setup.  This may be because the verifyApplicationSetup() method has not been called yet")
	}
	
	public boolean function hasValue(required any key) {
		param name="application.slatwall" default="#structNew()#";
		
		if(structKeyExists(application.slatwall, arguments.key)) {
			return true;	
		}
		
		return false;
	}
	
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
					
					
					setValue("initialized", false);
					
					setValue("fw", this);
					
					setValue("slatwallVfsRoot", this.mappings[ "/slatwallVfsRoot" ]);
					
					setValue("validateThis", new ValidateThis.ValidateThis({definitionPath = "/Slatwall/com/validation/",injectResultIntoBO = true,defaultFailureMessagePrefix = ""}));
					
					// Make sure the correct version is in the application scope
					var versionFile = getDirectoryFromPath(getCurrentTemplatePath()) & "version.txt";
					if( fileExists( versionFile ) ) {
						setValue("version", trim(fileRead(versionFile)));
					} else {
						setValue("version", "unknown");
					}
					
					// Set vfs root for slatwall 
					if(!directoryExists( getValue("slatwallVfsRoot") )) {
						directoryCreate( getValue("slatwallVfsRoot") );
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
					setValue("initialized", true);
					
					// Log that the application is finished setting up
					writeLog(file="Slatwall", text="Application Setup Complete");
				}
			}
		}
	}
	
	public void function setupGlobalRequest() {
		// Verify that the application is setup
		verifyApplicationSetup();
		
		// Run Sku Cache & Product Cache Update Threads if needed
		getBeanFactory().getBean("productCacheService").executeProductCacheUpdates();
		
		// Set up Slatwall Scope inside of request
		request.slatwallScope = new Slatwall.com.utility.SlatwallScope();
		
		// Confirm Session Setup
		getBeanFactory().getBean("sessionService").confirmSession();
	}

	public void function setupRequest() {
		// Call the setup of the global Request
		setupGlobalRequest();
		
		// Setup structured Data if a request context exists meaning that a full action was called
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
	
	// This handels all of the ORM persistece.
	public void function endSlatwallLifecycle() {
		if(request.slatwallScope.getORMHasErrors()) {
			ormClearSession();
		} else {
			ormFlush();
		}
	}
	
	// Uses the current mura user to check security against a given action
	public boolean function secureDisplay(required string action) {
		var hasAccess = false;
		var permissionName = UCASE("PERMISSION_#getSubsystem(arguments.action)#_#getSection(arguments.action)#_#getItem(arguments.action)#");
		
		if(getSubsystem(arguments.action) != "admin") {
			hasAccess = true;
		} else {
			if(request.muraScope.currentUser().getS2()) {
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
	
	// Additional redirect function that allows us to redirect to a setting.  This can be defined in an integration as well
	public void function redirectSetting(required string settingName) {
		endSlatwallLifecycle();
		
	}
	
	
	
}
