/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
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
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

*/
component extends="Slatwall.org.Hibachi.HibachiController" output="false" accessors="true"  {

	property name="accountService" type="any";
	property name="integrationService" type="any";

	this.publicMethods="";
	this.publicMethods = listAppend(this.publicMethods, "attachExistingUserAdminForm");
	this.publicMethods = listAppend(this.publicMethods, "attachExistingUser");
	this.publicMethods = listAppend(this.publicMethods, "attachNewUser");
	
	this.secureMethods="default";
	
	public void function default() {
		// Do Nothing
	}
	
	public void function attachExistingUserAdminForm() {
		// Do Nothing
	}
	
	public void function attachExistingUser(required struct rc) {
		
		// First we try to login the user based on the UN/PW they added
		getAccountService().processAccount(arguments.rc.$.slatwall.getAccount(), rc, "login");
		
		// If the user is logged in, then we can 
		if(arguments.rc.$.slatwall.getLoggedInFlag()) {
			
			var gigyaIntegration = getIntegrationService().getIntegrationByIntegrationPackage('gigya');
			
			gigyaIntegration.getIntegrationCFC( 'authentication' ).linkAccountToGigya(account=arguments.rc.$.slatwall.getAccount(), data=arguments.rc);
			
			if(structKeyExists(rc, "sRedirectURL")) {
				getFW().redirectExact(rc.sRedirectURL);
			} else {
				getFW().redirect(action="admin:main.default", queryString="s=1");	
			}
			
		}
		
		getFW().setView( "gigya:main.adminuserattach" );
	}
	
	public void function attachNewUser(required struct rc) {
		
		// TODO: Add logic here to create a new user, and then link to gigya account
		
	}
	
}
