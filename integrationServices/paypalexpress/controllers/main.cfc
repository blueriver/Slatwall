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
component accessors="true" output="false" {

	property name="fw" type="any";

	property name="orderService" type="any";
	property name="paymentService" type="any";
	
	public void function init( required any fw ) {
		setFW( arguments.fw );
	}
	
	public void function before() {
		getFW().setView("paypalexpress:main.blank");
	}
	
	public void function initiatePayment( required struct rc ) {
		param name="arguments.rc.paymentMethodID" default=""; 
		
		var paymentMethod = getPaymentService().getPaymentMethod(rc.paymentMethodID);
		
		if(!isNull(paymentMethod) && paymentMethod.getIntegration().getIntegrationPackage() eq "paypalexpress") {
			var paymentCFC = paymentMethod.getIntegration().getIntegrationCFC( 'payment' );
			
			var responseData = paymentCFC.getInitiatePaymentData( paymentMethod=paymentMethod, order=request.slatwallScope.getCart() );
			
			if(structKeyExists(responseData, "ack") && responseData.ack == "Success" && structKeyExists(responseData, "token")) {
				location("https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=#responseData.token#", false);																										// Dynamic
			}
		}
	}
	
	public void function processResponse( required struct rc ) {
		param name="rc.paymentMethodID" default="";
		param name="rc.token" default="";
		
		var paymentMethod = getPaymentService().getPaymentMethod( rc.paymentMethodID );
		
		if(!isNull(paymentMethod) && paymentMethod.getIntegration().getIntegrationPackage() eq "paypalexpress") {
			
			var paymentCFC = paymentMethod.getIntegration().getIntegrationCFC( 'payment' );
			
			var responseData = paymentCFC.getPaymentResponseData( paymentMethod=paymentMethod, token=rc.token );
			
			if(structKeyExists(responseData, "ack") && responseData.ack == "Success") {
				
				// Setup newOrderPayment
				var paymentData = {};
				paymentData.newOrderPayment = {};
				paymentData.newOrderPayment.accountPaymentMethodID = '';
				paymentData.newOrderPayment.orderPaymentID = '';
				paymentData.newOrderPayment.amount = responseData.PAYMENTREQUEST_0_AMT;
				paymentData.newOrderPayment.paymentMethod.paymentMethodID = paymentMethod.getPaymentMethodID();
				paymentData.newOrderPayment.order.orderID = rc.$.slatwall.cart().getOrderID();
				paymentData.newOrderPayment.orderPaymentType.typeID = '444df2f0fed139ff94191de8fcd1f61b';
				paymentData.newOrderPayment.providerToken = responseData.token & '~' & responseData.payerID;
				
				var order = getOrderService().processOrder( rc.$.slatwall.cart(), paymentData, 'addOrderPayment');
				
				arguments.rc.$.slatwall.addActionResult( "public:cart.addOrderPayment", order.hasErrors() );
			}
		}
		
	}
	
	
}