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
	
	property name="addressService";
	property name="taxService";
	
	public any function getVendorOrderSmartList(struct data={}) {
		arguments.entityName = "SlatwallVendorOrder";
		
		// Set the defaul showing to 25
		if(!structKeyExists(arguments.data, "P:Show")) {
			arguments.data["P:Show"] = 25;
		}
		
		var smartList = getDAO().getSmartList(argumentCollection=arguments);	
		/*smartList.addKeywordProperty(propertyIdentifier="vendorOrderNumber", weight=9);
		smartList.addKeywordProperty(propertyIdentifier="account_lastname", weight=4);
		smartList.addKeywordProperty(propertyIdentifier="account_firstname", weight=3);	*/
		smartList.joinRelatedProperty("SlatwallVendorOrder","vendor");
		
		return smartList;
	}
	
	public any function saveVendorOrder(required any vendorOrder, struct data={}) {
		
		// Call the super.save() method to do the base populate & validate logic
		arguments.vendorOrder = super.save(entity=arguments.vendorOrder, data=arguments.data);
		
		// If the vendorOrder has not been placed yet, loop over the vendorOrderItems to remove any that have a qty of 0
		if(arguments.vendorOrder.getStatusCode() == "ostNotPlaced") {
			for(var i=arrayLen(arguments.vendorOrder.getVendorOrderItems()); i>=1; i--) {
				if(arguments.vendorOrder.getVendorOrderItems()[i].getQuantity() < 1) {
					arguments.vendorOrder.removeVendorOrderItem(arguments.vendorOrder.getVendorOrderItems()[i]);
				}
			}	
		}
		
		// Recalculate the vendorOrder amounts for tax and promotions
		recalculateVendorOrderAmounts(arguments.vendorOrder);
		
		return arguments.vendorOrder;
	}
	
	public any function searchVendorOrders(struct data={}) {
		//set keyword and vendorOrderby
		var params = {
			keyword = arguments.data.keyword,
			vendorOrderBy = arguments.data.vendorOrderBy
		};
		// pass rc params (for paging) to smartlist
		structAppend(params,arguments.data);
		// if someone tries to filter for carts using URL, override the filter
		if(listFindNoCase(arguments.data.statusCode,"ostNotPlaced")) {
			params.statusCode = "ostNew,ostProcessing";
		} else {
			params['F:vendorOrderstatustype_systemcode'] = arguments.data.statusCode;	
		}
		// date range (start or end) have been submitted 
		if(len(trim(arguments.data.vendorOrderDateStart)) > 0 || len(trim(arguments.data.vendorOrderDateEnd)) > 0) {
			var dateStart = arguments.data.vendorOrderDateStart;
			var dateEnd = arguments.data.vendorOrderDateEnd;
			// if either the start or end date is blank, default them to a long time ago or now(), respectively
 			if(len(trim(arguments.data.vendorOrderDateStart)) == 0) {
 				dateStart = createDateTime(30,1,1,0,0,0);
 			} else if(len(trim(arguments.data.vendorOrderDateEnd)) == 0) {
 				dateEnd = now();
 			}
 			// make sure we have valid datetimes
 			if(isDate(dateStart) && isDate(dateEnd)) {
 				// since were comparing to datetime objects, I'll add 85,399 seconds to the end date to make sure we get all vendorOrders on the last day of the range (only if it was entered)
				if(len(trim(arguments.data.vendorOrderDateEnd)) > 0) {
					dateEnd = dateAdd('s',85399,dateEnd);	
				}
				params['R:vendorOrderOpenDateTime'] = "#dateStart#,#dateEnd#";
 			} else {
 				arguments.data.message = #arguments.data.$.slatwall.rbKey("admin.vendorOrder.search.invaliddates")#;
 				arguments.data.messagetype = "warning";
 			}
		}
		return getVendorOrderSmartList(params);
	}
	
	public void function addVendorOrderItem(required any vendorOrder, required any sku, numeric quantity=1, any vendorOrderFulfillment, struct customizatonData) {
		
		// Check to see if the vendorOrder has already been closed or canceled
		if (arguments.vendorOrder.getVendorOrderStatusType().getSystemCode() == "ostClosed" || arguments.vendorOrder.getVendorOrderStatusType().getSystemCode() == "ostCanceled") {
			throw("You cannot add an item to an vendorOrder that has been closed or canceled");
		}
		
		// Check for an vendorOrderFulfillment in the arguments.  If none, use the vendorOrders first.  If none has been setup create a new one
		if(!structKeyExists(arguments, "vendorOrderFulfillment")) {
			var osArray = arguments.vendorOrder.getVendorOrderFulfillments();
			if(!arrayLen(osArray)) {
				// TODO: This next is a hack... later the type of Fulfillment created should be dynamic 
				arguments.vendorOrderFulfillment = this.newVendorOrderFulfillmentShipping();
				
				arguments.vendorOrderFulfillment.setVendorOrder(arguments.vendorOrder);
				
				// Push the fulfillment into the hibernate scope
				getDAO().save(arguments.vendorOrderFulfillment);
			} else {
				arguments.vendorOrderFulfillment = osArray[1];
			}
		}
		
		var vendorOrderItems = arguments.vendorOrder.getVendorOrderItems();
		var itemExists = false;
		
		// If there are no product customizations then we can check for the vendorOrder item already existing.
		if(!structKeyExists(arguments, "customizatonData") || !structKeyExists(arguments.customizatonData, "attribute")) {
			// Check the existing vendorOrder items and increment quantity if possible.
			for(var i = 1; i <= arrayLen(vendorOrderItems); i++) {
				if(vendorOrderItems[i].getSku().getSkuID() == arguments.sku.getSkuID() && vendorOrderItems[i].getVendorOrderFulfillment().getVendorOrderFulfillmentID() == arguments.vendorOrderFulfillment.getVendorOrderFulfillmentID()) {
					itemExists = true;
					vendorOrderItems[i].setQuantity(vendorOrderItems[i].getQuantity() + arguments.quantity);
					vendorOrderItems[i].getVendorOrderFulfillment().vendorOrderFulfillmentItemsChanged();
				}
			}
		}
		
		// If the sku doesn't exist in the vendorOrder, then create a new vendorOrder item and add it
		if(!itemExists) {
			var newItem = this.newVendorOrderItem();
			newItem.setSku(arguments.sku);
			newItem.setQuantity(arguments.quantity);
			newItem.setVendorOrder(arguments.vendorOrder);
			newItem.setVendorOrderFulfillment(arguments.vendorOrderFulfillment);
			newItem.setPrice(arguments.sku.getLivePrice());
			
			// Check for product customization
			if(structKeyExists(arguments, "customizatonData") && structKeyExists(arguments.customizatonData, "attribute")) {
				var pcas = arguments.sku.getProduct().getAttributeSets(['astProductCustomization']);
				for(var i=1; i<=arrayLen(pcas); i++) {
					var attributes = pcas[i].getAttributes();
					for(var a=1; a<=arrayLen(attributes); a++) {
						if( structKeyExists(arguments.customizatonData.attribute,attributes[a].getAttributeID()) ) {
							var av = this.newVendorOrderItemAttributeValue();
							av.setAttribute(attributes[a]);
							av.setAttributeValue(arguments.customizatonData.attribute[attributes[a].getAttributeID()]);
							av.setVendorOrderItem(newItem);
						}
					}
				}
			}
		}
		
		// Recalculate the vendorOrder amounts for tax and promotions
		recalculateVendorOrderAmounts(arguments.vendorOrder);
		
		save(arguments.vendorOrder);
	}
	
	public void function removeVendorOrderItem(required any vendorOrder, required string vendorOrderItemID) {
		
		// Loop over all of the items in this vendorOrder
		for(var i=1; i<=arrayLen(arguments.vendorOrder.getVendorOrderItems()); i++) {
			
			// Check to see if this item is the same ID as the one passed in to remove
			if(arguments.vendorOrder.getVendorOrderItems()[i].getVendorOrderItemID() == arguments.vendorOrderItemID) {
				
				// Actually Remove that Item
				arguments.vendorOrder.removeVendorOrderItem( arguments.vendorOrder.getVendorOrderItems()[i] );
			}
		}
	}
	
	
	public boolean function updateAndVerifyVendorOrderAccount(required any vendorOrder, required struct data) {
		var accountOK = true;
		
		if( structKeyExists(data, "account")) {
			var accountData = data.account;
			var account = getAccountService().getAccount(accountData.accountID, true);
			account = getAccountService().saveAccount(account, accountData, data.siteID);
			arguments.vendorOrder.setAccount(account);
		}
		
		if( isNull(arguments.vendorOrder.getAccount()) || arguments.vendorOrder.getAccount().hasErrors()) {
			accountOK = false;
		}
		
		return accountOK;
	}
	
	public boolean function updateAndVerifyVendorOrderFulfillments(required any vendorOrder, required struct data) {
		var fulfillmentsOK = true;
		
		if( structKeyExists(data, "vendorOrderFulfillments")) {
			
			var fulfillmentsDataArray = data.vendorOrderFulfillments;
			
			for(var i=1; i<= arrayLen(fulfillmentsDataArray); i++) {
				
				var fulfillment = this.getVendorOrderFulfillment(fulfillmentsDataArray[i].vendorOrderFulfillmentID, true);
				
				if(arguments.vendorOrder.hasVendorOrderFulfillment(fulfillment)) {
					fulfillment = this.saveVendorOrderFulfillment(fulfillment, fulfillmentsDataArray[i]);
					if(fulfillment.hasErrors()) {
						fulfillmentsOK = false;
					}
				}		
			}
		}
		
		// Check each of the fulfillment methods to see if they are complete
		for(var i=1; i<=arrayLen(arguments.vendorOrder.getVendorOrderFulfillments());i++) {
			if(!arguments.vendorOrder.getVendorOrderFulfillments()[i].isProcessable()) {
				fulfillmentsOK = false;
			}
		}
		
		return fulfillmentsOK;
	}
	
	public boolean function updateAndVerifyVendorOrderPayments(required any vendorOrder, required struct data) {
		var paymentsOK = true;
		
		if( structKeyExists(data, "vendorOrderPayments")) {
			var paymentsDataArray = data.vendorOrderPayments;
			for(var i=1; i<= arrayLen(paymentsDataArray); i++) {
				var payment = this.getVendorOrderPaymentCreditCard(paymentsDataArray[i].vendorOrderPaymentID, true);
				
				if((payment.isNew() && vendorOrder.getPaymentAmountTotal() < vendorOrder.getTotal()) || !payment.isNew()) {
					if((payment.isNew() || isNull(payment.getAmount()) || payment.getAmount() <= 0) && !structKeyExists(paymentsDataArray[i], "amount")) {
						paymentsDataArray[i].amount = vendorOrder.getTotal() - vendorOrder.getPaymentAmountTotal();
					} else if(!payment.isNew() && (isNull(payment.getAmountAuthorized()) || payment.getAmountAuthorized() == 0) && !structKeyExists(paymentsDataArray[i], "amount")) {
						paymentsDataArray[i].amount = vendorOrder.getTotal() - vendorOrder.getPaymentAmountAuthorizedTotal();
					}
					
					// Make sure the payment is attached to the vendorOrder
					payment.setVendorOrder(arguments.vendorOrder);
					
					// Attempt to Validate & Save VendorOrder Payment
					payment = this.saveVendorOrderPaymentCreditCard(payment, paymentsDataArray[i]);
					
					// Check to see if this payment has any errors and if so then don't proceed
					if(payment.hasErrors() || payment.getBillingAddress().hasErrors() || payment.getCreditCardType() == "Invalid") {
						paymentsOK = false;
					}
				}
			}
		}
		
		// Verify that there are enough payments applied to the vendorOrder to proceed
		if(vendorOrder.getPaymentAmountTotal() < vendorOrder.getTotal()) {
			paymentsOK = false;
		}
		
		return paymentsOK;
	}
	
	private boolean function processVendorOrderPayments(required any vendorOrder) {
		var allPaymentsProcessed = true;
		
		// Process All Payments and Save the ones that were successful
		for(var i=1; i <= arrayLen(arguments.vendorOrder.getVendorOrderPayments()); i++) {
			var transactionType = setting('paymentMethod_#arguments.vendorOrder.getVendorOrderPayments()[i].getPaymentMethodID()#_checkoutTransactionType');
			
			if(transactionType != 'none') {
				var paymentOK = getPaymentService().processPayment(vendorOrder.getVendorOrderPayments()[i], transactionType);
				if(!paymentOK) {
					vendorOrder.getVendorOrderPayments()[i].setAmount(0);
					allPaymentsProcessed = false;
				}
			}
		}
		
		return allPaymentsProcessed;
	}
	
	public boolean function chargeVendorOrderPayment(any vendorOrderPayment, required string transactionID) {
		var chargeOK = getPaymentService().processPayment(arguments.vendorOrderPayment, "chargePreAuthorization", arguments.vendorOrderPayment.getAmount(), arguments.transactionID );
		if(chargeOK) {
			// set status of the vendorOrder
			var vendorOrder = arguments.vendorOrderPayment.getVendorOrder();
			if(vendorOrder.getQuantityUndelivered() gt 0) {
				vendorOrder.setVendorOrderStatusType(this.getTypeBySystemCode("ostProcessing"));
			} else {
				vendorOrder.setVendorOrderStatusType(this.getTypeBySystemCode("ostClosed"));
			}							
		}
		return chargeOK;
	}
	
	public any function processVendorOrder(struct data={}) {
		var processOK = false;
		
		// Lock down this determination so that the values getting called and set don't overlap
		lock scope="Session" timeout="60" {
			
			var vendorOrder = this.getVendorOrder(arguments.data.vendorOrderID);
			
			getDAO().reloadEntity(vendorOrder);
			
			if(vendorOrder.getVendorOrderStatusType().getSystemCode() != "ostNotPlaced") {
				processOK = true;
			} else {
				// update and validate all aspects of the vendorOrder
				var validAccount = updateAndVerifyVendorOrderAccount(vendorOrder=vendorOrder, data=arguments.data);
				var validPayments = updateAndVerifyVendorOrderPayments(vendorOrder=vendorOrder, data=arguments.data);
				var validFulfillments = updateAndVerifyVendorOrderFulfillments(vendorOrder=vendorOrder, data=arguments.data);
				
				if(validAccount && validPayments && validFulfillments) {
					// Double check that the vendorOrder requirements list is blank
					var vendorOrderRequirementsList = getVendorOrderRequirementsList(vendorOrder);
					
					if( !len(vendorOrderRequirementsList) ) {
						// prepare vendorOrder for processing
						// copy shipping address if needed
						copyFulfillmentAddress(vendorOrder=vendorOrder);
						
						// Process all of the vendorOrder payments
						var paymentsProcessed = processVendorOrderPayments(vendorOrder=vendorOrder);
						
						// If processing was successfull then checkout
						if(paymentsProcessed) {
							
							// If this vendorOrder is the same as the current cart, then set the current cart to a new vendorOrder
							if(vendorOrder.getVendorOrderID() == getSessionService().getCurrent().getVendorOrder().getVendorOrderID()) {
								getSessionService().getCurrent().setVendorOrder(JavaCast("null",""));
							}
							
							// Update the vendorOrder status
							vendorOrder.setVendorOrderStatusType(this.getTypeBySystemCode("ostNew"));
							
							// Save the vendorOrder to the database
							getDAO().save(vendorOrder);
							
							// Do a flush so that the vendorOrder is commited to the DB
							getDAO().flushORMSession();
							
							getService("logService").logMessage(message="New VendorOrder Processed - VendorOrder Number: #vendorOrder.getVendorOrderNumber()# - VendorOrder ID: #vendorOrder.getVendorOrderID()#", generalLog=true);
							
							// Send out the e-mail
							getUtilityEmailService().sendVendorOrderConfirmationEmail(vendorOrder=vendorOrder);
							
							processOK = true;
						}
					}
				}
			}
			
		} // END OF LOCK
		
		return processOK;
	}

	public any function getVendorOrderRequirementsList(required any vendorOrder) {
		var vendorOrderRequirementsList = "";
		
		// Check if the vendorOrder still requires a valid account
		if( isNull(arguments.vendorOrder.getAccount()) || arguments.vendorOrder.getAccount().hasErrors()) {
			vendorOrderRequirementsList = listAppend(vendorOrderRequirementsList, "account");
		}
		
		// Check each of the fulfillment methods to see if they are ready to process
		for(var i=1; i<=arrayLen(arguments.vendorOrder.getVendorOrderFulfillments());i++) {
			if(!arguments.vendorOrder.getVendorOrderFulfillments()[i].isProcessable()) {
				vendorOrderRequirementsList = listAppend(vendorOrderRequirementsList, "fulfillment");
				vendorOrderRequirementsList = listAppend(vendorOrderRequirementsList, arguments.vendorOrder.getVendorOrderFulfillments()[i].getVendorOrderFulfillmentID());
			}
		}
		
		// Make sure that the vendorOrder total is the same as the total payments applied
		if( arguments.vendorOrder.getTotal() != arguments.vendorOrder.getPaymentAmountTotal() ) {
			vendorOrderRequirementsList = listAppend(vendorOrderRequirementsList, "payment");
		}
		
		return vendorOrderRequirementsList;
	}
	
	public any function saveVendorOrderFulfillment(required any vendorOrderFulfillment, struct data={}) {
		
		arguments.vendorOrderFulfillment.populate(arguments.data);
		
		// If fulfillment method is shipping do this
		if(arguments.vendorOrderFulfillment.getFulfillmentMethod().getFulfillmentMethodID() == "shipping") {
			// define some variables for backward compatibility
			param name="data.saveAccountAddress" default="0";
			param name="data.saveAccountAddressName" default="";
			param name="data.addressIndex" default="0";  
			
			// Get Address
			if(data.addressIndex != 0){
				var address = getAddressService().getAddress(data.accountAddresses[data.addressIndex].address.addressID,true);
				var newAddressDataStruct = data.accountAddresses[data.addressIndex].address;
			} else {	
				var address = getAddressService().getAddress(data.shippingAddress.addressID,true);
				var newAddressDataStruct = data.shippingAddress;
			}
			
			// Populate Address And check if it has changed
			var serializedAddressBefore = address.getSimpleValuesSerialized();
			address.populate(newAddressDataStruct);
			var serializedAddressAfter = address.getSimpleValuesSerialized();
			
			if(serializedAddressBefore != serializedAddressAfter) {
				arguments.vendorOrderFulfillment.removeShippingMethodAndMethodOptions();
				getTaxService().updateVendorOrderAmountsWithTaxes(arguments.vendorOrderFulfillment.getVendorOrder());
			}
			
			// if address needs to get saved in account
			if(data.saveAccountAddress == 1 || data.addressIndex != 0){
				// new account address
				if(data.addressIndex == 0){
					var accountAddress = getAddressService().newAccountAddress();
				} else {
					//Existing address
					var accountAddress = getAddressService().getAccountAddress(data.accountAddresses[data.addressIndex].accountAddressID,true);
				}
				accountAddress.setAddress(address);
				accountAddress.setAccount(arguments.vendorOrderFulfillment.getVendorOrder().getAccount());
				
				// Figure out the name for this new account address, or update it if needed
				if(data.addressIndex == 0) {
					if(structKeyExists(data, "saveAccountAddressName") && len(data.saveAccountAddressName)) {
						accountAddress.setAccountAddressName(data.saveAccountAddressName);
					} else {
						accountAddress.setAccountAddressName(address.getname());	
					}	
				} else if (structKeyExists(data, "accountAddresses") && structKeyExists(data.accountAddresses[data.addressIndex], "accountAddressName")) {
					accountAddress.setAccountAddressName(data.accountAddresses[data.addressIndex].accountAddressName);
				}
				
				arguments.vendorOrderFulfillment.removeShippingAddress();
				arguments.vendorOrderFulfillment.setAccountAddress(accountAddress);
			} else {
				// Set the address in the vendorOrder Fulfillment as shipping address
				arguments.vendorOrderFulfillment.setShippingAddress(address);
				arguments.vendorOrderFulfillment.removeAccountAddress();
			}
			
			// Validate & Save Address
			address.validate(context="full");
			
			address = getAddressService().saveAddress(address);
			
			// Check for a shipping method option selected
			if(structKeyExists(arguments.data, "vendorOrderShippingMethodOptionID")) {
				var methodOption = this.getVendorOrderShippingMethodOption(arguments.data.vendorOrderShippingMethodOptionID);
				
				// Verify that the method option is one for this fulfillment
				if(!isNull(methodOption) && arguments.vendorOrderFulfillment.hasVendorOrderShippingMethodOption(methodOption)) {
					// Update the vendorOrderFulfillment to have this option selected
					arguments.vendorOrderFulfillment.setShippingMethod(methodOption.getShippingMethod());
					arguments.vendorOrderFulfillment.setFulfillmentCharge(methodOption.getTotalCharge());
				}
				
			}
			
			// Validate the vendorOrder Fulfillment
			arguments.vendorOrderFulfillment.validate();
			if(!getRequestCacheService().getValue("ormHasErrors")){
				getDAO().flushORMSession();
			}
		}
		
		// Save the vendorOrder Fulfillment
		return getDAO().save(arguments.vendorOrderFulfillment);
	}
	
	public any function copyFulfillmentAddress(required any vendorOrder){
		for(var vendorOrderFulfillment in vendorOrder.getVendorOrderFulfillments()){
			if(vendorOrderFulfillment.getFulfillmentMethod().getFulfillmentMethodID() == "shipping") {
				if(!isNull(vendorOrderFulfillment.getAccountAddress())){
					vendorOrderFulfillment.setShippingAddress(vendorOrderFulfillment.getAccountAddress().getAddress());
					vendorOrderFulfillment.removeAccountAddress();
					getDAO().save(vendorOrderFulfillment);
				}
			}
		}
	}
	
	/**
	/*@param data  struct of vendorOrderItemID keys with values that represent quantities to be processed (delivered)
	/*@returns vendorOrderDelivery entity
	*/
	public any function processVendorOrderFulfillment(required any vendorOrderFulfillment, struct data={}) {
		// Get the VendorOrder from the fulfillment
		var vendorOrder = arguments.vendorOrderFulfillment.getVendorOrder();
		
		// Figure out the Fulfillment Method
		var fulfillmentMethodID = arguments.vendorOrderFulfillment.getFulfillmentMethodID();
		
		// Create A New VendorOrder Delivery Type Based on fulfillment method
		var vendorOrderDelivery = this.new("SlatwallVendorOrderDelivery#fulfillmentMethodID#");
		
		// Set the VendorOrder As the VendorOrder for this Delivery
		vendorOrderDelivery.setVendorOrder(vendorOrder);
		
		vendorOrderDelivery.setDeliveryOpenDateTime(now());
		
		// TODO: change close date to indicate when item was received, downloaded, picked up, etc.
		vendorOrderDelivery.setDeliveryCloseDateTime(now());
				
		// Per Fulfillment method set whatever other details need to be set
		switch(fulfillmentMethodID) {
			case("shipping"): {
				// copy the shipping address from the vendorOrder fulfillment and set it in the delivery
				vendorOrderDelivery.setShippingAddress(getAddressService().copyAddress(arguments.vendorOrderFulfillment.getShippingAddress()));
				vendorOrderDelivery.setShippingMethod(arguments.vendorOrderFulfillment.getShippingMethod());
			}
			default:{}
		}
		
		// set the tracking number
		if(structkeyExists(arguments.data,"trackingNumber") && len(arguments.data.trackingNumber) > 0) {
			vendorOrderDelivery.setTrackingNumber(arguments.data.trackingNumber);			
		}
		
		var totalQuantity = 0;
		
		// Loop over the items in the fulfillment
		for( var i=1; i<=arrayLen(arguments.vendorOrderFulfillment.getVendorOrderFulfillmentItems()); i++) {
			
			var thisVendorOrderItem = arguments.vendorOrderFulfillment.getVendorOrderFulfillmentItems()[i];
			// Check to see if this fulfillment item has any quantity passed to it
			if(structKeyExists(arguments.data, thisVendorOrderItem.getVendorOrderItemID())) {
				var thisQuantity = arguments.data[thisVendorOrderItem.getVendorOrderItemID()];
				
				// Make sure that the quantity is greater than 1, and that this fulfillment item needs at least that many to be delivered
				if(thisQuantity > 0 && thisQuantity <= thisVendorOrderItem.getQuantityUndelivered()) {
					// keep track of the total quantity fulfilled
					totalQuantity += thisQuantity;
					// Create and Populate the delivery item
					var vendorOrderDeliveryItem = createVendorOrderDeliveryItem(thisVendorOrderItem, thisQuantity, vendorOrderDelivery);
					// change status of the vendorOrder item
					if(thisQuantity == thisVendorOrderItem.getQuantityUndelivered()) {
					//vendorOrder item was fulfilled
						local.statusType = this.getTypeBySystemCode("oistFulfilled");	
					} else {
					// TODO: create setting to make this flexible according to business rules
						local.statusType = this.getTypeBySystemCode("oistBackvendorOrdered");					
					}
					thisVendorOrderItem.setVendorOrderItemStatusType(local.statusType);	
				}
			}
		}
		
		vendorOrderDelivery.validate();
		
		if(!vendorOrderDelivery.hasErrors()) {
			// update the status of the vendorOrder
			if(totalQuantity < vendorOrder.getQuantityUndelivered()) {
				vendorOrder.setVendorOrderStatusType(this.getTypeBySystemCode("ostProcessing"));
			} else {
				if(vendorOrder.isPaid()) {
					vendorOrder.setVendorOrderStatusType(this.getTypeBySystemCode("ostClosed"));
				} else {
					vendorOrder.setVendorOrderStatusType(this.getTypeBySystemCode("ostProcessing"));
				}
			}
			arguments.entity = getDAO().save(target=vendorOrderDelivery);
		} else {
			getService("requestCacheService").setValue("ormHasErrors", true);
		}
				
		return vendorOrderDelivery;
	}
	
	private any function createVendorOrderDeliveryItem(required any vendorOrderItem, required numeric quantity, required any vendorOrderDelivery) {
		var vendorOrderDeliveryItem = this.newVendorOrderDeliveryItem();
		vendorOrderDeliveryItem.setVendorOrderItem(arguments.vendorOrderItem);
		vendorOrderDeliveryItem.setQuantityDelivered(arguments.quantity);
		vendorOrderDeliveryItem.setVendorOrderDelivery(arguments.vendorOrderDelivery);
		return this.saveVendorOrderDeliveryItem(vendorOrderDeliveryItem);
	}
	
	public any function saveVendorOrderPaymentCreditCard(required any vendorOrderPayment, struct data={}) {
		
		// Populate VendorOrder Payment	
		arguments.vendorOrderPayment.populate(arguments.data);
		
		// Manually Set the scurity code & Credit Card Number because it isn't a persistent property
		arguments.vendorOrderPayment.setSecurityCode(arguments.data.securityCode);
		arguments.vendorOrderPayment.setCreditCardNumber(arguments.data.creditCardNumber);
		
		// Validate the vendorOrder Payment
		arguments.vendorOrderPayment.validate();
		
		if(arguments.vendorOrderPayment.getCreditCardType() == "Invalid") {
			arguments.vendorOrderPayment.addError(errorName="creditCardNumber", errorMessage="Invalid credit card number.");
		}
		
		var address = arguments.vendorOrderPayment.getBillingAddress();
		
		// Get Address
		if( isNull(address) ) {
			// Set a new address in the vendorOrder payment
			var address = getAddressService().newAddress();
		}
		
		// Populate Address
		address.populate(arguments.data.billingAddress);
		
		// Validate Address
		address.validate();
		
		arguments.vendorOrderPayment.setBillingAddress(address);
		
		if(!arguments.vendorOrderPayment.hasErrors() && !address.hasErrors()) {
			getDAO().save(address);
			getDAO().save(arguments.vendorOrderPayment);	
		} else {
			getRequestCacheService().setValue("ormHasErrors", true);
		}
		
		return arguments.vendorOrderPayment;
	}
	
	/********* START: VendorOrder Actions ***************/
	
	public any function applyVendorOrderAction(required string vendorOrderID, required string vendorOrderActionTypeID) {
		var vendorOrder = this.getVendorOrder(arguments.vendorOrderID);
		var vendorOrderActionType = this.getType(arguments.vendorOrderActionTypeID);
		switch(vendorOrderActionType.getSystemCode()) {
			case "oatCancel": {
				return cancelVendorOrder(vendorOrder);
			}
			case "oatRefund": {
				return refundVendorOrder(vendorOrder);
			}
		}		
	}
	
	public any function cancelVendorOrder(required any vendorOrder) {
		// see if this action is allowed for this status
		var response = checkStatusAction(arguments.vendorOrder,"cancel");
		if(!response.hasErrors()) {
			var statusType = this.getTypeBySystemCode("ostCanceled");
			arguments.vendorOrder.setVendorOrderStatusType(statusType);	
		} 
		return response;
	}
	
	public any function refundVendorOrder(required any vendorOrder) {
		// see if this action is allowed for this status
		var response = checkStatusAction(arguments.vendorOrder,"refund");
		if(!response.hasErrors()) {
			//TODO: logic for refunding vendorOrder
		}
		return response;
	}
	
	public any function checkStatusAction(required any vendorOrder, required string action) {
		var response = new com.utility.ResponseBean();
		var actionOptions = arguments.vendorOrder.getActionOptions();
		var isValid = false;
		for( var i=1; i<=arrayLen(actionOptions);i++ ) {
			if( actionOptions[i].getVendorOrderActionType().getSystemCode() == "oat" & arguments.action ) {
				isValid = true;
				break;
			}
		}
		if(!isValid) {
			var message = rbKey("entity.vendorOrder.#arguments.action#_validatestatus");
			var message = replaceNocase(rc.message,"{statusValue}",arguments.vendorOrder.getStatus());
			response.addError(arguments.action,message);
		}
		return response;
	}
	
	public any function exportVendorOrders(required struct data) {
		var searchQuery = getDAO().getExportQuery(argumentCollection=arguments.data);
		return getService("utilityService").export(searchQuery);
	}
	
	/********* END: VendorOrder Actions ***************/
	
	
	public void function clearCart() {
		var currentSession = getSessionService().getCurrent();
		var cart = currentSession.getVendorOrder();
		
		if(!cart.isNew()) {
			currentSession.removeVendorOrder();
			
			getDAO().delete(cart.getVendorOrderItems());	
			getDAO().delete(cart.getVendorOrderFulfillments());	
			getDAO().delete(cart.getVendorOrderPayments());
			getDAO().delete(cart);
		}
	}
	
	public void function removeAccountSpecificVendorOrderDetails(required any vendorOrder) {
		
		// Loop over fulfillments and remove any account specific details
		for(var i=1; i<=arrayLen(arguments.vendorOrder.getVendorOrderFulfillments()); i++) {
			if(arguments.vendorOrder.getVendorOrderFulfillments()[i].getFulfillmentMethodID() == "shipping") {
				arguments.vendorOrder.getVendorOrderFulfillments()[i].setShippingAddress(javaCast("null",""));
			}
		}
		
		// TODO: Loop over payments and remove any account specific details 
		
		// Recalculate the vendorOrder amounts for tax and promotions
		recalculateVendorOrderAmounts(arguments.vendorOrder);
	}
	
	public void function recalculateVendorOrderAmounts(required any vendorOrder) {
		//TODO: add a verification to make sure that this doesn't get called from a closed vendorOrder
		
		// Re-Calculate the 'amounts' based on permotions ext.
		getPromotionService().updateVendorOrderAmountsWithPromotions(arguments.vendorOrder);
		// Re-Calculate tax now that the new promotions have been applied
		getTaxService().updateVendorOrderAmountsWithTaxes(arguments.vendorOrder);
	}
	
	public void function addPromotionCode(required any vendorOrder, required any promotionCode) {
		if(!arguments.vendorOrder.hasPromotionCode(arguments.promotionCode)) {
			arguments.vendorOrder.addPromotionCode(arguments.promotionCode);
		}
		getPromotionService().updateVendorOrderAmountsWithPromotions(vendorOrder=arguments.vendorOrder);
	}
	
	public void function removePromotionCode(required any vendorOrder, required any promotionCode) {
		arguments.vendorOrder.removePromotionCode(arguments.promotionCode);
		getPromotionService().updateVendorOrderAmountsWithPromotions(vendorOrder=arguments.vendorOrder);
	}
	
	/**************** LEGACY DEPRECATED METHOD ****************************/
	/*
	 * This method is only called from the cart controller if the data passed in for 'vendorOrderItems'
	 * was passed in as vendorOrderItems.{vendorOrderItemID}.property which is the old format that we no longer use.
	 * Now to accomplish the same task we are calling saveVendorOrder() from the controller and letting populate
	 * and validation take care of it.
	*/
	public void function updateVendorOrderItems(required any vendorOrder, required struct data) {
		
		var dataCollections = arguments.data;
		var vendorOrderItems = arguments.vendorOrder.getVendorOrderItems();
		for(var i=arrayLen(arguments.vendorOrder.getVendorOrderItems()); i>=1; i--) {
			if(structKeyExists(dataCollections.vendorOrderItem, arguments.vendorOrder.getVendorOrderItems()[i].getVendorOrderItemID())) {
				if(structKeyExists(dataCollections.vendorOrderItem[ "#arguments.vendorOrder.getVendorOrderItems()[i].getVendorOrderItemID()#" ], "quantity")) {
					arguments.vendorOrder.getVendorOrderItems()[i].getVendorOrderFulfillment().vendorOrderFulfillmentItemsChanged();
					
					if(dataCollections.vendorOrderItem[ "#arguments.vendorOrder.getVendorOrderItems()[i].getVendorOrderItemID()#" ].quantity <= 0) {
						arguments.vendorOrder.getVendorOrderItems()[i].removeVendorOrder(arguments.vendorOrder);
					} else {
						arguments.vendorOrder.getVendorOrderItems()[i].setQuantity(dataCollections.vendorOrderItem[ "#arguments.vendorOrder.getVendorOrderItems()[i].getVendorOrderItemID()#" ].quantity);		
					}
					
				}
			}
		}
		
		// Recalculate the vendorOrder amounts for tax and promotions
		recalculateVendorOrderAmounts(arguments.vendorOrder);
	}
	
}
