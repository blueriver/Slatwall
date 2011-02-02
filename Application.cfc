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
		ormReload();
		
		var serviceFactory = "";
		var rbFactory = "";
		var defaultSiteRBFactory = "";
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
		defaultSiteRBFactory=createObject("component","mura.resourceBundle.resourceBundleFactory").init(application.rbFactory,"#expandPath('/#application.configBean.getWebRootMap()#')#/default/includes/resourceBundles/", session.rb);
		rbFactory=createObject("component","mura.resourceBundle.resourceBundleFactory").init(defaultSiteRBFactory,"#getDirectoryFromPath(getCurrentTemplatePath())#/resourceBundles", session.rb);
		getpluginConfig().getApplication().setValue( "rbFactory", rbFactory);
	}
	
	public void function setupSession() {
	  	 session.slat = structnew();
		 session.slatwall.crumbdata = arraynew(1);
	}
	
	public void function setupRequest() {
		var item = 0;
		
		for (item in request.context) {
			if (isSimpleValue(request.context[item])){
				if (request.context[item] eq '0,1' or request.context[item] eq '1,0'){
					request.context[item] = 1;
				}
			}
		}
		
		if (not structKeyExists(request.context,"$")){
			request.context.$=getBeanFactory().getBean("muraScope").init(session.siteid);
		}
		
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
		
		getpluginConfig().getApplication().getValue("rbFactory").resetSessionLocale();
		
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