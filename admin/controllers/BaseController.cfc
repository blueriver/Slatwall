component persistent="false" accessors="true" output="false" extends="mura.cfobject" {
	
	property name="fw" type="any";
	property name="rbFactory" type="any";
	
	public any function init(required any fw) {
		setFW(arguments.fw);
		setRBFactory(getFW().getPluginConfig().getApplication().getValue("rbFactory"));
		return this;
	}
	
}