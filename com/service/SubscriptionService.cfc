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
			// find the existing subscription usage for this sku
			var subscriptionUsage = getDAO().getSubscriptionUsageBySku(arguments.orderItem.getSku().getSkuID(),arguments.orderItem.getOrder().getAccount().getAccountID());
			
			if(isNull(subscriptionUsage)) {
				setupInitialSubscriptionOrderItem(arguments.orderItem);
			} else {
				setupRenewalSubscriptionOrderItem(arguments.orderItem, subscriptionUsage);
			}
		}
	}
	
	// setup Initial SubscriptionOrderItem
	public void function setupInitialSubscriptionOrderItem(required any orderItem) {
		var subscriptionOrderItemType = "soitInitial";
		var subscriptionUsage = this.newSubscriptionUsage();
		
		//copy all the info from order items to subscription usage if it's initial order item
		subscriptionUsage.copyOrderItemInfo(arguments.orderItem);
		subscriptionUsage.setAccount(arguments.orderItem.getOrder().getAccount());
		subscriptionUsage.setAccountPaymentMethod(arguments.orderItem.getOrder().getAccountPaymentMethod());
		
		// add active status to subscription usage
		var subscriptionStatus = this.newSubscriptionStatus();
		subscriptionStatus.setSubscriptionStatusType(this.getTypeBySystemCode('sstActive'));
		subscriptionStatus.setSubscriptionStatusChangeDateTime(now());
		subscriptionUsage.addSubscriptionStatus(subscriptionStatus);
		
		// set next bill date
		subscriptionUsage.setNextBillDate(arguments.orderItem.getSku().getSubscriptionTerm().getInitialTerm().getDueDate());
		
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
	
	// setup renewal SubsriptionOrderItem
	public void function setupRenewalSubscriptionOrderItem(required any orderItem, required any subscriptionUsage) {
		var subscriptionOrderItemType = "soitRenewal";
		
		// set next bill date
		subscriptionUsage.setNextBillDate(arguments.orderItem.getSku().getSubscriptionTerm().getInitialTerm().getDueDate());
		
		// create new subscription orderItem
		var subscriptionOrderItem = this.newSubscriptionOrderItem();
		subscriptionOrderItem.setOrderItem(arguments.orderItem);
		subscriptionOrderItem.setSubscriptionOrderItemType(this.getTypeBySystemCode(subscriptionOrderItemType));
		subscriptionOrderItem.setSubscriptionUsage(subscriptionUsage);
		
		// call save on this entity to make it persistent so we can use it for further lookup
		this.saveSubscriptionUsage(subscriptionUsage);
		
		//TODO: setup renewal benefits
		
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
	
	// renew a subscription usage
	public void function renewSubscription(required any subscriptionUsage) {
		// first check if it time for renewal
		if(arguments.subscriptionUsage.getNextBillDate() > now() || arguments.subscriptionUsage.getCurrentStatusCode() == 'sstCancelled') {
			return;
		}
		// create a new order
		var order = getOrderService().newOrder();
		// set the account for order
		order.setAccount(arguments.subscriptionUsage.getAccount());
		// add order item to order
		getOrderService().addOrderItem(order,arguments.subscriptionUsage.subscriptionOrderItems()[1].getOrderItem().getSku());
		// add order payment to order
		if(order.getTotal() > 0) {
			var orderPayment = getPaymentService().newOrderPayment();
			orderPayment.setOrder(order);
			orderPayment.setAmount(order.getTotal());
			orderPayment.copyFromAccountPaymentMethod(subscriptionUsage.getAccountPaymentMethod());
			orderPayment.setOrderPaymentType(this.getTypeBySystemCode("optCharge"));
			getPaymentService().saveOrderPayment(orderPayment);
		}
		// save order for processing
		getOrderService().saveOrder(order);
		getDAO().flushORMSession();
		// process order 
		var orderData = {};
		orderData.orderID = order.getOrderID();
		orderData.doNotSendOrderConfirmationEmail = 1;
		getOrderService().processOrder(orderData);	
		// persist order changes to DB 
		getDAO().flushORMSession();
	}
	
}
