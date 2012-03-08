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
component displayname="Promotion Qualifier Fulfillment" entityname="SlatwallPromotionQualifierFulfillment" table="SlatwallPromotionQualifier" persistent="true" extends="PromotionQualifier" discriminatorValue="fulfillment" {
	
	// Persistent Properties
	property name="promotionQualifierID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="maximumFulfillmentWeight" ormtype="float";
	
	// Related Entities
	property name="fulfillmentMethods" singularname="fulfillmentMethod" cfc="FulfillmentMethod" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierFulfillmentFulfillmentMethod" fkcolumn="promotionQualifierID" inversejoincolumn="fulfillmentMethodID";
	property name="shippingMethods" singularname="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierFulfillmentShippingMethod" fkcolumn="promotionQualifierID" inversejoincolumn="shippingMethodID";
	property name="addressZones" singularname="addressZone" cfc="AddressZone" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierFulfillmentAddressZone" fkcolumn="promotionQualifierID" inversejoincolumn="addressZoneID";
	

	public any function init() {

		if(isNull(variables.fulfillmentMethods)) {
			variables.fulfillmentMethods = [];
		}

		if(isNull(variables.shippingMethods)) {
			variables.shippingMethods = [];
		}
		
		if(isNull(variables.addressZones)) {
			variables.addressZones = [];
		}

		return super.init();
	}
	
	public string function getQualifierType() {
		return "fulfillment";
	}
	
	/*-----  Relationship Management Methods for bidirectional relationships -----*/
	
	// shippingMethod (many-to-many)
	
	public void function addShippingMethod(required any ShippingMethod) {
		if(arguments.shippingMethod.isNew() || !hasShippingMethod(arguments.shippingMethod)) {
			// first add shippingMethod to this qualifier
			arrayAppend(this.getShippingMethods(),arguments.shippingMethod);
			//add this qualifier to the shippingMethod
			arrayAppend(arguments.shippingMethod.getPromotionQualifiers(),this);
		}
	}
    
    public void function removeShippingMethod(required any ShippingMethod) {
       // first remove the shippingMethod from this qualifier
       if(this.hasShippingMethod(arguments.shippingMethod)) {
	       var index = arrayFind(this.getShippingMethods(),arguments.shippingMethod);
	       if(index>0) {
	           arrayDeleteAt(this.getShippingMethods(),index);
	       }
	      // then remove this qualifier from the shippingMethod
	       var index = arrayFind(arguments.shippingMethod.getPromotionQualifiers(),this);
	       if(index > 0) {
	           arrayDeleteAt(arguments.shippingMethod.getPromotionQualifiers(),index);
	       }
	   }
    }
    
	// AddressZone (many-to-many)
	
	public void function addAddressZone(required any addressZone) {
		if(arguments.addressZone.isNew() || !hasAddressZone(arguments.addressZone)) {
			// first add addressZone to this qualifier
			arrayAppend(this.getAddressZones(),arguments.addressZone);
			//add this qualifier to the addressZone
			arrayAppend(arguments.addressZone.getPromotionQualifiers(),this);
		}
	}
    
    public void function removeAddressZone(required any AddressZone) {
       // first remove the AddressZone from this qualifier
       if(this.hasAddressZone(arguments.addressZone)) {
	       var index = arrayFind(this.getAddressZones(),arguments.addressZone);
	       if(index>0) {
	           arrayDeleteAt(this.getAddressZones(),index);
	       }
	      // then remove this qualifier from the addressZone
	       var index = arrayFind(arguments.addressZone.getPromotionQualifiers(),this);
	       if(index > 0) {
	           arrayDeleteAt(arguments.addressZone.getPromotionQualifiers(),index);
	       }
	   }
    }
	
	/*-----  End Relationship Management Methods  -----*/
	
	public array function getFulfillmentMethodsOptions() {
		var fulfillmentMethodsOptions = [];
		var fulfillmentMethods = getService("fulfillmentService").listFulfillmentMethodFilterByActiveFlag( true );
		
		for( var i=1;i<=arrayLen(fulFillmentMethods);i++ ) {
			local.thisFulfillmentMethod = fulfillmentMethods[i];
			local.thisID = local.thisFulfillmentMethod.getFulfillmentMethodID();
			arrayAppend( fulfillmentMethodsOptions, {name=rbKey("admin.setting.fulfillmentmethod.#local.thisID#"),value=local.thisID} );
		}
		return fulfillmentMethodsOptions;
	}

	public string function displayFulfillmentMethodNames() {
		var fulfillmentMethodNames = "";
		for( var i=1; i<=arrayLen(this.getFulfillmentMethods());i++ ) {
			fulfillmentMethodNames = listAppend(fulfillmentMethodNames,rbKey("admin.setting.fulfillmentmethod.#this.getFulfillmentMethods()[i].getFulfillmentMethodID()#"));
		}
		return fulfillmentMethodNames;
	}
	
	
	public string function getFulfillmentMethodIDs() {
		var fulfillmentMethodIDs = "";
		for( var i=1; i<=arrayLen(this.getFulfillmentMethods());i++ ) {
			fulfillmentMethodIDs = listAppend(fulfillmentMethodIDs,this.getFulfillmentMethods()[i].getFulfillmentMethodID());
		}
		return fulfillmentMethodIDs;
	}

	public string function displayShippingMethodNames() {
		var shippingMethodNames = "";
		for( var i=1; i<=arrayLen(this.getShippingMethods());i++ ) {
			shippingMethodNames = listAppend(shippingMethodNames,this.getShippingMethods()[i].getShippingMethodName());
		}
		return shippingMethodNames;
	}
	
	
	public string function getShippingMethodIDs() {
		var shippingMethodIDs = "";
		for( var i=1; i<=arrayLen(this.getShippingMethods());i++ ) {
			shippingMethodIDs = listAppend(shippingMethodIDs,this.getShippingMethods()[i].getShippingMethodID());
		}
		return shippingMethodIDs;
	}
	
	public string function displayAddressZoneNames() {
		var addressZoneNames = "";
		for( var i=1; i<=arrayLen(this.getAddressZones());i++ ) {
			addressZoneNames = listAppend(addressZoneNames,this.getAddressZones()[i].getAddressZoneName());
		}
		return addressZoneNames;
	}
	
	
	public string function getAddressZoneIDs() {
		var addressZoneIDs = "";
		for( var i=1; i<=arrayLen(this.getAddressZones());i++ ) {
			addressZoneIDs = listAppend(addressZoneIDs,this.getAddressZones()[i].getAddressZoneID());
		}
		return addressZoneIDs;
	}


	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================	
}