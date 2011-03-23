component extends="BaseService" accessors="true" output="false" {

	property name="tagProxyService" type="Slatwall.com.service.TagProxyService";

	public any function getCurrent() {
		return request.slatwallSession;
	}
	
	public string function setupSessionRequest() {
		// Setup Request Scope Slatwall Session holder
		request.slatwallSession = "";
		
		// Figure out the appropriate session ID and create a new one if necessary
		if(!structKeyExists(session, "slatwallSessionID")) {
			if(structKeyExists(cookie, "slatwallSessionID")) {
				session.slatwallSessionID = cookie.slatwallSessionID;
			} else {
				session.slatwallSessionID = "";
			}
		}
		
		// Load Session into request
		request.slatwallSession = getByID(session.slatwallSessionID);
		
		if(isNull(request.slatwallSession)) {
			request.slatwallSession = getNewEntity();
			save(request.slatwallSession);
		}
		
		session.slatwallSessionID = request.slatwallSession.getSessionID();
		getTagProxyService().cfcookie(name="slatwallSessionID", value=session.slatwallSessionID, expires="never");
	}
	
}