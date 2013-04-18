/*
	
    Slatwall - An Open Source eCommerce Platform
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
component extends="HibachiService" persistent="false" accessors="true" output="false" {

	property name="orderDAO";
	
	property name="accountService";
	property name="addressService";
	property name="emailService";
	property name="locationService";
	property name="fulfillmentService";
	property name="paymentService";
	property name="priceGroupService";
	property name="promotionService";
	property name="settingService";
	property name="shippingService";
	property name="skuService";
	property name="stockService";
	property name="subscriptionService";
	property name="taxService";
	
	// ===================== START: Logical Methods ===========================
	
	public void function addOrderItem(required any order, required any sku, any stock, numeric quantity=1, any orderFulfillment, struct customizatonData, struct data = {})	{
	
		// Check to see if the order has already been closed or canceled
		if(arguments.order.getOrderStatusType().getSystemCode() == "ostClosed" || arguments.order.getOrderStatusType().getSystemCode() == "ostCanceled") {
			throw("You cannot add an item to an order that has been closed or canceled");
		}
		
		// If the currency code was not passed in, then set it to the sku default
		if(!structKeyExists(arguments.data, "currencyCode")) {
			if( !isNull(arguments.order.getCurrencyCode()) && listFindNoCase(arguments.sku.setting('skuEligibleCurrencies'), arguments.order.getCurrencyCode()) && arrayLen(arguments.order.getOrderItems()) ) {
				arguments.data.currencyCode = arguments.order.getCurrencyCode();
			} else {
				arguments.data.currencyCode = arguments.sku.setting('skuCurrency');
			}
		}
		
		// Make sure the order has a currency code
		if( isNull(arguments.order.getCurrencyCode()) || !arrayLen(arguments.order.getOrderItems()) ) {
			arguments.order.setCurrencyCode( arguments.data.currencyCode );
		}
		
		// Verify the order has the same currency as the one being added
		if(arguments.order.getCurrencyCode() eq arguments.data.currencyCode) {
			
			// Make sure the item is in stock 
			if(arguments.sku.getQuantity('qats') gt 0) {
				
				// Update the quantity to add to whatever the qats is if trying to add more.
				if(arguments.sku.getQuantity('qats') lt arguments.quantity) {
					arguments.quantity = arguments.sku.getQuantity('qats'); 
				}
					
				// save order so it's added to the hibernate scope
				save( arguments.order );
				
				// if a filfillmentMethodID is passed in the data, set orderfulfillment to that
				if(structKeyExists(arguments.data, "fulfillmentMethodID") && !structKeyExists(arguments, "orderFulfillment")) {
					// make sure this is eligible fulfillment method
					if(listFindNoCase(arguments.sku.setting('skuEligibleFulfillmentMethods'), arguments.data.fulfillmentMethodID)) {
						var fulfillmentMethod = this.getFulfillmentService().getFulfillmentMethod(arguments.data.fulfillmentMethodID);
						if(!isNull(fulfillmentMethod)) {
							arguments.orderFulfillment = this.getOrderFulfillment({order=arguments.order,fulfillmentMethod=fulfillmentMethod},true);
							if(arguments.orderFulfillment.isNew()) {
								if(structKeyExists(arguments.data, "orderFulfillment"))	{
									arguments.orderFulfillment.populate( arguments.data.orderFulfillment );	
								}
								arguments.orderFulfillment.setFulfillmentMethod( fulfillmentMethod );
								arguments.orderFulfillment.setOrder( arguments.order );
								arguments.orderFulfillment.setCurrencyCode( arguments.order.getCurrencyCode() ) ;
								// Push the fulfillment into the hibernate scope
								getHibachiDAO().save(arguments.orderFulfillment);
							}
						}
					}
					
				}
				
				// Check for an orderFulfillment in the arguments.  If none, use the orders first.  If none has been setup create a new one
				if(!structKeyExists(arguments, "orderFulfillment"))	{
					
					var thisFulfillmentMethodType = getFulfillmentService().getFulfillmentMethod(listGetAt(arguments.sku.setting('skuEligibleFulfillmentMethods'),1)).getFulfillmentMethodType();
					
					// check if there is a fulfillment method of this type in the order
					for(var fulfillment in arguments.order.getOrderFulfillments()) {
						if(listFindNoCase(arguments.sku.setting('skuEligibleFulfillmentMethods'), fulfillment.getFulfillmentMethod().getFulfillmentMethodID())) {
							arguments.orderFulfillment = fulfillment;
							break;
						}
					}
					
					// if no fulfillment of this type found then create a new one 
					if(!structKeyExists(arguments, "orderFulfillment")) {
						
						var fulfillmentMethodOptions = arguments.sku.getEligibleFulfillmentMethods();
						
						// If there are at least 1 options, then we create the new method, otherwise stop and just return the order
						if(arrayLen(fulfillmentMethodOptions)) {
							arguments.orderFulfillment = this.newSlatwallOrderFulfillment();
							arguments.orderFulfillment.setFulfillmentMethod( fulfillmentMethodOptions[1] );
							arguments.orderFulfillment.setOrder( arguments.order );
							arguments.orderFulfillment.setCurrencyCode( arguments.order.getCurrencyCode() ) ;
						} else {
							return arguments.order;
						}
						
						// Push the fulfillment into the hibernate scope
						getHibachiDAO().save(arguments.orderFulfillment);
					}
				}
			
				var orderItems = arguments.order.getOrderItems();
				var itemExists = false;
				
				// If there are no product customizations then we can check for the order item already existing.
				if(!structKeyExists(arguments, "customizatonData") || !structKeyExists(arguments.customizatonData,"attribute"))	{
					// Check the existing order items and increment quantity if possible.
					for(var i = 1; i <= arrayLen(orderItems); i++) {
						
						// This is a simple check inside of the loop to find any sku that matches
						if(orderItems[i].getSku().getSkuID() == arguments.sku.getSkuID() && orderItems[i].getOrderFulfillment().getOrderFulfillmentID() == arguments.orderFulfillment.getOrderFulfillmentID()) {
							
							// This verifies that the stock being passed in matches the stock on the order item, or that both are null
							if( ( !isNull(arguments.stock) && !isNull(orderItems[i].getStock()) && arguments.stock.getStockID() == orderItems[i].getStock().getStockID() ) || ( isNull(arguments.stock) && isNull(orderItems[i].getStock()) ) ) {
								
								itemExists = true;
								// do not increment quantity for content access product
								if(orderItems[i].getSku().getBaseProductType() != "contentAccess") {
									
									// Verify that this item now that it has a greater quantity isn't bigger than the qats
									if((orderItems[i].getQuantity() + arguments.quantity) gt orderItems[i].getSku().getQuantity('qats')) {
										orderItems[i].setQuantity(orderItems[i].getSku().getQuantity('qats'));
									} else {
										orderItems[i].setQuantity(orderItems[i].getQuantity() + arguments.quantity);	
									}
									
									if( structKeyExists(arguments.data, "price") && arguments.sku.getUserDefinedPriceFlag() ) {
										orderItems[i].setPrice( arguments.data.price );
										orderItems[i].setSkuPrice( arguments.data.price );	
									} else {
										orderItems[i].setPrice( arguments.sku.getPriceByCurrencyCode( arguments.data.currencyCode ) );
										orderItems[i].setSkuPrice( arguments.sku.getPriceByCurrencyCode( arguments.data.currencyCode ) );
									}
								}
								break;
								
							}
						}
					}
				}
			
				// If the sku doesn't exist in the order, then create a new order item and add it
				if(!itemExists)	{
					var newItem = this.newOrderItem();
					newItem.setSku(arguments.sku);
					newItem.setQuantity(arguments.quantity);
					newItem.setOrder(arguments.order);
					newItem.setOrderFulfillment(arguments.orderFulfillment);
					newItem.setCurrencyCode( arguments.order.getCurrencyCode() );
					
					// All new items have the price and skuPrice set to the current price of the sku being added.  Later the price may be changed by the recalculateOrderAmounts() method
					if( structKeyExists(arguments.data, "price") && arguments.sku.getUserDefinedPriceFlag() ) {
						newItem.setPrice( arguments.data.price );
						newItem.setSkuPrice( arguments.data.price );
					} else {
						newItem.setPrice( arguments.sku.getPriceByCurrencyCode( arguments.data.currencyCode ) );
						newItem.setSkuPrice( arguments.sku.getPriceByCurrencyCode( arguments.data.currencyCode ) );
					}
					
					// If a stock was passed in, then assign it to this new item
					if(!isNull(arguments.stock)) {
						newItem.setStock(arguments.stock);
					}
				
					// Check for product customization
					if(structKeyExists(arguments, "customizationData") && structKeyExists(arguments.customizationData, "attribute")) {
						var pcas = arguments.sku.getProduct().getAttributeSets(['astOrderItem']);
						for(var i = 1; i <= arrayLen(pcas); i++) {
							var attributes = pcas[i].getAttributes();
							
							for(var a = 1; a <= arrayLen(attributes); a++) {
								if(structKeyExists(arguments.customizationData.attribute, attributes[a].getAttributeID())) {
									var av = this.newAttributeValue();
									av.setAttributeValueType("orderItem");
									av.setAttribute(attributes[a]);
									av.setAttributeValue(arguments.customizationData.attribute[attributes[a].getAttributeID()]);
									av.setOrderItem(newItem);
									// Push the attribute value
									getHibachiDAO().save(av);
								}
							}
						}
					}
					
					// Push the order Item into the hibernate scope
					getHibachiDAO().save(newItem);
				}
				
				// Recalculate the order amounts for tax and promotions and priceGroups
				recalculateOrderAmounts( arguments.order );
		
				
			} else {
				order.addError("quantity", rbKey('validate.order.orderitemoutofstock'));
			}
		} else {
			order.addError("currency", rbKey('validate.order.orderitemwrongcurrency'));
		}
		
	}
	
	public void function removeOrderItem(required any order, required string orderItemID) {
	
		// Loop over all of the items in this order
		for(var i = 1; i <= arrayLen(arguments.order.getOrderItems()); i++)	{
		
			// Check to see if this item is the same ID as the one passed in to remove
			if(arguments.order.getOrderItems()[i].getOrderItemID() == arguments.orderItemID) {
			
				// Actually Remove that Item
				arguments.order.removeOrderItem(arguments.order.getOrderItems()[i]);
				break;
			}
		}
		
		// Recalculate the order amounts for tax and promotions
		recalculateOrderAmounts(arguments.order);
	}
	
	public void function setupOrderItemContentAccess(required any orderItem) {
		for(var accessContent in arguments.orderItem.getSku().getAccessContents()) {
			var accountContentAccess = getAccountService().newAccountContentAccess();
			accountContentAccess.setAccount(arguments.orderItem.getOrder().getAccount());
			accountContentAccess.setOrderItem(arguments.orderItem);
			accountContentAccess.addAccessContent(accessContent);
			getAccountService().saveAccountContentAccess(accountContentAccess);
		}
	}
	
	public string function getOrderRequirementsList(required any order) {
		var orderRequirementsList = "";
		
		// Check if the order still requires a valid account
		if(isNull(arguments.order.getAccount()) || arguments.order.getAccount().hasErrors()) {
			orderRequirementsList = listAppend(orderRequirementsList, "account");
		}
	
		// Check each of the fulfillment methods to see if they are ready to process
		for(var i = 1; i <= arrayLen(arguments.order.getOrderFulfillments()); i++) {
			if(!arguments.order.getOrderFulfillments()[i].isProcessable( context="placeOrder" ) || arguments.order.getOrderFulfillments()[i].hasErrors()) {
				orderRequirementsList = listAppend(orderRequirementsList, "fulfillment");
				break;
			}
		}
	
		// Make sure that the order payments all pass the isProcessable for placeOrder
		for(var i = 1; i <= arrayLen(arguments.order.getOrderPayments()); i++) {
			if(!arguments.order.getOrderPayments()[i].isProcessable( context="placeOrder" ) || arguments.order.getOrderPayments()[i].hasErrors()) {
				orderRequirementsList = listAppend(orderRequirementsList, "payment");
				break;
			}
		}
	
		return orderRequirementsList;
	}
	
	public void function clearCart() {
		var currentSession = getSlatwallScope().getCurrentSession();
		var cart = currentSession.getOrder();
		
		if(!isNull(cart) && !cart.isNew()) {
			currentSession.removeOrder();
		
			getHibachiDAO().delete(cart.getOrderItems());
			getHibachiDAO().delete(cart.getOrderFulfillments());
			getHibachiDAO().delete(cart.getOrderPayments());
			getHibachiDAO().delete(cart);
		}
	}
	
	public void function removeAccountSpecificOrderDetails(required any order) {
	
		// Loop over fulfillments and remove any account specific details
		for(var i = 1; i <= arrayLen(arguments.order.getOrderFulfillments()); i++) {
			if(arguments.order.getOrderFulfillments()[i].getFulfillmentMethodID() == "shipping") {
				arguments.order.getOrderFulfillments()[i].setShippingAddress(javaCast("null", ""));
				arguments.order.getOrderFulfillments()[i].setAccountAddress(javaCast("null", ""));
			}
		}
	
		// TODO: Loop over payments and remove any account specific details
		// Recalculate the order amounts for tax and promotions
		recalculateOrderAmounts(arguments.order);
	}
	
	public void function recalculateOrderAmounts(required any order) {
		
		if(arguments.order.getOrderStatusType().getSystemCode() == "ostClosed") {
			throw("A recalculateOrderAmounts was called for an order that was already closed");
		} else {
			
			// Loop over the orderItems to see if the skuPrice Changed
			if(arguments.order.getOrderStatusType().getSystemCode() == "ostNotPlaced") {
				for(var i=1; i<=arrayLen(arguments.order.getOrderItems()); i++) {
					if(arguments.order.getOrderItems()[i].getOrderItemType().getSystemCode() == "oitSale" && arguments.order.getOrderItems()[i].getSkuPrice() != arguments.order.getOrderItems()[i].getSku().getPriceByCurrencyCode( arguments.order.getOrderItems()[i].getCurrencyCode() )) {
						arguments.order.getOrderItems()[i].setPrice( arguments.order.getOrderItems()[i].getSku().getPriceByCurrencyCode( arguments.order.getOrderItems()[i].getCurrencyCode() ) );
						arguments.order.getOrderItems()[i].setSkuPrice( arguments.order.getOrderItems()[i].getSku().getPriceByCurrencyCode( arguments.order.getOrderItems()[i].getCurrencyCode() ) );
					}
				}
			}
			
			// First Re-Calculate the 'amounts' base on price groups
			getPriceGroupService().updateOrderAmountsWithPriceGroups( arguments.order );
			
			// Then Re-Calculate the 'amounts' based on permotions ext.  This is done second so that the order already has priceGroup specific info added
			getPromotionService().updateOrderAmountsWithPromotions( arguments.order );
			
			// Re-Calculate tax now that the new promotions and price groups have been applied
			getTaxService().updateOrderAmountsWithTaxes( arguments.order );
		}
	}
	
	public any function addPromotionCode(required any order, required string promotionCode) {
		var pc = getPromotionService().getPromotionCodeByPromotionCode(arguments.promotionCode);
		
		if(isNull(pc) || !pc.getPromotion().getActiveFlag()) {
			arguments.order.addError("promotionCode", rbKey('validate.promotionCode.invalid'));
		} else if ( (!isNull(pc.getStartDateTime()) && pc.getStartDateTime() > now()) || (!isNull(pc.getEndDateTime()) && pc.getEndDateTime() < now()) || !pc.getPromotion().getCurrentFlag()) {
			arguments.order.addError("promotionCode", rbKey('validate.promotionCode.invaliddatetime'));
		} else if (arrayLen(pc.getAccounts()) && !pc.hasAccount(getSlatwallScope().getCurrentAccount())) {
			arguments.order.addError("promotionCode", rbKey('validate.promotionCode.invalidaccount'));
		} else {
			if(!arguments.order.hasPromotionCode( pc )) {
				arguments.order.addPromotionCode( pc );
			}
			getPromotionService().updateOrderAmountsWithPromotions(order=arguments.order);
		}
		
		return arguments.order;
	}
	
	public void function removePromotionCode(required any order, required any promotionCode) {
		arguments.order.removePromotionCode(arguments.promotionCode);
		getPromotionService().updateOrderAmountsWithPromotions(order=arguments.order);
	}
	
	public any function forceItemQuantityUpdate(required any order, required any messageBean) {
		// Loop over each order Item
		for(var i = arrayLen(arguments.order.getOrderItems()); i >= 1; i--)	{
			if(!arguments.order.getOrderItems()[i].hasQuantityWithinMaxOrderQuantity())	{
				if(arguments.order.getOrderItems()[i].getMaximumOrderQuantity() > 0) {
					arguments.messageBean.addMessage(messageName="forcedItemQuantityAdjusted", message="#arguments.order.getOrderItems()[i].getSku().getProduct().getTitle()# #arguments.order.getOrderItems()[i].getSku().displayOptions()# on your order had the quantity updated from #arguments.order.getOrderItems()[i].getQuantity()# to #arguments.order.getOrderItems()[i].getMaximumOrderQuantity()# because of inventory constraints.");
					arguments.order.getOrderItems()[i].setQuantity(arguments.order.getOrderItems()[i].getMaximumOrderQuantity());
				} else {
					arguments.messageBean.addMessage(messageName="forcedItemRemoved", message="#arguments.order.getOrderItems()[i].getSku().getProduct().getTitle()# #arguments.order.getOrderItems()[i].getSku().displayOptions()# was removed from your order because of inventory constraints");
					arguments.order.getOrderItems()[i].removeOrder();
				}
			}
		}
	}
	
	public any function duplicateOrderWithNewAccount(required any originalOrder, required any newAccount) {
		
		var newOrder = this.newOrder();
		newOrder.setCurrencyCode( arguments.originalOrder.getCurrencyCode() );
		
		// Copy Order Items
		for(var i=1; i<=arrayLen(arguments.originalOrder.getOrderItems()); i++) {
			var newOrderItem = this.newOrderItem();
			
			newOrderItem.setPrice( arguments.originalOrder.getOrderItems()[i].getPrice() );
			newOrderItem.setSkuPrice( arguments.originalOrder.getOrderItems()[i].getSkuPrice() );
			newOrderItem.setCurrencyCode( arguments.originalOrder.getOrderItems()[i].getCurrencyCode() );
			newOrderItem.setQuantity( arguments.originalOrder.getOrderItems()[i].getQuantity() );
			newOrderItem.setOrderItemType( arguments.originalOrder.getOrderItems()[i].getOrderItemType() );
			newOrderItem.setOrderItemStatusType( arguments.originalOrder.getOrderItems()[i].getOrderItemStatusType() );
			newOrderItem.setSku( arguments.originalOrder.getOrderItems()[i].getSku() );
			if(!isNull(arguments.originalOrder.getOrderItems()[i].getStock())) {
				newOrderItem.setStock( arguments.originalOrder.getOrderItems()[i].getStock() );
			}
			
			// copy order item customization
			for(var attributeValue in arguments.originalOrder.getOrderItems()[i].getAttributeValues()) {
				var av = this.newAttributeValue();
				av.setAttributeValueType(attributeValue.getAttributeValueType());
				av.setAttribute(attributeValue.getAttribute());
				av.setAttributeValue(attributeValue.getAttributeValue());
				av.setOrderItem(newOrderItem);
			}

			// check if there is a fulfillment method of this type in the order
			for(var fulfillment in newOrder.getOrderFulfillments()) {
				if(arguments.originalOrder.getOrderItems()[i].getOrderFulfillment().getFulfillmentMethod().getFulfillmentMethodID() == fulfillment.getFulfillmentMethod().getFulfillmentMethodID()) {
					var newOrderFulfillment = fulfillment;
					break;
				}
			}
			if(isNull(newOrderFulfillment)) {
				var newOrderFulfillment = this.newOrderFulfillment();
				newOrderFulfillment.setFulfillmentMethod( arguments.originalOrder.getOrderItems()[i].getOrderFulfillment().getFulfillmentMethod() );
				newOrderFulfillment.setOrder( newOrder );
				newOrderFulfillment.setCurrencyCode( arguments.originalOrder.getOrderItems()[i].getOrderFulfillment().getCurrencyCode() );
			}
			newOrderItem.setOrder( newOrder );
			newOrderItem.setOrderFulfillment( newOrderFulfillment );

		}
		
		newOrder.setAccount( arguments.newAccount );
		
		// Update any errors from the previous account to the new account
		newOrder.getAccount().setHibachiErrors( originalOrder.getAccount().getHibachiErrors() );
		
		this.saveOrder( newOrder );
		
		return newOrder;
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public struct function getQuantityPriceSkuAlreadyReturned(required any orderID, required any skuID) {
		return getOrderDAO().getQuantityPriceSkuAlreadyReturned(arguments.orderId, arguments.skuID);
	}
	
	public numeric function getPreviouslyReturnedFulfillmentTotal(required any orderID) {
		return getOrderDAO().getPreviouslyReturnedFulfillmentTotal(arguments.orderId);
	}
	
	public any function getMaxOrderNumber() {
		return getOrderDAO().getMaxOrderNumber();
	}
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// Process: Order
	public any function processOrder_addSaleOrderItem(required any order, required any processObject) {
		
		// Setup the Order Fulfillment
		if(len(processObject.getOrderFulfillmentID()) && processObject.getOrderFulfillmentID() neq "new") {
			
			// get the correct order fulfillment to attach this item to
			var orderFulfillment = this.getOrderFulfillment( processObject.getOrderFulfillmentID() );	
			
		} else {
			
			// Setup a new order fulfillment
			var orderFulfillment = this.newOrderFulfillment();
			orderFulfillment.setFulfillmentMethod( getFulfillmentService().getFulfillmentMethod( arguments.processObject.getFulfillmentMethodID() ) );
			orderFulfillment.setOrder( arguments.order );
			
			// Populate the shipping address info
			if(orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping") {
				
				// Check for an accountAddress
				if(len(arguments.processObject.getShippingAccountAddressID()) && arguments.processObject.getShippingAccountAddressID() neq "new") {
					
					// Find the correct account address, and set it in the order fulfillment
					var accountAddress = getAccountService().getAccountAddress( arguments.processObject.getShippingAccountAddressID() );
					orderFulfillment.setAccountAddress( accountAddress );
				
				// Otherwise setup a new shipping address
				} else {
					
					// First we need to persist the address from the processObject
					getAddressService().saveAddress( arguments.processObject.getShippingAddress() );
					
					// If we are supposed to save the new address, then we can do that here
					if(arguments.processObject.getSaveShippingAccountAddressFlag()) {
						
						var newAccountAddress = getAccountService().newAccountAddress();
						newAccountAddress.setAccount( arguments.order.getAccount() );
						newAccountAddress.setAccountAddressName( arguments.processObject.getSaveShippingAccountAddressName() );
						newAccountAddress.setAddress( arguments.processObject.getShippingAddress() );
						orderFulfillment.setAccountAddress( newAccountAddress );
						
					// Otherwise just set then new address in the order fulfillment
					} else {
						
						orderFulfillment.setShippingAddress( arguments.processObject.getShippingAddress() );
					}
				}
			}
			
			orderFulfillment = this.saveOrderFulfillment( orderFulfillment );
		}
		
		// Setup a boolean to see if we were able to just att this order item to an existing one
		var foundItem = false;
		
		// Check for the sku in the orderFulfillment already
		for(var i=1; i<=arrayLen(orderFulfillment.getOrderFulfillmentItems()); i++) {
			if(orderFulfillment.getOrderFulfillmentItems()[i].getSku().getSkuID() eq arguments.processObject.getSku().getSkuID() && orderFulfillment.getOrderFulfillmentItems()[i].getPrice() eq arguments.processObject.getPrice()) {
				foundItem = true;
				orderFulfillment.getOrderFulfillmentItems()[i].setQuantity(orderFulfillment.getOrderFulfillmentItems()[i].getQuantity() + arguments.processObject.getQuantity());
				break;
			}
		}
		
		// If we didn't already find the item in an orderFulfillment, then we can add it here.
		if(!foundItem) {
			// Create a new Order Item
			var newOrderItem = this.newOrderItem();
			
			// Set any customizations
			newOrderItem.populate( arguments.data );
			
			// Set Header Info
			newOrderItem.setOrderFulfillment( orderFulfillment );
			newOrderItem.setOrder( arguments.order );
			
			// Setup the Sku / Quantity / Price details
			newOrderItem.setSku( arguments.processObject.getSku() );
			newOrderItem.setCurrencyCode( arguments.order.getCurrencyCode() );
			newOrderItem.setQuantity( arguments.processObject.getQuantity() );
			newOrderItem.setPrice( arguments.processObject.getPrice() );
			newOrderItem.setSkuPrice( arguments.processObject.getSku().getPriceByCurrencyCode( newOrderItem.getCurrencyCode() ) );
			
			// Save the new order items
			this.saveOrderItem( newOrderItem );
		}
		
		// Call the recalculate so that promotions get set
		recalculateOrderAmounts( arguments.order );
		
		return arguments.order;
	}
	
	public any function processOrder_addOrderPayment(required any order, required any processObject) {
		
		// Setup the order payment
		var newOrderPayment = processObject.getNewOrderPayment();
		newOrderPayment.setAmount( arguments.processObject.getAmount() );
		
		// If this is an existing account payment method, then we can pull the data from there
		if( len(arguments.processObject.getAccountPaymentMethodID()) ) {
			
			// Setup the newOrderPayment from the existing payment method
			var accountPaymentMethod = getAccountService().getAccountPaymentMethod( arguments.processObject.getAccountPaymentMethodID() );
			newOrderPayment.copyFromAccountPaymentMethod( accountPaymentMethod );
			
		// This is a new payment, so we need to setup the billing address and see if there is a need to save it against the account
		} else {
			
			// Setup the payment method
			newOrderPayment.setPaymentMethod( getPaymentService().getPaymentMethod(arguments.processObject.getPaymentMethodID()) );
			
			// Setup the billing address as an accountAddress if it existed
			if(len(arguments.processObject.getAccountAddressID())) {
				var accountAddress = getAccountService().getAccountAddress( arguments.processObject.getAcccountAddressID() );
				
				newOrderPayment.setBillingAddress( accountAddress.copyAddress( true ) );
			}
			
			// If saveAccountPaymentMethodFlag is set to true, then we need to save this object
			if(arguments.processObject.getSaveAccountPaymentMethodFlag()) {
				var newAccountPaymentMethod = getAccountService().newAccountPaymentMethod();
				newAccountPaymentMethod.copyFromOrderPayment( newOrderPayment );
				newAccountPaymentMethod.setAccount( arguments.order.getAccount() );
			}

		}
		
		// Save the newOrderPayment
		getHibachiDAO().save( newOrderPayment );
		
		// Add this order payment to the order
		arguments.order.addOrderPayment( newOrderPayment );
		
		return arguments.order;
	}
	
	public any function processOrder_create(required any order, required any processObject, required struct data={}) {
		// Setup Account
		if(arguments.processObject.getNewAccountFlag()) {
			var account = getAccountService().processAccount(getAccountService().newAccount(), arguments.data, "create");
		} else {
			var account = getAccountService().getAccount(processObject.getAccountID());
		}
		arguments.order.setAccount(account);
		
		// Setup the Order Origin
		if( len(arguments.processObject.getOrderOriginID()) ) {
			arguments.order.setOrderOrigin( getSettingService().getOrderOrigin(arguments.processObject.getOrderOriginID()) );
		}
		
		// Setup the Currency Code
		arguments.order.setCurrencyCode( arguments.processObject.getCurrencyCode() );
		
		// Determine the order type
		var orderType = getSettingService().getType( processObject.getOrderTypeID() );
		
		// If the order type is a return or exchange then setup the first order return
		if (listFindNoCase("otReturnOrder,otExchangeOrder", orderType.getSystemCode())) {
			
			// Setup the first order fulfillment
			var orderReturn = this.newOrderReturn();
			
			orderReturn.setOrder( arguments.order );
		}
		
		// Save the order
		arguments.order = this.saveOrder(arguments.order);
		
		return arguments.order;
	}
	
	public any function processOrder_placeOrder(required any order, required struct data) {
		// First we need to lock the session so that this order doesn't get placed twice.
		lock scope="session" timeout="60" {
		
			// Reload the order in case it was already in cache
			getHibachiDAO().reloadEntity(arguments.order);
		
			// Make sure that the entity is notPlaced before going any further
			if(arguments.order.getOrderStatusType().getSystemCode() == "ostNotPlaced") {
				
				// Call the saveOrder method so that accounts, fulfillments & payments are updated
				arguments.order = this.saveOrder(arguments.order, arguments.data);
				
				// As long as the order doesn't have any errors after updating fulfillment & payments we can continue
				if(!arguments.order.hasErrors()) {
					
					// Generate the order requirements list, to see if we still need action to be taken
					var orderRequirementsList = getOrderRequirementsList( arguments.order );
					
					// Verify the order requirements list, to make sure that this order has everything it needs to continue
					if(!len(orderRequirementsList)) {
						
						// This will override the order.hasErrors() below in case one transaction goes through
						var hadChargeCreditAuthorizeSuccess = false;
						
						// Process All Payments and Save the ones that were successful
						for(var i = 1; i <= arrayLen(arguments.order.getOrderPayments()); i++) {
							
							// Setup a flag to check if this is an authorize,credit,charge type of transaction
							var chargeCreditAuthroizeTransaction = false;
							if(!isNull(arguments.order.getOrderPayments()[i].getPaymentMethod().getPlaceOrderChargeTransactionType()) && listFindNoCase("charge,credit,authorize,authorizeAndCapture", arguments.order.getOrderPayments()[i].getPaymentMethod().getPlaceOrderChargeTransactionType())) {
								chargeCreditAuthroizeTransaction = true;
							}
							
							// Call the placeOrderTransactionType for the order payment
							var thisOrderPayment = this.processOrderPayment(arguments.order.getOrderPayments()[i], {}, 'runPlaceOrderTransaction');
							
							// Tell the process that one transaction went through
							if(!thisOrderPayment.hasErrors() && chargeCreditAuthroizeTransaction) {
								hadChargeCreditAuthorizeSuccess = true;
							}
							
						}
						
						// After all of the processing, double check that the order does not have errors.  If one of the payments didn't go through, then an error would have been set on the order.
						if(!arguments.order.hasErrors() || hadChargeCreditAuthorizeSuccess) {
							
							// If this order is the same as the current cart, then set the current cart to a new order
							if(!isNull(getSlatwallScope().getCurrentSession().getOrder()) && arguments.order.getOrderID() == getHibachiScope().getCurrentSession().getOrder().getOrderID()) {
								getHibachiScope().getCurrentSession().setOrder(javaCast("null", ""));
							}
						
							// Update the order status
							order.setOrderStatusType( getSettingService().getTypeBySystemCode("ostNew") );
							
							// Update the orderPlaced
							order.confirmOrderNumberOpenDateCloseDate();
						
							// Save the order to the database
							getHibachiDAO().save(order);
						
							// Do a flush so that the order is commited to the DB
							getHibachiDAO().flushORMSession();
						
							// Log that the order was placed
							logHibachi(message="New Order Processed - Order Number: #order.getOrderNumber()# - Order ID: #order.getOrderID()#", generalLog=true);
							
						}
					}
					
				}
			}
			
		}	// END OF LOCK
		
		return arguments.order;
	}
	
	// (needs refactor)
	public any function processOrder_createReturn(required any order, struct data={}, string processContext="process") {
			
		var hasAtLeastOneItemToReturn = false;
		for(var i=1; i<=arrayLen(arguments.data.records); i++) {
			if(isNumeric(arguments.data.records[i].returnQuantity) && arguments.data.records[i].returnQuantity gt 0) {
				var hasAtLeastOneItemToReturn = true;		
			}
		}
		
		if(!hasAtLeastOneItemToReturn) {
			arguments.order.addError('processing', 'You need to specify at least 1 item to be returned');
		} else {
			
			// Create a new return order
			var returnOrder = this.newOrder();
			returnOrder.setAccount( arguments.order.getAccount() );
			returnOrder.setOrderType( getSettingService().getTypeBySystemCode("otReturnOrder") );
			returnOrder.setOrderStatusType( getSettingService().getTypeBySystemCode("ostNew") );
			returnOrder.setReferencedOrder( arguments.order );
			
			var returnLocation = getLocationService().getLocation( arguments.data.returnLocationID );
			
			// Create OrderReturn entity (to save the fulfillment amount)
			var orderReturn = this.newOrderReturn();
			orderReturn.setOrder( returnOrder );
			if(isNumeric(arguments.data.fulfillmentChargeRefundAmount) && arguments.data.fulfillmentChargeRefundAmount gt 0) {
				orderReturn.setFulfillmentRefundAmount( arguments.data.fulfillmentChargeRefundAmount );	
			} else {
				orderReturn.setFulfillmentRefundAmount( 0 );
			}
			orderReturn.setReturnLocation( returnLocation );
			
			// Loop over delivery items in each delivery
			for(var i = 1; i <= arrayLen(arguments.order.getOrderItems()); i++) {
				
				var originalOrderItem = arguments.order.getOrderItems()[i];
				
				// Look for that orderItem in the data records
				for(var r=1; r <= arrayLen(arguments.data.records); r++) {
					if(originalOrderItem.getOrderItemID() == arguments.data.records[r].orderItemID && isNumeric(arguments.data.records[r].returnQuantity) && arguments.data.records[r].returnQuantity > 0 && isNumeric(arguments.data.records[r].returnPrice) && arguments.data.records[r].returnPrice >= 0) {
						
						// Create a new return orderItem
						var orderItem = this.newOrderItem();
						orderItem.setOrderItemType( getSettingService().getTypeBySystemCode('oitReturn') );
						orderItem.setOrderItemStatusType( getSettingService().getTypeBySystemCode('oistNew') );
						
						orderItem.setReferencedOrderItem( originalOrderItem );
						orderItem.setOrder( returnOrder );
						orderItem.setPrice( arguments.data.records[r].returnPrice );
						orderItem.setSkuPrice( originalOrderItem.getSku().getPrice() );
						orderItem.setCurrencyCode( originalOrderItem.getSku().getCurrencyCode() );
						orderItem.setQuantity( arguments.data.records[r].returnQuantity );
						orderItem.setSku( originalOrderItem.getSku() );
						
						// Add this order item to the OrderReturns entity
						orderItem.setOrderReturn( orderReturn );
						
					}
				}
			}
			
			// Recalculate the order amounts for tax and promotions
			recalculateOrderAmounts( returnOrder );
			
			// Setup a payment to refund
			var referencedOrderPayment = this.getOrderPayment(arguments.data.referencedOrderPaymentID);
			if(!isNull(referencedOrderPayment)) {
				var newOrderPayment = referencedOrderPayment.duplicate();
				newOrderPayment.setOrderPaymentType( getSettingService().getTypeBySystemCode('optCredit') );
				newOrderPayment.setReferencedOrderPayment( referencedOrderPayment );
				newOrderPayment.setAmount( returnOrder.getTotal()*-1 );
				newOrderPayment.setOrder( returnOrder );
			}
			
			// Persit the new order
			getHibachiDAO().save( returnOrder );
			
			// If the end-user has choosen to auto-receive the return order && potentially
			if(arguments.data.autoProcessReceiveReturnFlag) {
				
				var autoProcessReceiveReturnData = {
					locationID = arguments.data.returnLocationID,
					boxCount = 1,
					packingSlipNumber = 'auto',
					autoProcessReturnPaymentFlag = arguments.data.autoProcessReturnPaymentFlag,
					records = arguments.data.records
				};
				
				for(var r=1; r <= arrayLen(autoProcessReceiveReturnData.records); r++) {
					for(var n=1; n<=arrayLen(returnOrder.getOrderItems()); n++) {
						if(autoProcessReceiveReturnData.records[r].orderItemID == returnOrder.getOrderItems()[n].getReferencedOrderItem().getOrderItemID()) {
							autoProcessReceiveReturnData.records[r].orderItemID = returnOrder.getOrderItems()[n].getOrderItemID();
						}
					}
					autoProcessReceiveReturnData.records[r].receiveQuantity = autoProcessReceiveReturnData.records[r].returnQuantity; 
				}
				
				processOrderReturn(orderReturn, autoProcessReceiveReturnData, "receiveReturn");
				
			// If we are only auto-processing the payment, but not receiving then we need to call the processPayment from here
			} else if (arguments.data.autoProcessReturnPaymentFlag && arrayLen(returnOrder.getOrderPayments())) {
				
				// Setup basic processing data
				var processData = {
					amount = returnOrder.getOrderPayments()[1].getAmount(),
					providerTransactionID = returnOrder.getOrderPayments()[1].getMostRecentChargeProviderTransactionID()
				};
				
				processOrderPayment(returnOrder.getOrderPayments()[1], processData, 'credit');
			
			}
			
		}
		
		return arguments.order;
	}
	
	public any function processOrder_placeOnHold(required any order, struct data={}, string processContext="process") {
		
		arguments.order.setOrderStatusType( getSettingService().getTypeBySystemCode("ostOnHold") );
		
		return arguments.order;
	}
	
	public any function processOrder_takeOffHold(required any order, struct data={}, string processContext="process") {
		
		arguments.order.setOrderStatusType( getSettingService().getTypeBySystemCode("ostProcessing") );
		updateOrderStatus(arguments.order);
					
		return arguments.order;
	}
	
	public any function processOrder_cancelOrder(required any order, struct data={}, string processContext="process") {
			
		// Loop over all the orderItems and set them to 0
		for(var i=1; i<=arrayLen(arguments.order.getOrderItems()); i++) {
			arguments.order.getOrderItems()[i].setQuantity(0);
			
			// Remove any promotionsApplied
			for(var p=arrayLen(arguments.order.getOrderItems()[i].getAppliedPromotions()); p>=1; p--) {
				arguments.order.getOrderItems()[i].getAppliedPromotions()[p].removeOrderItem();
			}
			
			// Remove any taxApplied
			for(var t=arrayLen(arguments.order.getOrderItems()[i].getAppliedTaxes()); t>=1; t--) {
				arguments.order.getOrderItems()[i].getAppliedTaxes()[t].removeOrderItem();
			}
		}
		
		// Loop over all the fulfillments and remove any fulfillmentCharges, and promotions applied
		for(var i=1; i<=arrayLen(arguments.order.getOrderFulfillments()); i++) {
			arguments.order.getOrderFulfillments()[i].setFulfillmentCharge(0);
			// Remove over any promotionsApplied
			for(var p=arrayLen(arguments.order.getOrderFulfillments()[i].getAppliedPromotions()); p>=1; p--) {
				arguments.order.getOrderFulfillments()[i].getAppliedPromotions()[p].removeOrderFulfillment();
			}
		}
		
		// Loop over all of the order discounts and remove them
		for(var p=arrayLen(arguments.order.getAppliedPromotions()); p>=1; p--) {
			arguments.order.getAppliedPromotions()[p].removeOrder();
		}
		
		// Loop over all the payments and credit for any charges, and set paymentAmount to 0
		for(var p=1; p<=arrayLen(arguments.order.getOrderPayments()); p++) {
			var totalReceived = precisionEvaluate(arguments.order.getOrderPayments()[p].getAmountReceived() - arguments.order.getOrderPayments()[p].getAmountCredited());
			if(totalReceived gt 0) {
				var paymentOK = getPaymentService().processPayment(arguments.order.getOrderPayments()[p], "credit", totalReceived, arguments.order.getOrderPayments()[p].getMostRecentChargeProviderTransactionID());
			}
			// Set payment amount to 0
			arguments.order.getOrderPayments()[p].setAmount(0);
		}
		
		// Set the status code to canceld
		arguments.order.setOrderStatusType( getSettingService().getTypeBySystemCode("ostCanceled") );
	
		
		return arguments.order;
	}
	
	public any function processOrder_addPromotionCode(required any order, required any processObject) {
			
		var pc = getPromotionService().getPromotionCodeByPromotionCode(arguments.processObject.getPromotionCode());
		
		if(isNull(pc) || !pc.getPromotion().getActiveFlag()) {
			arguments.processObject.addError("promotionCode", rbKey('validate.promotionCode.invalid'));
		} else if ( (!isNull(pc.getStartDateTime()) && pc.getStartDateTime() > now()) || (!isNull(pc.getEndDateTime()) && pc.getEndDateTime() < now()) || !pc.getPromotion().getCurrentFlag()) {
			arguments.processObject.addError("promotionCode", rbKey('validate.promotionCode.invaliddatetime'));
		} else if (arrayLen(pc.getAccounts()) && !pc.hasAccount(getSlatwallScope().getCurrentAccount())) {
			arguments.processObject.addError("promotionCode", rbKey('validate.promotionCode.invalidaccount'));
		} else {
			if(!arguments.order.hasPromotionCode( pc )) {
				arguments.order.addPromotionCode( pc );
				recalculateOrderAmounts(order=arguments.order);
			}
		}		
		
		return arguments.order;
	}

	// Process: Order Fulfillment
	// (needs refactory)
	public any function processOrderFulfillment_fulfillItems(required any orderFulfillment, struct data={}, string processContext="process") {
		
		// Make sure that a location was passed in
		if(structKeyExists(arguments.data, "locationID")) {
			var location = getLocationService().getLocation(  arguments.data.locationID );
			
			// Make sure that the location is not Null
			if(!isNull(location)) {
				
				// Create a new Order Delivery and set the relevent values
				var orderDelivery = this.newOrderDelivery();
				orderDelivery.setFulfillmentMethod( arguments.orderFulfillment.getFulfillmentMethod() );
				orderDelivery.setLocation( location );
				
				// Attach this delivery to the order
				orderDelivery.setOrder( arguments.orderFulfillment.getOrder() );
				
				// Per Fulfillment Method Type set whatever other details need to be set
				switch(arguments.orderFulfillment.getFulfillmentMethodType()) {
					
					case "auto": {
						// With an 'auto' type of setup, if no records exist in the data, then we can just create deliveryItems for the unfulfilled quantities of each item
						if(!structKeyExists(arguments.data, "records")) {
							arguments.data.records = [];
							for(var i=1; i<=arrayLen(arguments.orderFulfillment.getOrderFulfillmentItems()); i++) {
								arrayAppend(arguments.data.records, {orderItemID=arguments.orderFulfillment.getOrderFulfillmentItems()[i].getOrderItemID(), quantity=arguments.orderFulfillment.getOrderFulfillmentItems()[i].getQuantityUndelivered()});
							}
						}
						break;
					}
					case "shipping": {
						// Set the shippingAddress, shippingMethod & potentially tracking number
						orderDelivery.setShippingAddress( arguments.orderFulfillment.getShippingAddress().copyAddress( saveNewAddress=true ) );
						orderDelivery.setShippingMethod(arguments.orderFulfillment.getShippingMethod());
						if(structkeyExists(arguments.data, "trackingNumber") && len(arguments.data.trackingNumber)) {
							orderDelivery.setTrackingNumber(arguments.data.trackingNumber);
						}
						break;
					}
					default: {
						
						break;
					}
				}
				
				// Setup a total item value delivered so we can charge the proper amount for the payment later
				var totalItemValueDelivered = 0;
				
				// Loop over the records in the data to set the quantity for the delivery
				if(structKeyExists(arguments.data, "records")) {
					for(var i=1; i<=arrayLen(arguments.data.records); i++) {
						
						// Only add this orderItem to the delivery if it has an orderItemID, a quantity is defined, and the quantity is numeric and gt 1 
						if(structKeyExists(arguments.data.records[i], "orderItemID") && isSimpleValue(arguments.data.records[i].orderItemID) && structKeyExists(arguments.data.records[i], "quantity") && isNumeric(arguments.data.records[i].quantity) && arguments.data.records[i].quantity > 0) {
							
							var orderItem = this.getOrderItem(arguments.data.records[i].orderItemID);
							if(!isNull(orderItem)) {
								
								// Make sure that we aren't trying to deliver more than was ordered
								if(orderItem.getQuantityUndelivered() >= arguments.data.records[i].quantity) {
									
									// Grab the stock that matches the item and the location from which we are delivering
									var stock = getStockService().getStockBySkuAndLocation(orderItem.getSku(), orderDelivery.getLocation());
									
									// Create and Populate a new delivery item
									var orderDeliveryItem = this.newOrderDeliveryItem();
									orderDeliveryItem.setOrderDelivery( orderDelivery );
									orderDeliveryItem.setOrderItem( orderItem );
									orderDeliveryItem.setStock( stock );
									orderDeliveryItem.setQuantity( arguments.data.records[i].quantity );
									
									// Add the value of this item to the total charge
									totalItemValueDelivered = precisionEvaluate(totalItemValueDelivered + (orderItem.getExtendedPriceAfterDiscount() + orderItem.getTaxAmount()) * ( arguments.data.records[i].quantity / orderItem.getQuantity() ) );
									
									// setup subscription data if this was subscriptionOrder item
									getSubscriptionService().setupSubscriptionOrderItem( orderItem );
								
									// setup content access if this was content purchase
									setupOrderItemContentAccess( orderItem );
								
								} else {
									arguments.orderFulfillment.addError('orderFulfillmentItem', 'You are trying to fulfill a quantity of #arguments.data.records[i].quantity# for #orderItem.getSku().getProduct().getTitle()# - #orderItem.getSku().displayOptions()# and that item only has an undelivered quantity of #orderItem.getQuantityUndelivered()#');
									
								}
								
							} else {
								arguments.orderFulfillment.addError('orderFulfillmentItem', 'An orderItem with the ID: #arguments.data.records[i].orderItemID# was trying to be processed with this fulfillment, but that orderItem does not exist');
							}
						}
					}
				}
				
				// Validate the orderDelivery
				orderDelivery.validate();
				
				if(!orderDelivery.hasErrors()) {
					
					// Call save on the orderDelivery so that it is persisted
					getHibachiDAO().save( orderDelivery );
					
					// Update the Order Status
					updateOrderStatus( arguments.orderFulfillment.getOrder(), true );
					
					// Look to charge orderPayments
					if(structKeyExists(arguments.data, "processCreditCard") && isBoolean(arguments.data.processCreditCard) && arguments.data.processCreditCard) {
						var totalAmountToCharge = arguments.orderFulfillment.getOrder().getDeliveredItemsPaymentAmountUnreceived();
						var totalAmountCharged = 0;
						
						for(var p=1; p<=arrayLen(arguments.orderFulfillment.getOrder().getOrderPayments()); p++) {
							
							var orderPayment = arguments.orderFulfillment.getOrder().getOrderPayments()[p];
							
							// Make sure that this is a credit card, and that it is a charge type of payment
							if(orderPayment.getPaymentMethodType() == "creditCard" && orderPayment.getOrderPaymentType().getSystemCode() == "optCharge") {
								
								// Check to make sure this payment hasn't been fully received
								if(orderPayment.getAmount() > orderPayment.getAmountReceived()) {
									
									var thisAmountToCharge = 0;
									
									// Attempt to capture preAuthorizations first
									if(orderPayment.getAmountAuthorized() > orderPayment.getAmountReceived()) {
										var thisAmountToCharge = orderPayment.getAmountAuthorized() - orderPayment.getAmountReceived();
										if(thisAmountToCharge > (totalAmountToCharge - totalAmountCharged)) {
											thisAmountToCharge = totalAmountToCharge - totalAmountCharged;
										}
										
										orderPayment = processOrderPayment(orderPayment, {amount=thisAmountToCharge}, "chargePreAuthorization");
										if(!orderPayment.hasErrors()) {
											totalAmountCharged = precisionEvaluate(totalAmountCharged + thisAmountToCharge);
											
											// Set the new payment transaction into the orderDelivery for later use
											var pts = orderPayment.getPaymentTransactions();
											orderDelivery.setPaymentTransaction( pts[arrayLen(pts)] );
										} else {
											structDelete(orderPayment.getErrors(), "processing");
										}
									}
									
									// Attempt to authorizeAndCharge now
									if(orderPayment.getAmountReceived() < orderPayment.getAmount() && totalAmountToCharge > totalAmountCharged) {
										var thisAmountToCharge = orderPayment.getAmount() - orderPayment.getAmountReceived();
										if(thisAmountToCharge > (totalAmountToCharge - totalAmountCharged)) {
											thisAmountToCharge = totalAmountToCharge - totalAmountCharged;
										}
										orderPayment = processOrderPayment(orderPayment, {amount=thisAmountToCharge}, "authorizeAndCharge");
										if(!orderPayment.hasErrors()) {
											totalAmountCharged = precisionEvaluate(totalAmountCharged + thisAmountToCharge);
											
											// Set the new payment transaction into the orderDelivery for later use
											var pts = orderPayment.getPaymentTransactions();
											orderDelivery.setPaymentTransaction( pts[arrayLen(pts)] );
										} else {
											structDelete(orderPayment.getErrors(), "processing");
										}
									}
									
									// Stop trying to charge payments, if we have charged everything we need to
									if(totalAmountToCharge == totalAmountCharged) {
										break;
									}
								}
							}
						}
					}
					
				} else {
					
					getSlatwallScope().setORMHasErrors( true );
					
					arguments.orderFulfillment.addError('location', 'The delivery that would have been created had errors');
				}
				
			} else {
				arguments.orderFulfillment.addError('location', 'The Location id that was passed in does not represent a valid location');	
				
			}
		} else {
			arguments.orderFulfillment.addError('location', 'No Location was passed in');
			
		}
		
		// if this fulfillment had error then we don't want to persist anything
		if(arguments.orderFulfillment.hasErrors()) {
			
			getSlatwallScope().setORMHasErrors( true );
			
		}		
			
		return arguments.orderFulfillment;
	}
	
	// Process: Order Return
	// (needs refactor)
	public any function processOrderReturn_receiveReturn(required any orderReturn, struct data={}, string processContext="process") {
			
		var hasAtLeastOneItemToReturn = false;
		for(var i=1; i<=arrayLen(arguments.data.records); i++) {
			if(isNumeric(arguments.data.records[i].receiveQuantity) && arguments.data.records[i].receiveQuantity gt 0) {
				var hasAtLeastOneItemToReturn = true;		
			}
		}
		
		if(!hasAtLeastOneItemToReturn) {
			arguments.orderReturn.addError('processing', 'You need to specify at least 1 item to be returned');
		} else {
			// Set this up to calculate how much credit to process if that flag is set later
			var totalAmountToCredit = 0;
			
			// If this is the first Stock Receiver, then we should add the fulfillmentRefund to the total received amount
			if(!arrayLen(arguments.orderReturn.getOrder().getStockReceivers()) && !isNull(arguments.orderReturn.getFulfillmentRefundAmount()) && arguments.orderReturn.getFulfillmentRefundAmount() > 0) {
				totalAmountReceived = arguments.orderReturn.getFulfillmentRefundAmount();
			}
			
			// Setup the received location
			var receivedLocation = getLocationService().getLocation(arguments.data.locationID);
			
			// Create a new Stock Receiver
			var newStockReceiver = getStockService().newStockReceiver();
			newStockReceiver.setReceiverType( 'order' );
			newStockReceiver.setOrder( arguments.orderReturn.getOrder() );
			newStockReceiver.setBoxCount( arguments.data.boxcount );
			newStockReceiver.setPackingSlipNumber( arguments.data.packingSlipNumber );
			
			for(var i=1; i<=arrayLen(arguments.data.records); i++) {
				if(isNumeric(arguments.data.records[i].receiveQuantity) && arguments.data.records[i].receiveQuantity gt 0) {
					
					var orderItemReceived = this.getOrderItem( arguments.data.records[i].orderItemID );
					var stockReceived = getStockService().getStockBySkuAndLocation(orderItemReceived.getSku(), receivedLocation);
					
					totalAmountToCredit = precisionEvaluate(totalAmountToCredit + (orderItemReceived.getExtendedPriceAfterDiscount() + orderItemReceived.getTaxAmount()) * ( arguments.data.records[i].receiveQuantity / orderItemReceived.getQuantity() ) );
					
					var newStockReceiverItem = getStockService().newStockReceiverItem();
					newStockReceiverItem.setStockReceiver( newStockReceiver );
					newStockReceiverItem.setOrderItem( orderItemReceived );
					newStockReceiverItem.setStock( stockReceived );
					newStockReceiverItem.setQuantity( arguments.data.records[i].receiveQuantity );
					newStockReceiverItem.setCost( 0 );
					
					// Cancel a subscription if returned item has a subscriptionUsage
					if(!isNull(orderItemReceived.getReferencedOrderItem())) {
						var subscriptionOrderItem = getSubscriptionService().getSubscriptionOrderItem({orderItem=orderItemReceived.getReferencedOrderItem()});
						if(!isNull(subscriptionOrderItem)) {
							getSubscriptionService().processSubscriptionUsage(subscriptionUsage=subscriptionOrderItem.getSubscriptionUsage(), processContext="cancel");		
						}
					}
					
					// TODO: Cancel Content Access
					
				}
			}
			
			getStockService().saveStockReceiver( newStockReceiver );
			
			// Update the Order Status
			updateOrderStatus( arguments.orderReturn.getOrder(), true );
		
			// Look to credit any order payments
			if(arguments.data.autoProcessReturnPaymentFlag) {
				
				var totalAmountCredited = 0;
				
				for(var p=1; p<=arrayLen(arguments.orderReturn.getOrder().getOrderPayments()); p++) {
					
					var orderPayment = arguments.orderReturn.getOrder().getOrderPayments()[p];
					
					// Make sure that this is a credit card, and that it is a charge type of payment
					if(orderPayment.getPaymentMethodType() == "creditCard" && orderPayment.getOrderPaymentType().getSystemCode() == "optCredit") {
						
						// Check to make sure this payment hasn't been fully received
						if(orderPayment.getAmount() > orderPayment.getAmountCredited()) {
							
							var potentialCredit = precisionEvaluate(orderPayment.getAmount() - orderPayment.getAmountCredited());
							if(potentialCredit > precisionEvaluate(totalAmountToCredit - totalAmountCredited)) {
								var thisAmountToCredit = precisionEvaluate(totalAmountToCredit - totalAmountCredited);
							} else {
								var thisAmountToCredit = potentialCredit;
							}
							
							orderPayment = processOrderPayment(orderPayment, {amount=thisAmountToCredit, providerTransactionID=orderPayment.getMostRecentChargeProviderTransactionID()}, "credit");
							if(!orderPayment.hasErrors()) {
								totalAmountCredited = precisionEvaluate(totalAmountCredited + thisAmountToCredit);
							} else {
								structDelete(orderPayment.getErrors(), "processing");
							}
							
							// Stop trying to charge payments, if we have charged everything we need to
							if(totalAmountToCredit == totalAmountCredited) {
								break;
							}
						}
					}
				}
			}
			
		}	
		return arguments.orderReturn;
	}	
	
	// Process: Order Payment
	public any function processOrderPayment_createTransaction(required any orderPayment, required any processObject) {
		
		// Create a new payment transaction
		var paymentTransaction = getPaymentService().newPaymentTransaction();
		
		// Setup the orderPayment in the transaction to be used by the 'runTransaction'
		paymentTransaction.setOrderPayment( arguments.orderPayment );
		
		// Setup the transaction data
		transactionData = {
			transactionType = processObject.getTransactionType(),
			amount = processObject.getAmount()
		};
		
		// Run the transaction
		paymentTransaction = getPaymentService().processPaymentTransaction(paymentTransaction, transactionData, 'runTransaction');
		
		return arguments.orderPayment;
		
	}
	
	
	public any function processOrderPayment_runPlaceOrderTransaction(required any orderPayment, required any processObject) {
						
		var transactionType = "";
		
		if(!isNull(arguments.orderPayment.getPaymentMethod().getPlaceOrderChargeTransactionType()) && orderPayment.getOrderPaymentType().getSystemCode() eq "optCharge") {
			var transactionType = arguments.orderPayment.getPaymentMethod().getPlaceOrderPaymentChargeTransactionType();
		}
		if(!isNull(arguments.orderPayment.getPaymentMethod().getPlaceOrderCreditTransactionType()) && orderPayment.getOrderPaymentType().getSystemCode() eq "optCredit") {
			var transactionType = arguments.orderPayment.getPaymentMethod().getPlaceOrderPaymentCreditTransactionType();
		}
		
		if(transactionType != '' && transactionType != 'none' && arguments.orderPayment.getAmount() > 0) {
			
			// Setup payment processing info
			var processData = {
				transactionType = transactionType,
				amount = arguments.orderPayment.getAmount()
			};
			
			// Call the processing method
			arguments.orderPayment = this.processOrderPayment(arguments.orderPayment, processData, 'createPaymentTransaction');
			
			// If there was expected authorize, receive, or credit
			if( 
				(arguments.orderPayment.hasErrors() || listFindNoCase("authorize", processData.transactionType) && arguments.orderPayment.getAmountAuthroized() lt arguments.orderPayment.getAmount())
					||
				(arguments.orderPayment.hasErrors() || listFindNoCase("authorizeAndCharge,receive", processData.transactionType) && arguments.orderPayment.getAmountReceived() lt arguments.orderPayment.getAmount())
					||
				(arguments.orderPayment.hasErrors() || listFindNoCase("credit", processData.transactionType) && arguments.orderPayment.getAmountCredited() lt arguments.orderPayment.getAmount())
			) {
				
				// Add a generic payment processing error and make it persistable
				arguments.orderPayment.getOrder().setError('processing', rbKey('entity.order.process.placeOrder.paymentProcessingError'), true);
				
			}

		}
		
		return arguments.orderPayment;
	}
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	public void function updateOrderStatus( required any order, updateItemStatus=false ) {
		// First we make sure that this order status is not 'closed', 'canceld', 'notPlaced' or 'onHold' because we cannot automatically update those statuses
		if(!listFindNoCase("ostNotPlaced,ostOnHold,ostClosed,ostCanceled", arguments.order.getOrderStatusType().getSystemCode())) {
			
			// We can check to see if all the items have been delivered and the payments have all been received then we can close this order
			if(arguments.order.getPaymentAmountReceivedTotal() == arguments.order.getTotal() && arguments.order.getQuantityUndelivered() == 0 && arguments.order.getQuantityUnreceived() == 0)	{
				arguments.order.setOrderStatusType(  getSettingService().getTypeBySystemCode("ostClosed") );
				
			// The default case is just to set it to processing
			} else {
				arguments.order.setOrderStatusType(  getSettingService().getTypeBySystemCode("ostProcessing") );
			}
		}
		
		// If we are supposed to update the items as well, loop over all items and pass to 'updateItemStatus'
		if(arguments.updateItemStatus) {
			for(var i=1; i<=arrayLen(arguments.order.getOrderItems()); i++) {
				updateOrderItemStatus( arguments.order.getOrderItems()[i] );
			}
		}
	}
	
	public void function updateOrderItemStatus( required any orderItem ) {
		
		// First we make sure that this order item is not already fully fulfilled, or onHold because we cannont automatically update those statuses
		if(!listFindNoCase("oistFulfilled,oistOnHold",arguments.orderItem.getOrderItemStatusType().getSystemCode())) {
			
			// If the quantityUndelivered is set to 0 then we can mark this as fulfilled
			if(arguments.orderItem.getQuantityUndelivered() == 0) {
				arguments.orderItem.setOrderItemStatusType(  getSettingService().getTypeBySystemCode("oistFulfilled") );
				
			// If the sku is setup to track inventory and the qoh is 0 then we can set the status to 'backordered'
			} else if(arguments.orderItem.getSku().setting('skuTrackInventoryFlag') && arguments.orderItem.getSku().getQuantity('qoh') == 0) {
				arguments.orderItem.setOrderItemStatusType(  getSettingService().getTypeBySystemCode("oistBackordered") );
					
			// Otherwise we just set this to 'processing' to show that the item is in limbo
			} else {
				arguments.orderItem.setOrderItemStatusType(  getSettingService().getTypeBySystemCode("oistProcessing") );
				
			}
		}
		
	}
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	public any function saveOrder(required any order, struct data={}, string context="save") {
	
		// Call the super.save() method to do the base populate & validate logic
		arguments.order = super.save(entity=arguments.order, data=arguments.data, context=arguments.context);
	
		// If the order has not been placed yet, loop over the orderItems to remove any that have a qty of 0
		if(arguments.order.getStatusCode() == "ostNotPlaced") {
			for(var i = arrayLen(arguments.order.getOrderItems()); i >= 1; i--) {
				if(arguments.order.getOrderItems()[i].getQuantity() < 1) {
					arguments.order.removeOrderItem(arguments.order.getOrderItems()[i]);
				}
			}
		}
	
		// Recalculate the order amounts for tax and promotions
		recalculateOrderAmounts(arguments.order);
	
		return arguments.order;
	}
	
	public any function saveOrderFulfillment(required any orderFulfillment, struct data={}) {
		
		// If the shipping method or address changes
		var oldAddressSerialized = arguments.orderFulfillment.getAddress().getSimpleValuesSerialized();
		var oldShippingMethodID = "";
		if(!isNull(arguments.orderFulfillment.getShippingMethod())) {
			oldShippingMethodID = arguments.orderFulfillment.getShippingMethod().getShippingMethodID();
		}
		
		// Call the generic save method to populate and validate
		arguments.orderFulfillment = save(arguments.orderFulfillment, arguments.data);
		
		// If there were no errors, then we can check to see if the shippingMethod or the address changed
		if(!arguments.orderFulfillment.hasErrors()) {
			
			// Check Address
			if(oldAddressSerialized != arguments.orderFulfillment.getAddress().getSimpleValuesSerialized()) {
				getService("ShippingService").updateOrderFulfillmentShippingMethodOptions( arguments.orderFulfillment );
				getTaxService().updateOrderAmountsWithTaxes( arguments.orderFulfillment.getOrder() );
			}
			
			// Check Shipping Method, and update charge
			if(!isNull(arguments.orderFulfillment.getShippingMethod()) && arguments.orderFulfillment.getShippingMethod().getShippingMethodID() != oldShippingMethodID) {
				arguments.orderFulfillment.setFulfillmentCharge( arguments.orderFulfillment.getSelectedShippingMethodOption().getTotalCharge() );
			}
		}
		
		return arguments.orderFulfillment;
		/*
		// If fulfillment method is shipping do this
		if(arguments.orderFulfillment.getFulfillmentMethodType() == "shipping") {
			// define some variables for backward compatibility
			param name="data.saveAccountAddress" default="0";
			param name="data.saveAccountAddressName" default="";
			param name="data.addressIndex" default="0";

			// Get Address
			if(data.addressIndex != 0) {
				var address = getAddressService().getAddress(data.accountAddresses[data.addressIndex].address.addressID, true);
				var newAddressDataStruct = data.accountAddresses[data.addressIndex].address;
			} else {
				var address = getAddressService().getAddress(data.shippingAddress.addressID, true);
				var newAddressDataStruct = data.shippingAddress;
			}

			// Populate Address And check if it has changed
			var serializedAddressBefore = address.getSimpleValuesSerialized();
			address.populate(newAddressDataStruct);
			var serializedAddressAfter = address.getSimpleValuesSerialized();

			// If it has changed we need to update Taxes and Shipping Options
			if(serializedAddressBefore != serializedAddressAfter) {
				getService("ShippingService").updateOrderFulfillmentShippingMethodOptions( arguments.orderFulfillment );
				getTaxService().updateOrderAmountsWithTaxes( arguments.orderFulfillment.getOrder() );
			}

			// USING ACCOUNT ADDRESS
			if(data.saveAccountAddress == 1 || data.addressIndex != 0) {
				// new account address
				if(data.addressIndex == 0) {
					var accountAddress = getAddressService().newAccountAddress();
				} else {
					//Existing address
					var accountAddress = getAddressService().getAccountAddress(data.accountAddresses[data.addressIndex].accountAddressID, 
					                                                           true);
				}
				accountAddress.setAddress(address);
				accountAddress.setAccount(arguments.orderFulfillment.getOrder().getAccount());
			
				// Figure out the name for this new account address, or update it if needed
				if(data.addressIndex == 0) {
					if(structKeyExists(data, "saveAccountAddressName") && len(data.saveAccountAddressName)) {
						accountAddress.setAccountAddressName(data.saveAccountAddressName);
					} else {
						accountAddress.setAccountAddressName(address.getname());
					}
				} else if(structKeyExists(data, "accountAddresses") && structKeyExists(data.accountAddresses[data.addressIndex], "accountAddressName")) {
					accountAddress.setAccountAddressName(data.accountAddresses[data.addressIndex].accountAddressName);
				}
			
				// If there was previously a shipping Address we need to remove it and recalculate
				if(!isNull(arguments.orderFulfillment.getShippingAddress())) {
					arguments.orderFulfillment.removeShippingAddress();
					arguments.orderFulfillment.setAccountAddress(accountAddress);
					getService("ShippingService").updateOrderFulfillmentShippingMethodOptions( arguments.orderFulfillment );
					getTaxService().updateOrderAmountsWithTaxes(arguments.orderFulfillment.getOrder());
				// If there was previously an account address and we switch it, then we need to recalculate
				} else if (!isNull(arguments.orderFulfillment.getAccountAddress()) && arguments.orderFulfillment.getAccountAddress().getAccountAddressID() != accountAddress.getAccountAddressID()) {
					arguments.orderFulfillment.setAccountAddress(accountAddress);
					getTaxService().updateOrderAmountsWithTaxes(arguments.orderFulfillment.getOrder());
					getService("ShippingService").updateOrderFulfillmentShippingMethodOptions( arguments.orderFulfillment );
				// Else just set the account address
				} else {
					arguments.orderFulfillment.setAccountAddress(accountAddress);	
				}
				
			
			// USING SHIPPING ADDRESS
			} else {

				// If there was previously an account address we need to remove and recalculate
				if(!isNull(arguments.orderFulfillment.getAccountAddress())) {
					arguments.orderFulfillment.removeAccountAddress();
					getTaxService().updateOrderAmountsWithTaxes(arguments.orderFulfillment.getOrder());
					getService("ShippingService").updateOrderFulfillmentShippingMethodOptions( arguments.orderFulfillment );
				}
				
				// Set the address in the order Fulfillment as shipping address
				arguments.orderFulfillment.setShippingAddress(address);
			}
		
			// Validate & Save Address
			address.validate(context="full");
		
			address = getAddressService().saveAddress(address);
			
			// Check for a shippingMethodOptionID selected
			if(structKeyExists(arguments.data, "fulfillmentShippingMethodOptionID")) {
				var methodOption = getShippingService().getShippingMethodOption(arguments.data.fulfillmentShippingMethodOptionID);
				
				// Verify that the method option is one for this fulfillment
				if(!isNull(methodOption) && arguments.orderFulfillment.hasFulfillmentShippingMethodOption(methodOption)) {
					// Update the orderFulfillment to have this option selected
					arguments.orderFulfillment.setShippingMethod(methodOption.getShippingMethodRate().getShippingMethod());
					arguments.orderFulfillment.setFulfillmentCharge(methodOption.getTotalCharge());
				}
			
			// If no shippingMethodOption, then just check for a shippingMethodID that was passed in
			} else if (structKeyExists(arguments.data, "shippingMethodID")) {
				
				var shippingMethod = getShippingService().getShippingMethod(arguments.data.shippingMethodID);
				
				// If this is a valid shipping method, then we can loop over all of the shippingMethodOptions and make sure this one exists
				if(!isNull(shippingMethod)) {
					for(var i=1; i<=arrayLen(arguments.orderFulfillment.getShippingMethodOptions()); i++) {
						if(shippingMethod.getShippingMethodID() == arguments.orderFulfillment.getShippingMethodOptions()[i].getShippingMethodRate().getShippingMethod().getShippingMethodID()) {
							arguments.orderFulfillment.setShippingMethod( arguments.orderFulfillment.getShippingMethodOptions()[i].getShippingMethodRate().getShippingMethod() );
							arguments.orderFulfillment.setFulfillmentCharge( arguments.orderFulfillment.getShippingMethodOptions()[i].getTotalCharge() );
						}
					}
				}	
			}
			
			// Validate the order Fulfillment
			arguments.orderFulfillment.validate();
			
			// Set ORMHasErrors if the orderFulfillment has errors
			if(arguments.orderFulfillment.hasErrors()) {
				getSlatwallScope().setORMHasErrors( true );
			}
			
			if(!getSlatwallScope().getORMHasErrors()) {
				getHibachiDAO().flushORMSession();
			}
		}
	
		// Save the order Fulfillment
		return getHibachiDAO().save(arguments.orderFulfillment);
		*/
	}
	
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	public any function getOrderSmartList(struct data={}) {
		arguments.entityName = "SlatwallOrder";
	
		var smartList = getHibachiDAO().getSmartList(argumentCollection=arguments);
		
		smartList.joinRelatedProperty("SlatwallOrder", "account", "left", true);
		smartList.joinRelatedProperty("SlatwallOrder", "orderType", "left", true);
		smartList.joinRelatedProperty("SlatwallOrder", "orderStatusType", "left", true);
		smartList.joinRelatedProperty("SlatwallOrder", "orderOrigin", "left", true);
		smartList.joinRelatedProperty("SlatwallAccount", "primaryEmailAddress", "left", true);
		smartList.joinRelatedProperty("SlatwallAccount", "primaryPhoneNumber", "left", true);
		
		smartList.addKeywordProperty(propertyIdentifier="orderNumber", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="account.firstName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="account.lastName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="account.company", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="account.primaryEmailAddress.emailAddress", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="account.primaryPhoneNumber.phoneNumber", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="orderOrigin.orderOriginName", weight=1);
		
		return smartList;
	}
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}