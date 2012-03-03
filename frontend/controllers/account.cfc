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
component persistent="false" accessors="true" output="false" extends="BaseController" {

	property name="accountService" type="any";
	property name="orderService" type="any";
	property name="userUtility" type="any";
	
	public void function save(required struct rc) {
		getAccountService().saveAccount(account=rc.$.Slatwall.getCurrentAccount(), data=rc, siteID=rc.$.event('siteID'));
		getFW().setView("frontend:account.detail");
	}
	
	public void function login(required struct rc) {
		param name="rc.username" default="";
		param name="rc.password" default="";
		param name="rc.returnURL" default="";
		param name="rc.forgotPasswordEmail" default="";
		
		if(rc.forgotPasswordEmail != "") {
			rc.forgotPasswordResult = getUserUtility().sendLoginByEmail(email=rc.forgotPasswordEmail, siteid=rc.$.event('siteID'));
		} else {
			var loginSuccess = getAccountService().loginCmsUser(username=rc.username, password=rc.password, siteID=rc.$.event('siteID'));
		
			if(!loginSuccess) {
				request.status = "failed";
			} else if ( len(rc.returnURL) > 3) {
				getFW().redirectExact(returnURL);
			}
			
		}
		
		getFW().setView("frontend:account.detail");
	}
	
	// Special account specific logic to require a user to be logged in
	public void function after(required struct rc) {
		if(!rc.$.currentUser().isLoggedIn() && rc.slatAction != "frontend:account.detail") {
			var loginURL = rc.$.createHREF(filename=rc.$.siteConfig().getLoginURL());
			if(find("?",loginURL)) {
				loginURL &= "&";	
			} else {
				loginURL &= "?";
			}
			//loginURL &= "returnURL=" & URLEncodedFormat(getFW().buildURL(action=rc.slatAction, queryString=cgi.query_string));
			location(url=rc.$.siteConfig().getLoginURL(), addtoken=false);
		}
	}
}
