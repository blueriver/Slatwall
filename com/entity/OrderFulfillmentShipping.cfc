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
component displayname="Order Fulfillment Shipping" entityname="SlatwallOrderFulfillmentShipping" table="SlatwallOrderFulfillment" persistent="true" output="false" accessors="true" extends="OrderFulfillment" discriminatorvalue="shipping" {
	
	// Persistent Properties
	property name="orderFilfillmentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	
	property name="shippingAddress" cfc="Address" fieldtype="many-to-one" fkcolumn="shippingAddressID";
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	
	property name="orderShippingMethodOptions" singularname="orderShippingMethodOption" cfc="OrderShippingMethodOption" fieldtype="one-to-many" fkcolumn="orderFulfillmentID" cascade="all-delete-orphan" inverse="true";

	public any function init() {
		if(isNull(variables.orderShippingMethodOptions)) {
			variables.orderShippingMethodOptions = [];
		}
		
		return super.init();
	}

	public boolean function isProcessable() {
		if(!super.isProcessable()) {
			return false;
		}
		
		if(isNull(getShippingAddress())) {
			return false;
		} else if(getService("addressService").validateAddress(getShippingAddress()).getErrorBean().hasErrors()) {
			return false;
		}
		
		if(isNull(getShippingMethod())) {
			return false;
		}
		
		return true;
	}
	
	public void function orderFulfillmentItemsChanged() {
		removeShippingMethodAndMethodOptions();
	}
	
	public array function getOrderShippingMethodOptions(boolean autoPopulate=true) {
		if(autoPopulate) {
			populateOrderShippingMethodOptionsIfEmpty();
		}
		return variables.orderShippingMethodOptions;
	}
	
	public void function populateOrderShippingMethodOptionsIfEmpty() {
		if(!isNull(variables.shippingAddress) && arrayLen(variables.orderFulfillmentItems) && !arrayLen(variables.orderShippingMethodOptions)) {
			getService("ShippingService").populateOrderShippingMethodOptions(this);
		}
	}
	
	public void function removeShippingMethodAndMethodOptions() {
		// remove all existing options
		for(var i = arrayLen(getOrderShippingMethodOptions(false)); i >= 1; i--) {
			getOrderShippingMethodOptions()[i].removeOrderFulfillmentShipping(this);
		}
		setShippingMethod(javaCast("null", ""));
		setFulfillmentCharge(0);
	}
	
	// Any time a new Address gets set, we need to adjust the order shipping options
	public void function setAddress(required Address address) {
		variables.address = arguments.address;
		removeShippingMethodAndMethodOptions();
	}
		
    // Order Shipping Method Options (one-to-many)
    public void function addOrderShippingMethodOption(required OrderShippingMethodOption orderShippingMethodOption) {
    	arguments.orderShippingMethodOption.addOrderShipping(this);
    }
    
    public void function removeOrderShippingMethodOption(required OrderShippingMethodOption orderShippingMethodOption) {
    	arguments.orderShippingMethodOption.removeOrderShipping(this);
    }

	public numeric function getShippingCharge() {
		return getFulfillmentCharge();
	}
	
	public numeric function getTotalShippingWeight() {
    	if( !structKeyExists(variables, "totalShippingWeight") ) {
	    	variables.totalShippingWeight = 0;
	    	var items = getOrderFulfillmentItems();
	    	for( var i=1; i<=arrayLen(items); i++ ) {
	    		variables.totalShippingWeight += (items[i].getSku().getShippingWeight() * items[i].getQuantity());
	    	}			
  		}
    	return variables.totalShippingWeight;
    }
}