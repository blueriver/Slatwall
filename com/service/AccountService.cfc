/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component extends="BaseService" accessors="true" output="false" {
	
	property name="sessionService" type="any";
	property name="priceGroupService" type="any";
	property name="validationService" type="any";
	
	// Mura Injection
	property name="userManager" type="any";
	property name="userUtility" type="any";
	
	public boolean function loginMuraUser(required string username, required string password, required string siteID) {
		var loginResult = getUserUtility().login(username=arguments.username, password=arguments.password, siteID=arguments.siteID);
		
		if(loginResult) {
			getRequestCacheService().clearCache(keys="currentSession");
		}
		
		return loginResult;
	}
	
	public any function getAccountByMuraUser(required any muraUser) {
		// Load Account based upon the logged in muraUserID
		var account = getDAO().readByMuraUserID(muraUserID = arguments.muraUser.getUserID());
		
		if( isnull(account) ) {
			// TODO: Check to see if the e-mail exists and is assigned to an account.   If it does we should update that account with this mura user id.
			
			// Create new Account
			account = this.newAccount();
			
			// Link account to thus mura user
			account.setMuraUserID(arguments.muraUser.getUserID());
			
			// update and save with values from mura user
			account = updateAccountFromMuraUser(account, arguments.muraUser);
			getDAO().save(target=account);
			
		
		} else {
			// Update the existing account 
			account = updateAccountFromMuraUser(account, arguments.muraUser);	
		}
		
		return account;
	}
	
	public any function saveAccount(required any account, required struct data, required string siteID) {
		
		// Call the super.save() to do population and validation
		arguments.account = super.save(entity=arguments.account, data=arguments.data);
		
		// If the account doesn't have errors, is new, has and email address and password, has a password passed in, and not supposed to be a guest account. then attempt to setup the username and password in Mura
		if( !arguments.account.hasErrors() && arguments.account.isNew() && !isNull(arguments.account.getPrimaryEmailAddress()) && structKeyExists(arguments.data, "password") && (!structKeyExists(arguments.data, "guestAccount") || arguments.data.guestAccount == false) ) {
			
			// Try to get the user out of the mura database using the primaryEmail as the username
			var muraUser = getUserManager().getBean().loadBy(siteID=arguments.siteID, username=arguments.account.getPrimaryEmailAddress().getEmailAddress());
			
			if(!muraUser.getIsNew()) {
				getRequestCacheService().setValue("ormHasErrors", true);
				arguments.account.addError("primaryEmailAddress", "This E-Mail Address is already in use with another Account.");
			} else {
				// Setup a new mura user
				muraUser.setUsername(arguments.account.getPrimaryEmailAddress().getEmailAddress());
				muraUser.setPassword(arguments.data.password);
				muraUser.setSiteID(arguments.siteID);
				
				// Update mura user with values from account
				muraUser = updateMuraUserFromAccount(muraUser, arguments.account);
				muraUser.save();
				
				// Set the mura userID in the account
				arguments.account.setMuraUserID(muraUser.getUserID());
									
				// If there currently isn't a user logged in, then log in this new account
				var currentUser = getRequestCacheService().getValue("muraScope").currentUser();
				if(!currentUser.isLoggedIn()) {
					// Login the mura User
					getUserUtility().loginByUserID(muraUser.getUserID(), arguments.siteID);
					// Set the account in the session scope
					getSessionService().getCurrent().setAccount(arguments.account);
				}
			}
		}
		
		// If the account isn't new, and it has a muraUserID then update the mura user from the account
		if(!arguments.account.isNew() && !isNull(arguments.account.getMuraUserID())) {
			
			// Load existing mura user
			var muraUser = getUserManager().read(userID=arguments.account.getMuraUserID());
			
			// If that user exists, update from account and save
			if(!muraUser.getIsNew()) {
				muraUser = updateMuraUserFromAccount(muraUser, arguments.account);
				
				// Set the password to blank so that Mura doesn't try to save it (this is just how mura does things yo!)
				arguments.muraUser.setPassword("");
				
				muraUser.save();
			}
			
			// If the current user is the one whos account was just updated then Re-Login the current user so that the new values are saved.
			var currentUser = getRequestCacheService().getValue("muraScope").currentUser();
			if(currentUser.getUserID() == muraUser.getUserID()) {
				getUserUtility().loginByUserID(muraUser.getUserID(), arguments.siteID);	
			}
		}
		
		return arguments.account;
	}
	
	public any function updateMuraUserFromAccount(required any muraUser, required any Account) {
		
		// Sync Name & Company
		arguments.muraUser.setFName(arguments.account.getFirstName());
		arguments.muraUser.setLName(arguments.account.getLastName());
		if(!isNull(arguments.account.getCompany())) {
			arguments.muraUser.setCompany(arguments.account.getCompany());	
		}
		
		// Sync Primary Email
		if(!isNull(arguments.account.getPrimaryEmailAddress())) {
			arguments.muraUser.setEmail(arguments.account.getPrimaryEmailAddress().getEmailAddress());	
		}
		
		// Reset the password as whatever was already in the database
		
		// TODO: Sync the mobile phone number
		// TODO: Loop over addresses and sync them as well.
				
		return arguments.muraUser;
	}
	
	public any function updateAccountFromMuraUser(required any account, required any muraUser) {
		
		// Sync Name & Company
		if(arguments.account.getFirstName() != muraUser.getFName()){
			arguments.account.setFirstName(muraUser.getFName());
		}
		if(arguments.account.getLastName() != muraUser.getLName()) {
			arguments.account.setLastName(muraUser.getLName());
		}
		if(arguments.account.getCompany() != muraUser.getCompany()) {
			arguments.account.setCompany(muraUser.getCompany());
		}
		
		// Sync the primary email if out of sync
		if( isNull(arguments.account.getPrimaryEmailAddress()) || arguments.account.getPrimaryEmailAddress().getEmailAddress() != arguments.muraUser.getEmail()) {
			// Setup the new primary email object
			
			// Attempt to find that e-mail address in all of our emails
			for(var i=1; i<=arrayLen(arguments.account.getAccountEmailAddresses()); i++) {
				if(arguments.account.getAccountEmailAddresses()[i].getEmailAddress() == arguments.muraUser.getEmail()) {
					var primaryEmail = arguments.account.getAccountEmailAddresses()[i];
				}
			}
			if( isNull(primaryEmail) ) {
				var primaryEmail = this.newAccountEmailAddress();
				primaryEmail.setEmailAddress(arguments.muraUser.getEmail());
				primaryEmail.setAccount(arguments.account);
			}
			arguments.account.setPrimaryEmailAddress(primaryEmail);
		}
		
		// TODO: Sync the mobile phone number
		// TODO: Loop over addresses and set those up as well.
		
		return arguments.account;
	}
	
	public any function getAccountSmartList(struct data={}, currentURL="") {
		arguments.entityName = "SlatwallAccount";
		
		// Set the defaul showing to 25
		if(!structKeyExists(arguments.data, "P:Show")) {
			arguments.data["P:Show"] = 25;
		}
		
		var smartList = getDAO().getSmartList(argumentCollection=arguments);
		
		smartList.addKeywordProperty(propertyIdentifier="firstName", weight=3);
		smartList.addKeywordProperty(propertyIdentifier="lastName", weight=3);
		smartList.addKeywordProperty(propertyIdentifier="company", weight=1);
		/*smartList.addKeywordProperty(propertyIdentifier="primaryEmailAddress_emailAddress", weight=3);*/
		
		return smartList;
	}
}
