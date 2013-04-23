component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="order";

	// Data Properties
	property name="amount";
	property name="accountPaymentMethodID" hb_rbKey="entity.accountPaymentMethod" hb_formFieldType="select";
	property name="newOrderPayment" cfc="OrderPayment" fieldType="many-to-one" persistent="false" fkcolumn="orderPaymentID";
	property name="accountAddressID" hb_rbKey="entity.accountAddress" hb_formFieldType="select";
	property name="saveAccountPaymentMethodFlag" hb_formFieldType="yesno";
	property name="saveAccountPaymentMethodName" hb_rbKey="entity.accountPaymentMethod.accountPaymentMethodName";
	property name="orderPaymentTypeID" hb_rbKey="entity.orderPayment.orderPaymentType" hb_formFieldType="select";
	
	// Cached Properties
	property name="accountPaymentMethodIDOptions";
	property name="paymentMethodIDOptions";
	property name="accountAddressIDOptions";
	
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
				if(!isNull(pmArr[i].getActiveFlag()) && pmArr[i].getActiveFlag()) {
					arrayAppend(variables.accountPaymentMethodIDOptions, {name=pmArr[i].getSimpleRepresentation(), value=pmArr[i].getAccountPaymentMethodID()});	
				}
			}
			arrayAppend(variables.accountPaymentMethodIDOptions, {name=rbKey('define.new'), value=""});
		}
		return variables.accountPaymentMethodIDOptions;
	}
	
	public string function getAccountAddressID() {
		if(!structKeyExists(variables, "accountAddressID")) {
			variables.accountAddressID = getAccountAddressIDOptions()[1]['value'];
		}
		return variables.accountAddressID;
	}
	
	public array function getAccountAddressIDOptions() {
		if(!structKeyExists(variables, "accountAddressIDOptions")) {
			variables.accountAddressIDOptions = [];
			var aaArr = getOrder().getAccount().getAccountAddresses();
			for(var i=1; i<=arrayLen(aaArr); i++) {
				arrayAppend(variables.accountAddressIDOptions, {name=aaArr[i].getSimpleRepresentation(), value=aaArr[i].getAccountAddressID()});
			}
			arrayAppend(variables.accountAddressIDOptions, {name=rbKey('define.new'), value=""});
		}
		return variables.accountAddressIDOptions;
	}
	
	public any function getNewOrderPayment() {
		if(!structKeyExists(variables, "newOrderPayment")) {
			variables.newOrderPayment = getService("orderService").newOrderPayment();
		}
		return variables.newOrderPayment;
	}
	
	public boolean function getSaveAccountPaymentMethodFlag() {
		if(!structKeyExists(variables, "saveAccountPaymentMethodFlag")) {
			variables.saveAccountPaymentMethodFlag = 0;
		}
		return variables.saveAccountPaymentMethodFlag;
	}
	
	public string function getOrderPaymentTypeID() {
		return getNewOrderPayment().getOrderPaymentType().getTypeID();
	}
	
	public array function getOrderPaymentTypeIDOptions() {
		return getNewOrderPayment().getOrderPaymentTypeOptions();
	}
}