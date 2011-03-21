component extends="BaseService" accessors="true" {
			
	property name="sessionService" type="any";
	property name="userManager" type="any";
	
	public any function init() {
		return this;
	}
	
	public any function loginMuraUser(required any muraUser) {
		
		// Load Account based upon the logged in muraUserID
		var account = getDAO().readByMuraUserID(muraUserID = arguments.muraUser.getUserID());
		
		if(isnull(account)) {
			// If no account exists, check for an account with that email 
			account = getDAO().readByAccountEmail(email = arguments.muraUser.getEmail());
			
			if(isnull(account)) {
				// If no account exists, create a new one and save it linked to the user that just logged in.
				account = getNewEntity();
				account.setMuraUserID(arguments.muraUser.getUserID());
				var accountEmail = getNewEntity(entityName="SlatwallAccountEmail");
				accountEmail.setEmail(arguments.muraUser.getEmail());
				accountEmail.setAccount(account);
				account.addAccountEmail(accountEmail);
				save(entity=account);
			} else {
				// If account does exist with that e-mail, check if the account has a muraUserID already tied to it
				if(isnull(account.getMuraUser())) {
					// TODO: If no muraUserID already assigend to this account, Assign this muraUserID but set the verified = 0
				} else {
					// TODO: If a muraUserID is already assigned, Offer to merge Accounts.
				}
			}
		} else {
		}
		
		// Login Slatwall Account in Session
		getSessionService().getCurrent().setAccount(account);
	}
}