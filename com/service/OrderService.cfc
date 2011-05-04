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
	
	public void function addOrderItem(required any order, required any sku, numeric quantity=1) {
		
		// Check to see if a order was passed into the method call	
		if(!structKeyExists(arguments, "order")) {
			arguments.order = getSessionService().getCurrent().getCart();
		}
		
		// TODO: Check the status of the order to make sure it isn't closed
		
		var orderItems = arguments.order.getOrderItems();
		var exists = false;
		
		// Check the existing order items and just add quantity if sku exists
		for(var i = 1; i <= arrayLen(orderItems); i++) {
			if(orderItems[i].getSku().getSkuID() == arguments.sku.getSkuID()) {
				exists = true;
				orderItems[i].setQuantity(orderItems[i].getQuantity() + arguments.quantity);
			}
		}
		
		// If the sku doesn't exist in the order, then create a new order item and add it
		if(!exists) {
			var newOrderItem = getNewEntity(entityName="SlatwallOrderItem");
			newOrderItem.setQuantity(arguments.quantity);
			newOrderItem.setOrder(arguments.order);
			newOrderItem.setSku(arguments.sku);
			arguments.order.addOrderItem(newOrderItem);
		}
		
		save(arguments.order);
	}
	
	public void function clearOrderItems(required any order) {
		// TODO: Check the status of the order to make sure it hasn't been placed yet.
		
		argments.order.setOrderItems(arrayNew());
		save(arguments.order);
	}
	
}
