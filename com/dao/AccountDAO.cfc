component extends="slatwall.com.dao.BaseDAO" {
			
	public any function readByMuraUserID(required string muraUserID) {
		return ormExecuteQuery(" from SlatwallAccount aSlatwallAccount where aSlatwallAccount.muraUserID=:muraUserID", {muraUserID=arguments.muraUserID}, true);
	}
	
	public any function readByAccountEmail(required string email) {
		return ormExecuteQuery("SELECT account FROM SlatwallAccountEmail aSlatwallAccountEmail where aSlatwallAccountEmail.email=:email", {email=arguments.email}, true);
	}
}