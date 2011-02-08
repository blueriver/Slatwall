component extends="slatwall.com.dao.BaseDAO" {
			
	public any function readByMuraUserID(required string muraUserID) {
		return ormExecuteQuery(" from SlatwallAccount where muraUser.muraUserID=:muraUserID", {muraUserID=arguments.muraUserID}, true);
	}
	
	public any function readByAccountEmail(required string email) {
		var accountEmail = ormExecuteQuery(" from SlatwallAccountEmail where email=:email", {email=arguments.email}, true);
		if(!isnull(accountEmail)) {
			return accountEmail.getAccount();
		}
	}
	
	public any function readUserByMuraUserID(required string muraUserID) {
		return ormExecuteQuery(" from SlatwallUser where muraUserID=:muraUserID", {muraUserID=arguments.muraUserID}, true);
	}
}