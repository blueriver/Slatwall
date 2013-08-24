/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
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
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

*/

component accessors="true" output="false" displayname="Stripe" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {
	
	//Global variables

	public any function init(){
		return this;
	}
	
	public string function getPaymentMethodTypes() {
		return "creditCard";
	}
	
	public any function processCreditCard(required any requestBean){
		var responseBean = new Slatwall.model.transient.payment.CreditCardTransactionResponseBean();
		
		var logEnabled = setting("logEnabled");
		
		// Notes for future reference
		// inquiry, void, credit, receive, authorize, authorizeAndCharge, chargePreAuthorization, generateToken
		// Retrieve URL "#setting(apiUrl)#/#setting(apiVersion)#/charges/${chargeId}"
		// Retrieve Card Token URL "#setting(apiUrl)#/#setting(apiVersion)#/tokens/${cardTokenId}"
		
		var requestData = {};
		var responseData = {};
		
		// determine which authentication keys to use based on test mode setting
		var activePublicKey = setting("testPublicKey");
		var activeSecretKey = setting("testSecretKey");
		if (!setting("testMode"))
		{
			activePublicKey = setting("livePublicKey");
			activeSecretKey = setting("liveSecretKey");
		}
		
		var props = requestBean.getPropertiesStruct();
		var pairs = structNew();
		for (var p in props)
		{
			try
			{
				var getterMethod = requestBean["get" & props[p].name];
				structInsert(pairs, props[p].name, getterMethod());
			}
			catch (any e)
			{
				
			}
		}
		
		if (requestBean.getTransactionType() == "generateToken")
		{
			// TODO create customer in stripe and set as provider token
			
			// create charge token
			
			var createCardTokenRequest = new http();
			createCardTokenRequest.setMethod("post");
			createCardTokenRequest.setCharset("utf-8");
			createCardTokenRequest.setUrl("#setting('apiUrl')#/#setting('apiVersion')#/tokens");
			createCardTokenRequest.setUrl("#setting('apiUrl')#/#setting('apiVersion')#/customers");
			
			createCardTokenRequest.addParam(type="header", name="authorization", value="bearer #activePublicKey#");
			populateRequestParamsWithCardInfo(requestBean, createCardTokenRequest);
			// createCardTokenRequest.addParam(type="formfield", name="email", value="#requestBean.getEmail()#");
			// createCardTokenRequest.addParam(type="formfield", name="description", value="#requestBean.getEmail()#");
			
			responseData = deserializeResponse(createCardTokenRequest.send().getPrefix());
			
			writeDump(responseData);
			writeDump(pairs);
			abort;
			
			// populate response
			if (responseData.success)
			{
				responseBean.setProviderToken(responseData.result.card.id);
				responseBean.addMessage(messageName="stripe.token.id", message="#responseData.result.id#");
				responseBean.addMessage(messageName="stripe.card.id", message="#responseData.result.card.id#");
				responseBean.addMessage(messageName="stripe.livemode", message="#responseData.result.livemode#");
				responseBean.addMessage(messageName="stripe.object", message="#responseData.result.object#");
				responseBean.addMessage(messageName="stripe.type", message="#responseData.result.type#");
			}
		}
		else if (requestBean.getTransactionType() == "authorize" || requestBean.getTransactionType() == "authorizeAndCharge")
		{
			// authorize only or authorize and charge
			
			var authorizeChargeRequest = new http();
			authorizeChargeRequest.setMethod("post");
			authorizeChargeRequest.setCharset("utf-8");
			authorizeChargeRequest.setUrl("#setting('apiUrl')#/#setting('apiVersion')#/charges");
			authorizeChargeRequest.addParam(type="header", name="authorization", value="bearer #activeSecretKey#");
			if(!isNull(requestBean.getProviderToken())) {
				authorizeChargeRequest.addParam(type="formfield", name="card", value="#requestBean.getProviderToken()#");	
			}
			else {
				populateRequestParamsWithCardInfo(requestBean, authorizeChargeRequest);
			}
			authorizeChargeRequest.addParam(type="formfield", name="currency", value="#requestBean.getTransactionCurrency()#");
			authorizeChargeRequest.addParam(type="formfield", name="amount", value="#int(requestBean.getTransactionAmount() * 100)#"); // amount as integer (eg. eliminate cents)
			authorizeChargeRequest.addParam(type="formfield", name="description", value="TODO description");
			if (requestBean.getTransactionType() == "authorizeAndCharge")
			{
				// authorize and charge
				authorizeChargeRequest.addParam(type="formfield", name="capture", value="true");
			}
			else
			{
				// authorize only
				authorizeChargeRequest.addParam(type="formfield", name="capture", value="false");
			}
			
			responseData = deserializeResponse(authorizeChargeRequest.send().getPrefix());
			
			// populate response
			if (responseData.success)
			{
				responseBean.setTransactionID(responseData.result.id); // we can't retrieve the chargeID value during a subsequent capture
				responseBean.setProviderToken(listAppend(requestBean.getProviderToken(), responseData.result.id, "|" )); // but we are hacking by appending our chargeID to the initial cardTokenID
				responseBean.setAmountAuthorized(responseData.result.amount / 100); // need to convert back to decimal from integer
				if (requestBean.getTransactionType() == "authorizeAndCharge")
				{
					responseBean.setAmountCharged(responseData.result.amount / 100); // need to convert back to decimal from integer
				}
			}
		}
		else if (requestBean.getTransactionType() == "chargePreAuthorization")
		{
			// capture prior authorized charge
			
			var chargeID = listLast(requestBean.getProviderToken(), "|");
			
			var chargeRequest = new http();
			chargeRequest.setMethod("post");
			chargeRequest.setCharset("utf-8");
			chargeRequest.setUrl("#setting('apiUrl')#/#setting('apiVersion')#/charges/#chargeID#/capture");
			chargeRequest.addParam(type="header", name="authorization", value="bearer #activeSecretKey#");
			// api allows for an optional override of authorized transaction amount (amount can be lesser or equal to authorized charge but not greater)
			chargeRequest.addParam(type="formfield", name="amount", value="#int(requestBean.getTransactionAmount() * 100)#"); // amount as integer (eg. eliminate cents)
			responseData = deserializeResponse(chargeRequest.send().getPrefix());
			
			responseBean.setProviderToken(requestBean.getProviderToken());
			
			// populate response
			if (responseData.success)
			{
				responseBean.setAmountCharged(responseData.result.amount / 100); // need to convert back to decimal from integer
			}
		}
		else if (requestBean.getTransactionType() == "credit")
		{
			// Refund URL "#setting(apiUrl)#/#setting(apiVersion)#/charges/${chargeId}/refund"
			// response.setAmountCredited();
		}
		else
		{
			// error Stripe Payment Integration: no action implemented for transaction type '#requestBean.getTransactionType()#
		}
		
		/*
		var props = requestBean.getPropertiesStruct();
		var pairs = structNew();
		for (var p in props)
		{
			try
			{
			var getterMethod = requestBean["get" & props[p].name];
			structInsert(pairs, props[p].name, getterMethod());
			}
			catch (any e)
			{
				
			}
		}
		*/
		
		//writeDump(arguments);
		//throw(message="We throw this error to halt", type="StripeIntegration.HaltError");
		
		/*
		var rawResponse = "";
		var requestData = getRequestData(requestBean);
		rawResponse = postRequest(requestData);
		return getResponseBean(rawResponse, requestData, requestBean);
		*/
		return responseBean;
	}
	
	private struct function deserializeResponse(required any httpResponse)
	{
		
		var response = {
			statusCode = arguments.httpResponse.responseheader.status_code,
			success = arguments.httpResponse.responseheader.status_code eq 200
		};
		
		// filecontent may be of type java.io.ByteArrayOutputStream
		if(isSimpleValue(arguments.httpResponse.filecontent)) {
			response.rawResponse = arguments.httpResponse.filecontent;
		}
		else {
			response.rawResponse = arguments.httpResponse.filecontent.toString("UTF-8");
		}
		
		if (response.success)
		{
			response.result = deserializeJSON(response.rawResponse);
		}
		else
		{
			response.error = deserializeJSON(response.rawResponse);
		}
		
		return response;
	}
	
	private void function populateRequestParamsWithCardInfo(required any requestBean, required struct httpRequest)
	{
		httpRequest.addParam(type="formfield", name="card[number]", value="#requestBean.getCreditCardNumber()#");
		httpRequest.addParam(type="formfield", name="card[cvc]", value="#requestBean.getSecurityCode()#");
		httpRequest.addParam(type="formfield", name="card[exp_month]", value="#requestBean.getExpirationMonth()#");
		httpRequest.addParam(type="formfield", name="card[exp_year]", value="#requestBean.getExpirationYear()#");
		httpRequest.addParam(type="formfield", name="card[name]", value="#requestBean.getNameOnCreditCard()#");
		httpRequest.addParam(type="formfield", name="card[address_line1]", value="#requestBean.getBillingStreetAddress()#");	
		if(!isNull(requestBean.getBillingStreet2Address())) {
			httpRequest.addParam(type="formfield", name="card[address_line2]", value="#requestBean.getBillingStreet2Address()#");
		}
		httpRequest.addParam(type="formfield", name="card[address_city]", value="#requestBean.getBillingCity()#");
		httpRequest.addParam(type="formfield", name="card[address_state]", value="#requestBean.getBillingStateCode()#");
		httpRequest.addParam(type="formfield", name="card[address_zip]", value="#requestBean.getBillingPostalCode()#");
		httpRequest.addParam(type="formfield", name="card[address_country]", value="#requestBean.getBillingCountryCode()#");
	}
	
}

