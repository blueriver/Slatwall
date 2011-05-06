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
component displayname="Order" entityname="SlatwallOrder" table="SlatwallOrder" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
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
	property name="orderShipments" singularname="orderShipment" cfc="OrderShipment" fieldtype="one-to-many" fkcolumn="orderID" inverse="true" cascade="all";
	property name="orderItems" singularname="orderItem" cfc="OrderItem" fieldtype="one-to-many" fkcolumn="orderID" inverse="true" cascade="all";
	property name="orderPayments" singularname="orderPayment" cfc="OrderPayment" fieldtype="one-to-many" fkcolumn="orderID" inverse="true" cascade="all";
	
	public string function getStatus() {
		return getOrderStatusType().getType();
	}
	
	public string function getStatusCode() {
		return getOrderStatusType().getSystemCode();
	}
	
	public array function getOrderItems() {
		if(!structKeyExists(variables, "orderItems")) {
			variables.orderItems = arrayNew(1);
		}
		return variables.orderItems;
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
	
    /******* Association management methods for bidirectional relationships **************/
	
	// OrderItems (one-to-many)
	
	public void function addOrderItem(required OrderItem OrderItem) {
	   arguments.orderItem.setOrder(this);
	}
	
	public void function removeOrderItem(required OrderItem OrderItem) {
	   arguments.orderItem.removeOrder(this);
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
	
	public void function setAccount(required Account Account) {
	   variables.account = arguments.account;
	   if(!arguments.Account.hasOrder(this)) {
	       arrayAppend(arguments.Account.getOrders(),this);
	   }
	}
	
	public void function removeAccount(required Account Account) {
       var index = arrayFind(arguments.Account.getOrders(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.Account.getOrders(),index);
       }    
       structDelete(variables,"Account");
    }
	
    /************   END Association Management Methods   *******************/
	
}
