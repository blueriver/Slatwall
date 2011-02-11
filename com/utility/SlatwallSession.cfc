component accessors="true" extends="BaseObject" {

	property name="lastCrumbData" type="array";
	property name="accountID" type="string" default="";
	
	public any function init() {
		setLastCrumbData(arrayNew(1));
	}
	
	public any function getAccount() {
		if(!isDefined("request.ssc.account")) {
			if(getAccountID() != "") {
				request.ssc.account = getService("accountService").getByID(getAccountID());
			} else {
				request.ssc.account = getService("accountService").getNewEntity();
			}
		}
		return request.ssc.account;
	}
	
	public any function setAccount(required any account) {
		setAccountID(arguments.account.getAccountID());
	}
}