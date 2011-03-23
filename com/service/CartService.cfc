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
component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {
	
	property name="sessionService";
	
	public void function addCartItem(required any sku, numeric quantity=1, any cart) {
		
		// Check to see if a cart was passed into the method call	
		if(!structKeyExists(arguments, "cart")) {
			arguments.cart = getSessionService().getCurrent().getCart();
		}
		
		var cartItems = arguments.cart.getCartItems();
		var exists = false;
		
		// Check the existing cart items and just add quantity if sku exists
		for(var i = 1; i <= arrayLen(cartItems); i++) {
			if(cartItems[i].getSku().getSkuID() == arguments.sku.getSkuID()) {
				exists = true;
				cartItems[i].setQuantity(cartItems[i].getQuantity() + arguments.quantity);
			}
		}
		
		// If the sku doesn't exist in the cart, then create a new cart item and add it
		if(!exists) {
			var newCartItem = getNewEntity(entityName="SlatwallCartItem");
			newCartItem.setQuantity(arguments.quantity);
			newCartItem.setCart(arguments.cart);
			newCartItem.setSku(arguments.sku);
			arguments.cart.addCartItem(newCartItem);
		}
		
		save(arguments.cart);
	}
	
}
