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
component displayname="Order Payment Credit Card" entityname="SlatwallOrderPaymentCreditCard" table="SlatwallOrderPayment" persistent="true" output="false" accessors="true" extends="OrderPayment" discriminatorvalue="creditCard" {
	
	// Persistent Properties
	property name="orderPaymentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	
	property name="nameOnCreditCard" ormType="string";
	property name="creditCardNumberEncrypted" ormType="string";
	property name="creditCardLastFour" ormType="string";
	property name="creditCardType" ormType="string";
	property name="expirationMonth" ormType="string";
	property name="expirationYear" ormType="string";
	
	// Related Properties
	property name="billingAddress" cfc="Address" fieldtype="many-to-one" fkcolumn="billingAddressID" inverse="true";
	property name="creditCardTransactions" singularname="creditCardTransaction" cfc="CreditCardTransaction" fieldtype="one-to-many" fkcolumn="orderPaymentID" cascade="all" inverse="true" orderby="createdDateTime DESC" ;
	
	// Non-Persistent properties
	property name="creditCardNumber" persistent="false";
	property name="securityCode" persistent="false";
	property name="expirationDate" persistent="false";
	property name="amountAuthorized" persistent="false";
	property name="amountCharged" persistent="false";
	property name="amountCredited" persistent="false";
	
	public any function init(){
		// Set Defaults
		setPaymentMethodID("creditCard");
		if(isNull(variables.creditCardTransactions)) {
			variables.creditCardTransactions = [];
		}
		
		return super.init();
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
	
	public numeric function getAmountReceived() {
		return getAmountCharged() - getAmountCredited();
	}
	
	public numeric function getAmountAuthorized() {
		var amountAuthorized = 0;
		for(var i=1; i<=arrayLen(getCreditCardTransactions()); i++) {
			amountAuthorized += getCreditCardTransactions()[i].getAmountAuthorized();
		}
		return amountAuthorized;
	}
	
	public numeric function getAmountCharged() {
		var amountCharged = 0;
		for(var i=1; i<=arrayLen(getCreditCardTransactions()); i++) {
			amountCharged += getCreditCardTransactions()[i].getAmountCharged();
		}
		return amountCharged;
	}
	
	public numeric function getAmountCredited() {
		var amountCredited = 0;
		for(var i=1; i<=arrayLen(getCreditCardTransactions()); i++) {
			amountCredited += getCreditCardTransactions()[i].getAmountCredited();
		}
		return amountCredited;
	}
	
	public void function setCreditCardNumber(required string creditCardNumber) {
		variables.creditCardNumber = arguments.creditCardNumber;
		setCreditCardLastFour(Right(arguments.creditCardNumber, 4));
		setCreditCardType(getService("paymentService").getCreditCardTypeFromNumber(arguments.creditCardNumber));
		if(getCreditCardType() != "Invalid" && setting("paymentMethod_creditCard_storeCreditCardWithOrderPayment")) {
			setCreditCardNumberEncrypted(encryptCreditCardNumber(arguments.creditCardNumber));
		}
	}
	
	public void function encryptCreditCardNumber() {
		if(!isNull(getCreditCardNumber()) && getCreditCardNumber() != "") {
			variables.creditCardNumber = getService("encryptionService").encryptValue(getCreditCardNumber());
		}
	}
	
	public string function getExpirationDate() {
		if(!structKeyExists(variables,"expirationDate")) {
			variables.expirationDate = getExpirationMonth() & "/" & getExpirationYear();
		}
		return variables.expirationDate;
	}
	
	/******* Association management methods for bidirectional relationships **************/
	
	// OrderItems (one-to-many)
	
	public void function addCreditCardTransaction(required CreditCardTransaction creditCardTransaction) {
	   arguments.creditCardTransaction.setOrderPayment(this);
	}
	
	public void function removeOrderItem(required CreditCardTransaction creditCardTransaction) {
	   arguments.creditCardTransaction.removeOrderPayment(this);
	}
	/************   END Association Management Methods   *******************/

}
