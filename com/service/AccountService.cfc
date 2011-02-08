component extends="slatwall.com.service.BaseService" accessors="true" {
	
	public any function loginMuraUser(required any muraUser) {
		
		// Load Account based upon the logged in muraUserID
		var account = readByMuraUserID(muraUserID = arguments.muraUser.getUserID());
		
		if(isnull(account)) {
			/*
			// If no account exists, check for an account with that email 
			account = readByAccountEmail(accountEmail = arguments.muraUser.getEmail());
			
			if(isnull(account)) {
				// If no account exists, create a new one and save it linked to the user that just logged in.
				account = getAccountService().getNewEntity();
				var user = getAccountService().getMuraUserByID(session.muraUserID);
				account.setUser(user);
				getAccountService().save(account);
			} else {
				// If account does exist with that e-mail, check if the account has a muraUserID already tied to it
				if(isnull(account.getMuraUser())) {
					// If no muraUserID already assigend to this account, Assign this muraUserID but set the verified = 0
				} else {
					// If a muraUserID is already assigned, Offer to merge Accounts.
					// TODO: Merge Accounts
				}
			}
			*/
		} else {
			
		}
		
		// Login Slatwall Account in Session
	}
	
	public any function readByMuraUserID(required string muraUserID) {
		return getDAO().readByMuraUserID(muraUserID = arguments.muraUserID);
	}
	
}