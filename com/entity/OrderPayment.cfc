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
component displayname="Order Payment" entityname="SlatwallOrderPayment" table="SlatwallOrderPayment" persistent="true" output="false" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="orderPaymentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="amount" ormtype="big_decimal" notnull="true";
	
	// Persistent Properties - creditCard Specific
	property name="nameOnCreditCard" ormType="string";
	property name="creditCardNumberEncrypted" ormType="string";
	property name="creditCardLastFour" ormType="string";
	property name="creditCardType" ormType="string";
	property name="expirationMonth" ormType="string";
	property name="expirationYear" ormType="string";
	
	// Related Object Properties (many-to-one)
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="orderPaymentType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderPaymentTypeID";
	property name="paymentMethod" cfc="PaymentMethod" fieldtype="many-to-one" fkcolumn="paymentMethodID";
	property name="billingAddress" cfc="Address" fieldtype="many-to-one" fkcolumn="billingAddressID" cascade="all";
	
	// Related Object Properties (one-to-many)
	property name="creditCardTransactions" singularname="creditCardTransaction" cfc="CreditCardTransaction" fieldtype="one-to-many" fkcolumn="orderPaymentID" cascade="all" inverse="true" orderby="createdDateTime DESC" ;

	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="amountAuthorized" type="numeric" persistent="false";
	property name="amountCharged" type="numeric" persistent="false";
	property name="amountCredited" type="numeric" persistent="false";
	property name="amountReceived" type="numeric" persistent="false";
	property name="creditCardNumber" persistent="false";
	property name="expirationDate" persistent="false";
	property name="securityCode" persistent="false";
		
	public any function init() {
		// set the payment type to charge by default
		if( !structKeyExists(variables,"orderPaymentType") ) {
			setOrderPaymentType( getService("typeService").getTypeBySystemCode("optCharge") );
		}
		if(isNull(variables.amount)) {
			variables.amount = 0;
		}
		if(isNull(variables.creditCardTransactions)) {
			variables.creditCardTransactions = [];
		}
		
		return super.init();
	}
	
	public string function getPaymentMethodType() {
		return getPaymentMethod().getPaymentMethodType();
	}

	public string function getAuthorizationCodes() {
		var transactions = getCreditCardTransactions();
		var authCodes = "";
		for(var thisTransaction in transactions) {
			if(!listFind(authCodes,thisTransaction.getAuthorizationCode())) {
				authCodes = listAppend(authCodes,thisTransaction.getAuthorizationCode());
			}
		}
		return authCodes;
	}
	
	public array function getProcessTransactionTypeOptions() {
		var options = [];
		if(getAmountReceived() < getAmountAuthorized()) {
			arrayAppend(options, {value='chargePreAuthorization', name='Charge Pre-Authroization'});
		}
		if(getAmountAuthorized() == 0) {
			arrayAppend(options, {value='authorizeAndCharge', name='Authorize & Charge'});
			arrayAppend(options, {value='authorize', name='Authorize'});
		}
		if(getAmountReceived() > 0) {
			arrayAppend(options, {value='credit', name='Credit'});
		}
		return options;
	}
	
	public string function getProviderTransactionIDByTransactionType ( required any transactionType ) {
		var returnID = "";
		
		if(arguments.transactionType == "credit") {
			for(var i=1; i<=arrayLen(getCreditCardTransactions()); i++) {
				if(getCreditCardTransactions()[i].getAmountCharged() > 0) {
					returnID = getCreditCardTransactions()[i].getProviderTransactionID();
				}
			}
			
		} else if (arguments.transactionType == "chargePreAuthorization") {
			for(var i=1; i<=arrayLen(getCreditCardTransactions()); i++) {
				if(getCreditCardTransactions()[i].getAmountAuthorized() > getCreditCardTransactions()[i].getAmountCharged()) {
					returnID = getCreditCardTransactions()[i].getProviderTransactionID();
				}
			}
		}
		
		return returnID;
	}
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	public numeric function getAmountReceived() {
		if(!structKeyExists(variables, "amountReceived")) {
			switch(getPaymentMethodType()) {
				
				case "creditCard" :
					variables.amountReceived = getAmountCharged();
					break;
				default :
					variables.amountReceived = getAmount();
			}
		}
		return variables.amountReceived;
	}
	
	public numeric function getAmountAuthorized() {
		if(!structKeyExists(variables, "amountAuthorized")) {
			switch(getPaymentMethodType()) {
			
				case "creditCard" :
					variables.amountAuthorized = 0;
					for(var i=1; i<=arrayLen(getCreditCardTransactions()); i++) {
						variables.amountAuthorized += getCreditCardTransactions()[i].getAmountAuthorized();
					}
					break;
				default :
					variables.amountAuthorized = getAmount();
			}
		}
		return variables.amountAuthorized;
	}
	
	public numeric function getAmountCharged() {
		if(!structKeyExists(variables, "amountCharged")) {
			variables.amountCharged = 0;
			for(var i=1; i<=arrayLen(getCreditCardTransactions()); i++) {
				variables.amountCharged += getCreditCardTransactions()[i].getAmountCharged();
			}
		}
		return variables.amountCharged;
	}
	
	public numeric function getAmountCredited() {
		if(!structKeyExists(variables, "amountCredited")) {
			variables.amountCredited = 0;
			for(var i=1; i<=arrayLen(getCreditCardTransactions()); i++) {
				variables.amountCredited += getCreditCardTransactions()[i].getAmountCredited();
			}
			return variables.amountCredited;
		}
	}
	
	public string function getExpirationDate() {
		if(!structKeyExists(variables,"expirationDate")) {
			variables.expirationDate = coalesce(getExpirationMonth(),"") & "/" & coalesce(getExpirationYear(), "");
		}
		return variables.expirationDate;
	}
		
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Order (many-to-one)
	public void function setOrder(required any order) {
		variables.order = arguments.order;
		if(isNew() or !arguments.order.hasOrderPayment( this )) {
			arrayAppend(arguments.order.getOrderPayments(), this);
		}
	}
	public void function removeOrder(any order) {
		if(!structKeyExists(arguments, "order")) {
			arguments.order = variables.order;
		}
		var index = arrayFind(arguments.order.getOrderPayments(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.order.getOrderPayments(), index);
		}
		structDelete(variables, "order");
	}
	
	// Credit Card Transactions (one-to-many)
	public void function addCreditCardTransaction(required any creditCardTransaction) {
		arguments.creditCardTransaction.setOrderPayment( this );
	}
	public void function removeCreditCardTransaction(required any creditCardTransaction) {
		arguments.creditCardTransaction.removeOrderPayment( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================

	// ================== START: Overridden Methods ========================
	
	
	public void function setCreditCardNumber(required string creditCardNumber) {
		variables.creditCardNumber = arguments.creditCardNumber;
		setCreditCardLastFour(Right(arguments.creditCardNumber, 4));
		setCreditCardType(getService("paymentService").getCreditCardTypeFromNumber(arguments.creditCardNumber));
		if(getCreditCardType() != "Invalid" && getPaymentMethod().setting("paymentMethodStoreCreditCardNumberWithOrder") == 1) {
			setCreditCardNumberEncrypted(encryptValue(arguments.creditCardNumber));
		}
	}
	
	public string function getCreditCardNumber() {
		if(!structKeyExists(variables,"creditCardNumber")) {
			if(coalesce(getCreditCardNumberEncrypted(), "") NEQ "") {
				variables.creditCardNumber = decryptValue(getCreditCardNumberEncrypted());
			} else {	
				variables.creditCardNumber = "";
			}
		}
		return variables.creditCardNumber;
	}
	
	public string function getValidationContext(required string context) {
		if(arguments.context == "save") {
			return "save#getPaymentMethodType()#";
		}
		return arguments.context;
	}
	
	public any function getSimpleRepresentation() {
		if(getPaymentMethodType() == "creditCard") {
			return getPaymentMethod().getPaymentMethodName() & " - " & getCreditCardType() & " - ***" & getCreditCardLastFour();	
		}
		return getPaymentMethod().getPaymentMethodName();
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}