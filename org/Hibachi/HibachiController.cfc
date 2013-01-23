component output="false" accessors="true" extends="HibachiObject" {
	
	property name="fw" type="any";
	
	public void function init( required any fw ) {
		setFW(arguments.fw);
	}
}