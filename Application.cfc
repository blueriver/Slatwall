component extends="framework" output="false" {

	include "../../config/applicationSettings.cfm";
	include "../../config/mappings.cfm";
	include "../mappings.cfm";
	include "fw1Config.cfm";

	public void function setPluginConfig(required any pluginConfig) {
	  application[ variables.framework.applicationKey ].pluginConfig = arguments.pluginConfig; 
	}
	
	public any function getPluginConfig() {
	  return application[ variables.framework.applicationKey ].pluginConfig; 
	}
	
	// Start: Standard Application Functions. These are also called from the fw1EventAdapter.
	public void function setupApplication(any $) {
		var serviceFactory = "";
		var rbFactory = "";
		var xml = "";
		var xmlPath = "";

	    if ( not structKeyExists(request,"pluginConfig") or request.pluginConfig.getPackage() neq variables.framework.applicationKey){
		  	include "plugin/config.cfm";
		}
	    setPluginConfig(request.PluginConfig);
		xmlPath = "#expandPath( '/plugins' )#/#getPluginConfig().getDirectory()#/config/coldspring.xml";
		xml = FileRead("#xmlPath#"); 
		
		
		// Parse the xml and replace all [plugin] with the actual plugin mapping path.
	  	xml = replaceNoCase( xml, "[plugin]", "plugins.#getPluginConfig().getDirectory()#.", "ALL");
		
		if (getPluginConfig().getSetting("Integration") neq "Internal"){
			xml = replaceNoCase( xml, "[integration]", "#getPluginConfig().getSetting('Integration')#.", "ALL");
		}
		else {
			xml = replaceNoCase( xml, "[integration]", "", "ALL");
		}
		
		// Build Coldspring factory & Set in FW/1
		serviceFactory=createObject("component","coldspring.beans.DefaultXmlBeanFactory").init();
		serviceFactory.loadBeansFromXmlRaw( xml );
		serviceFactory.setParent(application.servicefactory);
		getpluginConfig().getApplication().setValue( "serviceFactory", serviceFactory );
		setBeanFactory(request.PluginConfig.getApplication().getValue( "serviceFactory" ));
				
		// Build RB Factory
		rbFactory= new mura.resourceBundle.resourceBundleFactory(application.settingsManager.getSite('default').getRBFactory(),"#getDirectoryFromPath(getCurrentTemplatePath())#resourceBundles/");
		getpluginConfig().getApplication().setValue( "rbFactory", rbFactory);
	}
	
	public void function setupSession() {
		session.slatwallSession = new Slatwall.com.utility.SlatwallSession();
	}
	
	public void function setupRequest() {
		if(!isDefined("session.SlatwallSession")) {
			setupSession();
		}
		
		// Setup Slatwall Specific request scope
		request.slatwallScope = new Slatwall.com.utility.SlatwallScope();
		request.context.$w = request.slatwallScope;
		
		// Look for values in the request content that are from checkboxes
		for (var item in request.context) {
			if (isSimpleValue(request.context[item])){
				if (request.context[item] eq '0,1' or request.context[item] eq '1,0'){
					request.context[item] = 1;
				}
			}
		}
		
		// Look for mura Scope.  If it doens't exist add it.
		if (not structKeyExists(request.context,"$")){
			request.context.$=getBeanFactory().getBean("muraScope").init(session.siteid);
		}
		
		// Set default mura session variables when needed
		param name="session.rb" default="en";
		if( not application.configBean.getSessionHistory()  or application.configBean.getSessionHistory() >= 30 ) {
			param name="session.dashboardSpan" default="30";
		} else {
			param name="session.dashboardSpan" default="#application.configBean.getSessionHistory()#";
		}
		if(not application.configBean.getSessionHistory()  or application.configBean.getSessionHistory() >= 30 ) {
			session.dashboardSpan=30;
		} else {
			session.dashboardSpan=application.configBean.getSessionHistory();
		}
		
		request.context.rbFactory = getPluginConfig().getApplication().getValue("rbFactory");
		variables.framework.baseURL="http://#cgi.http_host#/plugins/#getPluginConfig().getDirectory()#";
		
		
		// Run subsytem specific logic.
		if(isAdminRequest()) {
			controller("admin:BaseController.subSystemBefore");
		} else {
			controller("frontend:BaseController.subSystemBefore");
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
		// TODO: Add code to verify permisions
		return true;
	}
	
	// Override autowire function from fw/1 so that properties work
	private void function autowire(cfc, beanFactory) {
		var key = 0;
		var property = 0;
		var args = 0;
		var meta = getMetaData(arguments.cfc); 
		
		for(key in arguments.cfc) {
			if(len(key) > 3 && left(key,3) is "set") {
				property = right(key, len(key)-3);
				if(arguments.beanFactory.containsBean(property)) {
					evaluate("arguments.cfc.#key#(#arguments.beanFactory.getBean(property)#)");
				}
			}
		}
		if(isDefined("meta.accessors") && meta.accessors == true) {
			for(var i = 1; i <= arrayLen(meta.properties); i++) {
				if(arguments.beanFactory.containsBean(meta.properties[i].name)) {
					evaluate("arguments.cfc.set#meta.properties[i].name#(arguments.beanFactory.getBean(meta.properties[i].name))");
				}
			}
		}
	}
}