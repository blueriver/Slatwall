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
component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController" {

	property name="fw" type="any";
	property name="accountService" type="any";
	
	public void function init( required any fw ) {
		setFW( arguments.fw );
	}
	
	public void function before() {
		getFW().setView("public:main.blank");
	}
	
	// Login
	public void function login( required struct rc ) {
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'login' );
		
		arguments.rc.$.slatwall.addActionResult( "public:account.login", account.hasErrors() );
	}
	
	// Logout
	public void function logout( required struct rc ) {
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'logout' );
		
		arguments.rc.$.slatwall.addActionResult( "public:account.logout", false );
	}
	
	// Forgot Password
	public void function forgotPassword( required struct rc ) {
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'forgotPassword');
		
		arguments.rc.$.slatwall.addActionResult( "public:account.forgotPassword", account.hasErrors() );
	}
	
	// Reset Password
	public void function resetPassword( required struct rc ) {
		param name="rc.accountID" default="";
		
		var account = getAccountService().getAccount( rc.accountID );
		
		if(!isNull(account)) {
			var account = getAccountService().processAccount(account, rc, "resetPassword");
			
			arguments.rc.$.slatwall.addActionResult( "public:account.resetPassword", account.hasErrors() );
				
			// As long as there were no errors resetting the password, then we can set the email address in the form scope so that a chained login action will work
			if(!account.hasErrors() && !structKeyExists(form, "emailAddress") && !structKeyExists(url, "emailAddress")) {
				form.emailAddress = account.getEmailAddress();
			}
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:account.resetPassword", true );
		}
		
		// Populate the current account with this processObject so that any errors, ect are there.
		arguments.rc.$.slatwall.account().setProcessObject( account.getProcessObject( "resetPassword" ) );
	}
	
	// Change Password
	public void function changePassword( required struct rc ) {
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'changePassword');
		
		arguments.rc.$.slatwall.addActionResult( "public:account.changePassword", account.hasErrors() );
	}
	
	// Create - Account
	public void function create( required struct rc ) {
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'create');
		
		arguments.rc.$.slatwall.addActionResult( "public:account.create", account.hasErrors() );
	}
	
	// Update - Account
	public void function update( required struct rc ) {
		var account = getAccountService().saveAccount( rc.$.slatwall.getAccount(), arguments.rc );
		
		arguments.rc.$.slatwall.addActionResult( "public:account.update", account.hasErrors() );
	}
	
	// Delete - Account Email Address
	public void function deleteAccountEmailAddress() {
		param name="rc.accountEmailAddressID" default="";
		
		var accountEmailAddress = getAccountService().getAccountEmailAddress( rc.accountEmailAddressID );
		
		if(!isNull(accountEmailAddress) && accountEmailAddress.getAccount().getAccountID() == arguments.rc.$.slatwall.getAccount().getAccountID() ) {
			var deleteOk = getAccountService().deleteAccountEmailAddress( accountEmailAddress );
			arguments.rc.$.slatwall.addActionResult( "public:account.deleteAccountEmailAddress", !deleteOK );
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:account.deleteAccountEmailAddress", true );	
		}
	}
	
	// Delete - Account Phone Number
	public void function deleteAccountPhoneNumber() {
		param name="rc.accountPhoneNumberID" default="";
		
		var accountPhoneNumber = getAccountService().getAccountPhoneNumber( rc.accountPhoneNumberID );
		
		if(!isNull(accountPhoneNumber) && accountPhoneNumber.getAccount().getAccountID() == arguments.rc.$.slatwall.getAccount().getAccountID() ) {
			var deleteOk = getAccountService().deleteAccountPhoneNumber( accountPhoneNumber );
			arguments.rc.$.slatwall.addActionResult( "public:account.deleteAccountPhoneNumber", !deleteOK );
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:account.deleteAccountPhoneNumber", true );	
		}
	}
	
	// Delete - Account Address
	public void function deleteAccountAddress() {
		param name="rc.accountAddressID" default="";
		
		var accountAddress = getAccountService().getAccountAddress( rc.accountAddressID );
		
		if(!isNull(accountAddress) && accountAddress.getAccount().getAccountID() == arguments.rc.$.slatwall.getAccount().getAccountID() ) {
			var deleteOk = getAccountService().deleteAccountAddress( accountAddress );
			arguments.rc.$.slatwall.addActionResult( "public:account.deleteAccountAddress", !deleteOK );
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:account.deleteAccountAddress", true );	
		}
	}
	
	// Delete - Account Payment Method
	public void function deleteAccountPaymentMethod() {
		param name="rc.accountAddressID" default="";
		
		var accountPaymentMethod = getAccountService().getAccountPhoneNumber( rc.accountAddressID );
		
		if(!isNull(accountPaymentMethod) && accountPaymentMethod.getAccount().getAccountID() == arguments.rc.$.slatwall.getAccount().getAccountID() ) {
			var deleteOk = getAccountService().deleteAccountPaymentMethod( accountPaymentMethod );
			arguments.rc.$.slatwall.addActionResult( "public:account.deleteAccountPaymentMethod", !deleteOK );
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:account.deleteAccountPaymentMethod", true );	
		}
	}
	
}