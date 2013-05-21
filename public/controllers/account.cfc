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
	
	// Create
	public void function create( required struct rc ) {
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'create');
		
		arguments.rc.$.slatwall.addActionResult( "public:account.create", account.hasErrors() );
	}
	
	// Forgot Password
	public void function forgotPassword( required struct rc ) {
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'forgotPassword');
		
		arguments.rc.$.slatwall.addActionResult( "public:account.forgotPassword", account.hasErrors() );
	}
	
	// Change Password
	public void function changePassword( required struct rc ) {
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'changePassword');
		
		arguments.rc.$.slatwall.addActionResult( "public:account.changePassword", account.hasErrors() );
	}
	
	// Update
	public void function update( required struct rc ) {
		var account = getAccountService().saveAccount( rc.$.slatwall.getAccount(), arguments.rc );
		
		arguments.rc.$.slatwall.addActionResult( "public:account.update", account.hasErrors() );
	}
}