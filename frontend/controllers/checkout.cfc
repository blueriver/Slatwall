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
component persistent="false" accessors="true" output="false" extends="BaseController" {

	property name="accountService" type="any";
	property name="orderService" type="any";
	
	public void function detail(required struct rc) {
		// Insure that the cart is not new, and that it has order items in it.  otherwise redirect to the shopping cart
		if(rc.$.slatwall.cart().isNew() || !arrayLen(rc.$.slatwall.cart().getOrderItems())) {
			getFW().redirectExact(rc.$.createHREF('shopping-cart'));
		}
	}
	
	public void function saveNewOrderAccount(required struct rc) {
		rc.$.slatwall.cart().setAccount(getAccountService().createNewAccount(data=rc));
		getOrderService().save(rc.$.slatwall.cart());
		getFW().redirectExact($.createHREF(filename='checkout'));
	}
	
	public void function saveOrderShippingAddress(required struct rc) {
		param name="rc.orderShippingAddressID" value="";
		
		rc.$.slatwall.cart().getOrderShippings()[1];
		var address = getAccountService().getByID(rc.orderShippingAddressID, true);
		address = getAccountService().save(address,rc);
		if(!address.hasErrors()) {
			rc.$.slatwall.cart().getOrderShippings()[1].setAddress(address);
	   		getFW().redirectExact($.createHREF(filename='checkout'));
		} else {
			getFW().setView("frontend:checkout.detail");
		}
	}
	
	/*
	public void function updateOrderShippingAddress(required struct rc) {
		param name="rc.orderShippingID" default="";
		param name="rc.orderShippingAddressID" default="";
		
		// Get The Order Shipping
		var orderShipping = getOrderService().getByID(rc.orderShippingID, "SlatwallOrderShipping");
		if(isNull(orderShipping)) {
			var orderShipping = getOrderService().getNewEntity("SlatwallOrderShipping");
		}
		
		// Get The Address
		var orderShippingAddress = getAddressService().getByID(rc.orderShippingAddressID);
		if(isNull(ordershippingAddress)) {
			var ordershippingAddress = getAddressService().getNewEntity();
		}
		
		// Save the Address
		rc.orderShippingAddress = getAddressService().save(rc.orderShippingAddress, rc);
		
		// Set the Address as the 
		rc.$.slatwall.cart().getOrderShippings()[1].setAddress(rc.orderShippingAddress);
	}
	
	public void function updateOrderShippingMethod(required struct rc) {
		
	}
	
	public void function updateOrderShippingPayment(required struct rc) {
		
	}
	
	
	
	public void function updateOrderPayment(required struct rc) {
		
	}
	
	public void function processOrder(required struct rc) {
		
	}
	*/
}
