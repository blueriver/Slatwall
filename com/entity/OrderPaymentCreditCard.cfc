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
	
	property name="nameOnCreditCard" validateRequired="true" ormType="string";
	property name="creditCardNumberEncrypted" ormType="string";
	property name="creditCardLastFour" ormType="string";
	property name="creditCardType" ormType="string";
	property name="expirationMonth" ormType="string";
	property name="expirationYear" ormType="string";
	property name="amountAuthorized" ormtype="big_decimal";
	property name="amountCharged" ormtype="big_decimal";
	property name="amountRefunded" ormtype="big_decimal";
	
	// Related Properties
	property name="billingAddress" cfc="Address" fieldtype="many-to-one" fkcolumn="billingAddressID";
	property name="creditCardTransactions" singularname="creditCardTransaction" cfc="CreditCardTransaction" fkcolumn="orderPaymentID" fieldtype="one-to-many" cascade="all" inverse="true";
	
	// Non-Persistent properties
	property name="creditCardNumber" validateRequired="true" persistent="false";
	property name="securityCode" validateRequired="true" validateNumeric="true" persistent="false";
	property name="expirationDate" persistent="false";
	
	public any function init(){
		// Set Defaults
		setPaymentMethodID("creditCard");
		if(isNull(variables.creditCardTransactions)) {
			variables.creditCardTransactions = [];
		}
		if(isNull(variables.amountAuthorized)) {
			variables.amountAuthorized = 0;
		}
		if(isNull(variables.amountCharged)) {
			variables.amountCharged = 0;
		}
		
		return super.init();
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