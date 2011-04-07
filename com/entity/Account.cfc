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
component displayname="Account" entityname="SlatwallAccount" table="SlatwallAccount" persistent="true" output="false" accessors="true" extends="BaseEntity" {
	
	// Persistant Properties
	property name="accountID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="firstName" ormtype="string" hint="This Value is only Set if a MuraID does not exist";
	property name="lastName" ormtype="string" hint="This Value is only Set if a MuraID does not exist";
	property name="company" ormtype="string" hint="This Value is only Set if a MuraID does not exist";
	property name="remoteEmployeeID" ormtype="string" hint="Only used when integrated with a remote system";
	property name="remoteCustomerID" ormtype="string" hint="Only used when integrated with a remote system";
	property name="remoteContactID" ormtype="string" hint="Only used when integrated with a remote system";
	property name="muraUserID" ormtype="string";
	property name="createdDateTime" ormtype="timestamp";
	property name="lastUpdatedDateTime"	ormtype="timestamp";
	
	// Related Object Properties
	property name="type" cfc="Type" fieldtype="many-to-one" fkcolumn="accountTypeID";
	property name="accountEmails" singularname="accountEmail" type="array" fieldtype="one-to-many" fkcolumn="accountID" cfc="AccountEmail" inverse="true" cascade="all";
	property name="attributeSetAssignments" singularname="attributeSetAssignment" cfc="AttributeSetAssignment" fieldtype="one-to-many" fkcolumn="baseItemID" cascade="all";
	
	// Non-Persistant Properties
	property name="primaryEmail" type="string" persistent="false";
	property name="muraUser" type="any" persistent="false";
	
	public array function getAccountEmails() {
		if(!isDefined("variables.accountEmails")) {
			variables.accountEmails = arrayNew(1);
		}
		return variables.accountEmails;
	}

	// Start: User Helpers
	// The following four functions are designed to connect a Slatwall account to a Mura account.  If the mura account exists then this will pull all data from mura, if not then the firstName, lastName & company will be stored in the Slatwall DB.
	public string function getFirstName() {
		if(!getMuraUser().getIsNew()) {
			variables.firstName = getMuraUser().getFname();
		}
		if(!structKeyExists(variables, "firstName")) {
			variables.firstName = "";
		}
		return variables.firstName;
	}
	
	public string function getLastName() {
		if(!getMuraUser().getIsNew()) {
			variables.lastName = getMuraUser().getLname();
		}
		if(!structKeyExists(variables, "lastName")) {
			variables.lastName = "";
		}
		return variables.lastName;
	}
	
	public string function getCompany() {
		if(!getMuraUser().getIsNew()) {
			variables.company = getMuraUser().getCompany();
		}
		if(!structKeyExists(variables, "company")) {
			variables.company = "";
		}
		
		return variables.company;
	}
	// End: User Helpers
	
	public string function getFullName() {
		return "#getFirstName()# #getLastName()#";
	}
		
	public any function getMuraUser() {
		if(!structKeyExists(variables, "muraUser")) {
			variables.muraUser = getService("userManager").read(userID=getMuraUserID());
		}
		return variables.muraUser;
	}
	
	public any function setMuraUser(required any muraUser) {
		variables.muraUser = arguments.muraUser;
		setMuraUserID(arguments.muraUser.getUserID());
	}
	
	public string function getPrimaryEmail() {
		if(!isDefined("variables.primaryEmail")) {
			
			// Look through all account emails for the primary one
			var emails = getAccountEmails();
			
			for(var i = 1; i <= arrayLen(emails); i++) {
				if(emails[i].getIsPrimary() == true) {
					variables.primaryEmail = emails[i].getEmail();
				}
			}
			
			// If one wasn't found, but there were 1 or more emails, set the first one as primary.  Otherwise set as blank
			if(!isDefined("variables.primaryEmail") && arrayLen(emails) > 0) {
				emails[1].setIsPrimary(true);
				getService("accountService").save(entity = emails[1]);
				variables.primaryEmail = emails[1].getEmail();
			} else if(!isDefined("variables.primaryEmail")) {
				variables.primaryEmail = "";
			}
		}

		return variables.primaryEmail;
	}
	
	public any function setPrimaryEmail() {
		throw("Setting the primary email for an account should be done to an accountEmail entity, and should be done by using the method 'setIsPrimary'");
	}
	
}
