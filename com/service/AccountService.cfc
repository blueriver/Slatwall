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
	
	public any function getAccountByMuraUser(required any muraUser) {
		// Load Account based upon the logged in muraUserID
		var account = getDAO().readByMuraUserID(muraUserID = arguments.muraUser.getUserID());
		
		// TODO: Check to see if the e-mail exists and is assigned to an account.   If it does we should update that account with this mura user id.
		
		// If no account exists, create a new one and save it linked to the user that just logged in.
		if( isnull(account) ) {
			account = this.newAccount();
			account.setMuraUserID(arguments.muraUser.getUserID());
			account.setFirstName(arguments.muraUser.getFName());
			account.setLastName(arguments.muraUser.getLName());
			var accountEmail = this.newAccountEmailAddress();
			accountEmail.setEmailAddress(arguments.muraUser.getEmail());
			accountEmail.setAccount(account);
			account.setPrimaryEmailAddress(accountEmail);
			getDAO().save(target=account);
		} else if ( isNull(account.getPrimaryEmailAddress()) ) {
			if( isNull(account.getAccountEmailAddresses()) || !arrayLen(account.getAccountEmailAddresses()) ) {
				var accountEmail = this.newAccountEmailAddress();
				accountEmail.setEmailAddress(arguments.muraUser.getEmail());
				accountEmail.setAccount(account);
				account.setPrimaryEmailAddress(accountEmail);
			} else {
				account.setPrimaryEmailAddress(account.getAccountEmailAddresses()[1]);
			}
		}
		
		return account;
	}
	
	public any function saveAccount(required any account, required struct data) {
		// Populate the account from the data
		arguments.account.populate(arguments.data);
		
		// Validate Account
		getValidator().validateObject(entity=arguments.account);
		
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
			getValidator().validateObject(entity=accountEmailAddress);
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
			getValidator().validateObject(entity=accountPhoneNumber);
			if(accountPhoneNumber.hasErrors()) {
				arguments.account.getErrorBean().addError("primaryPhoneNumber", "The Account Phone Number Has Errors");
			}
		}
		
		if( !arguments.account.hasErrors() ) {
			getDAO().save(targer=arguments.account);
			
			// Check for new mura user information
			if( (isNull(arguments.account.getMuraUserID()) || arguments.account.getMuraUserID() == "") && structKeyExists(arguments.data, "password") && len(arguments.data.password) gt 2 && !isNull(arguments.account.getPrimaryEmailAddress())) {
				
				// TODO: Make sure that this user doesn't exist in mura
				
				var muraUser = getUserManager().getBean();
				
				// Setup the mura user
				muraUser.setFName(arguments.account.getFirstName());
				muraUser.setLName(arguments.account.getLastName());
				muraUser.setUsername(arguments.account.getPrimaryEmailAddress().getEmailAddress());
				muraUser.setEmail(arguments.account.getPrimaryEmailAddress().getEmailAddress());
				muraUser.setPassword(arguments.data.password);
				muraUser.setSiteID($.event('siteid'));
				muraUser.save();
				
				// Set the mura userID in the account
				arguments.account.setMuraUserID(muraUser.getUserID());
				
				getUserUtility().loginByUserID(muraUser.getUserID(), $.event('siteid'));
			}
		} else {
			getService("requestCacheService").setValue("ormHasErrors", true);
		}
		
		return arguments.account;
	}
}
