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
component displayname="Order Fulfillment" entityname="SlatwallOrderFulfillment" table="SlatwallOrderFulfillment" persistent=true accessors=true output=false extends="BaseEntity" discriminatorcolumn="fulfillmentMethodID" {
	
	// Persistent Properties
	property name="orderFulfillmentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="fulfillmentCharge" ormtype="float";
	
	//non-persistent Properties
	property name="subTotal" type="numeric" persistent="false";
	property name="taxAmount" type="numeric" persistent="false";
	
	// Related Object Properties
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="orderFulfillmentItems" validateRequired="true" singularname="orderFulfillmentItem" cfc="OrderItem" fieldtype="one-to-many" fkcolumn="orderFulfillmentID" cascade="all" inverse="true";
	
	// Special Related Discriminator Property
	property name="fulfillmentMethod" cfc="FulfillmentMethod" fieldtype="many-to-one" fkcolumn="fulfillmentMethodID" length="32" insert="false" update="false";
	property name="fulfillmentMethodID" insert="false" update="false";
	
	public any function init() {
		if(isNull(variables.orderFulfillmentItems)) {
			variables.orderFulfillmentItems = [];
		}
		
		return super.init();
	}
	
	public boolean function isProcessable() {
		if(!arrayLen(getOrderFulfillmentItems())) {
			return false;
		}
		
		return true;
	}
	
	//@ hint this method fires any time that there is a change to the orderFulfillmentItems.  It is designed to be overridden by the fulfillment method specific entities to adjust accordingly
	public void function orderFulfillmentItemsChanged() {
		
	}
	
	/******* Association management methods for bidirectional relationships **************/
	
	// Order (many-to-one)
	
	public void function setOrder(required Order order) {
		variables.order = arguments.order;
		if(!arguments.order.hasOrderFulfillment(this)) {
			arrayAppend(arguments.order.getOrderFulfillments(),this);
		}
	}
	
	public void function removeOrder(Order order) {
	   if(!structKeyExists(arguments,"order")) {
	   		arguments.order = variables.order;
	   }
       var index = arrayFind(arguments.order.getOrderFulfillments(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.order.getOrderFulfillments(), index);
       }
       structDelete(variables,"order");
    }
    
    // Order Fulfillment Items (one-to-many)
    public void function addOrderFulfillmentItem(required OrderItem orderFulfillmentItem) {
    	arguments.orderFulfillmentItem.setOrderFulfillment(this);
    }
    
    public void function removeOrderFulfillmentItem(required OrderItem orderFulfillmentItem) {
    	arguments.orderFulfillmentItem.removeOrderFulfillment(this);
    }
    
    /******* END Association management methods */ 
    
    public numeric function getSubTotal() {
  		if( !structKeyExists(variables,"subTotal") ) {
	    	variables.subTotal = 0;
	    	var items = getOrderFulfillmentItems();
	    	for( var i=1; i<=arrayLen(items); i++ ) {
	    		variables.subTotal += items[i].getExtendedPrice();
	    	}			
  		}
    	return variables.subTotal;
    }
    
    public numeric function getTax() {
    	if( !structkeyExists(variables, "taxAmount") ) {
    		variables.taxAmount = 0;
	    	var items = getOrderFulfillmentItems();
	    	for( var i=1; i<=arrayLen(items); i++ ) {
	    		variables.taxAmount += items[i].getTaxAmount();
	    	}
    	}
    	return variables.taxAmount;
    }
    
    public numeric function getTotalCharge() {
    	return getSubTotal() + getTax() + getFulfillmentCharge();
    }
    
}
