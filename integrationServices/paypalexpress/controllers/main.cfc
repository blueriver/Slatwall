component {
	
	public void function processResponse( required struct rc ) {
		param name="rc.orderID" default="";
		param name="rc.pmid" default="";
		
		rc.guestAccountOK = true;
		
		// Insure that all items in the cart are within their max constraint
		if(!getSlatwallScope().cart().hasItemsQuantityWithinMaxOrderQuantity()) {
			getFW().redirectExact(rc.$.createHREF(filename='shopping-cart',queryString='slatAction=frontend:cart.forceItemQuantityUpdate'));
		}
		
		// Setup the order
		var order = getOrderService().getOrder(rc.orderID);
		
		rc.orderPayments = [];
		rc.orderPayments[1].orderPaymentID = "";
		rc.orderPayments[1].paymentMethod.paymentMethodID = rc.pmid;
		rc.orderPayments[1].amount = "ADD AMOUNT HERE";
		
		// Attemp to process the order 
		order = getOrderService().processOrder(order, rc, "placeOrder");
		
		if(!order.hasErrors()) {
			
			// Save the order ID temporarily in the session for the confirmation page.  It will be removed by that controller
			getHibachiScope().setSessionValue("orderConfirmationID", rc.orderID);
			
			// Redirect to order Confirmation
			getFW().redirectExact($.createHREF(filename='order-confirmation'), false);
			
		}
			
		detail(rc);
		getFW().setView("frontend:checkout.detail");
	}
	
}