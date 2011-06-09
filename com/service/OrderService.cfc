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
	property name="paymentService";
	property name="addressService";
	
	public void function addOrderItem(required any order, required any sku, numeric quantity=1, any orderFulfillment) {
		// Check to see if the order has a status
		if(isNull(arguments.order.getOrderStatusType())) {
			arguments.order.setOrderStatusType(this.getTypeBySystemCode('ostNotPlaced'));
		} else if (arguments.order.getOrderStatusType().getSystemCode() == "ostClosed" || arguments.order.getOrderStatusType().getSystemCode() == "ostCanceled") {
			throw("You cannot add an item to an order that has been closed or canceld");
		}
		
		// Check for an orderFulfillment in the arguments.  If none, use the orders first.  If none has been setup create a new one
		if(!structKeyExists(arguments, "orderFulfillment")) {
			var osArray = arguments.order.getOrderFulfillments();
			if(!arrayLen(osArray)) {
				// TODO: This next is a hack... later the type of Fulfillment created should be dynamic 
				arguments.orderFulfillment = this.newOrderFulfillmentShipping();
				
				arguments.orderFulfillment.setOrder(arguments.order);
				save(arguments.orderFulfillment);
			} else {
				arguments.orderFulfillment = osArray[1];
			}
		}
		
		var orderItems = arguments.order.getOrderItems();
		var itemExists = false;
		
		// Check the existing order items and increment quantity if possible.
		for(var i = 1; i <= arrayLen(orderItems); i++) {
			if(orderItems[i].getSku().getSkuID() == arguments.sku.getSkuID() && orderItems[i].getOrderFulfillment().getOrderFulfillmentID() == arguments.orderFulfillment.getOrderFulfillmentID()) {
				itemExists = true;
				orderItems[i].setQuantity(orderItems[i].getQuantity() + arguments.quantity);
			}
		}
		
		// If the sku doesn't exist in the order, then create a new order item and add it
		if(!itemExists) {
			var newItem = this.newOrderItem();
			newItem.setSku(arguments.sku);
			newItem.setQuantity(arguments.quantity);
			newItem.setOrder(arguments.order);
			newItem.setOrderFulfillment(arguments.orderFulfillment);
			newItem.setPrice(arguments.sku.getPrice());
		}
		
		save(arguments.order);
	}
	
	public void function setOrderShippingMethodFromMethodOptionID(required any orderShipping, required string orderShippingMethodOptionID) {
		var selectedOption = this.getOrderShippingMethodOption(arguments.orderShippingMethodOptionID);
		arguments.orderShipping.setShippingMethod(selectedOption.getShippingMethod());
		arguments.orderShipping.setShippingCharge(selectedOption.getTotalCost());
	}
	
	public any function processOrder(required any order) {
		var allPaymentsOK = true;
		
		// Process All Payments and Save the ones that were successful
		for(var i=1; i <= arrayLen(arguments.order.getOrderPayments()); i++) {
			var paymentOK = getPaymentService().processPayment(arguments.order.getOrderPayments()[i]);
			if(!paymentOK) {
				allPaymentsOK = false;
			}
		}
		
		// If all payments were successful, then change the order status and clear the cart.
		if(allPaymentsOK) {
			// Set the current cart to None
			if(arguments.order.getOrderID() == $.slatwall.cart().getOrderID()) {
				$.slatwall.getCurrentSession().setOrder(JavaCast("null",""));
			}
			
			// Update the order status
			arguments.order.setOrderStatusType(this.getTypeBySystemCode("ostNew"));
			
			// Save the order to the database
			getDAO().save(arguments.order);
			
			return true;
		}
		
		return false;
	}
	
	public any function getOrderRequirementsList(required any order) {
		var orderRequirementsList = "";
		
		// Check if the order still requires a valid account
		if( isNull(arguments.order.getAccount()) || arguments.order.getAccount().hasErrors()) {
			orderRequirementsList &= "account,";
		}
		
		// Check each of the fulfillment methods to see if they are ready to process
		for(var i=1; i<=arrayLen(arguments.order.getOrderFulfillments());i++) {
			if(!arguments.order.getOrderFulfillments()[i].isProcessable()) {
				orderRequirementsList &= "fulfillment,#arguments.order.getOrderFulfillments()[i].getOrderFulfillmentID()#,";		
			}
		}
		
		// Make sure that the order total is the same as the total payments applied
		if( arguments.order.getTotal() != arguments.order.getPaymentAmountTotal() ) {
			orderRequirementsList &= "payment,";
		}
		
		if(len(orderRequirementsList)) {
			orderRequirementsList = left(orderRequirementsList,len(orderRequirementsList)-1);
		}
		
		return orderRequirementsList;
	}
	
	public any function saveOrderFulfillment(required any orderFulfillment, struct data={}) {
		arguments.orderFulfillment.populate(arguments.data);
		
		if(arguments.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodID() == "shipping") {
			if( isNull(arguments.orderFulfillment.getShippingAddress()) ) {
				var address = getAddressService().newAddress();
			} else {
				var address = arguments.orderFulfillment.getShippingAddress();
			}
			
			address.populate(data);
			
			getAddressService.validateAddress(address);
			
			if(!address.hasErrors()) {
				arguments.orderFulfillment.setShippingAddress(address);
			}
			
		}
		
	}
}
