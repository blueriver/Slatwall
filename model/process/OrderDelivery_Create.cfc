component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="orderDelivery";
	
	// Data Properties
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="orderFulfillment" cfc="OrderFulfillment" fieldtype="many-to-one" fkcolumn="orderFulfillmentID";
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	property name="shippingAddress" cfc="Address" fieldtype="many-to-one" fkcolumn="shippingAddressID";
	property name="orderDeliveryItems" type="array" hb_populateArray="true";
	
	property name="trackingNumber";
	property name="captureAuthorizedPaymentsFlag" hb_formFieldType="yesno";
	property name="capturableAmount" hb_formatType="currency";
	
	variables.orderDeliveryItems = [];
	
	public numeric function getCapturableAmount() {
		if(!structKeyExists(variables, "capturableAmount")) {
			
			variables.capturableAmount = 0;
			
			for(var i=1; i<=arrayLen(getOrderDeliveryItems()); i++) {
				var orderItem = getService('orderService').getOrderItem(getOrderDeliveryItems()[i].orderItem.orderItemID);
				var thisQuantity = getOrderDeliveryItems()[i].quantity;
				if(thisQuantity > orderItem.getQuantityUndelivered()) {
					thisQuantity = orderItem.getQuantityUndelivered();
				}
				variables.capturableAmount = precisionEvaluate(variables.capturableAmount + ((orderItem.getQuantityUndelivered() / thisQuantity) * orderItem.getExtendedPriceAfterDiscount()));
			}
			
			if(getOrder().getPaymentAmountReceivedTotal() eq 0) {
				variables.capturableAmount = precisionEvaluate(variables.capturableAmount + getOrderFulfillment().getChargeAfterDiscount());
			} else {
				variables.capturableAmount = precisionEvaluate(variables.capturableAmount - precisionEvaluate(getOrder().getPaymentAmountReceivedTotal() - getOrder().getDeliveredItemsAmountTotal()));
			}
			
			if(variables.capturableAmount lt 0) {
				variables.capturableAmount = 0;
			}
			
		}
		return variables.capturableAmount;
	}
	
	public boolean function getCaptureAuthorizedPaymentsFlag() {
		if(!structKeyExists(variables, "captureAuthorizedPaymentsFlag")) {
			variables.captureAuthorizedPaymentsFlag = 0;
			if(getCapturableAmount()) {
				variables.captureAuthorizedPaymentsFlag = 1;	
			}
		}
		return variables.captureAuthorizedPaymentsFlag;
	}
	
}