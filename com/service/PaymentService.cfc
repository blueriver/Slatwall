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
component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {

	property name="settingService" type="any";

	public any function savePaymentMethod(required any entity, struct data) {
		if( structKeyExists(arguments, "data") ) {
			// save paymentMethod-specific settings
			for(var item in arguments.data) {
				if(!isObject(arguments.data[item]) && listFirst(item,"_") == "paymentMethod") {
					var setting = getSettingService().getBySettingName(item);
					setting.setSettingName(item);
					setting.setSettingValue(arguments.data[item]);
					getSettingService().save(entity=setting);
				}
			}
		}
		return save(argumentcollection=arguments);
	}
	
	public boolean function processPayment(required any orderPayment, required string transactionType, numeric transactionAmount) {
		// Get the relavent info and objects for this order payment
		var processOK = false;
		var paymentMethod = this.getPaymentMethod(arguments.orderPayment.getPaymentMethodID());
		var paymentProviderGateway = paymentMethod.getProviderGateway();
		var providerService = getSettingService().getByPaymentServicePackage(paymentProviderGateway);
		
		if(arguments.orderPayment.getPaymentMethodID() eq "creditCard") {
			// Generate Process Request Bean
			var request = new Slatwall.com.utility.payment.CreditCardTransactionRequestBean();
			
			// Move all of the info into the new request bean
			request.populatePaymentInfoWithOrderPayment(arguments.orderPayment);
			
			// Setup the actuall processing information
			if(!structKeyExists(arguments, "transactionAmount")) {
				arguments.transactionAmount = arguments.orderPayment.getAmount();
			}
			
			request.setTransactionType(arguments.transactionType);
			request.setTransactionAmount(arguments.transactionAmount);
			request.setTransactionCurrency("USD"); // TODO: This is a hack that should be fixed at some point.  The currency needs to be more dynamic
			
			// Get Response Bean from provider service
			var response = providerService.processCreditCard(request);
			
			if(!response.hasErrors()) {
				processOK = true;
				
				// Populate a new Credit Card Transaction
				var transaction = this.newCreditCardTransaction();
				transaction.setTransactionType(arguments.transactionType);
				transaction.setProviderTransactionID(response.getTransactionID());
				transaction.setAuthorizationCode(response.getAuthorizationCode());
				transaction.setAuthorizedAmount(response.getAuthorizedAmount());
				transaction.setChargedAmount(response.getChargedAmount());
				transaction.setCreditedAmount(response.getCreditedAmount());
				transaction.setAVSCode(response.getAVSCode());
				transaction.setStatusCode(response.getStatusCode());
				transaction.setMessage(response.getMessageString());
				
				// Relate to order Payment
				transaction.setOrderPayment(arguments.orderPayment);
				
				// Save the Transaction to the DB
				this.saveCreditCardTransaction(transaction);
				
				// Update the order Payment
				var authAmount = arguments.orderPayment.getAmountAuthorized() + response.getAuthorizedAmount();
				var chargeAmount = arguments.orderPayment.getAmountCharged() + response.getChargedAmount();
				arguments.orderPayment.setAmountAuthorized(authAmount);
				arguments.orderPayment.setAmountCharged(chargeAmount);
			} else {
				// Populate the orderPayment with the processing error
				arguments.orderPayment.getErrorBean().addError('processing', response.getErrorBean().getAllErrorMessages());
			}
		}
		
		return processOK;
	}
	
	public string function getCreditCardTypeFromNumber(required string creditCardNumber) {
		if(isNumeric(arguments.creditCardNumber)) {
			var n = arguments.creditCardNumber;
			var l = len(trim(arguments.creditCardNumber));
			if( (l == 13 || l == 16) && left(n,1) == 4 ) {
				return 'Visa';
			} else if ( l == 16 && (left(n,2) == 51 || left(n,2) == 55) ) {
				return 'Mastercard';
			} else if ( (l == 15 && (left(n,4) == 2131 || left(n,4) == 1800)) || (l == 16 && left(n,1) == 3) ) {
				return 'JCB';
			} else if ( l == 15 && (left(n,4) == 2014 || left(n,4) == 2149) ) {
				return 'EnRoute';
			} else if ( l == 15 && left(n,4) == 6011) {
				return 'Discover';
			} else if ( l == 14 && left(n,2) == 38) {
				return 'CarteBlanche';
			} else if ( l == 14 && (left(n,2) == 36 || (left(n,3) >= 300 && left(n,3) <= 305)) ) {
				return 'Diners Club';
			} else if ( l == 15 && (left(n,2) == 34 || left(n,2) == 34) ) {
				return 'Amex';
			}
		}
		
		return 'Invalid';
	}
}