component persistent="false" accessors="true" output="false" extends="mura.cfobject" {
	
	property name="fw" type="any";
	property name="sessionService" type="any";
	
	public any function init(required any fw) {
		setFW(arguments.fw);
		
		return this;
	}

	public any function getPluginConfig() {
	   return application.slatwall.pluginConfig;
	}
}