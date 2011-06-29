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
component extends="BaseService" persistent="false" accessors="true" output="false" {
	
	property name="sessionService";
	property name="paymentService";
	property name="addressService";
	property name="tagProxyService";
	property name="taxService";
	
	public any function getOrderSmartList(struct data={}) {
		arguments.entityName = "SlatwallOrder";
		var smartList = getDAO().getSmartList(argumentCollection=arguments);
		
		smartList.addKeywordProperty(propertyIdentifier="orderNumber", weight=9);
		smartList.addKeywordProperty(propertyIdentifier="account_lastname", weight=4);
		smartList.addKeywordProperty(propertyIdentifier="account_firstname", weight=3);
		
		smartList.joinRelatedProperty("SlatwallOrder","account");
		
		return smartList;
	}
	
	public any function getOrderFulfillmentSmartList(struct data = {}) {
		arguments.entityName = "SlatwallOrderFulfillment";
		var smartList = getDAO().getSmartList(argumentCollection=arguments);
		smartList.addOrder("order_orderOpenDateTime|DESC");
		return smartList;
	}
	
	public any function getOrderStatusOptions(struct data={}) {
		arguments.entityName = "SlatwallType";
		var smartlist = getDAO().getSmartList(argumentCollection=arguments);
		smartList.addSelect("systemCode","id");
		smartList.addSelect("type","name");
		smartList.addFilter("parentType_systemCode","orderStatusType");
		smartList.addFilter("systemCode","ostNew,ostProcessing,ostOnHold,ostClosed,ostCancelled");
		return smartlist.getPageRecords();
	}
	
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
				
				// Push the fulfillment into the hibernate scope
				getDAO().save(arguments.orderFulfillment);
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
				orderItems[i].getOrderFulfillment().orderFulfillmentItemsChanged();
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
		arguments.orderShipping.setShippingCharge(selectedOption.getTotalCharge());
	}
	
	public boolean function setupPaymentAndProcessOrder(required any order, required struct data) {
		var result = false;
		
		// Place all of this code in a try catch so that if it errors we release the okToProcessOrder lock
		try {
			
			// Lock down this determination so that the values getting called and set don't overlap
			lock scope="Session" timeout="45" {
				// Get okToProcessOrder out of the session scope, and if it doesn't exist set it to true
				var okToProcessOrder = getSessionService().getValue("okToProcessOrder", true);
				
				// If okToProcessOrder was true, update the session variable to false because we are about to try an process
				if(okToProcessOrder) {
					getSessionService().setValue("okToProcessOrder", false);
				}
			}
			
			if(okToProcessOrder) {
				
				var payment = getPaymentService().getOrderPayment(data.orderPaymentID);
			
				if(isNull(payment)) {
					if(arguments.order.getTotal() != arguments.order.getPaymentAmountTotal()) {
						payment = getPaymentService().new("SlatwallOrderPayment#data.paymentMethodID#");
					} else {
						payment = arguments.order.getOrderPayments()[arrayLen(arguments.order.getOrderPayments())];
					}
					
					// If no amount was passed in from the data, add the amount as the order total minus and previous payments
					if(!structKeyExists(arguments.data, "amount")) {
						arguments.data.amount = arguments.order.getTotal() - arguments.order.getPaymentAmountTotal();
					}
					
					// Add new Payment to the order
					payment.setOrder(arguments.order);
				}
				
				// Attempt to Validate & Save Order Payment
				payment = this.saveOrderPayment(payment, arguments.data);
				
				// If the payment has errors do not proceed with the order processing
				if(payment.hasErrors()) {
					result = false;
				} else {
					result = this.processOrder(arguments.order);
				}
				// Processing is complete so we set the session variable okToProcessOrder to true so this can run again in the future
				getSessionService().setValue("okToProcessOrder", true);
			}
		} catch (any e) {
			// Processing is complete so we set the session variable okToProcessOrder to true so this can run again in the future
			getSessionService().setValue("okToProcessOrder", true);
		}
		return result;
	}
	
	public any function processOrder(required any order) {
		var allPaymentsOK = true;
		
		// Process All Payments and Save the ones that were successful
		for(var i=1; i <= arrayLen(arguments.order.getOrderPayments()); i++) {
			var transactionType = setting('paymentMethod_creditCard_checkoutTransactionType');
			if(transactionType != 'none') {
				var paymentOK = getPaymentService().processPayment(arguments.order.getOrderPayments()[i], transactionType);
				if(!paymentOK) {
					allPaymentsOK = false;
				}
			}
		}
		
		// If all payments were successful, then change the order status and clear the cart.
		if(allPaymentsOK) {
			// Set the current cart to None
			if(arguments.order.getOrderID() == getSessionService().getCurrent().getOrder().getOrderID()) {
				getSessionService().getCurrent().setOrder(JavaCast("null",""));
			}
			
			// Update the order status
			arguments.order.setOrderStatusType(this.getTypeBySystemCode("ostNew"));
			
			// Save the order to the database
			getDAO().save(arguments.order);
			
			// Do a flush so that the order is commited to the DB
			ormFlush();
			
			// Send out the e-mail
			sendOrderConfirmationEmail(arguments.order);
			
			return true;
		}
		
		return false;
	}

	function sendOrderConfirmationEmail (required any order) {
		
		var emailTo = '"#arguments.order.getAccount().getFirstName()# #arguments.order.getAccount().getLastName()#" <#arguments.order.getAccount().getPrimaryEmailAddress().getEmailAddress()#>';
		var emailFrom = setting('order_orderPlacedEmailFrom');
		var emailCC = setting('order_orderPlacedEmailCC');
		var emailBCC = setting('order_orderPlacedEmailBCC');
		var emailSubject = setting('order_orderPlacedEmailSubject');
		var emailBody = "";
		
		savecontent variable="emailBody" {
			include "#application.configBean.getContext()#/#request.context.$.event('siteid')#/includes/display_objects/custom/slatwall/email/orderPlaced.cfm";
		}
		
		getTagProxyService().cfmail(to = emailTo, from = emailFrom, cc = emailCC, bcc = emailBCC, subject = emailSubject, body = emailBody);
		
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
		
		// If fulfillment method is shipping do this
		if(arguments.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodID() == "shipping") {
			
			// Get Address
			if( isNull(arguments.orderFulfillment.getShippingAddress()) ) {
				var address = getAddressService().newAddress();
			} else {
				var address = arguments.orderFulfillment.getShippingAddress();
			}
			
			// Set the address in the order Fulfillment
			arguments.orderFulfillment.setShippingAddress(address);
			
			// Populate Address And check if it has changed
			var serializedAddressBefore = address.simpleValueSerialize();
			address.populate(data);
			var serializedAddressAfter = address.simpleValueSerialize();
			
			if(serializedAddressBefore != serializedAddressAfter) {
				arguments.orderFulfillment.removeShippingMethodAndMethodOptions();
				updateOrderTax(arguments.orderFulfillment.getOrder());
			}
			
			// Validate & Save Address
			address = getAddressService().saveAddress(address);
			
			// Check for a shipping method option selected
			if(structKeyExists(arguments.data, "orderShippingMethodOptionID")) {
				var methodOption = this.getOrderShippingMethodOption(arguments.data.orderShippingMethodOptionID);
				
				// Verify that the method option is one for this fulfillment
				if(arguments.orderFulfillment.hasOrderShippingMethodOption(methodOption)) {
					// Update the orderFulfillment to have this option selected
					arguments.orderFulfillment.setShippingMethod(methodOption.getShippingMethod());
					arguments.orderFulfillment.setFulfillmentCharge(methodOption.getTotalCharge());
				}
				
			}
			
			// Validate the order Fulfillment
			this.validateOrderFulfillmentShipping(arguments.orderFulfillment);
		}
		
		// Save the order Fulfillment
		return getDAO().save(arguments.orderFulfillment);
	}
	
	/**
	/*@param data  struct of orderItemID keys with values that represent quantities to be processed (delivered)
	/*@returns orderDelivery entity
	*/
	public any function processOrderFulfillment(required any orderFulfillment, struct data={}) {
		// Get the Order from the fulfillment
		var order = arguments.orderFulfillment.getOrder();
		
		// Figure out the Fulfillment Method
		var fulfillmentMethodID = arguments.orderFulfillment.getFulfillmentMethodID();
		
		// Create A New Order Delivery Type Based on fulfillment method
		var orderDelivery = this.new("SlatwallOrderDelivery#fulfillmentMethodID#");
		
		// Set the Order As the Order for this Delivery
		orderDelivery.setOrder(order);
		
		orderDelivery.setDeliveryOpenDateTime(now());
		// TODO: change close date to indicate when item was received, downloaded, picked up, etc.
		orderDelivery.setDeliveryCloseDateTime(now());
		
		
		// Per Fulfillment method set whatever other details need to be set
		switch(fulfillmentMethodID) {
			case("shipping"): {
				// copy the shipping address from the order fulfillment and set it in the delivery
				orderDelivery.setShippingAddress(getAddressService().copyAddress(arguments.orderFulfillment.getShippingAddress()));
				orderDelivery.setShippingMethod(arguments.orderFulfillment.getShippingMethod());
			}
			default:{}
		}
		
		var totalQuantity = 0;
		// Loop over the items in the fulfillment
		for( var i=1; i<=arrayLen(arguments.orderFulfillment.getOrderFulfillmentItems()); i++) {
			
			var thisOrderItem = arguments.orderFulfillment.getOrderFulfillmentItems()[i];
			// Check to see if this fulfillment item has any quantity passed to it
			if(structKeyExists(arguments.data, thisOrderItem.getOrderItemID())) {
				var thisQuantity = arguments.data[thisOrderItem.getOrderItemID()];
				
				// Make sure that the quantity is greater than 1, and that this fulfillment item needs at least that many to be delivered
				if(thisQuantity > 0 && thisQuantity <= thisOrderItem.getQuantityUndelivered()) {
					// keep track of the total quantity fulfilled
					totalQuantity += thisQuantity;
					// Create and Populate the delivery item
					var orderDeliveryItem = this.newOrderDeliveryItem();
					orderDeliveryItem.setQuantityDelivered(thisQuantity);
					orderDeliveryItem.setOrderItem(thisOrderItem);
					orderDeliveryItem.setOrderDelivery(orderDelivery);
					// change status of the order item
					if(thisQuantity == thisOrderItem.getQuantityUndelivered()) {
						//order item was fulfilled
						local.statusType = this.getTypeBySystemCode("oistFulfilled");
						thisOrderItem.setOrderItemStatusType(local.statusType);		
					}
				}
			}
		}
		
		// If items have not been added to the delivery, set an error so that it doesn't get persisted
		if(arrayLen(orderDelivery.getOrderDeliveryItems()) == 0) {
			getValidationService().setError(entity=orderDelivery, entityName="OrderDelivery", errorName="orderDeliveryItems",rule="hasOrderDeliveryItems");
		}
		
		// update the status of the order
		if(totalQuantity < order.getQuantityUndelivered()) {
			order.setOrderStatusType(this.getTypeBySystemCode("ostProcessing"));
		} else {
			if(order.isPaid()) {
				order.setOrderStatusType(this.getTypeBySystemCode("ostClosed"));
			} else {
				order.setOrderStatusType(this.getTypeBySystemCode("ostProcessing"));
			}
		}
		
		return this.save(orderDelivery);
	}
	
	public any function saveOrderPayment(required any orderPayment, struct data={}) {
		
		// Populate Order Payment	
		arguments.orderPayment.populate(arguments.data);
		
		// Manually Set the scurity code because it isn't a persistent property
		arguments.orderPayment.setSecurityCode(arguments.data.securityCode);
		
		// Get Address
		if( isNull(arguments.orderPayment.getBillingAddress()) ) {
			var address = getAddressService().newAddress();
		} else {
			var address = arguments.orderPayment.getBillingAddress();
		}
		
		// Set the address in the order Fulfillment
		arguments.orderPayment.setBillingAddress(address);
		
		// Populate Address
		address.populate(data);
		
		// Validate & Save Address
		address = getAddressService().saveAddress(address);
		
		// Validate the order Fulfillment
		this.validateOrderPaymentCreditCard(arguments.orderPayment);
		
		// Save the order Fulfillment
		return getDAO().save(arguments.orderPayment);
	}
	
	/*********  Order Actions ***************/
	
	public any function applyOrderAction(required string orderID, required string orderActionTypeID) {
		var order = this.getOrder(arguments.orderID);
		var orderActionType = this.getType(arguments.orderActionTypeID);
		switch(orderActionType.getSystemCode()) {
			case "oatCancel": {
				return cancelOrder(order);
			}
			case "oatRefund": {
				return refundOrder(order);
			}
		}		
	}
	
	public any function cancelOrder(required any order) {
		// see if this action is allowed for this status
		var response = checkStatusAction(arguments.order,"cancel");
		if(!response.hasErrors()) {
			var statusType = this.getTypeBySystemCode("ostCanceled");
			arguments.order.setOrderStatusType(statusType);	
		} 
		return response;
	}
	
	public any function refundOrder(required any order) {
		// see if this action is allowed for this status
		var response = checkStatusAction(arguments.order,"refund");
		if(!response.hasErrors()) {
			//TODO: logic for refunding order
		}
		return response;
	}
	
	public any function checkStatusAction(required any order, required string action) {
		var response = new com.utility.ResponseBean();
		var actionOptions = arguments.order.getActionOptions();
		var isValid = false;
		for( var i=1; i<=arrayLen(actionOptions);i++ ) {
			if( actionOptions[i].getOrderActionType().getSystemCode() == "oat" & arguments.action ) {
				isValid = true;
				break;
			}
		}
		if(!isValid) {
			var message = rbKey("entity.order.#arguments.action#_validatestatus");
			var message = replaceNocase(rc.message,"{statusValue}",arguments.order.getStatus());
			response.addError(arguments.action,message);
		}
		return response;
	}
	
	public void function updateOrderItems(required any order, required struct data) {
		var fu = new Slatwall.com.utility.FormUtilities();
		var dataCollections = fu.buildFormCollections(arguments.data);
		var orderItems = arguments.order.getOrderItems();
		for(var i=1; i<=arrayLen(arguments.order.getOrderItems()); i++) {
			if(structKeyExists(dataCollections.orderItem, arguments.order.getOrderItems()[i].getOrderItemID())) {
				if(structKeyExists(dataCollections.orderItem[ "#arguments.order.getOrderItems()[i].getOrderItemID()#" ], "quantity")) {
					arguments.order.getOrderItems()[i].getOrderFulfillment().orderFulfillmentItemsChanged();
					
					if(dataCollections.orderItem[ "#arguments.order.getOrderItems()[i].getOrderItemID()#" ].quantity <= 0) {
						arguments.order.getOrderItems()[i].removeOrder(arguments.order);
					} else {
						arguments.order.getOrderItems()[i].setQuantity(dataCollections.orderItem[ "#arguments.order.getOrderItems()[i].getOrderItemID()#" ].quantity);		
					}
					
				}
			}
		}
	}
	
	public void function removeAccountSpecificOrderDetails(required any order) {
		
		// Loop over fulfillments and remove any account specific details
		for(var i=1; i<=arrayLen(arguments.order.getOrderFulfillments()); i++) {
			if(arguments.order.getOrderFulfillments()[i].getFulfillmentMethodID() == "shipping") {
				arguments.order.getOrderFulfillments()[i].setShippingAddress(javaCast("null",""));
			}
		}
		
		// TODO: Loop over payments and remove any account specific details 
	}
	
	public void function updateOrderTax(required any order) {
		for(var i=1; i <= arrayLen(arguments.order.getOrderItems()); i++) {
			var itemTax = getTaxService().calculateOrderItemTax(arguments.order.getOrderItems()[i]);
			arguments.order.getOrderItems()[i].setTaxAmount(itemTax);
		}
	}
	
}
