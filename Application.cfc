component extends="framework" output="false" {

	include "../../config/applicationSettings.cfm";
	include "../../config/mappings.cfm";
	include "../mappings.cfm";
	include "fw1Config.cfm";

	public void function setPluginConfig(required any pluginConfig) {
	  application[ variables.framework.applicationKey ].pluginConfig = arguments.pluginConfig; 
	}
	
	public function getPluginConfig() {
	  return application[ variables.framework.applicationKey ].pluginConfig; 
	}
	
	// Start: Standard Application Functions. These are also called from the fw1EventAdapter.
	public function setupApplication(any $) {
		var serviceFactory = "";
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
		
		// Build Coldspring factory
		serviceFactory=createObject("component","coldspring.beans.DefaultXmlBeanFactory").init();
		serviceFactory.loadBeansFromXmlRaw( xml );
		serviceFactory.setParent(application.servicefactory);
		getpluginConfig().getApplication().setValue( "serviceFactory", serviceFactory );
		setBeanFactory(request.PluginConfig.getApplication().getValue( "serviceFactory" ));
	}
	
	
	public function setupSession() {
	  	 session.slat = structnew();
		 session.slatwall.crumbdata = arraynew(1);
	}
	
	public function setupRequest() {
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
		variables.framework.baseURL="http://#cgi.http_host#/plugins/#getPluginConfig().getDirectory()#";
	}
	// End: Standard Application Functions. These are also called from the fw1EventAdapter.

	// Helper Functions
	public function isAdminRequest() {
		return not structKeyExists(request,"servletEvent");
		
	}
	
	public function getExternalSiteLink(required String Address) {
		return #buildURL(action='external.site', queryString='es=#arguments.Address#')#;
	}
	

}