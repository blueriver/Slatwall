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
	
	property name="accountService";
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
	
	public any function searchOrders(struct data={}) {
		//set keyword and orderby
		var params = {
			keyword = arguments.data.keyword,
			orderBy = arguments.data.orderBy
		};

		// if someone tries to filter for carts using URL, override the filter
		if(listFindNoCase(arguments.data.statusCode,"ostNotPlaced")) {
			params.statusCode = "ostNew,ostProcessing";
		} else {
			params['F:orderstatustype_systemcode'] = arguments.data.statusCode;	
		}
		// date range (start or end) have been submitted 
		if(len(trim(arguments.data.orderDateStart)) > 0 || len(trim(arguments.data.orderDateEnd)) > 0) {
			var dateStart = arguments.data.orderDateStart;
			var dateEnd = arguments.data.orderDateEnd;
			// if either the start or end date is blank, default them to a long time ago or now(), respectively
 			if(len(trim(arguments.data.orderDateStart)) == 0) {
 				dateStart = createDateTime(30,1,1,0,0,0);
 			} else if(len(trim(arguments.data.orderDateEnd)) == 0) {
 				dateEnd = now();
 			}
 			// make sure we have valid datetimes
 			if(isDate(dateStart) && isDate(dateEnd)) {
 				// since were comparing to datetime objects, I'll add 85,399 seconds to the end date to make sure we get all orders on the last day of the range (only if it was entered)
				if(len(trim(arguments.data.orderDateEnd)) > 0) {
					dateEnd = dateAdd('s',85399,dateEnd);	
				}
				params['R:orderOpenDateTime'] = "#dateStart#,#dateEnd#";
 			} else {
 				arguments.data.message = #arguments.data.$.slatwall.rbKey("admin.order.search.invaliddates")#;
 				arguments.data.messagetype = "warning";
 			}
		}
		return getOrderSmartList(params);
	}
	
	public any function exportOrders(required struct data) {
		var searchQuery = getDAO().getExportQuery(argumentCollection=arguments.data);
		return getService("Utilities").export(searchQuery);
	}
	
	public void function addOrderItem(required any order, required any sku, numeric quantity=1, any orderFulfillment, struct customizatonData) {
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
		
		// If there are no product customizations then we can check for the order item already existing.
		if(!structKeyExists(arguments, "customizatonData") || !structKeyExists(arguments.customizatonData, "attribute")) {
			// Check the existing order items and increment quantity if possible.
			for(var i = 1; i <= arrayLen(orderItems); i++) {
				if(orderItems[i].getSku().getSkuID() == arguments.sku.getSkuID() && orderItems[i].getOrderFulfillment().getOrderFulfillmentID() == arguments.orderFulfillment.getOrderFulfillmentID()) {
					itemExists = true;
					orderItems[i].setQuantity(orderItems[i].getQuantity() + arguments.quantity);
					orderItems[i].getOrderFulfillment().orderFulfillmentItemsChanged();
				}
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
			
			// Check for product customization
			if(structKeyExists(arguments, "customizatonData") && structKeyExists(arguments.customizatonData, "attribute")) {
				var pcas = arguments.sku.getProduct().getAttributeSets(['astProductCustomization']);
				for(var i=1; i<=arrayLen(pcas); i++) {
					var attributes = pcas[i].getAttributes();
					for(var a=1; a<=arrayLen(attributes); a++) {
						if( structKeyExists(arguments.customizatonData.attribute,attributes[a].getAttributeID()) ) {
							var av = this.newOrderItemAttributeValue();
							av.setAttribute(attributes[a]);
							av.setAttributeValue(arguments.customizatonData.attribute[attributes[a].getAttributeID()]);
							av.setOrderItem(newItem);
						}
					}
				}
			}
		}
				
		save(arguments.order);
	}
	
	public boolean function updateAndVerifyOrderAccount(required any order, required struct data) {
		var accountOK = true;
		
		if( structKeyExists(data,"structuredData") && structKeyExists(data.structuredData, "account")) {
			var accountData = data.structuredData.account;
			var account = getAccountService().getAccount(accountData.accountID, true);
			account = getAccountService().saveAccount(account, accountData, data.siteID);
			arguments.order.setAccount(account);
		}
		
		if( isNull(arguments.order.getAccount()) || arguments.order.getAccount().hasErrors()) {
			accountOK = false;
		}
		
		return accountOK;
	}
	
	public boolean function updateAndVerifyOrderFulfillments(required any order, required struct data) {
		var fulfillmentsOK = true;
		
		if( structKeyExists(data,"structuredData") && structKeyExists(data.structuredData, "orderFulfillments")) {
			var fulfillmentsDataArray = data.structuredData.orderFulfillments;
			for(var i=1; i<= arrayLen(fulfillmentsDataArray); i++) {
				var fulfillment = this.getOrderFulfillment(fulfillmentsDataArray[i].orderFulfillmentID, true);
				if(arguments.order.hasOrderFulfillment(fulfillment)) {
					fulfillment = this.saveOrderFulfillment(fulfillment, fulfillmentsDataArray[i]);
					if(fulfillment.hasErrors()) {
						fulfillmentsOK = false;
					}
				}		
			}
		}
		
		// Check each of the fulfillment methods to see if they are complete
		for(var i=1; i<=arrayLen(arguments.order.getOrderFulfillments());i++) {
			if(!arguments.order.getOrderFulfillments()[i].isProcessable()) {
				fulfillmentsOK = false;
			}
		}
		
		return fulfillmentsOK;
	}
	
	public boolean function updateAndVerifyOrderPayments(required any order, required struct data) {
		var paymentsOK = true;
		
		if( structKeyExists(data,"structuredData") && structKeyExists(data.structuredData, "orderPayments")) {
			var paymentsDataArray = data.structuredData.orderPayments;
			for(var i=1; i<= arrayLen(paymentsDataArray); i++) {
				var payment = this.getOrderPaymentCreditCard(paymentsDataArray[i].orderPaymentID, true);
				
				if((payment.isNew() && order.getPaymentAmountTotal() < order.getTotal()) || !payment.isNew()) {
					if(payment.isNew() && !structKeyExists(paymentsDataArray[i], "amount")) {
						paymentsDataArray[i].amount = order.getTotal() - order.getPaymentAmountTotal();
					}
					
					// Make sure the payment is attached to the order
					payment.setOrder(arguments.order);
					
					// Attempt to Validate & Save Order Payment
					payment = this.saveOrderPaymentCreditCard(payment, paymentsDataArray[i]);
					
					// Check to see if this payment has any errors and if so then don't proceed
					if(payment.hasErrors() || payment.getBillingAddress().hasErrors() || payment.getCreditCardType() == "Invalid") {
						paymentsOK = false;
					}
				}
			}
		}
		
		// Verify that there are enough payments applied to the order to proceed
		if(order.getPaymentAmountTotal() < order.getTotal()) {
			paymentsOK = false;
		}
		
		return paymentsOK;
	}
	
	private boolean function processOrderPayments(required any order) {
		var allPaymentsProcessed = true;
		
		// Process All Payments and Save the ones that were successful
		for(var i=1; i <= arrayLen(arguments.order.getOrderPayments()); i++) {
			var transactionType = setting('paymentMethod_#arguments.order.getOrderPayments()[i].getPaymentMethodID()#_checkoutTransactionType');
			
			if(transactionType != 'none') {
				var paymentOK = getPaymentService().processPayment(order.getOrderPayments()[i], transactionType);
				if(!paymentOK) {
					allPaymentsProcessed = false;
				}
			}
		}
		
		return allPaymentsProcessed;
	}
	
	public any function processOrder(struct data={}) {
		var processOK = false;
		
		// Lock down this determination so that the values getting called and set don't overlap
		lock scope="Session" timeout="60" {
			
			var order = this.getOrder(arguments.data.orderID);
			
			reloadEntity(order);
			
			if(order.getOrderStatusType().getSystemCode() != "ostNotPlaced") {
				processOK = true;
			} else {
				// update and validate all aspects of the order
				var validAccount = updateAndVerifyOrderAccount(order=order, data=arguments.data);
				var validPayments = updateAndVerifyOrderPayments(order=order, data=arguments.data);
				var validFulfillments = updateAndVerifyOrderFulfillments(order=order, data=arguments.data);
				
				if(validAccount && validPayments && validFulfillments) {
					// Double check that the order requirements list is blank
					var orderRequirementsList = getOrderRequirementsList(order);
					
					if( !len(orderRequirementsList) ) {
						
						// Process all of the order payments
						var paymentsProcessed = processOrderPayments(order=order);
						
						// If processing was successfull then checkout
						if(paymentsProcessed) {
							
							// If this order is the same as the current cart, then set the current cart to a new order
							if(order.getOrderID() == getSessionService().getCurrent().getOrder().getOrderID()) {
								getSessionService().getCurrent().setOrder(JavaCast("null",""));
							}
							
							// Update the order status
							order.setOrderStatusType(this.getTypeBySystemCode("ostNew"));
							
							// Save the order to the database
							getDAO().save(order);
							
							// Do a flush so that the order is commited to the DB
							ormFlush();
							
							getService("logService").logMessage(message="New Order Processed - Order Number: #order.getOrderNumber()# - Order ID: #order.getOrderID()#", generalLog=true);
							
							// Send out the e-mail
							sendOrderConfirmationEmail(order);
							
							processOK = true;
						}
					}
				}
			}
			
		} // END OF LOCK
		
		return processOK;
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
			orderRequirementsList = listAppend(orderRequirementsList, "account");
		}
		
		// Check each of the fulfillment methods to see if they are ready to process
		for(var i=1; i<=arrayLen(arguments.order.getOrderFulfillments());i++) {
			if(!arguments.order.getOrderFulfillments()[i].isProcessable()) {
				orderRequirementsList = listAppend(orderRequirementsList, "fulfillment");
				orderRequirementsList = listAppend(orderRequirementsList, arguments.order.getOrderFulfillments()[i].getOrderFulfillmentID());
			}
		}
		
		// Make sure that the order total is the same as the total payments applied
		if( arguments.order.getTotal() != arguments.order.getPaymentAmountTotal() ) {
			orderRequirementsList = listAppend(orderRequirementsList, "payment");
		}
		
		// Trim the last 
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
			address.populate(data.shippingAddress);
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
					} else {
					// TODO: create setting to make this flexible according to business rules
						local.statusType = this.getTypeBySystemCode("oistBackordered");					
					}
					thisOrderItem.setOrderItemStatusType(local.statusType);	
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
	
	public any function saveOrderPaymentCreditCard(required any orderPayment, struct data={}) {
		
		// Populate Order Payment	
		arguments.orderPayment.populate(arguments.data);
		
		// Manually Set the scurity code & Credit Card Number because it isn't a persistent property
		arguments.orderPayment.setSecurityCode(arguments.data.securityCode);
		arguments.orderPayment.setCreditCardNumber(arguments.data.creditCardNumber);
		
		// Validate the order Payment
		arguments.orderPayment = this.validateOrderPaymentCreditCard(arguments.orderPayment);
		if(arguments.orderPayment.getCreditCardType == "Invalid") {
			arguments.orderPayment.addError(name="creditCardNumber", message="Invalid credit card number.");
		}
		
		if(!arguments.orderPayment.hasErrors()) {
			var address = arguments.orderPayment.getBillingAddress();
		
			// Get Address
			if( isNull(address) ) {
				// Set a new address in the order payment
				var address = getAddressService().newAddress();
			}
			
			// Populate Address
			address.populate(arguments.data.billingAddress);
			
			// Validate Address
			address = getAddressService().validateAddress(address);
			
			arguments.orderPayment.setBillingAddress(address);
			
			if(!address.hasErrors()) {
				getDAO().save(address);
				getDAO().save(arguments.orderPayment);	
			} else {
				getService("requestCacheService").setValue("ormHasErrors", true);
			}
		} else {
			getService("requestCacheService").setValue("ormHasErrors", true);
		}
			
		return arguments.orderPayment;
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
