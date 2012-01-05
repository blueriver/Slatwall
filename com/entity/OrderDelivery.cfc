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
component displayname="Order Delivery" entityname="SlatwallOrderDelivery" table="SlatwallOrderDelivery" persistent="true" accessors="true" output="false" extends="BaseEntity" discriminatorcolumn="fulfillmentMethodID" {
	
	// Persistent Properties
	property name="orderDeliveryID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="deliveryOpenDateTime" ormtype="timestamp";
	property name="deliveryCloseDateTime" ormtype="timestamp";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Related Object Properties
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="orderDeliveryItems" singularname="orderDeliveryItem" cfc="OrderDeliveryItem" fieldtype="one-to-many" fkcolumn="orderDeliveryID" cascade="all-delete-orphan" inverse="true";
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	
	
	// Special Related Discriminator Property
	property name="fulfillmentMethod" cfc="FulfillmentMethod" fieldtype="many-to-one" fkcolumn="fulfillmentMethodID" length="32" insert="false" update="false";
	property name="fulfillmentMethodID" length="255" insert="false" update="false";
	
	public OrderDelivery function init(){
	   // set default collections for association management methods
	   if(isNull(variables.orderDeliveryItems)) {
	       variables.orderDeliveryItems = [];
	   }    
	   return Super.init();
	}
	
	public any function getTotalQuanityDelivered() {
		var totalDelivered = 0;
		for(var i=1; i<=arrayLen(getOrderDeliveryItems()); i++) {
			totalDelivered += getOrderDeliveryItems()[i].getQuantityDelivered();
		}
		return totalDelivered;
	}
   
    /******* Association management methods for bidirectional relationships **************/
	
	// Order (many-to-one)
	
	public void function setOrder(required Order Order) {
	   variables.order = arguments.order;
	   if(!arguments.order.hasOrderDelivery(this)) {
	       arrayAppend(arguments.order.getOrderDeliveries(),this);
	   }
	}
	
	public void function removeOrder(required Order Order) {
       var index = arrayFind(arguments.order.getOrderDeliveries(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.order.getOrderDeliveries(),index);
       }    
       structDelete(variables,"order");
    }
    
	
	// OrderDeliveryItems (one-to-many)
	
	public void function addOrderDeliveryItem(required OrderDeliveryItem orderDeliveryItem) {
	   arguments.orderDeliveryItem.setOrderDelivery(this);
	}
	
	public void function removeOrderDeliveryItem(required OrderDeliveryItem OrderDeliveryItem) {
	   arguments.orderDeliveryItem.removeOrderDelivery(this);
	}
    /************   END Association Management Methods   *******************/
}
