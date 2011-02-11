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
		
		var item = 0;
		
		// Look for values in the request content that are from checkboxes
		for (item in request.context) {
			if (isSimpleValue(request.context[item])){
				if (request.context[item] eq '0,1' or request.context[item] eq '1,0'){
					request.context[item] = 1;
				}
			}
		}
		
		// Create Slatwall Scope and place in request content
		if (not structKeyExists(request.context,"$w")) {
			request.context.$w = new Slatwall.com.utility.SlatwallScope(); 
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
	}
	// End: Standard Application Functions. These are also called from the fw1EventAdapter.

	// Helper Functions
	public boolean function isAdminRequest() {
		return not structKeyExists(request,"servletEvent");
	}
	
	public string function getExternalSiteLink(required String Address) {
		return buildURL(action='external.site', queryString='es=#arguments.Address#');
	}
	
}
