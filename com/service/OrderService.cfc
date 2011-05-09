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
component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {
	
	property name="sessionService";
	
	public void function addOrderItem(required any order, required any sku, numeric quantity=1, any orderShipping) {
		// TODO: Check the status of the order to make sure it isn't closed
		
		var orderItems = arguments.order.getOrderItems();
		var itemExists = false;
		
		// Check for an orderShipping in the arguments.  If none, use the orders first.  If none has been setup create a new one
		if(!structKeyExists(arguments, "orderShipping")) {
			var osArray = arguments.order.getOrderShippings();
			if(!arrayLen(osArray)) {
				arguments.orderShipping = getNewEntity("SlatwallOrderShipping");
				arguments.orderShipping.setOrder(arguments.order);
				save(arguments.orderShipping);
			} else {
				arguments.orderShipping = osArray[1];
			}
		}
		
		// Check the existing order items
		for(var i = 1; i <= arrayLen(orderItems); i++) {
			if(orderItems[i].getSku().getSkuID() == arguments.sku.getSkuID() && orderItems[i].getOrderShipping() == arguments.orderShipping) {
				itemExists = true;
				orderItems[i].setQuantity(orderItems[i].getQuantity() + arguments.quantity);
			}
		}
		
		// If the sku doesn't exist in the order, then create a new order item and add it
		if(!itemExists) {
			var newItem = getNewEntity(entityName="SlatwallOrderItem");
			newItem.setSku(arguments.sku);
			newItem.setQuantity(arguments.quantity);
			newItem.setOrder(arguments.order);
			newItem.setOrderShipping(arguments.orderShipping);
		}
		
		save(arguments.order);
	}
	
	public void function clearOrderItems(required any order) {
		// TODO: Check the status of the order to make sure it hasn't been placed yet.
		var orderItems = arguments.order.getOrderItems();
		
		for(var i=1; i<=arrayLen(orderItems); i++) {
			orderItems[i].removeOrder(arguments.order);
		}
		
		save(arguments.order);
	}
	
	public boolean function verifyOrderAccount(required any order) {
		var verified = true;
		
		if(isNull(argument.order.account) || arguments.order.account.isNew()) {
			verified = false;
		}
		
		return verified;
	}
	
	public boolean function verifyOrderShippingAddress(required any order) {
		var verified = true;
		
		var orderShippings = arguments.order.getOrderShippings();
		
		for( var i=1; i<=arrayLen(orderShippings); i++ ) {
			if(isNull(orderShippings[i].getAddress()) || orderShippings[i].getAddress().isNew()) {
				verified = false;
			}
		}
		
		return verified;
	}
	
	public boolean function verifyOrderShippingMethod(required any order) {
		var verified = true;
		
		var orderShippings = arguments.order.getOrderShippings();
		
		for( var i=1; i<=arrayLen(orderShippings); i++ ) {
			if(isNull(orderShippings[i].getShippingMethod())) {
				verified = false;
			}
		}
		
		return verified;
	}
	
	public boolean function verifyOrderPayment(required any order) {
		return false;
	}
	
}
