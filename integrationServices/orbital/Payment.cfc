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
																			
	The documentation for this integration was found here:					
	http://download.chasepaymentech.com/									
																			
	It impliments the XML version of the API								
																			
*/

component accessors="true" output="false" displayname="PayFlowPro" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {
	
	public any function init(){
		// Set Defaults
		variables.transactionCodes = {
			authorize="A",
			authorizeAndCharge="AC",
			chargePreAuthorization="MFC",
			credit="R",
			void="",
			inquiry="",
			generateToken=""
		};
		
		return this;
	}
	
	public string function getPaymentMethodTypes() {
		return "creditCard";
	}
	
	public any function processCreditCard(required any requestBean){
		
		var requestXML = "";
		var responseXML = "";
		var httpRequest = new Http();
		var responseBean = getTransient("CreditCardTransactionResponseBean");
		
		if(listFindNoCase("authorize,authorizeAndCharge,credit", arguments.requestBean.getTransactionType())) {
			savecontent variable="requestXML" {
				include "xmltemplates/NewOrderRequest.cfm"; // This template needs to be made dynamic
			}
		} else if(listFindNoCase("chargePreAuthorization", arguments.requestBean.getTransactionType())) {
			savecontent variable="requestXML" {
				include "xmltemplates/MarkForCapture.cfm"; // This template needs to be made dynamic
			}
		}
		
		/*
		Configure this to post correctly
		
		httpRequest.setMethod("POST");
		httpRequest.setURL(variables.liveURL);
		httpRequest.addParam(type="xml", name="XMLRequest", value="#requestXML#");
		*/

		// Get the response from Orbital
		try {
			responseXML = XmlParse(httpRequest.send().getPrefix().fileContent);
		} catch(any e) {
			/* An unexpected error happened, handled below */
		}
		
		// TODO: Translate Response into response bean here
		
		return responseBean;
	}
	
}