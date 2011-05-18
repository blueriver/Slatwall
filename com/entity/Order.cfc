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
component displayname="Order" entityname="SlatwallOrder" table="SlatwallOrder" persistent=true output=false accessors=true extends="BaseEntity" {
	
	// Persistant Properties
	property name="orderID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="orderOpenDate" ormtype="timestamp";
	property name="orderCloseDate" ormtype="timestamp";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID" constrained="false";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID" constrained="false";
	
	// Related Object Properties
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="orderStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderStatusTypeID";
	property name="orderShippings" singularname="orderShipping" cfc="OrderShipping" fieldtype="one-to-many" fkcolumn="orderID" inverse="true" cascade="all";
	property name="orderShipments" singularname="orderShipment" cfc="OrderShipment" fieldtype="one-to-many" fkcolumn="orderID" inverse="true" cascade="all";
	property name="orderItems" singularname="orderItem" cfc="OrderItem" fieldtype="one-to-many" fkcolumn="orderID" inverse="true" cascade="all-delete-orphan";
	property name="orderPayments" singularname="orderPayment" cfc="OrderPayment" fieldtype="one-to-many" fkcolumn="orderID" inverse="true" cascade="all";
	
	public any function init() {
		if(isNull(variables.orderShippings)) {
			variables.orderShippings = [];
		}
		if(isNull(variables.orderShipments)) {
			variables.orderShipments = [];
		}
		if(isNull(variables.orderItems)) {
			variables.orderItems = [];
		}
		if(isNull(variables.orderPayments)) {
			variables.orderPayments = [];
		}
		return super.init();
	}
	
	public string function getStatus() {
		return getOrderStatusType().getType();
	}
	
	public string function getStatusCode() {
		return getOrderStatusType().getSystemCode();
	}
	
	public numeric function getTotalItems() {
		return arrayLen(getOrderItems());
	}
	
	public numeric function getTotalQuantity() {
		var orderItems = getOrderItems();
		var totalQuantity = 0;
		for(var i=1; i<=arrayLen(orderItems); i++) {
			totalQuantity += orderItems[i].getQuantity(); 
		}
		return totalQuantity;
	}
	
	public numeric function getSubtotal() {
		var subtotal = 0;
		var orderItems = getOrderItems();
		for(var i=1; i<=arrayLen(orderItems); i++) {
			subtotal += orderItems[i].getExtendedPrice();
		}
		return subtotal;
	}
	
	public numeric function getTaxTotal() {
		return 0;
	}
	
	public numeric function getShippingTotal() {
		return 0;
	}
	
	public numeric function getTotal() {
		return getSubtotal() + getTaxTotal() + getShippingTotal();
	}
	
	public void function removeAllOrderItems() {
		var orderItems = getOrderItems();
		for(var i=1; i<=arrayLen(orderItems); i++) {
			removeOrderItem(orderItems[i]);
		}
	}
	
    /******* Association management methods for bidirectional relationships **************/
	
	// OrderItems (one-to-many)
	
	public void function addOrderItem(required OrderItem OrderItem) {
	   arguments.orderItem.setOrder(this);
	}
	
	public void function removeOrderItem(required OrderItem OrderItem) {
	   arguments.orderItem.removeOrder(this);
	}
	
	// OrderShippings (one-to-many)
	
	public void function addOrderShipping(required OrderShipment orderShipping) {
	   arguments.orderShipping.setOrder(this);
	}
	
	public void function removeOrderShipping(required OrderShipment orderShipping) {
	   arguments.orderShipping.removeOrder(this);
	}
	
	// OrderShipments (one-to-many)
	
	public void function addOrderShipment(required OrderShipment OrderShipment) {
	   arguments.orderShipment.setOrder(this);
	}
	
	public void function removeOrderShipment(required OrderShipment OrderShipment) {
	   arguments.orderShipment.removeOrder(this);
	}
	
	// OrderPayments (one-to-many)
	
	public void function addOrderPayment(required OrderPayment OrderPayment) {
	   arguments.orderPayment.setOrder(this);
	}
	
	public void function removeOrderPayment(required OrderPayment OrderPayment) {
	   arguments.orderPayment.removeOrder(this);
	}
	
	// Account (many-to-one)
	
	public void function setAccount(required Account account) {
	   variables.account = arguments.account;
	   if(!arguments.account.hasOrder(this)) {
	       arrayAppend(arguments.account.getOrders(),this);
	   }
	}
	
	public void function removeAccount(Account account) {
		if(structKeyExists(variables,"account")) {
			if(!structKeyExists(arguments, "account")) {
				arguments.account = variables.account;
			}
			var index = arrayFind(arguments.account.getOrders(),this);
			if(index > 0) {
				arrayDeleteAt(arguments.account.getOrders(),index);
			}    
			structDelete(variables,"account");
		}
    }
	
    /************   END Association Management Methods   *******************/
	
	// These Methods are designed to check what still needs to be set before an order is ready to process
	public boolean function hasValidAccount() {
		if(isNull(variables.account) || variables.account.isNew()) {
			return false;
		} else {
			return true;	
		}
	}
	
	public boolean function hasValidOrderShippingAddress() {
		var valid = true;
		
		var orderShippings = getOrderShippings();
		
		// Loop over all order Shippings to make sure that there is a shipping address asigned
		for( var i=1; i<=arrayLen(orderShippings); i++ ) {
			if(isNull(orderShippings[i].getAddress()) || orderShippings[i].getAddress().isNew()) {
				valid = false;
			}
		}
		
		return valid;
	}
	
	public boolean function hasValidOrderShippingMethod() {
		var valid = true;
		
		var orderShippings = getOrderShippings();
		
		// Loop over all order Shippings to make sure that there is a shipping method asigned
		for( var i=1; i<=arrayLen(orderShippings); i++ ) {
			if(isNull(orderShippings[i].getShippingMethod())) {
				valid = false;
			}
		}
		
		return valid;
	}
	
	public boolean function hasValidOrderShipping() {
		var valid = false;
		
		if(hasValidOrderShippingAddress() && hasValidOrderShippingMethod()) {
			valid = true;
		}
		
		return valid;
	}
	
	public boolean function hasValidPayment() {
		var valid = true;
		var totalPayments = 0;
		
		var orderPayments = getOrderPayments();
		for(var i=1; i<=arrayLen(orderPayments); i++) {
			totalPayments += orderPayments[i].getAmount();
		}
		
		if(totalPayments == getTotal()) {
			valid = true;
		}
		
		return valid;
	}
	
	public boolean function isValidForProcessing() {
		var valid = false;
		if(hasValidAccount() && hasValidOrderShippingAddress() && hasValidOrderShippingMethod() && hasValidPayment()) {
			valid = true;
		}
		return valid;
	}
	
	
}
