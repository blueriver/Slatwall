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
	property name="loginManager" type="any";
	
	public any function getAccountByMuraUser(required any muraUser) {
		// Load Account based upon the logged in muraUserID
		var account = getDAO().readByMuraUserID(muraUserID = arguments.muraUser.getUserID());
		
		// TODO: Check to see if the e-mail exists and is assigned to an account.   If it does we should update that account with this mura user id.
		
		if(isnull(account)) {
			// If no account exists, create a new one and save it linked to the user that just logged in.
			var account = getNewEntity();
			account.setMuraUserID(arguments.muraUser.getUserID());
			var accountEmail = getNewEntity(entityName="SlatwallAccountEmailAddress");
			accountEmail.setEmailAddress(arguments.muraUser.getEmail());
			accountEmail.setPrimaryFlag(1);
			accountEmail.setAccount(account);
			save(entity=account);
		}
		
		// Add a primary e-mail to the account if one doesn't exist in slatwall but does in mura
		if(account.getPrimaryEmailAddress() == "" && arguments.muraUser.getEmail() != "") {
			var accountEmail = getNewEntity(entityName="SlatwallAccountEmailAddress");
			accountEmail.setEmailAddress(arguments.muraUser.getEmail());
			accountEmail.setPrimaryFlag(1);
			accountEmail.setAccount(account);
			save(entity=account);
		}
		
		return account;
	}
	
	public any function createNewAccount(required struct data) {
		// Create new Account
		var newAccount = getNewEntity();
		
		// Populate the account from the data
		newAccount.populate(arguments.data);
		
		// Validate Account
		getValidator().validateObject(entity=newAccount);
		
		// Create a Primary e-mail
		if( structKeyExists(arguments.data, "emailAddress") ) {
			var newEmailAddress = getNewEntity("SlatwallAccountEmailAddress");
			newEmailAddress.setEmailAddress(arguments.data.emailAddress);
			newEmailAddress.setPrimaryFlag(1);
			newEmailAddress.setAccount(newAccount);
			getValidator().validateObject(entity=newEmailAddress);
		}
		
		// Create a primary Phone Number
		if( structKeyExists(arguments.data, "phoneNumber") ) {
			var newPhoneNumber = getNewEntity("SlatwallAccountPhoneNumber");
			newPhoneNumber.setPhoneNumber(arguments.data.phoneNumber);
			newPhoneNumber.setPrimaryFlag(1);
			newPhoneNumber.setAccount(newAccount);
			getValidator().validateObject(entity=newEmailAddress);
		}
		
		// Create Mura User
		if( structKeyExists(arguments.data, "password") && len(arguments.data.password) gt 2 && structKeyExists(arguments.data, "emailAddress")) {
			var muraUser = getUserManager().readByUsername(username=arguments.data.email, siteid=$.event('siteid'));
			
			// Setup the mura user
			muraUser.setFName(arguments.data.firstName);
			muraUser.setLName(arguments.data.lastName);
			muraUser.setUsername(arguments.data.emailAddress);
			muraUser.setEmail(arguments.data.emailAddress);
			muraUser.setPassword(arguments.data.password);
			muraUser.setSiteID($.event('siteid'));
			
			// Set the mura userID in the new account
			newAccount.setMuraUserID(muraUser.getUserID());
		}
		
		if(!newAccount.hasErros() && !newEmailAddress.hasErros() && !newPhoneNumber.hasErros()) {
			// Save the account
			getDAO().save(entity=newAccount);
			
			if(!isNull(muraUser)) {
				// Save the mura user
				muraUser.save();
				
				// Login the new user
				var muraData = {};
				muraData.userID = muraUser.getUserID();
				muraData.siteid = $.event('siteid');
				getLoginManager().loginByUserID(muraData);
			}
		} else {
			getService("requestCacheService").setValue("ormHasErrors", true);
		}
		
		return newAccount;
	}
}
