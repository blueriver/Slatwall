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
component displayname="Shipping Rate" entityname="SlatwallShippingRate" table="SlatwallShippingRate" persistent=true output=false accessors=true extends="BaseEntity" {
	
	// Persistent Properties
	property name="shippingRateID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="minWeight" ormtype="int";
	property name="maxWeight" ormtype="int";
	property name="minPrice" ormtype="big_decimal";
	property name="maxPrice" ormtype="big_decimal";
	property name="shippingRate" ormtype="big_decimal";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Related Object Properties
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	property name="addressZone" cfc="AddressZone" fieldtype="many-to-one" fkcolumn="addressZoneID";
	
	public array function getAddressZoneOptions() {
		if(!structKeyExists(variables, "addressZoneOptions")) {
			var smartList = new Slatwall.org.entitySmartList.SmartList(entityName="SlatwallAddressZone");
			smartList.addSelect(propertyIdentifier="addressZoneName", alias="name");
			smartList.addSelect(propertyIdentifier="addressZoneID", alias="value"); 
			smartList.addOrder("addressZoneName|ASC");
			variables.addressZoneOptions = smartList.getRecords();
			arrayPrepend(variables.addressZoneOptions, {value="", name=rbKey('define.all')});
		}
		return variables.addressZoneOptions;
	}
	
	/******* Association management methods for bidirectional relationships **************/
	
	// Shipping Method (many-to-one)
	
	public void function setShippingMethod(required ShippingMethod shippingMethod) {
	   variables.shippingMethod = arguments.shippingMethod;
	   if(isNew() or !arguments.shippingMethod.hasShippingRate(this)) {
	       arrayAppend(arguments.shippingMethod.getShippingRates(),this);
	   }
	}
	
	public void function removeShippingMethod(ShippingMethod shippingMethod) {
	   if(!structKeyExists(arguments,"shippingMethod")) {
	   		arguments.shippingMethod = variables.shippingMethod;
	   }
       var index = arrayFind(arguments.shippingMethod.getShippingRates(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.shippingMethod.getShippingRates(),index);
       }
       structDelete(variables,"shippingMethod");
    }
    
    /******* END: Association management methods for bidirectional relationships **************/
	

}
