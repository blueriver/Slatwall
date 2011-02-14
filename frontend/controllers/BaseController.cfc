component persistent="false" accessors="true" output="false" extends="mura.cfobject" {
	
	property name="fw" type="any";
	
	public any function init(required any fw) {
		setFW(arguments.fw);
		return this;
	}
	
	public void function subSystemBefore() {
		// Place any functionality that you would like applied on every request of this subsystem.
	}
}