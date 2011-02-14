component extends="BaseController" persistent="false" accessors="true" output="false" {
	
	property name="accountService";
	
	public void function before(required struct rc) {
		rc.sectionTitle = rc.$w.rbKey("account.accounts");
	}
	
	public void function list(required struct rc) {
		param name="rc.keyword" default="";
		rc.itemTitle = rc.$w.rbKey("account.list");
		
		rc.accountSmartList = getAccountService().getSmartList(arguments.rc);
	}
}