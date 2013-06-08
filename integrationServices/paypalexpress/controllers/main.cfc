component accessors="true" output="false" {

	property name="orderService";
	
	public void function initiatePayment( required struct rc ) {
		
		var requestData = "";
		
		var httpRequest = new http();
		httpRequest.setMethod("POST");
		httpRequest.setUrl("https://api-3t.sandbox.paypal.com/nvp");																				// Dynamic
		httpRequest.setPort( 443 );
		httpRequest.setTimeout( 120 );
		httpRequest.setResolveurl(false);
		
		httpRequest.addParam(type="formfield", name="method", value="setExpressCheckout");
		httpRequest.addParam(type="formfield", name="paymentAction", value="sale");
		httpRequest.addParam(type="formfield", name="user", value="greg-facilitator_api1.gregmoser.com");											// Dynamic
		httpRequest.addParam(type="formfield", name="pwd", value="1370551670");																		// Dynamic
		httpRequest.addParam(type="formfield", name="signature", value="AQU0e5vuZCvSg-XJploSa.sGUDlpAznEghk3aTZpTNuHviPXOpxnnyzR");					// Dynamic
		httpRequest.addParam(type="formfield", name="version", value="66.0");
		httpRequest.addParam(type="formfield", name="paymentRequest_0_amt", value="#request.slatwallScope.getCart().getTotal()#");
		httpRequest.addParam(type="formfield", name="paymentRequest_0_currencyCode", value="#request.slatwallScope.getCart().getCurrencyCode()#");
		httpRequest.addParam(type="formfield", name="noShipping", value="0");																		// Dynamic
		httpRequest.addParam(type="formfield", name="allowNote", value="0");																		// Dynamic
		//httpRequest.addParam(type="formfield", name="hdrImg", value="");
		httpRequest.addParam(type="formfield", name="email", value="greg-facilitator@gregmoser.com");												// Dynamic
		httpRequest.addParam(type="formfield", name="returnURL", value="http://cf9.muracms/default/index.cfm/checkout/");							// Dynamic
		httpRequest.addParam(type="formfield", name="cancelURL", value="http://cf9.muracms/default/index.cfm/shopping-cart/");						// Dynamic
		
		writeDump(httpRequest.send().getPrefix());
		abort;
		
		return httpRequest.send().getPrefix();
	}
	
	public void function processResponse( required struct rc ) {
		param name="rc.orderID" default="";
		param name="rc.paymentMethodID" default="";
		
		// Setup newOrderPayment
		rc.newOrderPayment = {};
		rc.newOrderPayment.orderPaymentID = '';
		rc.newOrderPayment.amount = 'ADD AMOUNT CHARGED HERE';
		rc.newOrderPayment.paymentMethod.paymentMethodID = rc.paymentMethodID;
		rc.newOrderPayment.order.orderID = rc.$.slatwall.cart().getOrderID();
		rc.newOrderPayment.orderPaymentType.typeID = '444df2f0fed139ff94191de8fcd1f61b';
		
		var order = getOrderService().processOrder( rc.$.slatwall.cart(), arguments.rc, 'placeOrder');
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.placeOrder", order.hasErrors() );
		
		if(!order.hasErrors) {
			rc.$.slatwall.setSessionValue('confirmationOrderID', order.getOrderID());
		}
		
	}
	
	
}