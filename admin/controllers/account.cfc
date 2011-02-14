component extends="BaseController" persistent="false" accessors="true" output="false" {
	
	property name="accountService";
	
	public void function before(required struct rc) {
	}
	
	public void function list(required struct rc) {
		param name="rc.keyword" default="";
		
		rc.accountSmartList = getAccountService().getSmartList(arguments.rc);
	}
}