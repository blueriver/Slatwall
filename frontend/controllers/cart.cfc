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
component persistent="false" accessors="true" output="false" extends="BaseController" {

	property name="locationService" type="any";
	property name="orderService" type="any";
	property name="productService" type="any";
	property name="promotionService" type="any";
	property name="skuService" type="any";
	property name="stockService" type="any";
	property name="utilityFormService" type="any";
	
	// This method is deprecated as of 7/19/2011, the new method is clearCart
	public void function clearItems(required struct rc) {
		clearCart(rc);
	}
	
	public void function clearCart(required struct rc) {
		getOrderService().clearCart();
		
		
		getFW().setView("frontend:cart.detail");
	}
	
	public void function update(required struct rc) {
		
		// Conditional logic to see if we should use the deprecated method
		if(structKeyExists(rc, "orderItems") && isArray(rc.orderItems)) {
			getOrderService().saveOrder(rc.$.slatwall.cart(), rc);
		} else if (structKeyExists(rc, "orderItem") && isStruct(rc.orderItem)) {
			// This is the deprecated method
			getOrderService().updateOrderItems(order=rc.$.slatwall.cart(), data=rc);	
		}
				
		getFW().setView("frontend:cart.detail");
	}
	
	public void function addItem(required struct rc) {
		// Setup the frontend defaults
		param name="rc.preProcessDisplayedFlag" default="true";
		param name="rc.saveShippingAccountAddressFlag" default="false";
		param name="rc.orderFulfillmentID" default="";
		param name="rc.fulfillmentMethodID" default="";
		
		var cart = getOrderService().processOrder( rc.$.slatwall.cart(), arguments.rc, 'addOrderItem');
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.addOrderItem", cart.hasErrors() );
		
		if(!cart.hasErrors()) {
			cart.clearProcessObject("addOrderItem");
		}
		
		getFW().setView("frontend:cart.detail");
	}
	
	public void function removeItem(required struct rc) {
		param name="rc.orderItemID" default="";
		
		getOrderService().removeOrderItem(order=rc.$.slatwall.cart(), orderItemID=rc.orderItemID);
		
		getFW().setView("frontend:cart.detail");
	}
	
	public void function addPromotionCode(required struct rc) {
		param name="rc.promotionCode" default="";
		param name="rc.promotionCodeOK" default="true";
		
		getOrderService().addPromotionCode(order=rc.$.slatwall.cart(), promotionCode=rc.promotionCode);
		
		getFW().setView("frontend:cart.detail");
	}
	
	public void function removePromotionCode(required struct rc) {
		param name="rc.promotionCodeID" default="";
		
		var pc = getPromotionService().getPromotionCode(rc.promotionCodeID, true);
		
		getOrderService().removePromotionCode(order=rc.$.slatwall.cart(), promotionCode=pc);
		
		getFW().setView("frontend:cart.detail");
	}
	
	public void function forceItemQuantityUpdate(required struct rc) {
		
		getOrderService().forceItemQuantityUpdate(order=rc.$.slatwall.cart(), messageBean=rc.$.slatwall.getHibachiMessages());
		
		getFW().setView("frontend:cart.detail");
	}
	
}
