component persistent="false" accessors="true" output="false" extends="Slatwall.com.utility.BaseObject" {
	
	property name="fw" type="any";
	
	public any function init(required any fw) {
		setFW(arguments.fw);
		
		return this;
	}

	public any function getPluginConfig() {
	   return application.slatwall.pluginConfig;
	}
	
}