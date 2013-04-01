component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="order";

	// Data Properties
	property name="amount";
	property name="accountPaymentMethodID" hb_rbKey="entity.accountPaymentMethod" hb_formFieldType="select";
	property name="paymentMethodID" hb_rbKey="entity.paymentMethod" hb_formFieldType="select";
	property name="newOrderPayment";
	property name="saveAccountPaymentMethodFlag" hb_formFieldType="yesno";
	property name="saveAccountPaymentMethodName" hb_rbKey="entity.accountPaymentMethod.accountPaymentMethodName";
	
	// Cached Properties
	property name="paymentMethodIDOptions";
	
	public string function getAmount() {
		if(!structKeyExists(variables, "amount")) {
			variables.amount = precisionEvaluate(getOrder().getTotal() - getOrder().getPaymentAmountTotal());
		}
		return variables.amount;
	}
	
	public string function getAccountPaymentMethodID() {
		if(!structKeyExists(variables, "accountPaymentMethodID")) {
			variables.accountPaymentMethodID = getAccountPaymentMethodIDOptions()[1]['value'];
		}
		return variables.accountPaymentMethodID;
	}
	
	public array function getAccountPaymentMethodIDOptions() {
		if(!structKeyExists(variables, "accountPaymentMethodIDOptions")) {
			variables.accountPaymentMethodIDOptions = [];
			var pmArr = getOrder().getAccount().getAccountPaymentMethods();
			for(var i=1; i<=arrayLen(pmArr); i++) {
				arrayAppend(variables.accountPaymentMethodIDOptions, {name=pmArr[i].getAccountPaymentMethodName(), value=pmArr[i].getAccountPaymentMethodID()});
			}
			arrayAppend(variables.accountPaymentMethodIDOptions, {name=rbKey('define.new'), value=""});
		}
		return variables.accountPaymentMethodIDOptions;
	}
	
	public array function getPaymentMethodIDOptions() {
		if(!structKeyExists(variables, "paymentMethodIDOptions")) {
			var sl = getService("paymentService").getPaymentMethodSmartList();
			sl.addFilter('activeFlag', 1);
			
			sl.addSelect('paymentMethodID', 'value');
			sl.addSelect('paymentMethodName', 'name');
			sl.addSelect('paymentMethodType', 'paymentmethodtype');
			
			variables.paymentMethodIDOptions = sl.getRecords();
		}
		return variables.paymentMethodIDOptions;
	}
	
	public any function getNewOrderPayment() {
		if(!structKeyExists(variables, "newOrderPayment")) {
			variables.newOrderPayment = getService("orderService").newOrderPayment();
		}
		return variables.newOrderPayment;
	}
	
	public boolean function getSaveAccountPaymentMethodFlag() {
		if(!structKeyExists(variables, "saveAccountPaymentMethodFlag")) {
			variables.saveAccountPaymentMethodFlag = 1;
		}
		return variables.saveAccountPaymentMethodFlag;
	}
	/*
	property name="orderTypeID" hb_rbKey="entity.order.orderType" hb_formFieldType="select";
	property name="currencyCode" hb_rbKey="entity.currency" hb_formFieldType="select";
	property name="newAccountFlag";
	property name="accountID" hb_rbKey="entity.account" hb_formFieldType="textautocomplete" cfc="Account";
	property name="firstName" hb_rbKey="entity.account.firstName";
	property name="lastName" hb_rbKey="entity.account.lastName";
	property name="company" hb_rbKey="entity.account.company";
	property name="phoneNumber";
	property name="emailAddress";
	property name="emailAddressConfirm";
	property name="createAuthenticationFlag" hb_rbKey="processObject.account_create.createAuthenticationFlag";
	property name="test";
	property name="passwordConfirm";
	property name="fulfillmentMethodID" hb_rbKey="entity.fulfillmentMethod" hb_formFieldType="select";
	property name="orderOriginID" hb_rbKey="entity.orderOrigin" hb_formFieldType="select";
	
	// Cached Properties
	property name="fulfillmentMethodIDOptions";
	
	public string function getOrderTypeID() {
		if(!structKeyExists(variables, "orderTypeID")) {
			variables.orderTypeID = getService("settingService").getTypeBySystemCode("otSalesOrder").getTypeID();
		}
		return variables.orderTypeID;
	}
	
	public array function getCurrencyCodeOptions() {
		return getService("currencyService").getCurrencyOptions();
	}
	
	public array function getOrderTypeIDOptions() {
		return getOrder().getOrderTypeOptions();
	}
	
	public array function getOrderOriginIDOptions() {
		return getOrder().getOrderOriginOptions();
	}
	
	public boolean function getNewAccountFlag() {
		if(!structKeyExists(variables, "newAccountFlag")) {
			variables.newAccountFlag = 1;
		}
		return variables.newAccountFlag;
	}
	
	public boolean function getCreateAuthenticationFlag() {
		if(!structKeyExists(variables, "createAuthenticationFlag")) {
			variables.createAuthenticationFlag = 0;
		}
		return variables.createAuthenticationFlag;
	}
	
	public array function getFulfillmentMethodIDOptions() {
		if(!structKeyExists(variables, "fulfillmentMethodIDOptions")) {
			var fmSL = getService("fulfillmentService").getFulfillmentMethodSmartList();
			fmSL.addFilter('activeFlag', 1);
			
			fmSL.addSelect('fulfillmentMethodID', 'value');
			fmSL.addSelect('fulfillmentMethodName', 'name');
			
			variables.fulfillmentMethodIDOptions = fmSL.getRecords();
		}
		return variables.fulfillmentMethodIDOptions;
	}
	*/
}