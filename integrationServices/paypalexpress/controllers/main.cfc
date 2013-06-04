component accessors="true" output="false" {

	property name="orderService";
	
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