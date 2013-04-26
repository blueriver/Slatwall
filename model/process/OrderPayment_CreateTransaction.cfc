component output="false" accessors="true" extends="HibachiProcess" {
	
	// Injected Entity
	property name="orderPayment";
	
	// Data Properties
	property name="amount";
	property name="transactionType" hb_formFieldType="select";
	
	// Option Properties
	property name="transactionTypeOptions";
	
	public array function getTransactionTypeOptions() {
		if(!structKeyExists(variables, "transactionTypeOptions")) {
			
			variables.transactionTypeOptions = [];
			
			if(getOrderPayment().getPaymentMethod().getPaymentMethodType() eq "creditCard") {
				arrayAppend(variables.transactionTypeOptions, {name=rbKey('define.credit'), value="credit"});
				if(getOrderPayment().getAmountAuthorized() gt getOrderPayment().getAmountReceived()) {
					arrayAppend(variables.transactionTypeOptions, {name=rbKey('define.chargePreAuthorization'), value="chargePreAuthorization"});	
				}
				if(getOrderPayment().getCreditCardOrProviderTokenExistsFlag()) {
					arrayAppend(variables.transactionTypeOptions, {name=rbKey('define.authorizeAndCharge'), value="authorizeAndCharge"});
					arrayAppend(variables.transactionTypeOptions, {name=rbKey('define.authorize'), value="authorize"});
					arrayAppend(variables.transactionTypeOptions, {name=rbKey('define.generateToken'), value="generateToken"});	
				}
			} else {
				arrayAppend(variables.transactionTypeOptions, {name=rbKey('define.credit'), value="credit"});
				arrayAppend(variables.transactionTypeOptions, {name=rbKey('define.receive'), value="receive"});
			}
			
		}
		return variables.transactionTypeOptions;
	}
	
	public string function getTransactionType() {
		if(!structKeyExists(variables, "transactionType")) {
			if(getOrderPayment().getOrderPaymentType().getSystemCode() eq "optCharge") {
				variables.transactionType = 'receive';
				if(getOrderPayment().getPaymentMethod().getPaymentMethodType() eq "creditCard" && getOrderPayment().getAmountAuthorized() gt getOrderPayment().getAmountReceived()) {
					variables.transactionType = 'chargePreAuthorization';
				} else if (getOrderPayment().getPaymentMethod().getPaymentMethodType() eq "creditCard" && getOrderPayment().getAmountReceived() lt getAmount()) {
					variables.transactionType = 'authorizeAndCharge';
				} else if (getOrderPayment().getPaymentMethod().getPaymentMethodType() eq "creditCard" && getOrderPayment().getAmountReceived() gt getAmount()) {
					variables.transactionType = 'credit';
				}
			} else if (getOrderPayment().getOrderPaymentType().getSystemCode() eq "optCredit") {
				variables.transactionType = 'credit';
			}
		}
		return variables.transactionType;
	}
	
	public numeric function getAmount() {
		if(!structKeyExists(variables, "amount")) {
			if(!isNull(getTransactionType()) && listFindNoCase("receive,authorizeAndCharge,chargePreAuthorization", getTransactionType())) {
				variables.amount = getOrderPayment().getAmountUnreceived();
			} else if (!isNull(getTransactionType()) && listFindNoCase("credit", getTransactionType())) {
				variables.amount = getOrderPayment().getAmountUncredited();
			} else {
				variables.amount = 0;
			}
		}
		return variables.amount;
	}
	
}