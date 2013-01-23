component extends="FW1.framework" {
	
	// ======= START: ENVIORNMENT CONFIGURATION =======

	// =============== configApplication
	
	// Defaults
	this.name = "hibachi" & hash(getCurrentTemplatePath());
	this.sessionManagement = true;
	this.datasource = {};
	this.datasource.name = "hibachi";
	
	// Allow For Application Config
	if( fileExists(expandPath("config/configApplication.cfm")) ) {
		include "../../config/configApplication.cfm";
	}
	// Allow For Instance Config
	if( fileExists(expandPath("config/custom/configApplication.cfm")) ) {
		include "../../config/custom/configApplication.cfm";
	}
	
	// =============== configFramework
	
	// Defaults
	
	// FW1 Setup
	variables.framework=structNew();
	variables.framework.applicationKey = 'Hibachi';
	variables.framework.action = 'action';
	variables.framework.usingSubsystems = true;
	variables.framework.defaultSubsystem = 'admin';
	variables.framework.defaultSection = 'main';
	variables.framework.defaultItem = 'default';
	variables.framework.subsystemDelimiter = ':';
	variables.framework.siteWideLayoutSubsystem = 'common';
	variables.framework.home = 'admin:main.default';
  	variables.framework.error = 'admin:main.error';
  	variables.framework.reload = 'reload';
  	variables.framework.password = 'true';
  	variables.framework.reloadApplicationOnEveryRequest = false;
  	variables.framework.generateSES = false;
  	variables.framework.SESOmitIndex = true;
  	variables.framework.suppressImplicitService = true;
	variables.framework.unhandledExtensions = 'cfc';
	variables.framework.unhandledPaths = '/flex2gateway';
	variables.framework.unhandledErrorCaught = false;
	variables.framework.preserveKeyURLKey = 'fw1pk';
	variables.framework.maxNumContextsPreserved = 10;
	variables.framework.cacheFileExists = false;
	variables.framework.trace = false;
	variables.framework.routes = [
		{ "$GET/api/:entityName/:entityID" = "/admin:api/get/entityName/:entityName/entityID/:entityID"},
		{ "$GET/api/:entityName/" = "/admin:api/post/entityName/:entityName/"}
	];
	
	// Hibachi Setup
	variables.framework.hibachi = {};
	variables.framework.hibachi.fullUpdateKey = "Update";
	variables.framework.hibachi.fullUpdatePassword = "true";
	
	// Allow For Application Config
	if( fileExists(expandPath("config/configFramework.cfm")) ) {
		include "../../config/configFramework.cfm";
	}
	
	// Allow For Instance Config
	if( fileExists(expandPath("config/custom/configFramework.cfm")) ) {
		include "../../config/custom/configFramework.cfm";
	}
	
	// =============== configMappings
	
	// Defaults
	this.mappings[ "/#variables.framework.applicationKey#" ] = replace(replace(getDirectoryFromPath(getCurrentTemplatePath()),"\","/","all"), "/org/Hibachi/", "/");
	
	// Allow For Application Config 
	if( fileExists(expandPath("config/configMappings.cfm")) ) {
		include "../../config/configMappings.cfm";
	}
	
	// Allow For Instance Config
	if( fileExists(expandPath("config/custom/configMappings.cfm")) ) {
		include "../../config/custom/configMappings.cfm";
	}
	
	// =============== configCustomTags
	
	// Defaults
	this.customtagpaths = this.mappings[ "/#variables.framework.applicationKey#" ] & "/org/Hibachi/HibachiTags";
	
	// Allow For Application Config 
	if( fileExists(expandPath("config/configCustomTags.cfm")) ) {
		include "../../config/configCustomTags.cfm";
	}
	// Allow For Instance Config
	if( fileExists(expandPath("config/custom/configCustomTags.cfm")) ) {
		include "../../config/custom/configCustomTags.cfm";
	}
	
	// =============== configORM
	
	// Defaults
	this.ormenabled = true;
	this.ormsettings = {};
	this.ormsettings.cfclocation = [ "/#variables.framework.applicationKey#/model/entity" ];
	this.ormSettings.dbcreate = "update";
	this.ormSettings.flushAtRequestEnd = false;
	this.ormsettings.eventhandling = true;
	this.ormSettings.automanageSession = false;
	this.ormSettings.savemapping = false;
	this.ormSettings.skipCFCwitherror = false;
	this.ormSettings.useDBforMapping = true;
	this.ormSettings.autogenmap = true;
	this.ormSettings.logsql = false;
	
	// Allow For Application Config
	if( fileExists(expandPath("config/configORM.cfm")) ) {
		include "../../config/configORM.cfm";
	}
	// Allow For Instance Config
	if( fileExists(expandPath("config/custom/configORM.cfm")) ) {
		include "../../config/custom/configORM.cfm";
	}
	
	// Make Sure that the required values end up in the application scope so that we can get them from somewhere else
	
	// =======  END: ENVIORNMENT CONFIGURATION  =======
	
	public any function bootstrap() {
		setupGlobalRequest();
		
		return request["#variables.framework.applicationKey#Scope"];
	}
	
	public any function reloadApplication() {
		lock name="application_#getHibachiInstanceApplicationScopeKey()#_initialized" timeout="10" {
			if( !structKeyExists(application, getHibachiInstanceApplicationScopeKey()) ) {
				application[ getHibachiInstanceApplicationScopeKey() ] = {};
			}
			application[ getHibachiInstanceApplicationScopeKey() ].initialized = false;
		}
	}
	
	public void function setupGlobalRequest() {
		request["#variables.framework.applicationKey#Scope"] = createObject("component", "#variables.framework.applicationKey#.model.hibachi.Scope").init();
		
		// Verify that the application is setup
		verifyApplicationSetup();
		
		// Call the onEveryRequest() Method for the parent Application.cfc
		onEveryRequest();
	}
	
	public void function setupRequest() {
		setupGlobalRequest();
		
		// Setup structured Data if a request context exists meaning that a full action was called
		getBeanFactory().getBean("_FormUtilities").buildFormCollections(request.context);
		
		// Setup a $ in the request context, and the slatwallScope shortcut
		request.context.$ = {};
		request.context.$[ variables.framework.applicationKey ] = request[ "#variables.framework.applicationKey#Scope" ];
		
		// Check to see if any message keys were passed via the URL
		if(structKeyExists(request.context, "messageKeys")) {
			var messageKeys = listToArray(request.context.messageKeys);
			for(var i=1; i<=arrayLen(messageKeys); i++) {
				request[ "#variables.framework.applicationKey#Scope" ].showMessageKey( messageKeys[i] );
			}
		}
		
		// Call the onInternalRequest() Method for the parent Application.cfc
		onInternalRequest();
	}
	
	public void function verifyApplicationSetup() {
		if(structKeyExists(url, variables.framework.reload) && url[variables.framework.reload] == variables.framework.password) {
			reloadApplication();
		}
		
		// Check to see if out application stuff is initialized
		if(!getHibachiScope().hasApplicationValue("initialized") || !getHibachiScope().getApplicationValue("initialized")) {
			
			// If not, lock the application until this is finished
			lock scope="Application" timeout="240"  {
				
				// Check again so that the qued requests don't back up
				if(!getHibachiScope().hasApplicationValue("initialized") || !getHibachiScope().getApplicationValue("initialized")) {
					
					// Application Setup Started
					reloadApplication();
					writeLog(file="#variables.framework.applicationKey#", text="General Log - Application Setup Started");
					
					// Setup the fw1ApplicationKey in the application scope to use it later
					getHibachiScope().setApplicationValue("applicationKey", variables.framework.applicationKey);
					
					// Place the entire application in the application scope so that we can introspect these values later
					getHibachiScope().setApplicationValue("application", this);
					
					// =================== Required Application Setup ===================
					// The FW1 Application had not previously been loaded so we are going to call onApplicationStart()
					if(!structKeyExists(application, variables.framework.applicationKey)) {
						writeLog(file="#variables.framework.applicationKey#", text="General Log - onApplicationStart() was called");
						onApplicationStart();
						writeLog(file="#variables.framework.applicationKey#", text="General Log - onApplicationStart() finished");
					}
					// ================ END: Required Application Setup ==================
					
					//========================= IOC SETUP ====================================
					
					var bf = new org.Hibachi.DI1.ioc("/#variables.framework.applicationKey#/model", {
						transients=["transient", "entity", "process", "hibachi"]
					});
					
					bf.declareBean("hibachiDAO", "#variables.framework.applicationKey#.org.Hibachi.HibachiDAO", true);
					bf.declareBean("hibachiService", "#variables.framework.applicationKey#.org.Hibachi.HibachiService", true);
					
					if(!bf.containsBean("hibachiAuthenticationService")) {
						bf.declareBean("hibachiAuthenticationService", "#variables.framework.applicationKey#.org.Hibachi.HibachiAuthenticationService", true);	
					}
					if(!bf.containsBean("hibachiRBService")) {
						bf.declareBean("hibachiRBService", "#variables.framework.applicationKey#.org.Hibachi.HibachiRBService", true);	
					}
					if(!bf.containsBean("hibachiEventService")) {
						bf.declareBean("hibachiEventService", "#variables.framework.applicationKey#.org.Hibachi.HibachiEventService", true);	
					}
					if(!bf.containsBean("hibachiTagService")) {
						bf.declareBean("hibachiTagService", "#variables.framework.applicationKey#.org.Hibachi.HibachiTagService", true);	
					}
					if(!bf.containsBean("hibachiLogService")) {
						bf.declareBean("hibachiLogService", "#variables.framework.applicationKey#.org.Hibachi.HibachiLogService", true);	
					}
					
					bf.declareBean("_FormUtilities", "#variables.framework.applicationKey#.org.Hibachi.FormUtilities.FormUtilities", true);
					
					setBeanFactory( bf );
					writeLog(file="#variables.framework.applicationKey#", text="General Log - Bean Factory Set");
					
					//========================= END: IOC SETUP ===============================
					
					// Call the onFirstRequest() Method for the parent Application.cfc
					onFirstRequest();
					
					// ============================ FULL UPDATE =============================== (this is only run when updating, or explicitly calling it by passing update=true as a url key)
					if(!fileExists(expandPath('config/lastFullUpdate.txt.cfm')) || (structKeyExists(url, variables.framework.hibachi.fullUpdateKey) && url[ variables.framework.hibachi.fullUpdateKey ] == variables.framework.hibachi.fullUpdatePassword)){
						writeLog(file="#variables.framework.applicationKey#", text="General Log - Full Update Initiated");
						
						// Write File
						fileWrite(expandPath('config/lastFullUpdate.txt.cfm'), now());
						
						// Set the request timeout to 360
						getBeanFactory().getBean("hibachiTagService").cfsetting(requesttimeout=360);
						
						// Reload ORM
						writeLog(file="#variables.framework.applicationKey#", text="General Log - ORMReload() started");
						ormReload();
						writeLog(file="#variables.framework.applicationKey#", text="General Log - ORMReload() was successful");
							
						onUpdateRequest();						
					}
					// ========================== END: FULL UPDATE ==============================
					
					// Application Setup Ended
					getHibachiScope().setApplicationValue("initialized", true);
					writeLog(file="#variables.framework.applicationKey#", text="General Log - Application Setup Complete");
				}
			}
		}
	}
	
	public void function setupResponse() {
		endHibachiLifecycle();
		var httpRequestData = getHTTPRequestData();
		if(structKeyExists(httpRequestData.headers, "X-#variables.framework.applicationKey#-AJAX") && isBoolean(httpRequestData.headers["X-#variables.framework.applicationKey#-AJAX"]) && httpRequestData.headers["X-#variables.framework.applicationKey#-AJAX"]) {
			if(structKeyExists(request.context, "fw")) {
				structDelete(request.context, "fw");
			}
			if(structKeyExists(request.context, "$")) {
				structDelete(request.context, "$");
			}
			writeOutput( serializeJSON(request.context) );
			abort;
		}
	}
	
	public void function setupView() {
		var httpRequestData = getHTTPRequestData();
		if(structKeyExists(httpRequestData.headers, "X-#variables.framework.applicationKey#-AJAX") && isBoolean(httpRequestData.headers["X-#variables.framework.applicationKey#-AJAX"]) && httpRequestData.headers["X-#variables.framework.applicationKey#-AJAX"]) {
			setupResponse();
		}
		
		if(structKeyExists(url, "modal") && url.modal) {
			request.layout = false;
			setLayout("admin:modal");
		}
		
		// If this is an integration subsystem, then apply add the default layout to the request.layout
		if( !listFind("admin,frontend", getSubsystem(request.context.slatAction)) && (!structKeyExists(request,"layout") || request.layout)) {
			setLayout("admin:main");
		}
	}
	
	
	// This handels all of the ORM persistece.
	public void function endHibachiLifecycle() {
		if(getHibachiScope().getORMHasErrors()) {
			getBeanFactory().getBean("hibachiDAO").clearORMSession();
		} else {
			getBeanFactory().getBean("hibachiDAO").flushORMSession();
		}
	}
	
	// Additional redirect function to redirect to an exact URL and flush the ORM Session when needed
	public void function redirectExact(required string location, boolean addToken=false) {
		endHibachiLifecycle();
		location(arguments.location, arguments.addToken);
	}
	
	// This method will execute an actions controller, render the view for that action and return it without going through an entire lifecycle
	public string function doAction(required string action) {
		var response = "";
		
		// first, we double check to make sure all framework defaults are setup
		setupFrameworkDefaults();
		
		var originalContext = {};
		var originalServices = [];
		var originalViewOverride = "";
		var originalCFCBase = "";
		var originalBase = "";
		
		
		// If there was already a request.context, then we need to save it to be used later
		if(structKeyExists(request, "context")) {
			originalContext = request.context;
			structDelete(request, "context");
		}
		
		// If there was already a request.services, then we need to save it to be used later
		if(structKeyExists(request, "services")) {
			originalServices = request.services;
			structDelete(request, "services");
		}
		
		// If there was already a view override in the request, then we need to save it to be used later
		if(structKeyExists(request, "overrideViewAction")) {
			originalViewOverride = request.overrideViewAction;
			structDelete(request, "overrideViewAction");
		}
		
		// We also need to store the original cfcbase if there was one
		if(structKeyExists(request, "cfcbase")) {
			originalCFCBase = request.cfcbase;
			structDelete(request, "cfcbase");
		}
		
		// We also need to store the original base if there was one
		if(structKeyExists(request, "base")) {
			originalBase = request.base;
			structDelete(request, "base");
		}
		
		// create a new request context to hold simple data, and an empty request services so that the view() function works
		request.context = {};
		request.services = [];
		
		// Place form and URL into the new structure
		structAppend(request.context, form);
		structAppend(request.context, url);
		
		if(!structKeyExists(request.context, "$")) {
			request.context.$ = {};
			request.context.$[ variables.framework.applicationKey ] = request[ "#variables.framework.applicationKey#Scope" ];
		}
		
		// Add the slatAction to the RC Scope
		request.context[ variables.framework.action ] = arguments.action;
		
		// Do structured data just like a normal request
		getBeanFactory().getBean("_FormUtilities").buildFormCollections(request.context);
		
		// Get Action Details
		var subsystem = getSubsystem( arguments.action );
		var section = getSection( arguments.action );
		var item = getItem( arguments.action );
		
		// Setup the cfc base so that the getController method works
		request.cfcbase = variables.framework.cfcbase;
		request.base = variables.framework.base;

		// Call the controller
		var controller = getController( section = section, subsystem = subsystem );
		if(isObject(controller)) {
			doController( controller, 'before' );
			doController( controller, 'start' & item );
			doController( controller, item );
			doController( controller, 'end' & item );
			doController( controller, 'after' );
		}
				
		// Was the view overridden in the controller
		if ( structKeyExists( request, 'overrideViewAction' ) ) {
			subsystem = getSubsystem( request.overrideViewAction );
			section = getSection( request.overrideViewAction );
			item = getItem( request.overrideViewAction );
		}
		
		var viewPath = parseViewOrLayoutPath( subsystem & variables.framework.subsystemDelimiter & section & '/' & item, 'view' );
		
		// Place all of this formated data into a var named rc just like a regular request
		var rc = request.context;
		var $ = request.context.$;
		
		// Include the view
		savecontent variable="response"  {
			include "#viewPath#";
		}
		
		// Remove the cfcbase & base from the request so that future actions don't get screwed up
		structDelete( request, 'context' );
		structDelete( request, 'services' );
		structDelete( request, 'overrideViewAction' );
		structDelete( request, 'cfcbase' );
		structDelete( request, 'base' );
		
		// If there was an override view action before... place it back into the request
		if(structCount(originalContext)) {
			request.context = originalContext;
		}
		
		// If there was an override view action before... place it back into the request
		if(arrayLen(originalServices)) {
			request.services = originalServices;
		}
		
		// If there was an override view action before... place it back into the request
		if(len(originalViewOverride)) {
			request.overrideViewAction = originalViewOverride;
		}
		
		// If there was a different cfcbase before... place it back into the request
		if(len(originalCFCBase)) {
			request.cfcbase = originalCFCBase;
		}
		
		// If there was a different base before... place it back into the request
		if(len(originalBase)) {
			request.base = originalBase;
		}
		
		return response;
	}
	
	// @hint private helper method
	public any function getHibachiScope() {
		return request["#variables.framework.applicationKey#Scope"];
	}
	
	// @hint setups an application scope value that will always be consistent
	public any function getHibachiInstanceApplicationScopeKey() {
		var metaData = getMetaData( this );
		do {
			var filePath = metaData.path;
			metaData = metaData.extends;
		} while( structKeyExists(metaData, "extends") );
		
		filePath = lcase(replaceNoCase(getDirectoryFromPath(filePath), "/fw1/","/","all"));
		var appKey = hash(filePath);
		
		return appKey;
	}
	
	// THESE METHODS ARE INTENTIONALLY LEFT BLANK
	public void function onEveryRequest() {}
	
	public void function onInternalRequest() {}
	
	public void function onFirstRequest() {}
	
	public void function onUpdateRequest() {}
	
}