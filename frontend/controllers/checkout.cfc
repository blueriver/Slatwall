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
component persistent="false" accessors="true" output="false" extends="BaseController" {

	property name="accountService" type="any";
	property name="addressService" type="any";
	property name="orderService" type="any";
	property name="paymentService" type="any";
	property name="settingService" type="any";
	
	public void function detail(required struct rc) {
		param name="rc.edit" default="";
		param name="rc.orderRequirementsList" default="";
		param name="rc.guestAccountOK" default="false";
		
		// Insure that the cart is not new, and that it has order items in it.  otherwise redirect to the shopping cart
		if(rc.$.slatwall.cart().isNew() || !arrayLen(rc.$.slatwall.cart().getOrderItems())) {
			getFW().redirectExact(rc.$.createHREF('shopping-cart'));
		}
		
		// get the list of requirements left for this order to be processed
		rc.orderRequirementsList = getOrderService().getOrderRequirementsList(rc.$.slatwall.cart());
		
		// Account Setup Logic
		if ( isNull(rc.$.slatwall.cart().getAccount()) ) {
			// When no account is in the order then just set a new account in the rc so it works
			// We don't need to put account in the rc.orderRequirementsList because it will already be there
			rc.account = getAccountService().newAccount();
		} else {
			// If the account on cart is the same as the one logged in then set the rc.account from cart
			// OR If the cart is using a guest account, and this method was called from a different controller that says guest accounts are ok, then pass in the cart account
			if( rc.$.slatwall.cart().getAccount().getAccountID() == rc.$.slatwall.account().getAccountID() || (rc.$.slatwall.cart().getAccount().isGuestAccount() && rc.guestAccountOK) ) {
				rc.account = rc.$.slatwall.cart().getAccount();
			} else {
				rc.account = getAccountService().newAccount();
				// Here we need to add it to the requirements list because the cart already had an account
				rc.orderRequirementsList = listPrepend(rc.orderRequirementsList,"account");
			}
		}
		
		// Setup some elements to be used by different views
		rc.activePaymentMethods = getPaymentService().listPaymentMethodFilterByActiveFlag(1);
	}
	
	public void function loginAccount(required struct rc) {
		var loginSuccess = getAccountService().loginMuraUser(username=arguments.rc.username, password=arguments.rc.password, siteID=rc.$.event('siteid'));
		
		if(!loginSuccess) {
			request.status = "failed";
		}
		
		detail(rc);
		getFW().setView("frontend:checkout.detail");
	}
	
	public void function saveAccount(required struct rc) {
		detail(rc);
		
		rc.account = getAccountService().saveAccount(account=rc.account, data=rc, siteID=rc.$.event('siteID'));
		
		// IF the account doesn't have any errors than we can apply it to the order
		if(!rc.account.hasErrors()) {
			rc.$.slatwall.cart().setAccount(rc.account);
		}
		
		// Reload the order Requirements list
		rc.orderRequirementsList = getOrderService().getOrderRequirementsList(rc.$.slatwall.cart());
		
		// get the list of requirements left for this order to be processed
		getFW().setView("frontend:checkout.detail");
	}
	
	public void function saveFulfillment(required struct rc) {
		param name="rc.orderFulfillmentID" default="";
		
		rc.guestAccountOK = true;
		
		// Load the fulfillment
		var fulfillment = getOrderService().getOrderFulfillment(rc.orderFulfillmentID, true);
		
		// Verify the fulfillment is part of the cart then proceed
		if(rc.$.slatwall.cart().hasOrderFulfillment(fulfillment)) {
			fulfillment = getOrderService().saveOrderFulfillment(fulfillment, rc);
		}
		
		detail(rc);
		getFW().setView("frontend:checkout.detail");
	}
	
	public void function saveOrderPayment(required struct rc) {
		param name="rc.paymentMethodID" default="creditCard";
		
		rc.guestAccountOK = true;
		
		// Create new Payment Entity
		var payment = getOrderService().new("SlatwallOrderPayment#rc.paymentMethodID#");
		
		// Attempt to Validate & Save Order Payment
		payment = getOrderService().saveOrderPayment(rc.payment, rc);
		
		// Add payment to order
		rc.$.slatwall.cart().addOrderPayment(rc.payment);
		
		detail(rc);
		getFW().setView("frontend:checkout.detail");
	}
	
	public void function processOrder(required struct rc) {
		param name="rc.orderPaymentID" default="";
		
		rc.guestAccountOK = true;
		
		// Insure that the cart is not new, and that it has order items in it 
		if(rc.$.slatwall.cart().isNew() || !arrayLen(rc.$.slatwall.cart().getOrderItems())) {
			getFW().redirectExact(rc.$.createHREF('shopping-cart'));
		}
		
		// Reload the order Requirements list, and make sure that the only thing required is payment
		rc.orderRequirementsList = getOrderService().getOrderRequirementsList(rc.$.slatwall.cart());
		if(!listFind(rc.orderRequirementsList,"account") && !listFind(rc.orderRequirementsList,"fulfillment")) {
			
			var tempOrderID = rc.$.slatwall.cart().getOrderID();
			
			var result = getOrderService().setupPaymentAndProcessOrder(order=rc.$.slatwall.cart(), data=rc);
			
			if(result) {
				// Redirect to order Confirmation
				getFW().redirectExact($.createHREF(filename='my-account', querystring="slatAction=frontend:account.detailorder&orderID=#orderID#"), false);
			}
			
		}
		
		detail(rc);
		getFW().setView("frontend:checkout.detail");
	}

}
