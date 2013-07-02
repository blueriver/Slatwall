component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="subscriptionUsage";
	
	// Lazy Objects
	property name="order";

	// Data Properties
	property name="renewalStartType" hb_formFieldType="select";
	property name="proratedPrice" hb_rbKey="entity.sku.renewalPrice" hb_formatType="currency";
	property name="extendExpirationDateTime" hb_rbKey="entity.subscriptionUsage.expirationDate" hb_formatType="datetime";
	property name="prorateExpirationDateTime" hb_rbKey="entity.subscriptionUsage.expirationDate" hb_formatType="datetime";
	
	property name="renewalPaymentType" hb_formFieldType="select";
	
	property name="accountPaymentMethodID" hb_formFieldType="select" hb_rbKey="entity.accountPaymentMethod";
	property name="orderPaymentID" hb_formFieldType="select" hb_rbKey="entity.orderPayment";
	
	property name="newOrderPayment" cfc="OrderPayment" fieldType="many-to-one" persistent="false" fkcolumn="orderPaymentID";
	
	public any function getOrder() {
		if(!structKeyExists(variables, "order")) {
			for(var subscriptionOrderItem in getSubscriptionUsage().getSubscriptionOrderItems()) {
				if(subscriptionOrderItem.getSubscriptionOrderItemType().getSystemCode() == 'soitRenewal' && subscriptionOrderItem.getOrderItem().getOrder().getOrderStatusType().getSystemCode() != 'ostClosed') {
					variables.order = subscriptionOrderItem.getOrderItem().getOrder();
				}
			}
			if(!structKeyExists(variables, "order")) {
				variables.order = getService("orderService").newOrder();
			}
		}
		return variables.order;
	}
	
	public string function getExtendExpirationDateTime() {
		return getSubscriptionUsage().getSubscriptionOrderItems()[1].getOrderItem().getSku().getSubscriptionTerm().getRenewalTerm().getEndDate( getSubscriptionUsage().getNextBillDate() );
	}
	
	public string function getProrateExpirationDateTime() {
		return getSubscriptionUsage().getSubscriptionOrderItems()[1].getOrderItem().getSku().getSubscriptionTerm().getRenewalTerm().getEndDate( now() );
	}
	
	public numeric function getProratedPrice() {
		var extendDurationFromNow = dateDiff("d", now(), getExtendExpirationDateTime() );
		var prorateDurationFromNow = dateDiff("d", getSubscriptionUsage().getExpirationDate(), getProrateExpirationDateTime() );
		var proratePercentage = prorateDurationFromNow / extendDurationFromNow * 100;
		
		return round(getSubscriptionUsage().getRenewalPrice() * proratePercentage)/100;
	}
	
	public array function getRenewalStartTypeOptions() {
		return [
			{name="Extend Current Expiration", value='extend'},
			{name="Prorate & Extend From Today", value='prorate'}
		];
	}
	
	public string function getRenewalStartType() {
		if(!structKeyExists(variables, "renewalStartType")) {
			variables.renewalStartType = 'extend';
		}
		
		return variables.renewalStartType;
	}
	
	public string function getRenewalPaymentType() {
		if(!structKeyExists(variables, "renewalPaymentType")) {
			if(arrayLen(getAccountPaymentMethodIDOptions())) {
				variables.renewalPaymentType = 'accountPaymentMethod';
			} else {
				variables.renewalPaymentType = 'orderPayment';	
			}
		}
		
		return variables.renewalPaymentType;
	}
	
	public array function getRenewalPaymentTypeOptions() {
		var options = [];
		
		if(arrayLen(getAccountPaymentMethodIDOptions())) {
			arrayAppend(options, {name=rbKey('entity.accountPaymentMethod'), value='accountPaymentMethod'});
		}
		
		arrayAppend(options, {name=rbKey('entity.orderPayment'), value='orderPayment'});
		arrayAppend(options, {name=rbKey('define.new'), value='new'});
		
		if(getOrder().getNewFlag()) {
			arrayAppend(options, {name=rbKey('define.none'), value='none'});	
		}
		
		return options;
	}
	
	public numeric function getRenewalPrice() {
		if(!structKeyExists(variables, "renewalPrice")) {
			variables.renewalPrice = getSubscriptionUsage().getRenewalPrice();
		}
		return variables.renewalPrice;
	}
	
	public array function getOrderPaymentIDOptions() {
		if(!structKeyExists(variables, "orderPaymentIDOptions")) {
			variables.orderPaymentIDOptions = [];
		}
		return variables.orderPaymentIDOptions;
	}
	
	public any function getAccountPaymentMethodIDOptions() {
		if(!structKeyExists(variables, "accountPaymentMethodIDOptions")) {
			variables.accountPaymentMethodIDOptions = [];
			var smartList = getService("accountService").getAccountPaymentMethodSmartList();
			smartList.addFilter(propertyIdentifier="account.accountID", value=getSubscriptionUsage().getAccount().getAccountID());
			smartList.addOrder("accountPaymentMethodName|ASC");
			for(var apm in smartList.getRecords()) {
				arrayAppend(variables.accountPaymentMethodIDOptions,{name=apm.getSimpleRepresentation(),value=apm.getAccountPaymentMethodID()});
			}
		}
		return variables.accountPaymentMethodIDOptions;
    }
	
}