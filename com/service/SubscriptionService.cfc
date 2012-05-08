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
	property name="accessService" type="any";
	property name="orderService" type="any";
	property name="paymentService" type="any";
	
	public boolean function createSubscriptionUsageBenefitAccountByAccess(required any access, required any account) {
		var subscriptionUsageBenefitAccountCreated = false;
		if(!isNull(arguments.access.getSubscriptionUsageBenefitAccount()) && isNull(arguments.access.getSubscriptionUsageBenefitAccount().getAccount())) {
			arguments.access.getSubscriptionUsageBenefitAccount().setAccount(arguments.account);
			arguments.access.getSubscriptionUsageBenefitAccount().setActiveFlag(1);
			subscriptionUsageBenefitAccountCreated = true;
		} else if(!isNull(arguments.access.getSubscriptionUsageBenefit())) {
			var subscriptionUsageBenefitAccount = createSubscriptionUsageBenefitAccountBySubscriptionUsageBenefit(arguments.access.getSubscriptionUsageBenefit(), arguments.account);
			if(!isNull(subscriptionUsageBenefitAccount)) {
				subscriptionUsageBenefitAccountCreated = true;
			}
		} else if(!isNull(arguments.access.getSubscriptionUsage())) {
			var subscriptionUsageBenefitAccountArray = createSubscriptionUsageBenefitAccountBySubscriptionUsage(arguments.access.getSubscriptionUsage(), arguments.account);
			if(arrayLen(subscriptionUsageBenefitAccountArray)) {
				subscriptionUsageBenefitAccountCreated = true;
			}
		}
		return subscriptionUsageBenefitAccountCreated;
	}
	
	// Create subscriptionUsageBenefitAccount by subscription usage, returns array of all subscriptionUsageBenefitAccountArray created
	public any function createSubscriptionUsageBenefitAccountBySubscriptionUsage(required any subscriptionUsage, any account) {
		var subscriptionUsageBenefitAccountArray = [];
		for(var subscriptionUsageBenefit in arguments.subscriptionUsage.getSubscriptionUsageBenefits()) {
			var data.subscriptionUsageBenefit = subscriptionUsageBenefit;
			// if account is passed then set the account to this benefit else create an access record to be used for account creation
			if(structKeyExists(arguments,"account")) {
				data.account = arguments.account;
			}
			var subscriptionUsageBenefitAccount = createSubscriptionUsageBenefitAccountBySubscriptionUsageBenefit(argumentCollection=data);
			if(!isNull(subscriptionUsageBenefitAccount)) {
				arrayAppend(subscriptionUsageBenefitAccountArray,subscriptionUsageBenefitAccount);
			}
		}
		return subscriptionUsageBenefitAccountArray;
	}
	
	public any function createSubscriptionUsageBenefitAccountBySubscriptionUsageBenefit(required any subscriptionUsageBenefit, any account) {
		if(arguments.subscriptionUsageBenefit.getAvailableUseCount() GT 0) {
			var subscriptionUsageBenefitAccount = this.newSubscriptionUsageBenefitAccount();
			subscriptionUsageBenefitAccount.setSubscriptionUsageBenefit(arguments.subscriptionUsageBenefit);
			this.saveSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);
			// if account is passed then set the account to this benefit else create an access record to be used for account creation
			if(structKeyExists(arguments,"account")) {
				subscriptionUsageBenefitAccount.setAccount(arguments.account);
				subscriptionUsageBenefitAccount.setActiveFlag(1);
			} else {
				var access = getAccessService().newAccess();
				access.setSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);
				getAccessService().saveAccess(access);
			}
			return subscriptionUsageBenefitAccount;
		}
	}
	
	public void function setupSubscriptionOrderItem(required any orderItem) {
		if(!isNull(arguments.orderItem.getSku().getSubscriptionTerm())) {
			// check if orderItem is assigned to a subscriptionOrderItem
			var subscriptionOrderItem = this.getSubscriptionOrderItem({orderItem=arguments.orderItem});
			if(isNull(arguments.subscriptionOrderItem)) {
				// new orderItem, setup subscription
				setupInitialSubscriptionOrderItem(arguments.orderItem);
			} else {
				// orderItem already exists in subscription, just setup access
				// if current status is not active, set active status to subscription usage
				if(arguments.subscriptionUsage.getCurrentStatusCode() != 'sstActive') {
					setSubscriptionStatus(subscriptionOrderItem.getSubscriptionUsage(), 'sstActive');
				}
				// set renewal benefit if needed
				setupRenewalSubscriptionBenefitAccess(subscriptionOrderItem.getSubscriptionUsage());
			}
		}
	}
	
	// setup Initial SubscriptionOrderItem
	private void function setupInitialSubscriptionOrderItem(required any orderItem) {
		var subscriptionOrderItemType = "soitInitial";
		var subscriptionUsage = this.newSubscriptionUsage();
		
		//copy all the info from order items to subscription usage if it's initial order item
		subscriptionUsage.copyOrderItemInfo(arguments.orderItem);
		
		// set account
		subscriptionUsage.setAccount(arguments.orderItem.getOrder().getAccount());
		
		// set payment method is there was only 1 payment method for the order
		// if there are multiple orderPayment, logic needs to get added for user to defined the paymentMethod for renewals
		if(arrayLen(arguments.orderItem.getOrder().getOrderPayments()) == 1) {
			subscriptionUsage.setAccountPaymentMethod(arguments.orderItem.getOrder().getOrderPayments()[1].getAccountPaymentMethod());
		}
		
		// set next bill date
		subscriptionUsage.setNextBillDate(arguments.orderItem.getSku().getSubscriptionTerm().getInitialTerm().getDueDate());
		
		// add active status to subscription usage
		setSubscriptionStatus(subscriptionUsage, 'sstActive');
		
		// create new subscription orderItem
		var subscriptionOrderItem = this.newSubscriptionOrderItem();
		subscriptionOrderItem.setOrderItem(arguments.orderItem);
		subscriptionOrderItem.setSubscriptionOrderItemType(this.getTypeBySystemCode(subscriptionOrderItemType));
		subscriptionOrderItem.setSubscriptionUsage(subscriptionUsage);
		
		// call save on this entity to make it persistent so we can use it for further lookup
		this.saveSubscriptionUsage(subscriptionUsage);

		// copy all the subscription benefits
		for(var subscriptionBenefit in arguments.orderItem.getSku().getSubscriptionBenefits()) {
			var subscriptionUsageBenefit = this.getSubscriptionUsageBenefitBySubscriptionBenefitANDSubscriptionUsage([subscriptionBenefit,subscriptionUsage],true);
			subscriptionUsageBenefit.copyFromSubscriptionBenefit(subscriptionBenefit);
			subscriptionUsage.addSubscriptionUsageBenefit(subscriptionUsageBenefit);

			// call save on this entity to make it persistent so we can use it for further lookup
			this.saveSubscriptionUsageBenefit(subscriptionUsageBenefit);

			// create subscriptionUsageBenefitAccount for this account
			var subscriptionUsageBenefitAccount = this.getSubscriptionUsageBenefitAccountBySubscriptionUsageBenefit(subscriptionUsageBenefit,true);
			subscriptionUsageBenefitAccount.setSubscriptionUsageBenefit(subscriptionUsageBenefit);
			subscriptionUsageBenefitAccount.setAccount(arguments.orderItem.getOrder().getAccount());
			this.saveSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);

			// setup benefits
			setupSubscriptionBenefitAccess(subscriptionUsageBenefit);
		}
		
		// copy all the subscription benefits for renewal
		for(var subscriptionBenefit in arguments.orderItem.getSku().getRenewalSubscriptionBenefits()) {
			var subscriptionUsageBenefit = this.getSubscriptionUsageBenefitBySubscriptionBenefitANDSubscriptionUsage([subscriptionBenefit,subscriptionUsage],true);
			subscriptionUsageBenefit.copyFromSubscriptionBenefit(subscriptionBenefit);
			subscriptionUsage.addRenewalSubscriptionUsageBenefit(subscriptionUsageBenefit);
			this.saveSubscriptionUsageBenefit(subscriptionUsageBenefit);
		}
		
		this.saveSubscriptionOrderItem(subscriptionOrderItem);
	}
	
	// setup subscription benefits for use by accounts
	public void function setupSubscriptionBenefitAccess(required any subscriptionUsageBenefit) {
		// add this benefit to access
		if(arguments.subscriptionUsageBenefit.getSubscriptionBenefit().getAccessType().getSystemCode() == "satPerSubscription") {
			var accessSmartList = getAccessService().getAccessSmartList();
			accessSmartList.addFilter(propertyIdentifier="subscriptionUsage_subscriptionUsageID", value=arguments.subscriptionUsageBenefit.getSubscriptionUsage().getSubscriptionUsageID());
			if(!accessSmartList.getRecordsCount()) {
				var access = getAccessService().getAccessBySubscriptionUsage(arguments.subscriptionUsageBenefit.getSubscriptionUsage(),true);
				access.setSubscriptionUsage(arguments.subscriptionUsageBenefit.getSubscriptionUsage());
				getAccessService().saveAccess(access);
			}

		} else if(arguments.subscriptionUsageBenefit.getSubscriptionBenefit().getAccessType().getSystemCode() == "satPerBenefit") {
			var access = getAccessService().getAccessBySubscriptionUsageBenefit(arguments.subscriptionUsageBenefit,true);
			access.setSubscriptionUsageBenefit(arguments.subscriptionUsageBenefit);
			getAccessService().saveAccess(access);

		} else if(arguments.subscriptionUsageBenefit.getSubscriptionBenefit().getAccessType().getSystemCode() == "satPerAccount") {
			// TODO: this should get moved to DAO because adding large number of records like this could timeout
			// check how many access records already exists and create new ones
			var subscriptionUsageBenefitAccountSmartList = getSubscriptionUsageBenefitAccountSmartList();
			subscriptionUsageBenefitAccountSmartList.addFilter(propertyIdentifier="subscriptionUsageBenefit_subscriptionUsageBenefitID", value=arguments.subscriptionUsageBenefit.getSubscriptionUsageBenefitID());
			var recordCountForCreation = arguments.subscriptionBenefit.getTotalQuantity() - subscriptionUsageBenefitAccountSmartList.getRecordCount();

			for(var i = 0; i < recordCountForCreation; i++) {
				var subscriptionUsageBenefitAccount = this.newSubscriptionUsageBenefitAccount();
				subscriptionUsageBenefitAccount.setSubscriptionUsageBenefit(arguments.subscriptionUsageBenefit);
				saveSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);
				var access = getAccessService().newAccess();
				access.setSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);
				getAccessService().saveAccess(access);
			}
		}
	}

	// setup renewal subscription benefits for use by accounts
	public void function setupRenewalSubscriptionBenefitAccess(required any subscriptionUsage) {
		//setup renewal benefits, if first renewal and renewal benefit exists
		if(arrayLen(arguments.subscriptionUsage.getSubscriptionOrderItems()) == 2 && arrayLen(arguments.subscriptionUsage.getRenewalSubscriptionUsageBenefits())) {
			// remove all existing benefits
			while(arrayLen(arguments.subscriptionUsage.getSubscriptionUsageBenefits())) {
				var subscriptionUsageBenefit = arguments.subscriptionUsage.getSubscriptionUsageBenefits()[1];
				// delete old subscriptionUsageBenefitAccount
				var subscriptionUsageBenefitAccount = this.getSubscriptionUsageBenefitAccountBySubscriptionUsageBenefit(subscriptionUsageBenefit);
				this.deleteSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);
				arguments.subscriptionUsage.removeSubscriptionUsageBenefit(subscriptionUsageBenefit);
			}
			
			// copy all the renewal subscription benefits
			for(var subscriptionUsageBenefit in arguments.subscriptionUsage.getRenewalSubscriptionUsageBenefits()) {
				var subscriptionUsageBenefit = this.newSubscriptionUsageBenefit();
				subscriptionUsageBenefit.copyFromSubscriptionUsageBenefit(subscriptionUsageBenefit);
				subscriptionUsage.addSubscriptionUsageBenefit(subscriptionUsageBenefit);
	
				// call save on this entity to make it persistent so we can use it for further lookup
				this.saveSubscriptionUsageBenefit(subscriptionUsageBenefit);
				
				// create subscriptionUsageBenefitAccount for this account
				var subscriptionUsageBenefitAccount = this.getSubscriptionUsageBenefitAccountBySubscriptionUsageBenefit(subscriptionUsageBenefit,true);
				subscriptionUsageBenefitAccount.setSubscriptionUsageBenefit(subscriptionUsageBenefit);
				subscriptionUsageBenefitAccount.setAccount(arguments.subscriptionUsage.getAccount());
				this.saveSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);
	
				// setup benefits access
				setupSubscriptionBenefitAccess(subscriptionUsageBenefit);
			}
		}
	}

	// process a subscription usage
	public boolean function processSubscriptionUsage(required any subscriptionUsageID, required any context, struct data={}) {
		var subscriptionUsage = this.getSubscriptionUsage(arguments.subscriptionUsageID); 
		if(arguments.context == 'renew') {
			return renewSubscriptionUsage(subscriptionUsage, arguments.data);
		} else if(arguments.context == 'cancel') {
			return cancelSubscriptionUsage(subscriptionUsage, arguments.data);
		}
	}
	
	// renew a subscription usage
	private boolean function renewSubscriptionUsage(required any subscriptionUsage, struct data={}) {
		// first check if it's time for renewal
		if(arguments.subscriptionUsage.getNextBillDate() > now() || arguments.subscriptionUsage.getCurrentStatusCode() == 'sstCancelled') {
			return true;
		}
		// if this is called from autorenewal task and auto renewal is false, then suspend the subscription
		// should we suspend or cancel???
		if(!arguments.subscriptionUsage.getAutoRenewFlag() && structKeyExists(data, 'isAutoRenewalTask')) {
			// add active status to subscription usage
			setSubscriptionStatus(arguments.subscriptionUsage, 'sstSuspended');
			return true;
		}
		
		var renewalOk = false;
		
		// if order was passed use it, else create a new one
		if(structKeyExists(data, "orderID")) {
			var order = getOrderService().getOrder(data.orderID); 
		} else {
			// create a new order
			var order = getOrderService().newOrder();
			
			// set the account for order
			order.setAccount(arguments.subscriptionUsage.getAccount());

			// add order item to order
			getOrderService().addOrderItem(order,arguments.subscriptionUsage.getSubscriptionOrderItems()[1].getOrderItem().getSku());

			// set the orderitem price to renewal price
			order.getOrderItems()[1].setPrice(arguments.subscriptionUsage.getRenewalPrice());
	
			// create new subscription orderItem
			var subscriptionOrderItem = this.newSubscriptionOrderItem();
			subscriptionOrderItem.setOrderItem(order.getOrderItems()[1]);
			subscriptionOrderItem.setSubscriptionOrderItemType(this.getTypeBySystemCode('soitRenewal'));
			subscriptionOrderItem.setSubscriptionUsage(arguments.subscriptionUsage);
			this.saveSubscriptionOrderItem(subscriptionOrderItem);
		}
		
		// save order for processing
		getOrderService().saveOrder(order);

		// add order payment to order if amount > 0
		if(order.getTotal() > 0) { 
			// if autoPayFlag true then apply payment else suspend
			if(arguments.subscriptionUsage.getAutoPayFlag()) {
				var orderPayment = getPaymentService().newOrderPayment();
				orderPayment.setOrder(order);
				orderPayment.setAmount(order.getTotal());
				orderPayment.copyFromAccountPaymentMethod(subscriptionUsage.getAccountPaymentMethod());
				orderPayment.setOrderPaymentType(this.getTypeBySystemCode("optCharge"));
				getPaymentService().saveOrderPayment(orderPayment);
			} else {
				setSubscriptionStatus(arguments.subscriptionUsage, 'sstSuspended');
			}
		}

		// set next bill date, calculated from the last bill date
		// need setting to decide what start date to use for next bill date calculation
		arguments.subscriptionUsage.setNextBillDate(order.getOrderItems()[1].getSku().getSubscriptionTerm().getInitialTerm().getDueDate(arguments.subscriptionUsage.getNextBillDate()));
		
		this.saveSubscriptionUsage(arguments.subscriptionUsage);
		
		// flush session to make sure order is persisted to DB
		getDAO().flushORMSession();
		
		// process order 
		var orderData = {};
		orderData.orderID = order.getOrderID();
		orderData.doNotSendOrderConfirmationEmail = 1;
		var processOK = getOrderService().processOrder(orderData);	
		if(processOK) {
			// if current status is not active, set active status to subscription usage
			if(arguments.subscriptionUsage.getCurrentStatusCode() != 'sstActive') {
				setSubscriptionStatus(arguments.subscriptionUsage, 'sstActive');
			}
			// set renewal benefit if needed
			setupRenewalSubscriptionBenefitAccess(arguments.subscriptionUsage);
			
			renewalOk = true;
		} else {
			// suspend the account if payment failed
			if(orderPayment.hasErrors()) {
				setSubscriptionStatus(arguments.subscriptionUsage, 'sstSuspended', now(), 'sscrtPaymentFailed');
			}
			// some other error, suspend the account
			setSubscriptionStatus(arguments.subscriptionUsage, 'sstSuspended');
		}
		// persist order changes to DB 
		getDAO().flushORMSession();
		return renewalOk;
	}
	
	private boolean function cancelSubscriptionUsage(required any subscriptionUsage, struct data={}) {
		// first check if it's not alreayd cancelled
		if(arguments.subscriptionUsage.getCurrentStatusCode() == 'sstCancelled') {
			return true;
		}
		if(!structKeyExists(data, effectiveDateTime)) {
			data.effectiveDate = now();
		}
		if(!structKeyExists(data, subscriptionStatusChangeReasonTypeCode)) {
			data.subscriptionStatusChangeReasonTypeCode = "";
		}
		// add active status to subscription usage
		setSubscriptionStatus(arguments.subscriptionUsage, 'sstCancelled', data.effectiveDate, data.subscriptionStatusChangeReasonTypeCode);
		return true;
	}
	
	private void function setSubscriptionStatus(required any subscriptionUsage, required string subscriptionStatusTypeCode, any effectiveDate = now(), any subscriptionStatusChangeReasonTypeCode) {
		var subscriptionStatus = this.newSubscriptionStatus();
		subscriptionStatus.setSubscriptionStatusType(this.getTypeBySystemCode(arguments.subscriptionStatusTypeCode));
		if(structKeyExists(arguments, "subscriptionStatusChangeReasonTypeCode") && arguments.subscriptionStatusChangeReasonTypeCode != "") {
			subscriptionStatus.setSubscriptionStatusChangeReasonTypeCode(this.getTypeBySystemCode(arguments.subscriptionStatusChangeReasonTypeCode));
		}
		subscriptionStatus.setEffectiveDateTime(arguments.effectiveDate);
		subscriptionStatus.setChangeDateTime(now());
		arguments.subscriptionUsage.addSubscriptionStatus(subscriptionStatus);
		this.saveSubscriptionUsage(arguments.subscriptionUsage);
	} 
	
}
