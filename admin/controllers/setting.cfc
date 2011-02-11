component extends="BaseController" output="false" accessors="true" {
			
	property name="settingService" type="any";
	
	public void function detail(required struct rc) {
		param name="rc.edit" default="false";
		rc.settingService = getSettingService();
	}
	
}