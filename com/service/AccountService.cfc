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
component extends="BaseService" accessors="true" {
			
	property name="sessionService" type="any";
	property name="userManager" type="any";
	
	public any function getAccountByMuraUser(required any muraUser) {
		// Load Account based upon the logged in muraUserID
		var account = getDAO().readByMuraUserID(muraUserID = arguments.muraUser.getUserID());
		
		if(isnull(account)) {
			// If no account exists, check for an account with that email 
			account = getDAO().readByAccountEmail(email = arguments.muraUser.getEmail());
			
			if(isnull(account)) {
				// If no account exists, create a new one and save it linked to the user that just logged in.
				account = getNewEntity();
				account.setMuraUserID(arguments.muraUser.getUserID());
				var accountEmail = getNewEntity(entityName="SlatwallAccountEmail");
				accountEmail.setEmail(arguments.muraUser.getEmail());
				accountEmail.setPrimaryFlag(1);
				accountEmail.setAccount(account);
				save(entity=account);
			} else {
				// If account does exist with that e-mail, check if the account has a muraUserID already tied to it
				if(isnull(account.getMuraUser())) {
					// TODO: If no muraUserID already assigend to this account, Assign this muraUserID but set the verified = 0
				} else {
					// TODO: If a muraUserID is already assigned, Offer to merge Accounts.
				}
			}
		}
		
		return account;
	}
}
