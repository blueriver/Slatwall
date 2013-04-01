component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="order";

	// Data Properties
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