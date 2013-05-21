/*

    Slatwall - An Open Source eCommerce Platform
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
component extends="HibachiService" accessors="true" output="false" {
	
	property name="accountDAO" type="any";
	
	property name="emailService" type="any";
	property name="paymentService" type="any";
	property name="permissionService" type="any";
	property name="priceGroupService" type="any";
	property name="sessionService" type="any";
	property name="validationService" type="any";
	
	public string function getHashedAndSaltedPassword(required string password, required string salt) {
		return hash(arguments.password & arguments.salt, 'SHA-512');
	}
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public any function getInternalAccountAuthenticationsByEmailAddress(required string emailAddress) {
		return getAccountDAO().getInternalAccountAuthenticationsByEmailAddress(argumentcollection=arguments);
	}
	
	public boolean function getAccountAuthenticationExists() {
		return getAccountDAO().getAccountAuthenticationExists();
	}
	
	// =====================  END: DAO Passthrough ============================
	
	// ===================== START: Process Methods ===========================
	
	public any function processAccount_login(required any account, required any processObject) {
		
		// Take the email address and get all of the user accounts by primary e-mail address
		var accountAuthentications = getInternalAccountAuthenticationsByEmailAddress(emailAddress=arguments.processObject.getEmailAddress());
		
		if(arrayLen(accountAuthentications)) {
			for(var i=1; i<=arrayLen(accountAuthentications); i++) {
				// If the password matches what it should be, then set the account in the session and 
				if(!isNull(accountAuthentications[i].getPassword()) && len(accountAuthentications[i].getPassword()) && accountAuthentications[i].getPassword() == getHashedAndSaltedPassword(password=arguments.processObject.getPassword(), salt=accountAuthentications[i].getAccountAuthenticationID())) {
					getSessionService().loginAccount( accountAuthentications[i].getAccount(), accountAuthentications[i] );
					return arguments.session;
				}
			}
			arguments.processObject.addError('password', rbKey('validate.session_authorizeAccount.password.incorrect'));
		} else {
			arguments.processObject.addError('emailAddress', rbKey('validate.session_authorizeAccount.emailAddress.notfound'));
		}
		
		return arguments.account;
	}
	
	public any function processAccount_changePassword(required any account, required any processObject) {
		var authArray = arguments.account.getAccountAuthentications();
		for(var i=1; i<=arrayLen(authArray); i++) {
			// Find the non-integration authentication
			if(isNull(authArray[i].getIntegration())) {
				// Set the password
				authArray[i].setPassword( getHashedAndSaltedPassword(arguments.processObject.getPassword(), authArray[i].getAccountAuthenticationID()) );		
			}
		}
	}
	
	public any function processAccount_create(required any account, required any processObject) {
		
		// Populate the account with the correct values that have been previously validated
		arguments.account.setFirstName( processObject.getFirstName() );
		arguments.account.setLastName( processObject.getLastName() );
		
		// If company was passed in then set that up
		if(!isNull(processObject.getCompany())) {
			arguments.account.setCompany( processObject.getCompany() );	
		}
		
		// If phone number was passed in the add a primary phone number
		if(!isNull(processObject.getPhoneNumber())) {
			var accountPhoneNumber = this.newAccountPhoneNumber();
			accountPhoneNumber.setAccount( arguments.account );
			accountPhoneNumber.setPhoneNumber( processObject.getPhoneNumber() );
		}
		
		// If email address was passed in then add a primary email address
		if(!isNull(processObject.getEmailAddress())) {
			var accountEmailAddress = this.newAccountEmailAddress();
			accountEmailAddress.setAccount( arguments.account );
			accountEmailAddress.setEmailAddress( processObject.getEmailAddress() );
		}
		
		// If the createAuthenticationFlag was set to true, the add the authentication
		if(processObject.getCreateAuthenticationFlag()) {
			var accountAuthentication = this.newAccountAuthentication();
			accountAuthentication.setAccount( arguments.account );
		
			// Put the accountAuthentication into the hibernate scope so that it has an id which will allow the hash / salting below to work
			getHibachiDAO().save(accountAuthentication);
		
			// Set the password
			accountAuthentication.setPassword( getHashedAndSaltedPassword(arguments.processObject.getPassword(), accountAuthentication.getAccountAuthenticationID()) );	
		}
		
		// Call save on the account now that it is all setup
		arguments.account = this.saveAccount(arguments.account);
		
		return arguments.account;
	}

	public any function processAccount_createPassword(required any account, required any processObject) {
		var accountAuthentication = this.newAccountAuthentication();
		accountAuthentication.setAccount( arguments.account );
	
		// Put the accountAuthentication into the hibernate scope so that it has an id which will allow the hash / salting below to work
		getHibachiDAO().save(accountAuthentication);
	
		// Set the password
		accountAuthentication.setPassword( getHashedAndSaltedPassword(arguments.processObject.getPassword(), accountAuthentication.getAccountAuthenticationID()) );	
	}
	
	public any function processAccount_setupInitialAdmin(required any account, required struct data={}, required any processObject) {
		
		// Populate the account with the correct values that have been previously validated
		arguments.account.setFirstName( processObject.getFirstName() );
		arguments.account.setLastName( processObject.getLastName() );
		if(!isNull(processObject.getCompany())) {
			arguments.account.setCompany( processObject.getCompany() );	
		}
		arguments.account.setSuperUserFlag( 1 );
		
		// Setup the email address
		var accountEmailAddress = this.newAccountEmailAddress();
		accountEmailAddress.setAccount(arguments.account);
		accountEmailAddress.setEmailAddress( processObject.getEmailAddress() );
		
		// Setup the authentication
		var accountAuthentication = this.newAccountAuthentication();
		accountAuthentication.setAccount( arguments.account );
		
		// Put the accountAuthentication into the hibernate scope so that it has an id
		getHibachiDAO().save(accountAuthentication);
		
		// Set the password
		accountAuthentication.setPassword( getHashedAndSaltedPassword(arguments.data.password, accountAuthentication.getAccountAuthenticationID()) );
		
		// Call save on the account now that it is all setup
		arguments.account = this.saveAccount(arguments.account);
		
		// Login the new account
		if(!arguments.account.hasErrors()) {
			getHibachiSessionService().loginAccount(account=arguments.account, accountAuthentication=accountAuthentication);	
		}
		
		return arguments.account;
	}
	
	public any function processAccount_addAccountPayment(required any account, required any processObject) {
		return arguments.account;
	}
	
	public any function processAccountPayment_createTransaction(required any accountPayment, required any processObject) {
		
		// Create a new payment transaction
		var paymentTransaction = getPaymentService().newPaymentTransaction();
		
		// Setup the orderPayment in the transaction to be used by the 'runTransaction'
		paymentTransaction.setAccountPayment( arguments.accountPayment );
		
		// Setup the transaction data
		transactionData = {
			transactionType = processObject.getTransactionType(),
			amount = processObject.getAmount()
		};
		
		// Run the transaction
		paymentTransaction = getPaymentService().processPaymentTransaction(paymentTransaction, transactionData, 'runTransaction');
		
		return arguments.accountPayment;	
	}
	
	
	/*
	public any function processAccountPayment_offlineTransaction(required any account, required struct data={}) {
		var newPaymentTransaction = getPaymentService().newPaymentTransaction();
		newPaymentTransaction.setTransactionType( "offline" );
		newPaymentTransaction.setAccountPayment( arguments.accountPayment );
		newPaymentTransaction = getPaymentService().savePaymentTransaction(newPaymentTransaction, arguments.data);
		
		if(newPaymentTransaction.hasErrors()) {
			arguments.accountPayment.addError('processing', rbKey('validate.accountPayment.offlineProcessingError'));	
		}
	}
	
	public any function processAccountPayment_process(required any account, required struct data={}) {
		getPaymentService().processPayment(arguments.accountPayment, arguments.processContext, arguments.data.amount);
	}
	*/
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	public any function savePermissionGroup(required any permissionGroup, struct data={}, string context="save") {
	
		arguments.permissionGroup.setPermissionGroupName( arguments.data.permissionGroupName );
		
		// As long as permissions were passed in we can set those up
		if(structKeyExists(arguments.data, "permissions")) {
			// Loop over all of the permissions that were passed in.
			for(var i=1; i<=arrayLen(arguments.data.permissions); i++) {
				
				var pData = arguments.data.permissions[i];	
				var pEntity = this.getPermission(arguments.data.permissions[i].permissionID, true);
				pEntity.populate( pData );
				
				// Delete this permssion
				if(!pEntity.isNew() && (isNull(pEntity.getAllowCreateFlag()) || !pEntity.getAllowCreateFlag()) && (isNull(pEntity.getAllowReadFlag()) || !pEntity.getAllowReadFlag()) && (isNull(pEntity.getAllowUpdateFlag()) || !pEntity.getAllowUpdateFlag()) && (isNull(pEntity.getAllowDeleteFlag()) || !pEntity.getAllowDeleteFlag()) && (isNull(pEntity.getAllowProcessFlag()) || !pEntity.getAllowProcessFlag()) && (isNull(pEntity.getAllowActionFlag()) || !pEntity.getAllowActionFlag()) ) {
					arguments.permissionGroup.removePermission( pEntity );
					this.deletePermission( pEntity );
				// Otherwise Save This Entity
				} else if ((!isNull(pEntity.getAllowCreateFlag()) && pEntity.getAllowCreateFlag()) || (!isNull(pEntity.getAllowReadFlag()) && pEntity.getAllowReadFlag()) || (!isNull(pEntity.getAllowUpdateFlag()) && pEntity.getAllowUpdateFlag()) || (!isNull(pEntity.getAllowDeleteFlag()) && pEntity.getAllowDeleteFlag()) || (!isNull(pEntity.getAllowProcessFlag()) && pEntity.getAllowProcessFlag()) || (!isNull(pEntity.getAllowActionFlag()) && pEntity.getAllowActionFlag())) {
					getAccountDAO().save( pEntity );
					arguments.permissionGroup.addPermission( pEntity );
				}
			}
		}
		
		// Validate the permission group
		arguments.permissionGroup.validate(context='save');
		
		// Setup hibernate session correctly if it has errors or not
		if(!arguments.permissionGroup.hasErrors()) {
			getAccountDAO().save( arguments.permissionGroup );
		} else {
			getHibachiScope().setORMHasErrors( true );
		}
		
		return arguments.permissionGroup;
	}
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	

	public any function getAccountSmartList(struct data={}, currentURL="") {
		arguments.entityName = "SlatwallAccount";
		
		var smartList = getHibachiDAO().getSmartList(argumentCollection=arguments);
		
		smartList.joinRelatedProperty("SlatwallAccount", "primaryEmailAddress", "left");
		smartList.joinRelatedProperty("SlatwallAccount", "primaryPhoneNumber", "left");
		smartList.joinRelatedProperty("SlatwallAccount", "primaryAddress", "left");
		
		smartList.addKeywordProperty(propertyIdentifier="firstName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="lastName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="company", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="primaryEmailAddress.emailAddress", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="primaryPhoneNumber.phoneNumber", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="primaryAddress.streetAddress", weight=1);
		
		return smartList;
	}
	
	public any function getAccountEmailAddressSmartList(struct data={}, currentURL="") {
		arguments.entityName = "SlatwallAccountEmailAddress";
		
		var smartList = getHibachiDAO().getSmartList(argumentCollection=arguments);
		
		smartList.joinRelatedProperty("SlatwallAccountEmailAddress", "accountEmailType", "left");
		
		return smartList;
	}
	
	public any function getAccountPhoneNumberSmartList(struct data={}, currentURL="") {
		arguments.entityName = "SlatwallAccountPhoneNumber";
		
		var smartList = getHibachiDAO().getSmartList(argumentCollection=arguments);
		
		smartList.joinRelatedProperty("SlatwallAccountPhoneNumber", "accountPhoneType", "left");
		
		return smartList;
	}
	
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
	// ===================== START: Delete Overrides ==========================
	
	public boolean function deleteAccount(required any account) {
	
		// Check delete validation
		if(arguments.account.isDeletable()) {
			
			// Remove the primary fields so that we can delete this entity
			arguments.account.setPrimaryEmailAddress(javaCast("null", ""));
			arguments.account.setPrimaryPhoneNumber(javaCast("null", ""));
			arguments.account.setPrimaryAddress(javaCast("null", ""));
			
			getAccountDAO().removeAccountFromAllSessions( accountID );
			
			return delete(arguments.account);
		}
		
		return false;
	}
	
	public boolean function deleteAccountEmailAddress(required any accountEmailAddress) {
		
		// Check delete validation
		if(arguments.accountEmailAddress.isDeletable()) {
			
			// If the primary email address is this e-mail address then set the primary to null
			if(arguments.accountEmailAddress.getAccount().getPrimaryEmailAddress().getAccountEmailAddressID() eq arguments.accountEmailAddress.getAccountEmailAddressID()) {
				arguments.accountEmailAddress.getAccount().setPrimaryEmailAddress(javaCast("null",""));
			}
			
			return delete(arguments.accountEmailAddress);
		}
		
		return false;
	}
	
	public boolean function deleteAccountPhoneNumber(required any accountPhoneNumber) {
		
		// Check delete validation
		if(arguments.accountPhoneNumber.isDeletable()) {
			
			// If the primary email address is this e-mail address then set the primary to null
			if(arguments.accountPhoneNumber.getAccount().getPrimaryPhoneNumber().getAccountPhoneNumberID() eq arguments.accountPhoneNumber.getAccountPhoneNumberID()) {
				arguments.accountPhoneNumber.getAccount().setPrimaryPhoneNumber(javaCast("null",""));
			}
			
			return delete(arguments.accountPhoneNumber);
		}
		
		return false;
	}
	
	public boolean function deleteAccountAddress(required any accountAddress) {
		
		// Check delete validation
		if(arguments.accountAddress.isDeletable()) {

			// If the primary email address is this e-mail address then set the primary to null
			if(arguments.accountAddress.getAccount().getPrimaryAddress().getAccountAddressID() eq arguments.accountAddress.getAccountAddressID()) {
				arguments.accountAddress.getAccount().setPrimaryAddress(javaCast("null",""));
			}
			
			return delete(arguments.accountAddress);
		}
		
		return false;
	}
	
	// =====================  END: Delete Overrides ===========================
	
}
