component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="orderDelivery";
	
	// Data Properties
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="orderFulfillment" cfc="OrderFulfillment" fieldtype="many-to-one" fkcolumn="orderFulfillmentID";
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	property name="fulfillmentMethod" cfc="FulfillmentMethod" fieldtype="many-to-one" fkcolumn="fulfillmentMethodID";
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	property name="shippingAddress" cfc="Address" fieldtype="many-to-one" fkcolumn="shippingAddressID";
	property name="orderDeliveryItems" singularname="orderDeliveryItem" cfc="OrderDeliveryItem" fieldtype="one-to-many" fkcolumn="orderDeliveryID";
	
	property name="trackingNumber";
	property name="captureAuthorizedPaymentsFlag" hb_formFieldType="yesno";
	property name="capturableAmount" hb_formatType="currency";
	
	variables.orderDeliveryItems = [];
	
	public void function addOrderDeliveryItem( required any orderDeliveryItem ) {
		arrayAppend(variables.orderDeliveryItems, arguments.orderDeliveryItem );
	}
	
	public numeric function getCapturableAmount() {
		if(!structKeyExists(variables, "capturableAmount")) {
			variables.capturableAmount = 0;
			for(var i=1; i<=arrayLen(getOrderDeliveryItems()); i++) {
				var thisQuantity = getOrderDeliveryItems()[i].getQuantity();
				if(thisQuantity > getOrderDeliveryItems()[i].getOrderItem().getQuantityUndelivered()) {
					thisQuantity = getOrderDeliveryItems()[i].getOrderItem().getQuantityUndelivered();
				}
				variables.capturableAmount = precisionEvaluate(variables.capturableAmount + (getOrderDeliveryItems()[i].getOrderItem().getQuantityUndelivered() / thisQuantity) * getOrderDeliveryItems()[i].getOrderItem().getExtendedPriceAfterDiscount());
			}
			if(getOrder().getPaymentAmountReceivedTotal() eq 0) {
				variables.capturableAmount = precisionEvaluate(variables.capturableAmount + getOrderFulfillment().getChargeAfterDiscount());
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