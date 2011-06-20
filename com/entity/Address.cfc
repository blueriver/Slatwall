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
component displayname="Address" entityname="SlatwallAddress" table="SlatwallAddress" persistent="true" output="false" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="addressID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="name" ormtype="string";
	property name="company" ormtype="string";
	property name="phone" ormtype="string";
	property name="streetAddress" ormtype="string";
	property name="street2Address" ormtype="string";
	property name="locality" ormtype="string";
	property name="city" ormtype="string";
	property name="stateCode" ormtype="string";
	property name="postalCode" ormtype="string";
	property name="countryCode" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID" constrained="false";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID" constrained="false";
	
	// Non persistent cached properties
	property name="country" persistent="false";
	
	public any function init() {
		if(isNull(variables.countryCode)) {
			variables.countryCode = "US";
		}
		
		return super.init();
	}
	
	public string function getFullAddress(string delimiter = ", ") {
		var address = "";
		address = listAppend(address,getCompany());
		address = listAppend(address, getStreetAddress());
		address = listAppend(address,getStreet2Address());
		address = listAppend(address,getCity());
		address = listAppend(address,getStateCode());
		address = listAppend(address,getPostalCode());
		address = listAppend(address,getCountryCode());
		// this will remove any empty elements and insert any passed-in delimiter
		address = listChangeDelims(address,arguments.delimiter,",","no");
		return address;
	}
	
	public array function getCountryCodeOptions() {
		if(!structKeyExists(variables, "countryCodeOptions")) {
			var smartList = new Slatwall.com.utility.SmartList(entityName="SlatwallCountry");
			smartList.addSelect(propertyIdentifier="countryName", alias="name");
			smartList.addSelect(propertyIdentifier="countryCode", alias="id");
			smartList.addOrder("countryName|ASC");
			variables.countryCodeOptions = smartList.getRecords();
		}
		return variables.countryCodeOptions;
	}
	
	public array function getStateCodeOptions() {
		if(!structKeyExists(variables, "stateCodeOptions")) {
			var smartList = new Slatwall.com.utility.SmartList(entityName="SlatwallState");
			smartList.addSelect(propertyIdentifier="stateName", alias="name");
			smartList.addSelect(propertyIdentifier="stateCode", alias="id");
			smartList.addFilter("countryCode", getCountryCode()); 
			smartList.addOrder("stateName|ASC");
			variables.stateCodeOptions = smartList.getRecords();
		}
		return variables.stateCodeOptions;
	}
	
	public any function getCountry() {
		if(!structKeyExists(variables, "country")) {
			variables.country = getService("addressService").getCountry(getCountryCode());
		}
		return variables.country;
	}
}
