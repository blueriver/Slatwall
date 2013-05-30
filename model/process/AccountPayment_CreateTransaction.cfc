component output="false" accessors="true" extends="HibachiProcess" {
	
	// Injected Entity
	property name="accountPayment";
	
	// Data Properties
	property name="amount";
	property name="transactionType" hb_formFieldType="select";
	
	// Option Properties
	property name="transactionTypeOptions";
	
	public array function getTransactionTypeOptions() {
		if(!structKeyExists(variables, "transactionTypeOptions")) {
			
			variables.transactionTypeOptions = [];
			
			if(getAccountPayment().getPaymentMethod().getPaymentMethodType() eq "creditCard") {
				arrayAppend(variables.transactionTypeOptions, {name=rbKey('define.credit'), value="credit"});
				if(getAccountPayment().getAmountAuthorized() gt getAccountPayment().getAmountReceived()) {
					arrayAppend(variables.transactionTypeOptions, {name=rbKey('define.chargePreAuthorization'), value="chargePreAuthorization"});	
				}
				if(getAccountPayment().getCreditCardOrProviderTokenExistsFlag()) {
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
			if(getAccountPayment().getAccountPaymentType().getSystemCode() eq "optCharge") {
				variables.transactionType = 'receive';
				if(getAccountPayment().getPaymentMethod().getPaymentMethodType() eq "creditCard" && getAccountPayment().getAmountAuthorized() gt getAccountPayment().getAmountReceived()) {
					variables.transactionType = 'chargePreAuthorization';
				} else if (getAccountPayment().getPaymentMethod().getPaymentMethodType() eq "creditCard" && getAccountPayment().getAmountReceived() lt getAmount()) {
					variables.transactionType = 'authorizeAndCharge';
				} else if (getAccountPayment().getPaymentMethod().getPaymentMethodType() eq "creditCard" && getAccountPayment().getAmountReceived() gt getAmount()) {
					variables.transactionType = 'credit';
				}
			} else if (getAccountPayment().getAccountPaymentType().getSystemCode() eq "optCredit") {
				variables.transactionType = 'credit';
			}
		}
		return variables.transactionType;
	}
	
	public numeric function getAmount() {
		if(!structKeyExists(variables, "amount")) {
			if(!isNull(getTransactionType()) && listFindNoCase("receive,authorizeAndCharge,chargePreAuthorization", getTransactionType())) {
				variables.amount = getAccountPayment().getAmountUnreceived();
			} else if (!isNull(getTransactionType()) && listFindNoCase("credit", getTransactionType())) {
				variables.amount = getAccountPayment().getAmountUncredited();
			} else {
				variables.amount = 0;
			}
		}
		return variables.amount;
	}
		
}