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
	property name="firstName" validateRequired ormtype="string" hint="This Value is only Set if a MuraID does not exist";
	property name="lastName" validateRequired ormtype="string" hint="This Value is only Set if a MuraID does not exist";
	property name="company" ormtype="string" hint="This Value is only Set if a MuraID does not exist";
	property name="muraUserID" ormtype="string";
	property name="remoteEmployeeID" ormtype="string" hint="Only used when integrated with a remote system";
	property name="remoteCustomerID" ormtype="string" hint="Only used when integrated with a remote system";
	property name="remoteContactID" ormtype="string" hint="Only used when integrated with a remote system";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID" constrained="false";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID" constrained="false";
	
	// Related Object Properties
	property name="accountEmailAddresses" singularname="accountEmailAddress" type="array" fieldtype="one-to-many" fkcolumn="accountID" cfc="AccountEmailAddress" cascade="all-delete-orphan" inverse="true";
	property name="primaryEmailAddress" cfc="AccountEmailAddress" fieldtype="many-to-one" fkcolumn="primaryEmailAddressID";
	property name="accountPhoneNumbers" singularname="accountPhoneNumber" type="array" fieldtype="one-to-many" fkcolumn="accountID" cfc="AccountPhoneNumber" cascade="all-delete-orphan" inverse="true";
	property name="primaryPhoneNumber" cfc="AccountPhoneNumber" fieldtype="many-to-one" fkcolumn="primaryPhoneNumber";
	property name="attributeSetAssignments" singularname="attributeSetAssignment" cfc="AccountAttributeSetAssignment" fieldtype="one-to-many" fkcolumn="accountID" cascade="all-delete-orphan" inverse="true";
	
	property name="orders" singularname="order" fieldType="one-to-many" type="array" fkColumn="accountID" cfc="Order" inverse="true";
	
	// Non-Persistent Cached Values
	variables.primaryEmail = "";
	
	public any function init() {
		if(isNull(variables.accountEmailAddresses)) {
			variables.accountEmailAddresses = [];
		}
		if(isNull(variables.accountPhoneNumbers)) {
			variables.accountPhoneNumbers = [];
		}
		if(isNull(variables.orders)) {
			variables.orders = [];
		}
		return super.init();
	}
	
	public string function getFullName() {
		return "#getFirstName()# #getLastName()#";
	}
	
	public boolean function isGuestAccount() {
		if(isNull(getMuraUserID())) {
			return true;
		} else {
			return false;
		}
	}
	
    /******* Association management methods for bidirectional relationships **************/
	
	// Orders (one-to-many)
	
	public void function addOrder(required Order Order) {
	   arguments.order.setAccount(this);
	}
	
	public void function removeOrder(required Order Order) {
	   arguments.order.removeAccount(this);
	}
	
	// Account (one-to-many)
	
	public void function addAccountEmail(required AccountEmail accountEmail) {
	   arguments.accountEmail.setAccount(this);
	}
	
	public void function addAccountPhoneNumber(required AccountPhoneNumber accountPhoneNumber) {
	   arguments.accountPhoneNumber.setAccount(this);
	}
		
    /************   END Association Management Methods   *******************/

	
}
