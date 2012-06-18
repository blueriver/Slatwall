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
component displayname="Order Payment" entityname="SlatwallOrderPayment" table="SlatwallOrderPayment" persistent="true" output="false" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="orderPaymentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="amount" ormtype="big_decimal" notnull="true";
	
	// Persistent Properties - creditCard Specific
	property name="nameOnCreditCard" ormType="string";
	property name="creditCardNumberEncrypted" ormType="string";
	property name="creditCardLastFour" ormType="string";
	property name="creditCardType" ormType="string";
	property name="expirationMonth" ormType="string" formfieldType="select";
	property name="expirationYear" ormType="string" formfieldType="select";
	
	// Related Object Properties (many-to-one)
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="orderPaymentType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderPaymentTypeID";
	property name="referencedOrderPayment" cfc="OrderPayment" fieldtype="many-to-one" fkcolumn="referencedOrderPaymentID";
	property name="paymentMethod" cfc="PaymentMethod" fieldtype="many-to-one" fkcolumn="paymentMethodID";
	property name="billingAddress" cfc="Address" fieldtype="many-to-one" fkcolumn="billingAddressID" cascade="all";
	property name="accountPaymentMethod" cfc="AccountPaymentMethod" fieldtype="many-to-one" fkcolumn="accountPaymentMethodID";
	
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
	property name="amountCredited" type="numeric" persistent="false";
	property name="amountReceived" type="numeric" persistent="false";
	property name="creditCardNumber" persistent="false";
	property name="expirationDate" persistent="false";
	property name="securityCode" persistent="false";
		
	public any function init() {
		if(isNull(variables.amount)) {
			variables.amount = 0;
		}
		
		return super.init();
	}
	
	public string function getMostRecentChargeProviderTransactionID() {
		for(var i=1; i<=arrayLen(getCreditCardTransactions()); i++) {
			if(!isNull(getCreditCardTransactions()[i].getAmountCharged()) && getCreditCardTransactions()[i].getAmountCharged() > 0 && !isNull(getCreditCardTransactions()[i].getProviderTransactionID()) && len(getCreditCardTransactions()[i].getProviderTransactionID())) {
				return getCreditCardTransactions()[i].getProviderTransactionID();
			}
		}
		// Check referenced payment, and might have a charge.  This works recursivly
		if(!isNull(getReferencedPayment())) {
			return getReferencedPayment().getMostRecentChargeProviderTransactionID();
		}
		return "";
	}
	
	public string function getPaymentMethodType() {
		return getPaymentMethod().getPaymentMethodType();
	}

	public array function getExpirationMonthOptions() {
		return [
			'01',
			'02',
			'03',
			'04',
			'05',
			'06',
			'07',
			'08',
			'09',
			'10',
			'11',
			'12'
		];
	}
	
	public array function getExpirationYearOptions() {
		var yearOptions = [];
		var currentYear = year(now());
		for(var i = 0; i < 10; i++) {
			var thisYear = currentYear + i;
			arrayAppend(yearOptions,{name=thisYear, value=right(thisYear,2)});
		}
		return yearOptions;
	}

	public array function getProcessTransactionTypeOptions() {
		var options = [];
		
		// Charge Payments
		if( getOrderPaymentType().getSystemCode() == "optCharge" ) {
			if( getAmountReceived() < getAmountAuthorized() ) {
				arrayAppend(options, {value='chargePreAuthorization', name='Charge Pre-Authroization'});
			}
			if( getAmountReceived() < getAmount() ) {
				arrayAppend(options, {value='authorizeAndCharge', name='Authorize & Charge'});	
			}
			if(getAmountReceived() < getAmount() && getAmountAuthorized() < getAmount()) {
				arrayAppend(options, {value='authorize', name='Authorize'});	
			}
			
		// Credit Payments
		} else {
			if( getAmountCredited() < getAmount() ) {
				arrayAppend(options, {value='credit', name='Credit'});
			}
		}
		
		return options;
	}
	
	public void function copyFromAccountPaymentMethod(required any accountPaymentMethod) {
		setNameOnCreditCard( accountPaymentMethod.getNameOnCreditCard() );
		setPaymentMethod( accountPaymentMethod.getPaymentMethod() );
		setCreditCardNumber( accountPaymentMethod.getCreditCardNumber() );
		setExpirationMonth( accountPaymentMethod.getExpirationMonth() );
		setExpirationYear( accountPaymentMethod.getExpirationYear() );
		setBillingAddress( accountPaymentMethod.getBillingAddress().copyAddress( true ) );
		setAccountPaymentMethod( arguments.accountPaymentMethod );
	}	
	
	// ============ START: Non-Persistent Property Methods =================
	
	public numeric function getAmountReceived() {
		var amountReceived = 0;
		
		// We only show 'received' for charged payments
		if( getOrderPaymentType().getSystemCode() == "optCharge" ) {
			switch(getPaymentMethodType()) {
			
				case "creditCard" :
					for(var i=1; i<=arrayLen(getCreditCardTransactions()); i++) {
						amountReceived = precisionEvaluate(amountReceived + getCreditCardTransactions()[i].getAmountCharged());
					}
					break;
					
				default :
					amountReceived = getAmount();
					
			}
		}
				
		return amountReceived;
	}
	
	public numeric function getAmountCredited() {
		var amountCredited = 0;
		
		// We only show 'credited' for credited payments
		if( getOrderPaymentType().getSystemCode() == "optCredit" ) {
			switch(getPaymentMethodType()) {
				
				case "creditCard" :
					for(var i=1; i<=arrayLen(getCreditCardTransactions()); i++) {
						amountCredited = precisionEvaluate(amountCredited + getCreditCardTransactions()[i].getAmountCredited());
					}
					break;
					
				default :
					amountCredited = getAmount();
			}
		}
			
		return amountCredited;
	}
	

	public numeric function getAmountAuthorized() {
		var amountAuthorized = 0;
			
		switch(getPaymentMethodType()) {
		
			case "creditCard" :
				amountAuthorized = 0;
				for(var i=1; i<=arrayLen(getCreditCardTransactions()); i++) {
					amountAuthorized = precisionEvaluate(amountAuthorized + getCreditCardTransactions()[i].getAmountAuthorized());
				}
				break;
				
			default :
				amountAuthorized = getAmount();
		}
		
		return amountAuthorized;
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
	
	// ============== START: Overridden Implicet Getters ===================

	public any function getOrderPaymentType() {
		if( !structKeyExists(variables, "orderPaymentType") ) {
			variables.orderPaymentType = getService("typeService").getTypeBySystemCode("optCharge");
		}
		return variables.orderPaymentType;
	}
	
	// ==============  END: Overridden Implicet Getters ====================

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
	
	public void function preInsert(){
		super.preInsert();
		
		// Verify Defaults are Set
		getOrderPaymentType();
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}
