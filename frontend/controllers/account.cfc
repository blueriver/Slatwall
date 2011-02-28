component persistent="false" accessors="true" output="false" extends="BaseController" {

	property name="accountService" type="any";
	
	public void function detail(required struct rc) {
		param name="rc.edit" default="false";
		
		rc.account = rc.$.Slatwall.getCurrentAccount();
	}
	
	public void function edit(required struct rc) {
		rc.edit = true;
		setView("frontend:account.detail");
		detail(rc);

	}
	
}