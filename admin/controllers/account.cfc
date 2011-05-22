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
component extends="BaseController" persistent="false" accessors="true" output="false" {
	
	property name="accountService";
	
	public void function before(required struct rc) {
	}
	
	public void function dashboard(required struct rc) {
		getFW().redirect(action="admin:account.list");
	}
	
	public void function detail(required struct rc) {
		param name="rc.accountID" default="";
		param name="rc.edit" default="false";
		
		rc.account = getAccountService().getAccount(rc.accountID, true);
	}
	
	public void function create(required struct rc) {
		detail(arguments.rc);
		getFW().setView("admin:account.detail");
		rc.edit = true;
	}
	
	public void function edit(required struct rc) {
		detail(arguments.rc);
		getFW().setView("admin:account.detail");
		rc.edit = true;
	}
	
	public void function delete(required struct rc) {
		var account = getAccountService().getByID(rc.accountID);
		var deleteResponse = getAccountService().delete(account);
		if(deleteResponse.getStatusCode()) {
			rc.message = deleteResponse.getMessage();		
		} else {
			rc.message=deleteResponse.getData().getErrorBean().getError("delete");
			rc.messagetype="error";
		}
		getFW().redirect(action="admin:account.list",preserve="message");
	}

	public void function list(required struct rc) {
		param name="rc.keyword" default="";
		
		rc.accountSmartList = getAccountService().getSmartList(data=arguments.rc);
	}
}
