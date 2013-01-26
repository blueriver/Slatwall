component output="false" accessors="true" extends="HibachiService"  {

	property name="accountService" type="any";
	property name="orderService" type="any";
	property name="hibachiTagService" type="any";
	
	public string function getAPIKey(required string resource, required string verb) {
		var apiKey = hash("#now()##lcase(arguments.resource)##lcase(arguments.verb)#");
		var sessionAPIKeys = getValue("apiKeys", structNew());
		sessionAPIKeys[ apiKey ] = {resource=arguments.resource, verb=arguments.verb};
		setValue("apiKeys", sessionAPIKeys);
		return apiKey;
	}
	
	public boolean function verifyAPIKey(required string resource, required string verb, required string apiKey) {
		var sessionAPIKeys = getValue("apiKeys", structNew());
		if(structKeyExists(sessionAPIKeys, arguments.apiKey)) {
			try {
				if(sessionAPIKeys[arguments.apiKey].resource == arguments.resource && sessionAPIKeys[arguments.apiKey].verb == arguments.verb) {
					return true;
				}
			} catch(any e){
				return false;
			}
		}
		return false;
	}

	// ===================== START: Logical Methods ===========================
	
	public void function setPropperSession() {
		// Figure out the appropriate session ID and create a new one if necessary
		if(!isDefined('session.slatwall.sessionID')) {
			if(structKeyExists(cookie, "slatwallSessionID")) {
				session.slatwall.sessionID = cookie.slatwallSessionID;
			} else {
				session.slatwall.sessionID = "";
			}
		}

		// Load Session
		var currentSession = this.getSession(session.slatwall.sessionID, true);
		getSlatwallScope().setCurrentSession( currentSession );
		
		// Check to see if this session has an accountAuthentication, if it does then we need to verify that the authentication shouldn't be auto logged out
		if(!isNull(currentSession.getAccountAuthentication())) {
			
			// If there was an integration, then check the verify method for any custom auto-logout logic
			if(!isNull(currentSession.getAccountAuthentication().getIntegration()) && !currentSession.getAccountAuthentication().getIntegration().getIntegrationCFC( "authentication" ).verifySessionLogin( currentSession )) {
				logoutAccount();
				
			// Check with the auto logout setting of the authentication
			} else if( listLen(currentSession.getAccountAuthentication().setting('accountAuthenticationAutoLogoutTimespan')) eq 4 ) {
				var tsArr = listToArray(currentSession.getAccountAuthentication().setting('accountAuthenticationAutoLogoutTimespan'));
				var autoExpireDateTime = currentSession.getLastRequestDateTime() + createTimeSpan(tsArr[1],tsArr[2],tsArr[3],tsArr[4]);
				if(autoExpireDateTime lt now()) {
					logoutAccount();
				}
			}
			
		}
		
		// Update the last request datetime
		currentSession.setLastRequestDateTime( now() );
		
		// Save the session
		getHibachiDAO().save(target=currentSession);
		
		// Save session ID in the session Scope & cookie scope for next request
		session.slatwall.sessionID = currentSession.getSessionID();
		getHibachiTagService().cfcookie(name="slatwallSessionID", value=currentSession.getSessionID(), expires="never");
	}
	
	public string function loginAccount(required any account, required any accountAuthentication) {
		var currentSession = getSlatwallScope().getCurrentSession();
		
		currentSession.setAccount( arguments.account );
		currentSession.setAccountAuthentication( arguments.accountAuthentication );
		
		// If the current order has an account, and it is different from the one being logged in... then create a copy of the order without any personal information
		if( !isNull(currentSession.getOrder().getAccount()) && currentSession.getOrder().getAccount().getAccountID() != arguments.account.getAccountID()) {
			var newOrder = getOrderService().duplicateOrderWithNewAccount( currentSession.getOrder(), currentSession.getAccount() ); 
			currentSession.setOrder( newOrder );
		// If the current order doesn't have an account, and the current order is not new, then set this account in the current order
		} else if ( isNull(currentSession.getOrder().getAccount()) && !currentSession.getOrder().isNew() ) {
			currentSession.getOrder().setAccount( currentSession.getAccount() );
		}
		
		// Make sure that this login is persisted
		getHibachiDAO().flushORMSession();
	}
	
	public void function logoutAccount() {
		var currentSession = getSlatwallScope().getCurrentSession();
		
		currentSession.removeAccount();
		currentSession.removeAccountAuthentication();
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	public any function processSession(required any session, struct data={}, processContext="process") {
		if(arguments.processContext == "authorizeAccount") {
			param name="arguments.data.emailAddress" default="";
			param name="arguments.data.password" default="";
			
			// Take the email address and get all of the user accounts by primary e-mail address
			
			var accountAuthentications = getAccountService().getInternalAccountAuthenticationsByEmailAddress(emailAddress=arguments.data.emailAddress);
			
			if(arrayLen(accountAuthentications)) {
				for(var i=1; i<=arrayLen(accountAuthentications); i++) {
					// If the password matches what it should be, then set the account in the session and 
					if(!isNull(accountAuthentications[i].getPassword()) && len(accountAuthentications[i].getPassword()) && accountAuthentications[i].getPassword() == getAccountService().getHashedAndSaltedPassword(password=arguments.data.password, salt=accountAuthentications[i].getAccountAuthenticationID())) {
						loginAccount( accountAuthentications[i].getAccount(), accountAuthentications[i] );
						return arguments.session;
					}
				}
				arguments.session.addError('processing', rbKey('validate.session.authorizeAccount.invalidpassword'), true);
			} else {
				arguments.session.addError('processing', rbKey('validate.session.authorizeAccount.invalidemail'), true);
			}
		}
	}
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
}