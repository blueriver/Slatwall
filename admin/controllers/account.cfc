component extends="BaseController" persistent="false" accessors="true" output="false" {
	
	property name="accountService";
	
	public void function list(required struct rc) {
		param name="rc.keyword" default="";
		rc.section = "Account List";
		
		rc.accountSmartList = getAccountService().getSmartList(arguments.rc);
	}
}