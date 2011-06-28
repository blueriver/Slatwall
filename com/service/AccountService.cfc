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
	property name="userManager" type="any";
	property name="userUtility" type="any";
	
	public boolean function loginMuraUser(required string username, required string password, required string siteID) {
		var loginResult = getUserUtility().login(username=arguments.username, password=arguments.password, siteID=arguments.siteID);
		
		if(loginResult) {
			getService("requestCacheService").clearCache(keys="currentSession");
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
		// Populate the account from the data
		arguments.account.populate(arguments.data);
		
		// Validate Account
		getValidationService().validateObject(entity=arguments.account);
		
		// Account Email
		if( structKeyExists(arguments.data, "emailAddress") ) {
			param name="arguments.data.accountEmailAddressID" default="";
			
			// Setup Email Address
			var accountEmailAddress = this.getAccountEmailAddress(arguments.data.accountEmailAddressID, true);
			accountEmailAddress.populate(arguments.data);
			accountEmailAddress.setAccount(arguments.account);
			if( isNull(arguments.account.getPrimaryEmailAddress()) ) {
				arguments.account.setPrimaryEmailAddress(accountEmailAddress);
			}
			
			// Validate This Object
			getValidationService().validateObject(entity=accountEmailAddress);
			if(accountEmailAddress.hasErrors()) {
				arguments.account.getErrorBean().addError("primaryEmailAddress", "The Account E-Mail Address Has Errors");
			}
		}
		
		// Account Phone Number
		if( structKeyExists(arguments.data, "phoneNumber") ) {
			param name="arguments.data.accountPhoneNumberID" default="";
			
			// Setup Phone Number
			var accountPhoneNumber = this.getAccountPhoneNumber(arguments.data.accountPhoneNumberID, true);
			accountPhoneNumber.populate(arguments.data);
			accountPhoneNumber.setAccount(arguments.account);
			if( isNull(arguments.account.getPrimaryPhoneNumber()) ) {
				arguments.account.setPrimaryPhoneNumber(accountPhoneNumber);
			}
			
			// Validate This Object
			getValidationService().validateObject(entity=accountPhoneNumber);
			if(accountPhoneNumber.hasErrors()) {
				arguments.account.getErrorBean().addError("primaryPhoneNumber", "The Account Phone Number Has Errors");
			}
		}
		
		if( !arguments.account.hasErrors() ) {
			// Make sure that the account is in the hibernate session so it will save.
			getDAO().save(target=arguments.account);
			
			// If this account doesn't have a mura user check to see if we can create one
			if( ( isNull(arguments.account.getMuraUserID()) || arguments.account.getMuraUserID() == "") && structKeyExists(arguments.data, "password") && len(arguments.data.password) gt 2 && !isNull(arguments.account.getPrimaryEmailAddress())) {
				
				// TODO: Make sure that this user doesn't exist in mura
				
				var muraUser = getUserManager().getBean();
				
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
				var currentUser = getService("requestCacheService").getValue("muraScope").currentUser();
				if(!currentUser.isLoggedIn()) {
					writeDump(var="LogInCalled", output="console");
					getUserUtility().loginByUserID(muraUser.getUserID(), arguments.siteID);	
				}
			// If the account already has a mura user, make sure that the mura user gets updated
			} else if ( !isNull(arguments.account.getMuraUserID()) ) {
				
				// Load existing mura user
				var muraUser = getUserManager().read(userID=arguments.account.getMuraUserID());
				
				// If that user exists, update from account and save
				if(!muraUser.getIsNew()) {
					muraUser = updateMuraUserFromAccount(muraUser, arguments.account);
					muraUser.save();
				}
				
				// If the current user is the one whos account was just updated then Re-Login the current user so that the new values are saved.
				var currentUser = getService("requestCacheService").getValue("muraScope").currentUser();
				if(currentUser.getUserID() == muraUser.getUserID()) {
					getUserUtility().loginByUserID(muraUser.getUserID(), arguments.siteID);	
				}
				
			}

		} else {
			getService("requestCacheService").setValue("ormHasErrors", true);
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
			var primaryEmail = arguments.account.getPrimaryEmailAddress();
			
			// Attempt to find that e-mail address in all of our emails
			for(var i=1; i<=arrayLen(arguments.account.getAccountEmailAddresses()); i++) {
				if(arguments.account.getAccountEmailAddresses()[i].getEmailAddress() == arguments.muraUser.getEmail()) {
					primaryEmail = arguments.account.getAccountEmailAddresses()[i];
				}
			}
			if( isNull(primaryEmail) ) {
				primaryEmail = this.newAccountEmailAddress();
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
		var smartList = getDAO().getSmartList(argumentCollection=arguments);
		
		smartList.addKeywordProperty(propertyIdentifier="firstName", weight=3);
		smartList.addKeywordProperty(propertyIdentifier="lastName", weight=3);
		smartList.addKeywordProperty(propertyIdentifier="company", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="primaryEmailAddress_emailAddress", weight=3);
		
		return smartList;
	}
	
}
