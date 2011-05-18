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
component displayname="Order Item" entityname="SlatwallOrderItem" table="SlatwallOrderItem" persistent=true accessors=true output=false extends="BaseEntity" {
	
	// Persistant Properties
	property name="orderItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="price" ormtype="float";
	property name="quantity" ormtype="float";
	property name="taxAmount" ormtype="float";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID" constrained="false";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID" constrained="false";
	
	// Related Object Properties
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="sku" cfc="sku" fieldtype="many-to-one" fkcolumn="skuID";
	property name="profile" cfc="Profile" fieldtype="many-to-one" fkcolumn="profileID";
	property name="orderShipping" cfc="OrderShipping" fieldtype="many-to-one" fkcolumn="orderShippingID";
	property name="orderShipment" cfc="OrderShipment" fieldtype="many-to-one" fkcolumn="orderShipmentID";
	property name="orderItemStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderItemStatusTypeID";
	
	public string function getStatus(){
		return getOrderItemStatusType().getType();
	}
	
	public string function getStatusCode() {
		return getOrderItemStatusType().getSystemCode();
	}
	
	public numeric function getExtendedPrice() {
		return getPrice()*getQuantity();
	}
	
	/******* Association management methods for bidirectional relationships **************/
	
	// Order (many-to-one)
	
	public void function setOrder(required Order Order) {
		variables.order = arguments.order;
		if(isNew() || !arguments.order.hasOrderItem(this)) {
			arrayAppend(arguments.order.getOrderItems(),this);
		}
	}
	
	public void function removeOrder(Order order) {
		if(!structKeyExists(arguments, "order")) {
			arguments.order = variables.order;
		}
		var index = arrayFind(arguments.order.getOrdertItems(),this);
		if(index > 0) {
			arrayDeleteAt(arguments.order.getOrderItems(),index);
		}    
		structDelete(variables,"order");
    }
    
    // Order Shipping (many-to-one)
    
    public void function setOrderShipping(required OrderShipping orderShipping) {
		variables.orderShipping = arguments.orderShipping;
		if(isNew() || !arguments.orderShipping.hasOrderShippingItems(this)) {
			arrayAppend(arguments.orderShipping.getOrderShippingItems(),this);
		}
    }
    
    public void function removeOrderShipping(OrderShipping orderShipping) {
    	if(!structKeyExists(arguments, "orderShipping")) {
    		arguments.orderShipping = variables.orderShipping;
    	}
    	var index = arrayFind(arguments.orderShipping.getOrderShippingItems(), this);
    	if(index > 0) {
    		arrayDeleteAt(arguments.orderShipping.getOrderShippingItems(), index);
    	}
    	structDelete(variables, "orderShipping");
    }
	
	/************   END Association Management Methods   *******************/
	
}
