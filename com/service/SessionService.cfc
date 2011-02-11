component extends="BaseService" output="false" {

	public any function getCurrent() {
		return session.slatwallSession;
	}
	
	public any function saveSession(required any SlatwallSession) {
		var sessionEntity = getNewEntity();
		sessionEntity.setAccount(arguments.SlatwallSession.getAccount());
		sessionEntity.setCart(arguments.SlatwallSession.getCart());
		// TODO: Set all session values
		save(entity = sessionEntity);
	}
}