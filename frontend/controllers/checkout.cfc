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

	property name="orderService" type="any";
	property name="productService" type="any";
	property name="addressService" type="any";
	
	public void function detail(required struct rc) {
		param name="rc.validAccount" default="false";
		param name="rc.validShipping" default="false";
		param name="rc.validPayment" default="false";
		
		// Insure that the cart is not new, and that it has order items in it.  otherwise redirect to the shopping cart
		if(rc.$.slatwall.cart().isNew() || !arrayLen(rc.$.slatwall.cart().getOrderItems())) {
			getFW().redirectExact(rc.$.createHREF('shopping-cart'));
		}
		
		// If the current account is not new, then it should be used for the cart.
		if(!rc.$.slatwall.account().isNew()) {
			rc.$.slatwall.cart().setAccount(rc.$.slatwall.account());
		}
		
		// Verify the sections that should be shown
		if(isNull(rc.$.slatwall.cart().getAccount())) {
			rc.validAccount = true;
		}
		if(getOrderService().verifyOrderShipping()) {
			rc.validShipping = true;
		}
		if(getOrderService().verifyOrderPayment()) {
			rc.validShipping = true;
		}
	}
	
	public void function update(required struct rc) {
		
		
	}
	
	public void function addShippingAddress(required struct rc) {
		param name="rc.shippingAddressID" default="";
		
		// Save the address
		rc.shippingAddress = getAddressService().getByID(rc.shippingAddressID);
		if(isNull(rc.shippingAddress)) {
			rc.shippingAddress = getAddressService().getNewEntity();
		}
		rc.shippingAddress = getAddressService().save(rc.shippingAddress, rc);
		
		
	}
	
	public void function addOrderPayment(required struct rc) {
		
	}
	
	public void function processOrder(required struct rc) {
		
	}
	
}
