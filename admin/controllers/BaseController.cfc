component persistent="false" accessors="true" output="false" extends="mura.cfobject" {
	
	property name="fw" type="any";
	
	public any function init(required any fw) {
		setFW(arguments.fw);
		
		return this;
	}
	
}