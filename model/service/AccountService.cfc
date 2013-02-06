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
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	private any function processAccount_changePassword(required any account, struct data={}) {
		// TODO: Add Change Password Logic Here
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
	
	/*
	public any function processAccountPayment(required any accountPayment, struct data={}, string processContext="process") {
		
		param name="arguments.data.amount" default="0";
		
		// CONTEXT: offlineTransaction
		if (arguments.processContext == "offlineTransaction") {
		
			var newPaymentTransaction = getPaymentService().newPaymentTransaction();
			newPaymentTransaction.setTransactionType( "offline" );
			newPaymentTransaction.setAccountPayment( arguments.accountPayment );
			newPaymentTransaction = getPaymentService().savePaymentTransaction(newPaymentTransaction, arguments.data);
			
			if(newPaymentTransaction.hasErrors()) {
				arguments.accountPayment.addError('processing', rbKey('validate.accountPayment.offlineProcessingError'));	
			}
			
		} else {
			
			getPaymentService().processPayment(arguments.accountPayment, arguments.processContext, arguments.data.amount);
			
		}
		
		return arguments.accountPayment;
	}
	*/
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
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
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
	// ===================== START: Delete Overrides ==========================
	
	public boolean function deleteAccount(required any account) {
	
		// Set the primary fields temporarily in the local scope so we can reset if delete fails
		var accountID = arguments.account.getAccountID();
		var primaryEmailAddress = arguments.account.getPrimaryEmailAddress();
		var primaryPhoneNumber = arguments.account.getPrimaryPhoneNumber();
		var primaryAddress = arguments.account.getPrimaryAddress();
		
		// Remove the primary fields so that we can delete this entity
		arguments.account.setPrimaryEmailAddress(javaCast("null", ""));
		arguments.account.setPrimaryPhoneNumber(javaCast("null", ""));
		arguments.account.setPrimaryAddress(javaCast("null", ""));
	
		// Use the base delete method to check validation
		var deleteOK = super.delete(arguments.account);
		
		// If the delete failed, then we just reset the primary fields in account and return false
		if(deleteOK) {
			getAccountDAO().removeAccountFromAllSessions( accountID );
			
			super.delete(primaryEmailAddress);
			super.delete(primaryPhoneNumber);
			super.delete(primaryAddress);
			
		} else {
			arguments.account.setPrimaryEmailAddress(primaryEmailAddress);
			arguments.account.setPrimaryPhoneNumber(primaryPhoneNumber);
			arguments.account.setPrimaryAddress(primaryAddress);
		
			return false;
		}
	
		return true;
	}
	
	// =====================  END: Delete Overrides ===========================
	
}
